SSAnneB1FRooms_Script:
	ld hl, SSAnne10TrainerHeaders
	ld de, SSAnneB1FRooms_ScriptPointers
	ld bc, wSSAnneB1FRoomsCurScript
	jp ExecuteCustomMapScriptInTable

SSAnneB1FRooms_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSANNEB1FROOMS_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSANNEB1FROOMS_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSANNEB1FROOMS_END_BATTLE

SSAnneB1FRooms_TextPointers:
	def_text_pointers
	dba_const SSAnneB1FRoomsSailor1Text,   TEXT_SSANNEB1FROOMS_SAILOR1
	dba_const SSAnneB1FRoomsSailor2Text,   TEXT_SSANNEB1FROOMS_SAILOR2
	dba_const SSAnneB1FRoomsSailor3Text,   TEXT_SSANNEB1FROOMS_SAILOR3
	dba_const SSAnneB1FRoomsSailor4Text,   TEXT_SSANNEB1FROOMS_SAILOR4
	dba_const SSAnneB1FRoomsSailor5Text,   TEXT_SSANNEB1FROOMS_SAILOR5
	dba_const SSAnneB1FRoomsFisherText,    TEXT_SSANNEB1FROOMS_FISHER
	dba_const SSAnneB1FRoomsSuperNerdText, TEXT_SSANNEB1FROOMS_SUPER_NERD
	dba_const SSAnneB1FRoomsMachokeText,   TEXT_SSANNEB1FROOMS_MACHOKE
	dba_const PickUp2ItemText,             TEXT_SSANNEB1FROOMS_ITEM1
	dba_const PickUpItemText,              TEXT_SSANNEB1FROOMS_ITEM2
	dba_const PickUpItemText,              TEXT_SSANNEB1FROOMS_ITEM3

SSAnne10TrainerHeaders:
	def_trainers
SSAnne10TrainerHeader0:
	trainer EVENT_BEAT_SS_ANNE_10_TRAINER_0, 2, _SSAnneB1FRoomsSailor1BattleText, _SSAnneB1FRoomsSailor1EndBattleText, _SSAnneB1FRoomsSailor1AfterBattleText
SSAnne10TrainerHeader1:
	trainer EVENT_BEAT_SS_ANNE_10_TRAINER_1, 3, _SSAnneB1FRoomsSailor2BattleText, _SSAnneB1FRoomsSailor2EndBattleText, _SSAnneB1FRoomsSailor2AfterBattleText
SSAnne10TrainerHeader2:
	trainer EVENT_BEAT_SS_ANNE_10_TRAINER_2, 2, _SSAnneB1FRoomsSailor3BattleText, _SSAnneB1FRoomsSailor3EndBattleText, _SSAnneB1FRoomsSailor3AfterBattleText
SSAnne10TrainerHeader3:
	trainer EVENT_BEAT_SS_ANNE_10_TRAINER_3, 2, _SSAnneB1FRoomsSailor4BattleText, _SSAnneB1FRoomsSailor4EndBattleText, _SSAnneB1FRoomsSailor4AfterBattleText
SSAnne10TrainerHeader4:
	trainer EVENT_BEAT_SS_ANNE_10_TRAINER_4, 2, _SSAnneB1FRoomsSailor5BattleText, _SSAnneB1FRoomsSailor5EndBattleText, _SSAnneB1FRoomsSailor5AfterBattleText
SSAnne10TrainerHeader5:
	trainer EVENT_BEAT_SS_ANNE_10_TRAINER_5, 3, _SSAnneB1FRoomsFisherBattleText, _SSAnneB1FRoomsFisherEndBattleText, _SSAnneB1FRoomsFisherAfterBattleText
	db -1 ; end

SSAnneB1FRoomsSailor1Text:
	script_trainer SSAnne10TrainerHeader0

SSAnneB1FRoomsSailor2Text:
	script_trainer SSAnne10TrainerHeader1

SSAnneB1FRoomsSailor3Text:
	script_trainer SSAnne10TrainerHeader2

SSAnneB1FRoomsSailor4Text:
	script_trainer SSAnne10TrainerHeader3

SSAnneB1FRoomsSailor5Text:
	script_trainer SSAnne10TrainerHeader4

SSAnneB1FRoomsFisherText:
	script_trainer SSAnne10TrainerHeader5

SSAnneB1FRoomsMachokeText:
	text_far _SSAnneB1FRoomsMachokeText
	text_asm
	ld c, DEX_MACHOKE - 1
	callfar SetMonSeen
	ld a, MACHOKE
	call PlayCry
	rst TextScriptEnd

SSAnneB1FRoomsSuperNerdText:
	text_far _SSAnneB1FRoomsSuperNerdText
	text_asm
	ld a, SSANNEB1FROOMS_MACHOKE
	call SetSpriteFacingDown
	ld c, DEX_MACHOKE - 1
	callfar SetMonSeen
	lb hl, DEX_MACHOKE, SAILOR
	ld de, LearnsetTough
	ld bc, LearnsetShowedCoolMoves
	predef_jump LearnsetTrainerScriptMain
