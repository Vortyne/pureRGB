MtMoon1F_Script:
	ld hl, MtMoon1TrainerHeaders
	ld de, MtMoon1F_ScriptPointers
	ld bc, wMtMoon1FCurScript
	jp ExecuteCustomMapScriptInTable

MtMoon1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_MTMOON1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_MTMOON1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_MTMOON1F_END_BATTLE

MtMoon1F_TextPointers:
	def_text_pointers
	dba_const MtMoon1FHikerText,         TEXT_MTMOON1F_HIKER
	dba_const MtMoon1FYoungster1Text,    TEXT_MTMOON1F_YOUNGSTER1
	dba_const MtMoon1FCooltrainerF1Text, TEXT_MTMOON1F_COOLTRAINER_F1
	dba_const MtMoon1FSuperNerdText,     TEXT_MTMOON1F_SUPER_NERD
	dba_const MtMoon1FCooltrainerF2Text, TEXT_MTMOON1F_COOLTRAINER_F2
	dba_const MtMoon1FYoungster2Text,    TEXT_MTMOON1F_YOUNGSTER2
	dba_const MtMoon1FYoungster3Text,    TEXT_MTMOON1F_YOUNGSTER3
	dba_const PickUp3ItemText,           TEXT_MTMOON1F_ITEM1
	dba_const PickUpItemText,            TEXT_MTMOON1F_ITEM2
	dba_const PickUpItemText,            TEXT_MTMOON1F_ITEM3
	dba_const PickUpItemText,            TEXT_MTMOON1F_ITEM4
	dba_const PickUp3ItemText,           TEXT_MTMOON1F_ITEM5
	dba_const PickUpItemText,            TEXT_MTMOON1F_ITEM6
	dba_const MtMoon1FBewareZubatSign,   TEXT_MTMOON1F_BEWARE_ZUBAT_SIGN

MtMoon1TrainerHeaders:
	def_trainers
MtMoon1TrainerHeader0:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_0, 2, _MtMoon1FHikerBattleText, _MtMoon1FHikerEndBattleText, _MtMoon1FHikerAfterBattleText
MtMoon1TrainerHeader1:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_1, 3, _MtMoon1FYoungster1BattleText, _MtMoon1FYoungster1EndBattleText, _MtMoon1FYoungster1AfterBattleText
MtMoon1TrainerHeader2:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_2, 3, _MtMoon1FCooltrainerF1BattleText, _MtMoon1FCooltrainerF1EndBattleText, _MtMoon1FCooltrainerF1AfterBattleText
MtMoon1TrainerHeader3:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_3, 3, _MtMoon1FSuperNerdBattleText, _MtMoon1FSuperNerdEndBattleText, _MtMoon1FSuperNerdAfterBattleText
MtMoon1TrainerHeader4:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_4, 3, _MtMoon1FCooltrainerF2BattleText, _MtMoon1FCooltrainerF2EndBattleText, _MtMoon1FCooltrainerF2AfterBattleText
MtMoon1TrainerHeader5:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_5, 3, _MtMoon1FYoungster2BattleText, _MtMoon1FYoungster2EndBattleText, _MtMoon1FYoungster2AfterBattleText
MtMoon1TrainerHeader6:
	trainer EVENT_BEAT_MT_MOON_1_TRAINER_6, 3, _MtMoon1FYoungster3BattleText, _MtMoon1FYoungster3EndBattleText, _MtMoon1FYoungster3AfterBattleText
	db -1 ; end

MtMoon1FHikerText:
	script_trainer MtMoon1TrainerHeader0

MtMoon1FYoungster1Text:
	script_trainer MtMoon1TrainerHeader1

MtMoon1FCooltrainerF1Text:
	script_trainer MtMoon1TrainerHeader2

MtMoon1FSuperNerdText:
	script_trainer MtMoon1TrainerHeader3

MtMoon1FCooltrainerF2Text:
	script_trainer MtMoon1TrainerHeader4

MtMoon1FYoungster2Text:
	script_trainer MtMoon1TrainerHeader5

MtMoon1FYoungster3Text:
	script_trainer MtMoon1TrainerHeader6

MtMoon1FBewareZubatSign:
	text_far _MtMoon1FBewareZubatSign
	text_asm
	CheckEvent FLAG_GOLBAT_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_ZUBAT
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
