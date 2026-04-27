; PureRGBnote: ADDED: new trainers in this location

SafariZoneCenter_Script:
	call CheckModifySafariWildRate
	call EnableAutoTextBoxDrawing
	ld hl, SafariZoneCenterTrainerHeaders
	ld de, SafariZoneCenter_ScriptPointers
	ld a, [wSafariZoneCenterCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSafariZoneCenterCurScript], a
	ret

SafariZoneCenter_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFARIZONECENTER_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFARIZONECENTER_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFARIZONECENTER_END_BATTLE
	dw_const RangerPostBattle,                		SCRIPT_SAFARIZONECENTER_RANGER_POST_BATTLE

SafariZoneCenter_TextPointers:
	def_text_pointers
	dw_const SafariZoneCenterRangerText0,         TEXT_SAFARIZONECENTER_RANGER
	dw_const SafariZoneCenterTrainerText0,        TEXT_SAFARIZONECENTER_ROCKER
	dw_const SafariZoneCenterTrainerText1,        TEXT_SAFARIZONECENTER_ENGINEER
	dw_const SafariZoneCenterTrainerText2,        TEXT_SAFARIZONECENTER_JUGGLER
	dw_const SafariZoneCenterTrainerText3,        TEXT_SAFARIZONECENTER_POKEMANIAC
	dw_const PickUpItemText,                      TEXT_SAFARIZONECENTER_ITEM1
	dw_const SafariZoneCenterRestHouseSignText,   TEXT_SAFARIZONECENTER_REST_HOUSE_SIGN
	dw_const SafariZoneCenterTrainerTipsSignText, TEXT_SAFARIZONECENTER_TRAINER_TIPS_SIGN

CheckModifySafariWildRate:
	call WasMapJustLoaded
	ret z
	ld a, [wSafariType]
	and a
	ret nz
	ld a, 30 ; original grass encounter rate in classic mode
	ld [wGrassRate], a
	ret


RangerPostBattle::
	call EndTrainerBattle
	ld a, [wIsInBattle] 
	cp $ff ; if you lost the battle don't decrement and return
	ret z
	ld hl, wNumRangersLeft
	dec [hl]
	ret

SafariZoneCenterRestHouseSignText:
	text_far _SafariZoneCenterRestHouseSignText
	text_end

SafariZoneCenterTrainerTipsSignText:
	text_asm
	ld hl, .default
	ld a, [wSafariType]
	ld bc, 5
	call AddNTimes
	rst _PrintText
	rst TextScriptEnd
.default:
	text_far _SafariZoneCenterTrainerTipsSignText
	text_end
.rangerHunt:
	text_far _SafariZoneCenterText3RangerHunt
	text_end
.freeRoam:
	text_far _SafariZoneCenterText3FreeRoam
	text_end

SafariZoneCenterTrainerHeaders:
	def_trainers
SafariZoneCenterRangerHeader:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_RANGER_0, 0, SafariZoneCenterRangerBattleText0, SafariZoneCenterRangerEndBattleText0, SafariZoneCenterRangerAfterBattleText0
SafariZoneCenterTrainerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_0, 3, SafariZoneCenterTrainerBattleText0, SafariZoneCenterTrainerEndBattleText0, SafariZoneCenterTrainerAfterBattleText0
SafariZoneCenterTrainerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_1, 0, SafariZoneCenterTrainerBattleText1, SafariZoneCenterTrainerEndBattleText1, SafariZoneCenterTrainerAfterBattleText1
SafariZoneCenterTrainerHeader2:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_2, 3, SafariZoneCenterTrainerBattleText2, SafariZoneCenterTrainerEndBattleText2, SafariZoneCenterTrainerAfterBattleText2
SafariZoneCenterTrainerHeader3:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_3, 3, SafariZoneCenterTrainerBattleText3, SafariZoneCenterTrainerEndBattleText3, SafariZoneCenterTrainerAfterBattleText3
	db -1 ; end

SafariZoneCenterRangerText0:
	text_asm
	ld hl, SafariZoneCenterRangerHeader
	call TalkToTrainer
	ld a, SCRIPT_SAFARIZONECENTER_RANGER_POST_BATTLE
	ld [wCurMapScript], a 
	rst TextScriptEnd

SafariZoneCenterTrainerText0:
	text_asm
	ld hl, SafariZoneCenterTrainerHeader0
	jr SafariZoneCenterTalkToTrainer

SafariZoneCenterTrainerText1:
	text_asm
	ld hl, SafariZoneCenterTrainerHeader1
	jr SafariZoneCenterTalkToTrainer

SafariZoneCenterTrainerText2:
	text_asm
	ld hl, SafariZoneCenterTrainerHeader2
	jr SafariZoneCenterTalkToTrainer

SafariZoneCenterTrainerText3:
	text_asm
	ld hl, SafariZoneCenterTrainerHeader3
SafariZoneCenterTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SafariZoneCenterRangerBattleText0:
	text_far _SafariZoneCenterRangerText
	text_end

SafariZoneCenterRangerEndBattleText0:
	text_far _SafariZoneCenterRangerEndBattleText
	text_end

SafariZoneCenterRangerAfterBattleText0:
	text_far _SafariZoneCenterRangerAfterBattleText
	text_end

SafariZoneCenterTrainerBattleText0:
	text_far _SafariZoneCenterRockerText
	text_end

SafariZoneCenterTrainerEndBattleText0:
	text_far _SafariZoneCenterRockerEndBattleText
	text_end

SafariZoneCenterTrainerAfterBattleText0:
	text_far _SafariZoneCenterRockerAfterBattleText
	text_end

SafariZoneCenterTrainerBattleText1:
	text_far _SafariZoneCenterEngineerText
	text_end

SafariZoneCenterTrainerEndBattleText1:
	text_far _SafariZoneCenterEngineerEndBattleText
	text_end

SafariZoneCenterTrainerAfterBattleText1:
	text_far _SafariZoneCenterEngineerAfterBattleText
	text_end

SafariZoneCenterTrainerBattleText2:
	text_far _SafariZoneCenterJugglerText
	text_end

SafariZoneCenterTrainerEndBattleText2:
	text_far _SafariZoneCenterJugglerEndBattleText
	text_end

SafariZoneCenterTrainerAfterBattleText2:
	text_far _SafariZoneCenterJugglerAfterBattleText
	text_asm
	lb hl, DEX_TAUROS, JUGGLER
	ld de, TaurosLearnsetText
	ld bc, LearnsetFadeOutInStory
	predef_jump LearnsetTrainerScriptMain

SafariZoneCenterTrainerBattleText3:
	text_far _SafariZoneCenterManiacText
	text_end

SafariZoneCenterTrainerEndBattleText3:
	text_far _SafariZoneCenterManiacEndBattleText
	text_end

SafariZoneCenterTrainerAfterBattleText3:
	text_far _SafariZoneCenterManiacAfterBattleText
	text_end

SafariZonePlayMusic::
	ld a, [wWalkBikeSurfState]
	cp BIKING
	jr z, .bikeCheck
.noBikeMusic
	ld a, [wOptions2]
	bit BIT_MUSIC, a
	jr z, .ogMusic
	ld a, MUSIC_SAFARI_ZONE_EXPANDED
	ld [wReplacedMapMusic], a
	ld hl, Music_SafariZone
	ld c, BANK(Music_SafariZone)
	jp PlaySpecialFieldMusic
.ogMusic
	xor a
	ld [wReplacedMapMusic], a
	ld hl, Music_Evolution_In_SafariZone
	ld c, BANK(Music_Evolution_In_SafariZone)
	jp PlaySpecialFieldMusic
.bikeCheck
	ld a, [wOptions2]
	bit BIT_BIKE_MUSIC, a
	jr nz, .noBikeMusic
	; if we are on the bike currently, play default bike music
	xor a
	ld [wReplacedMapMusic], a
	jp PlayDefaultMusic