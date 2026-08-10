; PureRGBnote: ADDED: new trainers in this location

SafariZoneCenter_Script:
	call CheckModifySafariWildRate
	ld hl, SafariZoneCenterTrainerHeaders
	ld de, SafariZoneCenter_ScriptPointers
	ld bc, wSafariZoneCenterCurScript
	jp ExecuteCustomMapScriptInTable

SafariZoneCenter_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFARIZONECENTER_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFARIZONECENTER_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFARIZONECENTER_END_BATTLE
	dw_const RangerPostBattle,                		SCRIPT_SAFARIZONECENTER_RANGER_POST_BATTLE

SafariZoneCenter_TextPointers:
	def_text_pointers
	dba_const SafariZoneCenterRangerText0,         TEXT_SAFARIZONECENTER_RANGER
	dba_const SafariZoneCenterTrainerText0,        TEXT_SAFARIZONECENTER_ROCKER
	dba_const SafariZoneCenterTrainerText1,        TEXT_SAFARIZONECENTER_ENGINEER
	dba_const SafariZoneCenterTrainerText2,        TEXT_SAFARIZONECENTER_JUGGLER
	dba_const SafariZoneCenterTrainerText3,        TEXT_SAFARIZONECENTER_POKEMANIAC
	dba_const PickUpItemText,                      TEXT_SAFARIZONECENTER_ITEM1
	dba_const _SafariZoneCenterRestHouseSignText,   TEXT_SAFARIZONECENTER_REST_HOUSE_SIGN
	dba_const SafariZoneCenterTrainerTipsSignText, TEXT_SAFARIZONECENTER_TRAINER_TIPS_SIGN

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

SafariZoneCenterTrainerTipsSignText:
	text_asm
	ld hl, .default
	ld a, [wSafariType]
	ld bc, 5
	call AddNTimes
	rst _PrintText
	rst TextScriptEnd
.default:
	text_far_end _SafariZoneCenterTrainerTipsSignText
.rangerHunt:
	text_far_end _SafariZoneCenterText3RangerHunt
.freeRoam:
	text_far_end _SafariZoneCenterText3FreeRoam

SafariZoneCenterTrainerHeaders:
	def_trainers
SafariZoneCenterRangerHeader:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_RANGER_0, 0, _SafariZoneCenterRangerText, _SafariZoneCenterRangerEndBattleText, _SafariZoneCenterRangerAfterBattleText
SafariZoneCenterTrainerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_0, 3, _SafariZoneCenterRockerText, _SafariZoneCenterRockerEndBattleText, _SafariZoneCenterRockerAfterBattleText
SafariZoneCenterTrainerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_1, 0, _SafariZoneCenterEngineerText, _SafariZoneCenterEngineerEndBattleText, _SafariZoneCenterEngineerAfterBattleText
SafariZoneCenterTrainerHeader2:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_2, 3, _SafariZoneCenterJugglerText, _SafariZoneCenterJugglerEndBattleText, SafariZoneCenterJugglerAfterBattleText
SafariZoneCenterTrainerHeader3:
	trainer EVENT_BEAT_SAFARI_ZONE_CENTER_TRAINER_3, 3, _SafariZoneCenterManiacText, _SafariZoneCenterManiacEndBattleText, _SafariZoneCenterManiacAfterBattleText
	db -1 ; end

SafariZoneCenterRangerText0:
	text_asm
	ld hl, SafariZoneCenterRangerHeader
	call TalkToTrainer
	ld a, SCRIPT_SAFARIZONECENTER_RANGER_POST_BATTLE
	ld [wCurMapScript], a 
	rst TextScriptEnd

SafariZoneCenterTrainerText0:
	script_trainer SafariZoneCenterTrainerHeader0

SafariZoneCenterTrainerText1:
	script_trainer SafariZoneCenterTrainerHeader1

SafariZoneCenterTrainerText2:
	script_trainer SafariZoneCenterTrainerHeader2

SafariZoneCenterTrainerText3:
	script_trainer SafariZoneCenterTrainerHeader3

SafariZoneCenterJugglerAfterBattleText:
	text_far _SafariZoneCenterJugglerAfterBattleText
	text_asm
	lb hl, DEX_TAUROS, JUGGLER
	ld de, TaurosLearnsetText
	ld bc, LearnsetFadeOutInStory
	predef_jump LearnsetTrainerScriptMain

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