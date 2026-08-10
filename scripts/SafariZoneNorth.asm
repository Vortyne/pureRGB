; PureRGBnote: ADDED: new trainers in this location

SafariZoneNorth_Script:
	call CheckModifySafariWildRate
	ld hl, SafariZoneNorthTrainerHeaders
	ld de, SafariZoneNorth_ScriptPointers
	ld bc, wSafariZoneNorthCurScript
	jp ExecuteCustomMapScriptInTable

SafariZoneNorth_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFARIZONENORTH_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFARIZONENORTH_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFARIZONENORTH_END_BATTLE
	dw_const RangerPostBattle,                 		SCRIPT_SAFARIZONENORTH_RANGER_POST_BATTLE
	ASSERT BANK(RangerPostBattle) == BANK(SafariZoneNorth_Script)

SafariZoneNorth_TextPointers:
	def_text_pointers
	dba_const SafariZoneNorthRangerText0,       TEXT_SAFARIZONENORTH_RANGER_F
	dba_const SafariZoneNorthTrainerText0,      TEXT_SAFARIZONENORTH_JUGGLER
	dba_const SafariZoneNorthTrainerText1,      TEXT_SAFARIZONENORTH_COOLTRAINER_M
	dba_const SafariZoneNorthTrainerText2,      TEXT_SAFARIZONENORTH_SUPER_NERD
	dba_const SafariZoneNorthTrainerText3,      TEXT_SAFARIZONENORTH_ENGINEER
	dba_const SafariZoneNorthTrainerText4,      TEXT_SAFARIZONENORTH_POKEMANIAC
	dba_const PickUpItemText,                   TEXT_SAFARIZONENORTH_ITEM1
	dba_const PickUpItemText,                   TEXT_SAFARIZONENORTH_ITEM2
	dba_const _SafariZoneNorthRestHouseSignText, TEXT_SAFARIZONENORTH_REST_HOUSE_SIGN
	dba_const _SafariZoneNorthTrainerTips1Text,  TEXT_SAFARIZONENORTH_TRAINER_TIPS_1
	dba_const _SafariZoneNorthSignText,          TEXT_SAFARIZONENORTH_SIGN
	dba_const _SafariZoneNorthTrainerTips2Text,  TEXT_SAFARIZONENORTH_TRAINER_TIPS_2
	dba_const _SafariZoneNorthTrainerTips3Text,  TEXT_SAFARIZONENORTH_TRAINER_TIPS_3

SafariZoneNorthTrainerHeaders:
	def_trainers
SafariZoneNorthRangerHeader:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_RANGER_0, 0, _SafariZoneNorthRangerText, _SafariZoneNorthRangerEndBattleText, _SafariZoneNorthRangerAfterBattleText
SafariZoneNorthTrainerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_0, 4, _SafariZoneNorthJugglerText, _SafariZoneNorthJugglerEndBattleText, _SafariZoneNorthJugglerAfterBattleText
SafariZoneNorthTrainerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_1, 4, _SafariZoneNorthCooltrainerMText, _SafariZoneNorthCooltrainerMEndBattleText, _SafariZoneNorthCooltrainerMAfterBattleText
SafariZoneNorthTrainerHeader2:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_2, 1, _SafariZoneNorthSuperNerdText, _SafariZoneNorthSuperNerdEndBattleText, _SafariZoneNorthSuperNerdAfterBattleText
SafariZoneNorthTrainerHeader3:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_3, 0, _SafariZoneNorthEngineerText, _SafariZoneNorthEngineerEndBattleText, _SafariZoneNorthEngineerAfterBattleText
SafariZoneNorthTrainerHeader4:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_4, 4, _SafariZoneNorthManiacText, _SafariZoneNorthManiacEndBattleText, _SafariZoneNorthManiacAfterBattleText
	db -1 ; end

SafariZoneNorthRangerText0:
	text_asm
	ld hl, SafariZoneNorthRangerHeader
	call TalkToTrainer
	ld a, SCRIPT_SAFARIZONENORTH_RANGER_POST_BATTLE
	ld [wCurMapScript], a 
	rst TextScriptEnd

SafariZoneNorthTrainerText0:
	script_trainer SafariZoneNorthTrainerHeader0

SafariZoneNorthTrainerText1:
	script_trainer SafariZoneNorthTrainerHeader1

SafariZoneNorthTrainerText2:
	script_trainer SafariZoneNorthTrainerHeader2

SafariZoneNorthTrainerText3:
	script_trainer SafariZoneNorthTrainerHeader3

SafariZoneNorthTrainerText4:
	script_trainer SafariZoneNorthTrainerHeader4
