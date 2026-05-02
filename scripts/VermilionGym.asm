VermilionGym_Script:
	ld hl, wCurrentMapScriptFlags
	res BIT_CUR_MAP_LOADED_1, [hl]
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, VermilionGymSetDoorTile
	call EnableAutoTextBoxDrawing
	ld hl, VermilionGymTrainerHeaders
	ld de, VermilionGym_ScriptPointers
	ld a, [wVermilionGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVermilionGymCurScript], a
	ret

VermilionGymSetDoorTile:
	CheckEvent EVENT_2ND_LOCK_OPENED
	ld a, $5 ; clear floor tile ID
	jr nz, .replaceTile
	ld a, $24 ; double door tile ID
.replaceTile
	ld [wNewTileBlockID], a
	lb bc, 2, 2
	call ReplaceTileBlock
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	ret z
	jp GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here

VermilionGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_VERMILIONGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VERMILIONGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VERMILIONGYM_END_BATTLE
	dw_const VermilionGymLTSurgeAfterBattleScript,  SCRIPT_VERMILIONGYM_LT_SURGE_AFTER_BATTLE



VermilionGymResetScripts:
	call ResetMapScripts
	; a = 0 from ResetMapScripts
	ld [wVermilionGymCurScript], a
	ret

VermilionGymLTSurgeAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff ; did we lose?
	jr z, VermilionGymResetScripts
	call DisableDpad

VermilionGymLTSurgeReceiveTM24Script:
	ld d, VERMILIONGYM_LT_SURGE
	callfar MakeSpriteFacePlayer
	ld a, TEXT_VERMILIONGYM_LT_SURGE_THUNDER_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_LT_SURGE
	lb bc, TM_SURGE, 1
	call GiveItem
	jr nc, .bag_full
	ld a, TEXT_VERMILIONGYM_LT_SURGE_RECEIVED_TM24
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM24
	jr .gym_victory
.bag_full
	ld a, TEXT_VERMILIONGYM_LT_SURGE_TM24_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gym_victory
	ld hl, wObtainedBadges
	set BIT_THUNDERBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VERMILION_GYM_TRAINER_0, EVENT_BEAT_VERMILION_GYM_TRAINER_2

	ld a, VERMILIONGYM_LT_SURGE
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr VermilionGymResetScripts

VermilionGym_TextPointers:
	def_text_pointers
	dw_const VermilionGymLTSurgeText,                 TEXT_VERMILIONGYM_LT_SURGE
	dw_const VermilionGymGentlemanText,               TEXT_VERMILIONGYM_SOLDIER1
	dw_const VermilionGymSuperNerdText,               TEXT_VERMILIONGYM_ROCKER
	dw_const VermilionGymSailorText,                  TEXT_VERMILIONGYM_SOLDIER2
	dw_const VermilionGymGymGuideText,                TEXT_VERMILIONGYM_GYM_GUIDE
	dw_const VermilionGymGarbageNearSurgeText,        TEXT_VERMILIONGYM_GARBAGE_NEAR_SURGE
	dw_const VermilionGymBookshelfText,               TEXT_VERMILIONGYM_BOOKSHELF
	dw_const VermilionGymLTSurgeThunderBadgeInfoText, TEXT_VERMILIONGYM_LT_SURGE_THUNDER_BADGE_INFO
	dw_const VermilionGymLTSurgeReceivedTM24Text,     TEXT_VERMILIONGYM_LT_SURGE_RECEIVED_TM24
	dw_const VermilionGymLTSurgeTM24NoRoomText,       TEXT_VERMILIONGYM_LT_SURGE_TM24_NO_ROOM
	dw_const VermilionGymTrashText,                   TEXT_VERMILIONGYM_ONLY_TRASH_HERE
	dw_const VermilionGymTrashSuccessText1,           TEXT_VERMILIONGYM_FOUND_FIRST_SWITCH
	dw_const VermilionGymTrashSuccessText3,           TEXT_VERMILIONGYM_FOUND_SECOND_SWITCH

VermilionGymTrainerHeaders:
	def_trainers 2
VermilionGymTrainerHeader0:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_0, 3, VermilionGymGentlemanBattleText, VermilionGymGentlemanEndBattleText, VermilionGymGentlemanAfterBattleText
VermilionGymTrainerHeader1:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_1, 2, VermilionGymSuperNerdBattleText, VermilionGymSuperNerdEndBattleText, VermilionGymSuperNerdAfterBattleText
VermilionGymTrainerHeader2:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_2, 3, VermilionGymSailorBattleText, VermilionGymSailorEndBattleText, VermilionGymSailorAfterBattleText
	db -1 ; end

VermilionGymLTSurgeText:
	text_asm
	CheckEvent EVENT_BEAT_LT_SURGE
	jr z, .before_beat
	CheckEventReuseA EVENT_GOT_TM24
	jr nz, .got_tm24_already
	call z, VermilionGymLTSurgeReceiveTM24Script
	call DisableWaitingAfterTextDisplay
	jr .text_script_end
.got_tm24_already
	ld hl, .PostBattleAdviceText
	rst _PrintText
	jr .text_script_end
.before_beat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, VermilionGymLTSurgeReceivedThunderBadgeText
	ld de, VermilionGymLTSurgeReceivedThunderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_VERMILIONGYM_LT_SURGE_AFTER_BATTLE
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
.text_script_end
	rst TextScriptEnd

.PreBattleText:
	text_far _VermilionGymLTSurgePreBattleText
	text_end

.PostBattleAdviceText:
	text_far _VermilionGymLTSurgePostBattleAdviceText
	text_end

VermilionGymLTSurgeThunderBadgeInfoText:
	text_far _VermilionGymLTSurgeThunderBadgeInfoText
	text_end

VermilionGymLTSurgeReceivedTM24Text:
	text_far _VermilionGymLTSurgeReceivedTM24Text
	sound_get_key_item
	text_far _TM24ExplanationText
	text_end

VermilionGymLTSurgeTM24NoRoomText:
	text_far _VermilionGymLTSurgeTM24NoRoomText
	text_end

VermilionGymLTSurgeReceivedThunderBadgeText:
	text_far _VermilionGymLTSurgeReceivedThunderBadgeText
	text_end

VermilionGymGentlemanText:
	text_asm
	ld hl, VermilionGymTrainerHeader0
VermilionGymTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

VermilionGymSuperNerdText:
	text_asm
	ld hl, VermilionGymTrainerHeader1
	jr VermilionGymTalkToTrainer

VermilionGymSailorText:
	text_asm
	ld hl, VermilionGymTrainerHeader2
	jr VermilionGymTalkToTrainer

VermilionGymGentlemanBattleText:
	text_far _VermilionGymGentlemanBattleText
	text_end

VermilionGymGentlemanEndBattleText:
	text_far _VermilionGymGentlemanEndBattleText
	text_end

VermilionGymGetTrainerText:
	call .getWhich
	ld b, 0
	add hl, bc
	rst _PrintText
	rst TextScriptEnd
.getWhich
	ld c, 0
	CheckEvent EVENT_BEAT_LT_SURGE
	ret nz
	CheckEvent EVENT_2ND_LOCK_OPENED
	ld c, 5
	ret nz
	ld c, 10
	ret

VermilionGymGentlemanAfterBattleText:
	text_asm
	ld hl, .text_entries
	jr VermilionGymGetTrainerText
.text_entries
.afterBeat
	text_far _VermilionGymGentlemanAfterBattleGymDefeatedText
	text_end
.afterLocks
	text_far _VermilionGymGentlemanAfterLocksText
	text_end
.beforeBeat
	text_far _VermilionGymGentlemanAfterBattleText
	text_end

VermilionGymSuperNerdAfterBattleText:
	text_asm
	ld hl, .text_entries
	jr VermilionGymGetTrainerText
.text_entries
.afterBeat
	text_far _VermilionGymSuperNerdAfterBattleGymDefeatedText
	text_end
.afterLocks
	text_far _VermilionGymSuperNerdAfterLocksText
	text_end
.beforeBeat
	text_far _VermilionGymSuperNerdAfterBattleText
	text_end

VermilionGymSailorAfterBattleText:
	text_asm
	ld hl, .text_entries
	jr VermilionGymGetTrainerText
.text_entries
.afterBeat
	text_far _VermilionGymSailorAfterBattleGymDefeatedText
	text_end
.afterLocks
	text_far _VermilionGymSailorAfterLocksText
	text_end
.beforeBeat
	text_far _VermilionGymSailorAfterBattleText
	text_end

VermilionGymSailorBattleText:
	text_far _VermilionGymSailorBattleText
	text_end

VermilionGymSailorEndBattleText:
	text_far _VermilionGymSailorEndBattleText
	text_end

VermilionGymSuperNerdBattleText:
	text_far _VermilionGymSuperNerdBattleText
	text_end

VermilionGymSuperNerdEndBattleText:
	text_far _VermilionGymSuperNerdEndBattleText
	text_end

VermilionGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_THUNDERBADGE, a
	ld hl, VermilionGymGuideChampInMakingText
	jr z, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, VermilionGymGuidePostBattleText
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	CheckEvent EVENT_GOT_VERMILION_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText3
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText3
	jr nc, .printDone
	ld hl, ReceivedApexChipsText3
	rst _PrintText
	ld hl, VermilionGymGuideApexChipElectricText
	rst _PrintText
	SetEvent EVENT_GOT_VERMILION_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText3
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText3:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText3:
	text_far _PewterGymTM34NoRoomText
	text_end

GymGuideMoreApexChipText3:
	text_far _GymGuideMoreApexChipText
	text_end

AlreadyReceivedApexChipsText3:
	text_far _AlreadyReceivedApexChipsText
	text_end

VermilionGymGuideChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far _VermilionGymGymGuideChampInMakingText
	text_end

VermilionGymGuidePostBattleText:
	text_far _VermilionGymGymGuideBeatLTSurgeText
	text_end

VermilionGymGuideApexChipElectricText:
	text_far _VermilionGymGuideApexChipElectricText
	text_end

; PureRGBnote: ADDED: text entries for the garbage can and bookcase near surge for some flavour

VermilionGymGarbageNearSurgeText:
	text_far _VermilionGymGarbageNearSurgeText
	text_end

VermilionGymBookshelfText:
	text_far _VermilionGymBookshelfText
	text_end

VermilionGymTrashText::
	text_far _VermilionGymTrashText
	text_end

GymTrashScript::
	call EnableAutoTextBoxDrawing
	ld a, [wHiddenEventFunctionArgument]
	ld [wGymTrashCanIndex], a

; Don't do the trash can puzzle if it's already been done.
	CheckEvent EVENT_2ND_LOCK_OPENED
	jr nz, .onlyTrashHere
.ok
	CheckEventReuseA EVENT_1ST_LOCK_OPENED
	jr nz, .trySecondLock

	ld a, [wFirstLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr z, .openFirstLock
.onlyTrashHere
	ld a, TEXT_VERMILIONGYM_ONLY_TRASH_HERE
.displayText
	ldh [hTextID], a
	jp DisplayTextID
.openFirstLock
; Next can is trying for the second switch.
	SetEvent EVENT_1ST_LOCK_OPENED

	ld hl, GymTrashCans
	ld a, [wGymTrashCanIndex]
	; * 5
	ld b, a
	add a
	add a
	add b

	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]

; Bug: This code should calculate a value in the range [0, 3],
; but if the mask and random number don't have any 1 bits in common, then
; the result of the AND will be 0. When 1 is subtracted from that, the value
; will become $ff. This will result in 255 being added to hl, which will cause
; hl to point to one of the zero bytes that pad the end of the ROM bank.
; Trash can 0 was intended to be able to have the second lock only when the
; first lock was in trash can 1 or 3. However, due to this bug, trash can 0 can
; have the second lock regardless of which trash can had the first lock.

	ldh [hGymTrashCanRandNumMask], a
	push hl
.tryagain
	call Random
	swap a
	ld b, a
	ldh a, [hGymTrashCanRandNumMask]
	and b
	jr z, .tryagain ; PureRGBnote: FIXED: never AND to 0
	dec a
	pop hl

	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	and $f
	ld [wSecondLockTrashCanIndex], a

	ld a, TEXT_VERMILIONGYM_FOUND_FIRST_SWITCH
	jr .displayText

.trySecondLock
	ld a, [wSecondLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr z, .openSecondLock

; Reset the cans. ; PureRGBnote: CHANGED: don't reset locks because it's just an annoying waste of time
	;ResetEvent EVENT_1ST_LOCK_OPENED
	;call Random

	;and $e
	;ld [wFirstLockTrashCanIndex], a

	;tx_pre_id VermilionGymTrashFailText
	jr .onlyTrashHere

.openSecondLock
; Completed the trash can puzzle.
	SetEvent EVENT_2ND_LOCK_OPENED
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_2, [hl]

	ld a, TEXT_VERMILIONGYM_FOUND_SECOND_SWITCH
	jr .displayText

GymTrashCans:
; byte 0: mask for random number
; bytes 1-4: indices of the trash cans that can have the second lock
;            (but see the comment above explaining a bug regarding this)
; Note that the mask is simply the number of valid trash can indices that
; follow. The remaining bytes are filled with 0 to pad the length of each entry
; to 5 bytes.
	db 2,  1,  3,  0,  0 ; 0
	db 3,  0,  2,  4,  0 ; 1
	db 2,  1,  5,  0,  0 ; 2
	db 3,  0,  4,  6,  0 ; 3
	db 4,  1,  3,  5,  7 ; 4
	db 3,  2,  4,  8,  0 ; 5
	db 3,  3,  7,  9,  0 ; 6
	db 4,  4,  6,  8, 10 ; 7
	db 3,  5,  7, 11,  0 ; 8
	db 3,  6, 10, 12,  0 ; 9
	db 4,  7,  9, 11, 13 ; 10
	db 3,  8, 10, 14,  0 ; 11
	db 2,  9, 13,  0,  0 ; 12
	db 3, 10, 12, 14,  0 ; 13
	db 2, 11, 13,  0,  0 ; 14

VermilionGymTrashSuccessText1::
	text_far _VermilionGymTrashSuccessText1
	text_asm
	ld a, SFX_SWITCH
	call PlaySoundWaitForCurrent
	call DisplayTextPromptButton
	ld hl, .lockOpened
	rst _PrintText
	ld a, SFX_TELEPORT_ENTER_2
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	rst TextScriptEnd
.lockOpened
	text_far _VermilionGym1stElectricLock
	text_end

VermilionGymTrashSuccessText3::
	text_far _VermilionGymTrashSuccessText2
	text_asm
	ld a, SFX_SWITCH
	call PlaySoundWaitForCurrent
	call DisplayTextPromptButton
	ld hl, .lockOpened
	rst _PrintText
	ld a, SFX_TELEPORT_ENTER_2
	call PlaySoundWaitForCurrent
	call DisplayTextPromptButton
	ld hl, .motorizedDoorOpened
	rst _PrintText
	ld a, SFX_GO_INSIDE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	rst TextScriptEnd
.lockOpened
	text_far _VermilionGym2ndElectricLock
	text_end
.motorizedDoorOpened
	text_far _VermilionGymTrashSuccessText3
	text_end

;VermilionGymTrashFailText::
;	text_far _VermilionGymTrashFailText
;	text_asm
;	ld a, SFX_DENIED
;	rst PlaySoundWaitForCurrent
;	call WaitForSoundToFinish
;	rst TextScriptEnd
