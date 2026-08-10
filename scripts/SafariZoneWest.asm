; PureRGBnote: ADDED: new trainers in this location

SafariZoneWest_Script:
	ld hl, SafariZoneWestTrainerHeaders
	ld de, SafariZoneWest_ScriptPointers
	ld bc, wSafariZoneWestCurScript
	jp ExecuteCustomMapScriptInTable

SafariZoneWest_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFARIZONEWEST_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFARIZONEWEST_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFARIZONEWEST_END_BATTLE
	dw_const RangerPostBattle,  	                SCRIPT_SAFARIZONEWEST_RANGER_POST_BATTLE
	ASSERT BANK(RangerPostBattle) == BANK(SafariZoneWest_Script)

SafariZoneWest_TextPointers:
	def_text_pointers
	dba_const SafariZoneWestRangerText0,              TEXT_SAFARIZONEWEST_RANGER1
	dba_const SafariZoneWestRangerText1,              TEXT_SAFARIZONEWEST_RANGER2
	dba_const SafariZoneWestTrainerText0,             TEXT_SAFARIZONEWEST_BURGLAR
	dba_const SafariZoneWestTrainerText1,             TEXT_SAFARIZONEWEST_POKEMANIAC
	dba_const SafariZoneWestTrainerText2,             TEXT_SAFARIZONEWEST_ROCKER
	dba_const SafariZoneWestTrainerText3,             TEXT_SAFARIZONEWEST_JUGGLER
	dba_const SafariZoneWestTrainerText4,             TEXT_SAFARIZONEWEST_PSYCHIC
	dba_const PickUpItemText,                         TEXT_SAFARIZONEWEST_ITEM1
	dba_const PickUpItemText,                         TEXT_SAFARIZONEWEST_ITEM2
	dba_const PickUpItemText,                         TEXT_SAFARIZONEWEST_ITEM3
	dba_const PickUpItemText,                         TEXT_SAFARIZONEWEST_ITEM4
	dba_const _SafariZoneWestRestHouseSignText,        TEXT_SAFARIZONEWEST_REST_HOUSE_SIGN
	dba_const _SafariZoneWestFindWardensTeethSignText, TEXT_SAFARIZONEWEST_FIND_WARDENS_TEETH_SIGN
	dba_const _SafariZoneWestTrainerTipsText,          TEXT_SAFARIZONEWEST_TRAINER_TIPS
	dba_const _SafariZoneWestSignText,                 TEXT_SAFARIZONEWEST_SIGN

SafariZoneWestTrainerHeaders:
	def_trainers
SafariZoneWestRangerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_RANGER_0, 0, _SafariZoneWestRanger0Text, _SafariZoneWestRanger0EndBattleText, _SafariZoneWestRanger0AfterBattleText
SafariZoneWestRangerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_RANGER_1, 0, _SafariZoneWestRanger1Text, _SafariZoneWestRanger1EndBattleText, _SafariZoneWestRanger1AfterBattleText
SafariZoneWestTrainerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_TRAINER_0, 3, _SafariZoneWestBurglarText, _SafariZoneWestBurglarEndBattleText, _SafariZoneWestBurglarAfterBattleText
SafariZoneWestTrainerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_TRAINER_1, 3, _SafariZoneWestManiacText, _SafariZoneWestManiacEndBattleText, _SafariZoneWestManiacAfterBattleText
SafariZoneWestTrainerHeader2:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_TRAINER_2, 3, _SafariZoneWestRockerText, _SafariZoneWestRockerEndBattleText, _SafariZoneWestRockerAfterBattleText
SafariZoneWestTrainerHeader3:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_TRAINER_3, 3, _SafariZoneWestJugglerText, _SafariZoneWestJugglerEndBattleText, _SafariZoneWestJugglerAfterBattleText
SafariZoneWestTrainerHeader4:
	trainer EVENT_BEAT_SAFARI_ZONE_WEST_TRAINER_4, 3, _SafariZoneWestPsychicText, _SafariZoneWestPsychicEndBattleText, _SafariZoneWestPsychicAfterBattleText
	db -1 ; end

SafariZoneWestRangerText0:
	text_asm
	ld hl, SafariZoneWestRangerHeader0
	jr SafariZoneWestRangerText1.rangerBattle

SafariZoneWestRangerText1:
	text_asm
	ld hl, SafariZoneWestRangerHeader1
.rangerBattle
	call TalkToTrainer
	ld a, SCRIPT_SAFARIZONEWEST_RANGER_POST_BATTLE
	ld [wCurMapScript], a 
	rst TextScriptEnd

SafariZoneWestTrainerText0:
	script_trainer SafariZoneWestTrainerHeader0

SafariZoneWestTrainerText1:
	script_trainer SafariZoneWestTrainerHeader1

SafariZoneWestTrainerText2:
	script_trainer SafariZoneWestTrainerHeader2

SafariZoneWestTrainerText3:
	script_trainer SafariZoneWestTrainerHeader3

SafariZoneWestTrainerText4:
	script_trainer SafariZoneWestTrainerHeader4
