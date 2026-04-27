ViridianCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCity_ScriptPointers
	ld a, [wViridianCityCurScript]
	jp CallFunctionInTable

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
	dw_const ViridianCityYoungster1Text,                     TEXT_VIRIDIANCITY_YOUNGSTER1
	dw_const ViridianCityGambler1Text,                       TEXT_VIRIDIANCITY_GAMBLER1
	dw_const ViridianCityYoungster2Text,                     TEXT_VIRIDIANCITY_YOUNGSTER2
	dw_const ViridianCityGirlText,                           TEXT_VIRIDIANCITY_GIRL
	dw_const ViridianCityOldManSleepyText,                   TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	dw_const ViridianCityFisherText,                         TEXT_VIRIDIANCITY_FISHER
	dw_const ViridianCityOldManText,                         TEXT_VIRIDIANCITY_OLD_MAN
	dw_const ViridianCitySignText,                           TEXT_VIRIDIANCITY_SIGN
	dw_const ViridianCityTrainerTips1Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS1
	dw_const ViridianCityTrainerTips2Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS2
	dw_const MartSignText,                                   TEXT_VIRIDIANCITY_MART_SIGN
	dw_const PokeCenterSignText,                             TEXT_VIRIDIANCITY_POKECENTER_SIGN
	dw_const ViridianCityGymSignText,                        TEXT_VIRIDIANCITY_GYM_SIGN
	dw_const ViridianCityGymLockedText,                      TEXT_VIRIDIANCITY_GYM_LOCKED
	dw_const ViridianCityOldManYouNeedToWeakenTheTargetText, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET

ViridianCityYoungster1Text:
	text_far _ViridianCityYoungster1Text
	text_end

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
	text_far _ViridianCityGambler1GymAlwaysClosedText
	text_end

.GymLeaderReturnedText:
	text_far _ViridianCityGambler1GymLeaderReturnedText
	text_end

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
	text_far _ViridianCityYoungster2YouWantToKnowAboutText
	text_end

.OkThenText:
	text_far ViridianCityYoungster2OkThenText
	text_end

.CaterpieAndWeedleDescriptionText:
	text_far ViridianCityYoungster2CaterpieAndWeedleDescriptionText
	text_end

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
	text_far _ViridianCityGirlHasntHadHisCoffeeYetText
	text_end

.WhenIGoShopText:
	text_far _ViridianCityGirlWhenIGoShopText
	text_end

ViridianCityOldManSleepyText:
	text_asm
	ld hl, .PrivatePropertyText
	rst _PrintText
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	rst TextScriptEnd

.PrivatePropertyText:
	text_far _ViridianCityOldManSleepyPrivatePropertyText
	text_end

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
	text_far ViridianCityFisherYouCanHaveThisText
	text_end

.ReceivedTM42Text:
	text_far _ViridianCityFisherReceivedTM42Text
	sound_get_item_2
	text_end

.TM42ExplanationText:
	text_far _ViridianCityFisherTM42ExplanationText
	text_end

.TM42NoRoomText:
	text_far _ViridianCityFisherTM42NoRoomText
	text_end

SleeperName:
	db "SLEEPY GUY@"

ViridianCityOldManText:
	text_asm
	ld hl, .HadMyCoffeeNowText
	rst _PrintText
	ld c, 2
	rst _DelayFrames
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
	text_far _ViridianCityOldManHadMyCoffeeNowText
	text_end

.KnowHowToCatchPokemonText:
	text_far _ViridianCityOldManKnowHowToCatchPokemonText
	text_end

.TimeIsMoneyText:
	text_far _ViridianCityOldManTimeIsMoneyText
	text_end

ViridianCityOldManYouNeedToWeakenTheTargetText:
	text_far _ViridianCityOldManYouNeedToWeakenTheTargetText
	text_end

ViridianCitySignText:
	text_far _ViridianCitySignText
	text_end

ViridianCityTrainerTips1Text:
	text_far _ViridianCityTrainerTips1Text
	text_end

ViridianCityTrainerTips2Text:
	text_far _ViridianCityTrainerTips2Text
	text_end

ViridianCityGymSignText:
	text_far _ViridianCityGymSignText
	text_end

ViridianCityGymLockedText:
	text_far _ViridianCityGymLockedText
	text_end
