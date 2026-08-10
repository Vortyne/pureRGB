; PureRGBnote: ADDED: new trainers in this location

SafariZoneEast_Script:
	call CheckModifySafariWildRate
	ld hl, SafariZoneEastTrainerHeaders
	ld de, SafariZoneEast_ScriptPointers
	ld bc, wSafariZoneEastCurScript
	jp ExecuteCustomMapScriptInTable

SafariZoneEast_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFARIZONEEAST_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFARIZONEEAST_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFARIZONEEAST_END_BATTLE
	dw_const RangerPostBattle,		                SCRIPT_SAFARIZONEEAST_RANGER_POST_BATTLE
	ASSERT BANK(RangerPostBattle) == BANK(SafariZoneEast_Script)

SafariZoneEast_TextPointers:
	def_text_pointers
	dba_const SafariZoneEastRangerText0,       TEXT_SAFARIZONEEAST_RANGER_F
	dba_const SafariZoneEastTrainerText0,      TEXT_SAFARIZONEEAST_PSYCHIC
	dba_const SafariZoneEastTrainerText1,      TEXT_SAFARIZONEEAST_ROCKER
	dba_const SafariZoneEastTrainerText2,      TEXT_SAFARIZONEEAST_COOLTRAINER_M
	dba_const SafariZoneEastTrainerText3,      TEXT_SAFARIZONEEAST_ENGINEER
	dba_const PickUpItemText,                  TEXT_SAFARIZONEEAST_ITEM1
	dba_const PickUp5ItemText,                 TEXT_SAFARIZONEEAST_ITEM2
	dba_const PickUpItemText,                  TEXT_SAFARIZONEEAST_ITEM3
	dba_const PickUpItemText,                  TEXT_SAFARIZONEEAST_ITEM4
	dba_const _SafariZoneEastRestHouseSignText, TEXT_SAFARIZONEEAST_REST_HOUSE_SIGN
	dba_const _SafariZoneEastTrainerTipsText,   TEXT_SAFARIZONEEAST_TRAINER_TIPS
	dba_const _SafariZoneEastSignText,          TEXT_SAFARIZONEEAST_SIGN

SafariZoneEastTrainerTipsText:
	text_asm
	ld a, [wSafariType]
	cp SAFARI_TYPE_CLASSIC
	ld hl, SafariZoneEastText6Default
	jr z, .done
	ld hl, SafariZoneEastText6NotClassic
.done
	rst _PrintText
	rst TextScriptEnd

SafariZoneEastText6Default:
	text_far_end _SafariZoneEastTrainerTipsText

SafariZoneEastText6NotClassic:
	text_far_end _SafariZoneEastText6NotClassic

SafariZoneEastTrainerHeaders:
	def_trainers
SafariZoneEastRangerHeader:
	trainer EVENT_BEAT_SAFARI_ZONE_EAST_RANGER_0, 0, _SafariZoneEastRangerText, _SafariZoneEastRangerEndBattleText, _SafariZoneEastRangerAfterBattleText
SafariZoneEastTrainerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_EAST_TRAINER_0, 3, _SafariZoneEastPsychicText, _SafariZoneEastPsychicEndBattleText, _SafariZoneEastPsychicAfterBattleText
SafariZoneEastTrainerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_EAST_TRAINER_1, 4, _SafariZoneEastRockerText, _SafariZoneEastRockerEndBattleText, _SafariZoneEastRockerAfterBattleText
SafariZoneEastTrainerHeader2:
	trainer EVENT_BEAT_SAFARI_ZONE_EAST_TRAINER_2, 2, _SafariZoneEastCooltrainerMText, _SafariZoneEastCooltrainerMEndBattleText, _SafariZoneEastCooltrainerMAfterBattleText
SafariZoneEastTrainerHeader3:
	trainer EVENT_BEAT_SAFARI_ZONE_EAST_TRAINER_3, 0, _SafariZoneEastEngineerText, _SafariZoneEastEngineerEndBattleText, _SafariZoneEastEngineerAfterBattleText
	db -1 ; end

SafariZoneEastRangerText0:
	text_asm
	ld hl, SafariZoneEastRangerHeader
	call TalkToTrainer
	ld a, SCRIPT_SAFARIZONEEAST_RANGER_POST_BATTLE
	ld [wCurMapScript], a 
	rst TextScriptEnd

SafariZoneEastTrainerText0:
	script_trainer SafariZoneEastTrainerHeader0

SafariZoneEastTrainerText1:
	script_trainer SafariZoneEastTrainerHeader1

SafariZoneEastTrainerText2:
	script_trainer SafariZoneEastTrainerHeader2

SafariZoneEastTrainerText3:
	script_trainer SafariZoneEastTrainerHeader3
