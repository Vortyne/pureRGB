SSAnne1FRooms_Script:
	ld hl, SSAnne8TrainerHeaders
	ld de, SSAnne1FRooms_ScriptPointers
	ld bc, wSSAnne1FRoomsCurScript
	jp ExecuteCustomMapScriptInTable

SSAnne1FRooms_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSANNE1FROOMS_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSANNE1FROOMS_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSANNE1FROOMS_END_BATTLE

SSAnne1FRooms_TextPointers:
	def_text_pointers
	dba_const SSAnne1FRoomsGentleman1Text,    TEXT_SSANNE1FROOMS_GENTLEMAN1
	dba_const SSAnne1FRoomsGentleman2Text,    TEXT_SSANNE1FROOMS_GENTLEMAN2
	dba_const SSAnne1FRoomsYoungsterText,     TEXT_SSANNE1FROOMS_YOUNGSTER
	dba_const SSAnne1FRoomsCooltrainerFText,  TEXT_SSANNE1FROOMS_COOLTRAINER_F
	dba_const _SSAnne1FRoomsGirl1Text,         TEXT_SSANNE1FROOMS_GIRL1
	dba_const _SSAnne1FRoomsMiddleAgedManText, TEXT_SSANNE1FROOMS_MIDDLE_AGED_MAN
	dba_const _SSAnne1FRoomsLittleGirlText,    TEXT_SSANNE1FROOMS_LITTLE_GIRL
	dba_const SSAnne1FRoomsWigglytuffText,    TEXT_SSANNE1FROOMS_WIGGLYTUFF
	dba_const _SSAnne1FRoomsGirl2Text,         TEXT_SSANNE1FROOMS_GIRL2
	dba_const PickUpItemText,                 TEXT_SSANNE1FROOMS_ITEM1
	dba_const _SSAnne1FRoomsGentleman3Text,    TEXT_SSANNE1FROOMS_GENTLEMAN3

SSAnne8TrainerHeaders:
	def_trainers
SSAnne8TrainerHeader0:
	trainer EVENT_BEAT_SS_ANNE_8_TRAINER_0, 2, _SSAnne1FRoomsGentleman1BattleText, _SSAnne1FRoomsGentleman1EndBattleText, SSAnne1FRoomsGentleman1AfterBattleText
SSAnne8TrainerHeader1:
	trainer EVENT_BEAT_SS_ANNE_8_TRAINER_1, 3, _SSAnne1FRoomsGentleman2BattleText, _SSAnne1FRoomsGentleman2EndBattleText, _SSAnne1FRoomsGentleman2AfterBattleText
SSAnne8TrainerHeader2:
	trainer EVENT_BEAT_SS_ANNE_8_TRAINER_2, 2, _SSAnne1FRoomsYoungsterBattleText, _SSAnne1FRoomsYoungsterEndBattleText, _SSAnne1FRoomsYoungsterAfterBattleText
SSAnne8TrainerHeader3:
	trainer EVENT_BEAT_SS_ANNE_8_TRAINER_3, 2, _SSAnne1FRoomsCooltrainerFBattleText, _SSAnne1FRoomsCooltrainerFEndBattleText, _SSAnne1FRoomsCooltrainerFAfterBattleText
	db -1 ; end

SSAnne1FRoomsGentleman1Text:
	script_trainer SSAnne8TrainerHeader0

SSAnne1FRoomsGentleman2Text:
	script_trainer SSAnne8TrainerHeader1

SSAnne1FRoomsYoungsterText:
	script_trainer SSAnne8TrainerHeader2

SSAnne1FRoomsCooltrainerFText:
	script_trainer SSAnne8TrainerHeader3

SSAnne1FRoomsWigglytuffText:
	text_far _SSAnne1FRoomsWigglytuffText
	text_asm
	ld c, DEX_WIGGLYTUFF - 1
  	callfar SetMonSeen
	ld a, WIGGLYTUFF
	call PlayCry
	rst TextScriptEnd

SSAnne1FRoomsGentleman1AfterBattleText:
	text_far _SSAnne1FRoomsGentleman1AfterBattleText
	text_asm
	lb hl, DEX_GROWLITHE, GENTLEMAN
	ld de, LearnsetGrowlithe
	ld bc, LearnsetFadeOutInfirmary
	predef_jump LearnsetTrainerScriptMain
