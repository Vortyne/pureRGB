SSAnneBow_Script:
	ld hl, SSAnne5TrainerHeaders
	ld de, SSAnneBow_ScriptPointers
	ld bc, wSSAnneBowCurScript
	jp ExecuteCustomMapScriptInTable

SSAnneBow_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSANNEBOW_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSANNEBOW_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSANNEBOW_END_BATTLE

SSAnneBow_TextPointers:
	def_text_pointers
	dba_const _SSAnneBowSuperNerdText,    TEXT_SSANNEBOW_SUPER_NERD
	dba_const _SSAnneBowSailor1Text,      TEXT_SSANNEBOW_SAILOR1
	dba_const _SSAnneBowCooltrainerMText, TEXT_SSANNEBOW_COOLTRAINER_M
	dba_const SSAnneBowSailor2Text,      TEXT_SSANNEBOW_SAILOR2
	dba_const SSAnneBowSailor3Text,      TEXT_SSANNEBOW_SAILOR3

SSAnne5TrainerHeaders:
	def_trainers 4
SSAnne5TrainerHeader0:
	trainer EVENT_BEAT_SS_ANNE_5_TRAINER_0, 3, _SSAnneBowSailor2BattleText, _SSAnneBowSailor2EndBattleText, _SSAnneBowSailor2AfterBattleText
SSAnne5TrainerHeader1:
	trainer EVENT_BEAT_SS_ANNE_5_TRAINER_1, 3, _SSAnneBowSailor3BattleText, _SSAnneBowSailor3EndBattleText, _SSAnneBowSailor3AfterBattleText
	db -1 ; end

SSAnneBowSailor2Text:
	script_trainer SSAnne5TrainerHeader0

SSAnneBowSailor3Text:
	script_trainer SSAnne5TrainerHeader1
