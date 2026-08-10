ViridianCity_Script:
	ld hl, ViridianCity_ScriptPointers
	ld de, wViridianCityCurScript
	jp CallMapScriptInTable

ViridianCity_ScriptPointers:
	def_script_pointers
	dw_const ViridianCityDefaultScript,                  SCRIPT_VIRIDIANCITY_DEFAULT
	dw_const ViridianCityOldManStartCatchTrainingScript, SCRIPT_VIRIDIANCITY_OLD_MAN_START_CATCH_TRAINING
	dw_const ViridianCityOldManEndCatchTrainingScript,   SCRIPT_VIRIDIANCITY_OLD_MAN_END_CATCH_TRAINING
	dw_const ViridianCityPlayerMovingDownScript,         SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN

ViridianCityDefaultScript:
	call ViridianCityCheckGymOpenScript
	jp ViridianCityCheckGotPokedexScript

ViridianCityCheckGymOpenScript:
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	ret nz
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr nz, .gym_closed
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ret
.gym_closed
	lb bc, 8, 32
	ld d, TEXT_VIRIDIANCITY_GYM_LOCKED
	jr ViridianCityCheckTriggerMoveDownScript

ViridianCityCheckGotPokedexScript:
	CheckEvent EVENT_GOT_POKEDEX
	ret nz
	lb bc, 9, 19
	ld d, TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
ViridianCityCheckTriggerMoveDownScript:
	ld a, [wYCoord]
	cp b
	ret nz
	ld a, [wXCoord]
	cp c
	ret nz
	ld a, d
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManStartCatchTrainingScript:
	ld hl, wSprite03StateData1YPixels
	ld de, hSpriteScreenYCoord
	ld bc, 4
	rst _CopyData
	xor a
	ld [wListScrollOffset], a

;;;;;;;;;; PureRGBnote: ADDED: enable item duplication "glitch" via this new wram variable
	ld hl, wNewInGameFlags
	set ITEM_DUPLICATION_ACTIVE, [hl] ; each time the game is reset we have to trigger this to allow item duplication from missingno
;;;;;;;;;;

	; set up battle for Old Man
	ld a, BATTLE_TYPE_OLD_MAN
	ld [wBattleType], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, WEEDLE
	ld [wCurOpponent], a
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_END_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManEndCatchTrainingScript:
	ld hl, hSpriteScreenYCoord
	ld de, wSprite03StateData1YPixels
	ld bc, 4
	rst _CopyData
	call UpdateSpritesAndDelay3
	call EnableAllJoypad
	ld a, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET
	ldh [hTextID], a
	call DisplayTextID
	call EnableAllJoypad
	; a = 0 from EnableAllJoypad
	ld [wBattleType], a
	jr ViridianCityPlayerMovingDownScript.resetScript

ViridianCityPlayerMovingDownScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
.resetScript
	ld [wViridianCityCurScript], a  ; SCRIPT_VIRIDIANCITY_DEFAULT
	ret

ViridianCityMovePlayerDownScript:
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call EnableAllJoypad
	ld [wSpritePlayerStateData1FacingDirection], a
	ret

ViridianCity_TextPointers:
	def_text_pointers
	dba_const _ViridianCityYoungster1Text,                     TEXT_VIRIDIANCITY_YOUNGSTER1
	dba_const ViridianCityGambler1Text,                       TEXT_VIRIDIANCITY_GAMBLER1
	dba_const ViridianCityYoungster2Text,                     TEXT_VIRIDIANCITY_YOUNGSTER2
	dba_const ViridianCityGirlText,                           TEXT_VIRIDIANCITY_GIRL
	dba_const ViridianCityOldManSleepyText,                   TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	dba_const ViridianCityFisherText,                         TEXT_VIRIDIANCITY_FISHER
	dba_const ViridianCityOldManText,                         TEXT_VIRIDIANCITY_OLD_MAN
	dba_const _ViridianCitySignText,                           TEXT_VIRIDIANCITY_SIGN
	dba_const _ViridianCityTrainerTips1Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS1
	dba_const _ViridianCityTrainerTips2Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS2
	dba_const MartSignText,                                   TEXT_VIRIDIANCITY_MART_SIGN
	dba_const PokeCenterSignText,                             TEXT_VIRIDIANCITY_POKECENTER_SIGN
	dba_const _ViridianCityGymSignText,                        TEXT_VIRIDIANCITY_GYM_SIGN
	dba_const _ViridianCityGymLockedText,                      TEXT_VIRIDIANCITY_GYM_LOCKED
	dba_const _ViridianCityOldManYouNeedToWeakenTheTargetText, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET

ViridianCityGambler1Text:
	text_asm
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	ld hl, .GymLeaderReturnedText
	jr z, .print_text
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .print_text
	ld hl, .GymAlwaysClosedText
.print_text
	rst _PrintText
	rst TextScriptEnd

.GymAlwaysClosedText:
	text_far_end _ViridianCityGambler1GymAlwaysClosedText

.GymLeaderReturnedText:
	text_far_end _ViridianCityGambler1GymLeaderReturnedText

ViridianCityYoungster2Text:
	text_asm
	ld hl, .YouWantToKnowAboutText
	rst _PrintText
	call YesNoChoice
	ld hl, .OkThenText
	jr nz, .printDone
	ld hl, .CaterpieAndWeedleDescriptionText
.printDone
	rst _PrintText
	rst TextScriptEnd

.YouWantToKnowAboutText:
	text_far_end _ViridianCityYoungster2YouWantToKnowAboutText

.OkThenText:
	text_far_end ViridianCityYoungster2OkThenText

.CaterpieAndWeedleDescriptionText:
	text_far_end ViridianCityYoungster2CaterpieAndWeedleDescriptionText

ViridianCityGirlText:
	text_asm
	CheckEvent EVENT_GOT_POKEDEX
	ld hl, .WhenIGoShopText
	jr nz, .printDone
	ld hl, .HasntHadHisCoffeeYetText
.printDone
	rst _PrintText
	rst TextScriptEnd

.HasntHadHisCoffeeYetText:
	text_far_end _ViridianCityGirlHasntHadHisCoffeeYetText

.WhenIGoShopText:
	text_far_end _ViridianCityGirlWhenIGoShopText

ViridianCityOldManSleepyText:
	text_asm
	ld hl, .PrivatePropertyText
	rst _PrintText
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	rst TextScriptEnd

.PrivatePropertyText:
	text_far_end _ViridianCityOldManSleepyPrivatePropertyText

ViridianCityFisherText:
	text_asm
	CheckEvent EVENT_GOT_TM42
	jr nz, .got_item
	ld hl, .YouCanHaveThisText
	rst _PrintText
	lb bc, TM_VIRIDIAN_CITY_SLEEPING_GUY, 1
	call GiveItem
	ld hl, .TM42NoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_TM42
	ld hl, .ReceivedTM42Text
.printDone
	rst _PrintText
	rst TextScriptEnd
.got_item
	ld hl, .TM42ExplanationText
	rst _PrintText
	ld c, DEX_GASTLY - 1
	callfar SetMonSeen
	ld de, SleeperName
	call CopyTrainerName
	lb hl, DEX_GASTLY, $FF
	ld de, GastlyLearnset
	ld bc, LearnsetFadeOutInDream
	predef_jump LearnsetTrainerScriptMain

.YouCanHaveThisText:
	text_far_end ViridianCityFisherYouCanHaveThisText

.ReceivedTM42Text:
	text_far _ViridianCityFisherReceivedTM42Text
	sound_get_item_2
	text_end

.TM42ExplanationText:
	text_far_end _ViridianCityFisherTM42ExplanationText

.TM42NoRoomText:
	text_far_end _ViridianCityFisherTM42NoRoomText

SleeperName:
	db "SLEEPY GUY@"

ViridianCityOldManText:
	text_asm
	ld hl, .HadMyCoffeeNowText
	rst _PrintText
	ld c, 2
	rst DelayFrames
	call YesNoChoice
	ld hl, .TimeIsMoneyText
	jr z, .printDone
	ld hl, .KnowHowToCatchPokemonText
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_START_CATCH_TRAINING
	ld [wViridianCityCurScript], a
.printDone
	rst _PrintText
	rst TextScriptEnd

.HadMyCoffeeNowText:
	text_far_end _ViridianCityOldManHadMyCoffeeNowText

.KnowHowToCatchPokemonText:
	text_far_end _ViridianCityOldManKnowHowToCatchPokemonText

.TimeIsMoneyText:
	text_far_end _ViridianCityOldManTimeIsMoneyText
