; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.
; PureRGBnote: ADDED: code that plays Giovanni's theme if we have the option turned on

SilphCo11F_Script:
	call SilphCo11FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo11TrainerHeaders
	ld de, SilphCo11F_ScriptPointers
	ld a, [wSilphCo11FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo11FCurScript], a
	ret

SilphCo11FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	jpfar SilphCo11FCardKeyMapLoad

SilphCo11FTeamRocketLeavesScript::
	ld hl, .HideToggleableObjectIDs
.hide_loop
	ld a, [hli]
	cp $ff
	jr z, .done_hiding
	push hl
	ld c, a
	call HideObject
	pop hl
	jr .hide_loop
.done_hiding ; the lists are in a sequence so you can just keep going after the first loop hits -1
.show_loop
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld c, a
	call ShowObject
	pop hl
	jr .show_loop

.HideToggleableObjectIDs:
	db TOGGLE_SAFFRON_CITY_1
	db TOGGLE_SAFFRON_CITY_2
	db TOGGLE_SAFFRON_CITY_3
	db TOGGLE_SAFFRON_CITY_4
	db TOGGLE_SAFFRON_CITY_5
	db TOGGLE_SAFFRON_CITY_6
	db TOGGLE_SAFFRON_CITY_7
	db TOGGLE_SAFFRON_CITY_E
	db TOGGLE_SAFFRON_CITY_F
	db TOGGLE_SILPH_CO_2F_2
	db TOGGLE_SILPH_CO_2F_3
	db TOGGLE_SILPH_CO_2F_4
	db TOGGLE_SILPH_CO_2F_5
	db TOGGLE_SILPH_CO_3F_1
	db TOGGLE_SILPH_CO_3F_2
	db TOGGLE_SILPH_CO_4F_1
	db TOGGLE_SILPH_CO_4F_2
	db TOGGLE_SILPH_CO_4F_3
	db TOGGLE_SILPH_CO_5F_1
	db TOGGLE_SILPH_CO_5F_2
	db TOGGLE_SILPH_CO_5F_3
	db TOGGLE_SILPH_CO_5F_4
	db TOGGLE_SILPH_CO_6F_1
	db TOGGLE_SILPH_CO_6F_2
	db TOGGLE_SILPH_CO_6F_3
	db TOGGLE_SILPH_CO_7F_1
	db TOGGLE_SILPH_CO_7F_2
	db TOGGLE_SILPH_CO_7F_3
	db TOGGLE_SILPH_CO_7F_4
	db TOGGLE_SILPH_CO_8F_1
	db TOGGLE_SILPH_CO_8F_2
	db TOGGLE_SILPH_CO_8F_3
	db TOGGLE_SILPH_CO_9F_1
	db TOGGLE_SILPH_CO_9F_2
	db TOGGLE_SILPH_CO_9F_3
	db TOGGLE_SILPH_CO_10F_1
	db TOGGLE_SILPH_CO_10F_2
	db TOGGLE_SILPH_CO_11F_1
	db TOGGLE_SILPH_CO_11F_2
	db TOGGLE_SILPH_CO_11F_3
	db -1 ; end
.ShowToggleableObjectIDs:
	db TOGGLE_SAFFRON_CITY_8
	db TOGGLE_SAFFRON_CITY_9
	db TOGGLE_SAFFRON_CITY_A
	db TOGGLE_SAFFRON_CITY_B
	db TOGGLE_SAFFRON_CITY_C
	db TOGGLE_SAFFRON_CITY_D
;;;;;;;;;; PureRGBnote: ADDED: show additional new NPCs on the first floor
	db TOGGLE_SILPH_CO_1F_TRAINER_1
	db TOGGLE_SILPH_CO_1F_TRAINER_2
	db TOGGLE_SILPH_CO_1F_TRAINER_3
	db TOGGLE_SILPH_CO_1F_TRAINER_4
;;;;;;;;;;
	db TOGGLE_SILPH_CO_1F_RECEPTIONIST ; PureRGBnote: CHANGED: used to be shown with an event instead for some reason
	db -1 ; end

SilphCo11F_ScriptPointers:
	def_script_pointers
	dw_const SilphCo11FDefaultScript,               SCRIPT_SILPHCO11F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO11F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO11F_END_BATTLE
	dw_const SilphCo11FGiovanniBattleFacingScript,  SCRIPT_SILPHCO11F_GIOVANNI_FACING
	dw_const SilphCo11FGiovanniStartBattleScript,   SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	dw_const SilphCo11FGiovanniAfterBattleScript,   SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE

SilphCo11FDefaultScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	jp nz, CheckFightingMapTrainers
ENDC
	ld hl, .PlayerCoordsArray
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	callfar PlayGiovanniMusic
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	xor a
	ldh [hJoyHeld], a
	call DisableDpad
	ld a, TEXT_SILPHCO11F_GIOVANNI
	ldh [hTextID], a
	call DisplayTextID
	ld a, SILPHCO11F_GIOVANNI
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, .GiovanniMovement
	call MoveSprite
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_FACING
	jr SilphCo11FSetCurScript

.PlayerCoordsArray:
	dbmapcoord  6, 13
	dbmapcoord  7, 12
	db -1 ; end

.GiovanniMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SilphCo11FResetCurScript:
	call EnableAllJoypad
; fallthrough
SilphCo11FSetCurScript:
	ld [wSilphCo11FCurScript], a
	ld [wCurMapScript], a
	ret

SilphCo11FGiovanniAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, SilphCo11FResetCurScript
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, upper-right entry in SilphCo11FDefaultScript.PlayerCoordsArray
	ld a, PLAYER_DIR_UP
	jr z, .gotDirections
	ld a, PLAYER_DIR_LEFT
.gotDirections
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	call SilphCo11FGateCallbackScript
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	call GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here
	callfar PlayGiovanniMusic
	call DisableDpad
	ld d, SILPHCO11F_GIOVANNI
	callfar MakeSpriteFacePlayer
	ld a, TEXT_SILPHCO11F_GIOVANNI_YOU_RUINED_OUR_PLANS
	ldh [hTextID], a
	call DisplayTextID
	call GBFadeOutToBlack
	call SilphCo11FTeamRocketLeavesScript
	call UpdateSpritesAndDelay3
	call GBFadeInFromBlack
	SetEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	callfar PlayDefaultMusicIfMusicBitSet
	jr SilphCo11FResetCurScript

SilphCo11FGiovanniBattleFacingScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, SILPHCO11F_GIOVANNI
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, upper-right entry in SilphCo11FDefaultScript.PlayerCoordsArray
	ld a, PLAYER_DIR_UP
	jr z, .gotDirections
	ld a, PLAYER_DIR_LEFT
.gotDirections
	ld [wPlayerMovingDirection], a
	ld d, SILPHCO11F_GIOVANNI
	callfar MakeSpriteFacePlayer
	call Delay3
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	jp SilphCo11FSetCurScript

SilphCo11FGiovanniStartBattleScript:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo10FGiovanniILostAgainText
	ld de, SilphCo10FGiovanniILostAgainText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	call EnableAllJoypad
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE
	jp SilphCo11FSetCurScript

SilphCo11F_TextPointers:
	def_text_pointers
	dw_const SilphCo11FSilphPresidentText,            TEXT_SILPHCO11F_SILPH_PRESIDENT
	dw_const SilphCo11FBeautyText,                    TEXT_SILPHCO11F_BEAUTY
	dw_const SilphCo11FGiovanniText,                  TEXT_SILPHCO11F_GIOVANNI
	dw_const SilphCo11FRocket1Text,                   TEXT_SILPHCO11F_ROCKET1
	dw_const SilphCo11FRocket2Text,                   TEXT_SILPHCO11F_ROCKET2
	dw_const SilphCo11FPorygonText,                   TEXT_SILPHCO11F_COMPUTER_MONITOR
	dw_const SilphCo11FGiovanniYouRuinedOurPlansText, TEXT_SILPHCO11F_GIOVANNI_YOU_RUINED_OUR_PLANS

SilphCo11TrainerHeaders:
	def_trainers 4
SilphCo11TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_11F_TRAINER_0, 4, SilphCo11FRocket1BattleText, SilphCo11FRocket1EndBattleText, SilphCo11FRocket1AfterBattleText
SilphCo11TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_11F_TRAINER_1, 3, SilphCo11FRocket2BattleText, SilphCo11FRocket2EndBattleText, SilphCo11FRocket2AfterBattleText
	db -1 ; end

SilphCo11FSilphPresidentText:
	text_asm
	CheckEvent EVENT_GOT_MASTER_BALL
	ld hl, .MasterBallDescriptionText
	jp nz, .printDone
	ld hl, .Text
	rst _PrintText
	lb bc, ITEM_SILPH_CO_PRESIDENT_REWARD, 1
	call GiveItem
	ld hl, .NoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_MASTER_BALL
	ld hl, .ReceivedMasterBallText
.printDone
	rst _PrintText
	rst TextScriptEnd

.Text:
	text_far _SilphCo11FSilphPresidentText
	text_end

.ReceivedMasterBallText:
	text_far _SilphCo11FSilphPresidentReceivedMasterBallText
	sound_get_key_item
	text_end

.MasterBallDescriptionText:
	text_far _SilphCo11FSilphPresidentMasterBallDescriptionText
	text_end

.NoRoomText:
	text_far _SilphCo11FSilphPresidentNoRoomText
	text_end

SilphCo11FBeautyText:
	text_far _SilphCo11FBeautyText
	text_end

SilphCo11FGiovanniText:
	text_far _SilphCo11FGiovanniText
	text_end

SilphCo10FGiovanniILostAgainText:
	text_far _SilphCo10FGiovanniILostAgainText
	text_end

SilphCo11FGiovanniYouRuinedOurPlansText:
	text_far _SilphCo11FGiovanniYouRuinedOurPlansText
	text_end

SilphCo11FRocket1Text:
	text_asm
	ld hl, SilphCo11TrainerHeader0
	; fall through
SilphCo11FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo11FRocket2Text:
	text_asm
	ld hl, SilphCo11TrainerHeader1
	jr SilphCo11FTalkToTrainer

SilphCo11FRocket1BattleText:
	text_far _SilphCo11FRocket1BattleText
	text_end

SilphCo11FRocket1EndBattleText:
	text_far _SilphCo11FRocket1EndBattleText
	text_end

SilphCo11FRocket1AfterBattleText:
	text_far _SilphCo11FRocket1AfterBattleText
	text_end

SilphCo11FRocket2BattleText:
	text_far _SilphCo11FRocket2BattleText
	text_end

SilphCo11FRocket2EndBattleText:
	text_far _SilphCo11FRocket2EndBattleText
	text_end

SilphCo11FRocket2AfterBattleText:
	text_far _SilphCo11FRocket2AfterBattleText
	text_end

; PureRGBnote: CHANGED: this text was unused, now it's used.
SilphCo11FPorygonText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, .WrongSideText
	jr nz, .printDone
	ld hl, .Text
	rst _PrintText
	ld a, PORYGON
	call DisplayPokedex
	; dex number still stored in wPokedexNum
	callfar IsPokemonLearnsetUnlockedDirect
	jr nz, .done
	call AreLearnsetsEnabled
	jr z, .done
	callfar SetPokemonLearnsetUnlocked
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .infoOn
	rst _PrintText
	; wNameBuffer still contains pokemon name
	callfar LearnsetUnlockedScript
	rst TextScriptEnd
.printDone
	rst _PrintText
.done
	rst TextScriptEnd
.Text:
	text_far _SilphCo11FPorygonText
	text_end
.WrongSideText
	text_far _RedsHouse1FTVWrongSideText
	text_end
.infoOn
	text_far _BillsHousePCInfo
	text_end