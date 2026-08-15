; PureRGBnote: MOVED: a bunch of code was moved from this file to other banks or commented out since it was unused.
; TODO: probably stuff in here that can be moved to another bank
StoreTrainerHeaderPointer::
	ld a, h
	ld [wTrainerHeaderPtr], a
	ld a, l
	ld [wTrainerHeaderPtr+1], a
	ret

; Same as below, but accepts a custom wram map script tracker in bc
ExecuteCustomMapScriptInTable::
	call EnableAutoTextBoxDrawing
ExecuteCustomMapScriptInTableOnly::
	ld a, [bc]
	call ExecuteCurMapScriptInTable
	ld [bc], a
	ret

; executes the current map script from the function pointer array provided in de.
; a: map script index to execute (unless overridden by [wStatusFlags7] BIT_USE_CUR_MAP_SCRIPT)
; hl: trainer header pointer
ExecuteCurMapScriptInTable::
	push af
	push de
	call StoreTrainerHeaderPointer
	pop hl
	pop af
	push hl
	ld hl, wStatusFlags7
	bit BIT_USE_CUR_MAP_SCRIPT, [hl]
	res BIT_USE_CUR_MAP_SCRIPT, [hl]
	jr z, .useProvidedIndex
	ld a, [wCurMapScript]
.useProvidedIndex
	pop hl
	ld [wCurMapScript], a
	call CallFunctionInTable
	ld a, [wCurMapScript]
	ret

; reads specific information from trainer header (pointed to at wTrainerHeaderPtr)
; a: offset in header data
ReadTrainerHeaderInfo::
	ld hl, wTrainerHeaderPtr
	push de
	push af
	ld d, 0
	ld e, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, de
	pop af
	and a
	pop de
	jr nz, .nonZeroOffset
	ld a, [hl]
	ld [wTrainerHeaderFlagBit], a
	ret
.nonZeroOffset
	cp TRAINER_EVENT_FLAG_POINTER
	jp z, GetAddressFromPointer
	cp TRAINER_END_BATTLE_TEXT_BANK
	ret z
PrintBankedTrainerText::
	; print the text immediately otherwise for Start or After battle texts
	ld a, [hLoadedROMBank]
	push af
	call GetBankedTrainerTextPointer
	call SetCurBank
	rst _PrintText
	pop af
	jp SetCurBank

; PureRGBnote: CHANGED: this function was optimized a bit and now has banks stored for the trainer text entries
TalkToTrainer::
	call StoreTrainerHeaderPointer
	xor a ; TRAINER_EVENT_FLAG_BIT
	call ReadTrainerHeaderInfo     ; read flag's bit
	call TrainerFlagActionTest      ; read trainer's flag
	ld a, c
	and a
	jr z, .trainerNotYetFought     ; test trainer's flag
	ld a, TRAINER_AFTER_BATTLE_TEXT_BANK
	jp ReadTrainerHeaderInfo     ; print after battle text
.trainerNotYetFought
	ld a, TRAINER_BEFORE_BATTLE_TEXT_BANK
	call ReadTrainerHeaderInfo     ; print before battle text
	ld a, TRAINER_END_BATTLE_TEXT_BANK
	call ReadTrainerHeaderInfo     ; read end battle text
	call SaveBankedEndBattleTextPointers
	ld hl, wStatusFlags7
	set BIT_USE_CUR_MAP_SCRIPT, [hl] ; activate map script index override (index is set below)
	ld hl, wMiscFlags
	bit BIT_SEEN_BY_TRAINER, [hl]
	ret nz
; if the player talked to the trainer of their own volition
	call EngageMapTrainer
	ld hl, wCurMapScript
	inc [hl] ; increment map script index before StartTrainerBattle increments it again (next script function is usually EndTrainerBattle)
	jp StartTrainerBattle

; checks if any trainers are seeing the player and wanting to fight
CheckFightingMapTrainers::
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	jr nz, .trainerNotEngaging
ENDC
	call CheckForEngagingTrainers
	ld a, [wSpriteIndex]
	cp $ff
	jr nz, .trainerEngaging
IF DEF(_DEBUG)
.trainerNotEngaging
ENDC
	xor a
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	ret
.trainerEngaging
	ld hl, wStatusFlags7
	set BIT_TRAINER_BATTLE, [hl]
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	callfar EmotionBubble
	call DisableDpad
	xor a
	ldh [hJoyHeld], a
	call TrainerWalkUpToPlayer_Bank0
	ld hl, wCurMapScript
	inc [hl] ; increment map script index (next script function is usually DisplayEnemyTrainerTextAndStartBattle)
	ret

; display the before battle text after the enemy trainer has walked up to the player's sprite
DisplayEnemyTrainerTextAndStartBattle::
	call IsNPCAutoMoving
	ret nz ; return if the enemy trainer hasn't finished walking to the player's sprite
	call EnableAllJoypad
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	call DisplayTextID
	; fall through

StartTrainerBattle::
	call EnableAllJoypad
	call InitBattleEnemyParameters
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	ld hl, wCurMapScript
	inc [hl] ; increment map script index (next script function is usually EndTrainerBattle)
	ret

EndTrainerBattle::
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	ld hl, wStatusFlags3
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER, [hl]
	ld a, [wIsInBattle]
	cp $ff
	jr z, ResetButtonPressedAndMapScript
	ld b, FLAG_SET
	call TrainerFlagAction ; flag trainer as fought
	ld a, [wEnemyMonOrTrainerClass]
	cp OPP_ID_OFFSET
	jr nc, .skipRemoveSprite    ; test if trainer was fought (in that case skip removing the corresponding sprite)
	; code that removes overworld pokemon like articuno, mewtwo, snorlax, etc. when defeated
	; TODO: hide extra object if in extra map???
	ld hl, wToggleableObjectList
	ld de, 2
	ld a, [wSpriteIndex]
	call IsInArray ; search for sprite ID
	inc hl
	ld c, [hl]
	call HideObject
.skipRemoveSprite
	; PureRGBnote: REMOVED: was this needed??? 
	;ld hl, wStatusFlags5
	;bit BIT_UNKNOWN_5_4, [hl]
	;res BIT_UNKNOWN_5_4, [hl]
	;ret nz

ResetButtonPressedAndMapScript::
	call EnableAllJoypad
	; a = 0 from EnableAllJoypad
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ld [wCurMapScript], a
	ret

TrainerWalkUpToPlayer_Bank0::
	farjp TrainerWalkUpToPlayer

; sets opponent trainer class and party level based on the engaging trainer data
InitBattleEnemyParameters::
	ld a, [wEngagedTrainerClass]
	ld [wCurOpponent], a
	ld [wEnemyMonOrTrainerClass], a
	cp OPP_ID_OFFSET
	ld a, [wEngagedTrainerSet]
	jr c, .noTrainer
	ld [wTrainerNo], a
	ret
.noTrainer
	ld [wCurEnemyLevel], a
	ret

GetSpritePosition1::
	ld hl, _GetSpritePosition1
	jr SpritePositionBankswitch

GetSpritePosition2::
	ld hl, _GetSpritePosition2
	jr SpritePositionBankswitch

SetSpritePosition1::
	ld hl, _SetSpritePosition1
	jr SpritePositionBankswitch

SetSpritePosition2::
	ld hl, _SetSpritePosition2
SpritePositionBankswitch::
	ld b, BANK("Trainer Sight")
	rst _Bankswitch
	ret

CheckForEngagingTrainers::
	xor a ; TRAINER_EVENT_FLAG_BIT
	call ReadTrainerHeaderInfo       ; read trainer flag's bit (unused)
	ld d, h                          
	ld e, l
.trainerLoop
	call StoreTrainerHeaderPointer
	ld a, [de]
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	cp -1
	ret z
	call TrainerFlagActionTest
	ld a, c
	and a ; has the trainer already been defeated?
	jr nz, .continue
	push hl
	push de
	push hl
	xor a ; TRAINER_EVENT_FLAG_BIT
	call ReadTrainerHeaderInfo
	inc hl
	ld a, [hl]
	pop hl
	ld [wTrainerEngageDistance], a
	ld a, [wSpriteIndex]
	swap a
	ld [wTrainerSpriteOffset], a
	callfar TrainerEngage
	pop de
	pop hl
	ld a, [wTrainerSpriteOffset]
	and a
	ret nz ; break if the trainer is engaging
.continue
	ld hl, TRAINER_STRUCT_SIZE
	add hl, de
	ld d, h
	ld e, l
	jr .trainerLoop

GetBankedTrainerTextPointer:
	ld a, [hli]
	push af
	hl_deref
	pop af
	ret

; for all basic trainers, loss text = end battle text, they never print loss text anyway
SaveBankedEndBattleTextPointers:
	call GetBankedTrainerTextPointer
	ld d, h
	ld e, l
	jr SaveEndBattleTextPointersCommon
; hl = text if the player wins
; de = text if the player loses
SaveEndBattleTextPointers::
	ld a, [hLoadedROMBank]
SaveEndBattleTextPointersCommon::
	ld [wEndBattleTextRomBank], a
	ld a, h
	ld [wEndBattleWinTextPointer], a
	ld a, l
	ld [wEndBattleWinTextPointer + 1], a
	ld a, d
	ld [wEndBattleLoseTextPointer], a
	ld a, e
	ld [wEndBattleLoseTextPointer + 1], a
	ret

; loads data of some trainer on the current map and plays pre-battle music
; [wSpriteIndex]: sprite ID of trainer who is engaged
EngageMapTrainer::
	ld hl, wMapSpriteExtraData
	ld d, 0
	ld a, [wSpriteIndex]
	dec a
	add a
	ld e, a
	add hl, de
	ld a, [hli]
	ld [wEngagedTrainerClass], a
	ld a, [hl]
	ld [wEngagedTrainerSet], a
	jpfar PlayTrainerMusic ; PureRGBnote: MOVED: playtrainermusic was moved to another bank

PrintEndBattleText::
	push hl
	ld hl, wStatusFlags3
	bit BIT_PRINT_END_BATTLE_TEXT, [hl]
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
	pop hl
	ret z
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wEndBattleTextRomBank]
	call SetCurBank
	push hl
	farcall SaveTrainerName
	ld hl, TrainerEndBattleText
	rst _PrintText
	pop hl
	pop af
	call SetCurBank
	farcall SetEnemyTrainerToStayAndFaceAnyDirection
	jp WaitForSoundToFinish

GetSavedEndBattleTextPointer::
	ld a, [wBattleResult]
	and a
	jr nz, .lostBattle
	hl_deref_reverse wEndBattleWinTextPointer
	ret
.lostBattle
	hl_deref_reverse wEndBattleLoseTextPointer
	ret

TrainerEndBattleText::
	text_far _TrainerNameText
	text_asm
	call GetSavedEndBattleTextPointer
	call TextCommandProcessor
	rst TextScriptEnd

TrainerFlagActionTest::
	ld b, FLAG_TEST
	; fall through
TrainerFlagAction::
	ld a, TRAINER_EVENT_FLAG_POINTER
	call ReadTrainerHeaderInfo     ; read flag's byte ptr (does not change b register)
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	jp FlagAction
