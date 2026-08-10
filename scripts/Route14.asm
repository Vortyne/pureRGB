; PureRGBnote: ADDED: new trainers in this route.

Route14_Script:
	ld hl, Route14TrainerHeaders
	ld de, Route14_ScriptPointers
	ld bc, wRoute14CurScript
	jp ExecuteCustomMapScriptInTable

Route14_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE14_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE14_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE14_END_BATTLE

Route14_TextPointers:
	def_text_pointers
	dba_const Route14CooltrainerM1Text, TEXT_ROUTE14_COOLTRAINER_M1
	dba_const Route14CooltrainerM2Text, TEXT_ROUTE14_COOLTRAINER_M2
	dba_const Route14CooltrainerM3Text, TEXT_ROUTE14_COOLTRAINER_M3
	dba_const Route14CooltrainerM4Text, TEXT_ROUTE14_COOLTRAINER_M4
	dba_const Route14CooltrainerM5Text, TEXT_ROUTE14_COOLTRAINER_M5
	dba_const Route14CooltrainerM6Text, TEXT_ROUTE14_COOLTRAINER_M6
	dba_const Route14Biker1Text,        TEXT_ROUTE14_BIKER1
	dba_const Route14Biker2Text,        TEXT_ROUTE14_BIKER2
	dba_const Route14Biker3Text,        TEXT_ROUTE14_BIKER3
	dba_const Route14Biker4Text,        TEXT_ROUTE14_BIKER4
	dba_const Route14Text11,            TEXT_ROUTE14_COOLTRAINER_M7
	dba_const Route14Text12,            TEXT_ROUTE14_BEAUTY
	dba_const _Route14SignText,         TEXT_ROUTE14_SIGN
	dba_const _Route14Text12,           TEXT_ROUTE14_TRAINER_TIPS ; PureRGBnote: ADDED: new trainer tips sign on this route.

Route14TrainerHeaders:
	def_trainers
Route14TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_0, 2, _Route14CooltrainerM1BattleText, _Route14CooltrainerM1EndBattleText, _Route14CooltrainerM1AfterBattleText
Route14TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_1, 2, _Route14CooltrainerM2BattleText, _Route14CooltrainerM2EndBattleText, _Route14CooltrainerM2AfterBattleText
Route14TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_2, 4, _Route14CooltrainerM3BattleText, _Route14CooltrainerM3EndBattleText, _Route14CooltrainerM3AfterBattleText
Route14TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_3, 3, _Route14CooltrainerM4BattleText, _Route14CooltrainerM4EndBattleText, _Route14CooltrainerM4AfterBattleText
Route14TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_4, 3, _Route14CooltrainerM5BattleText, _Route14CooltrainerM5EndBattleText, Route14CooltrainerM5AfterBattleText
Route14TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_5, 4, _Route14CooltrainerM6BattleText, _Route14CooltrainerM6EndBattleText, _Route14CooltrainerM6AfterBattleText
Route14TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_6, 4, _Route14Biker1BattleText, _Route14Biker1EndBattleText, _Route14Biker1AfterBattleText
Route14TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_7, 4, _Route14Biker2BattleText, _Route14Biker2EndBattleText, _Route14Biker2AfterBattleText
Route14TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_8, 3, _Route14Biker3BattleText, _Route14Biker3EndBattleText, _Route14Biker3AfterBattleText
Route14TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_9, 4, _Route14Biker4BattleText, _Route14Biker4EndBattleText, _Route14Biker4AfterBattleText
Route14TrainerHeader10:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_10, 3, _Route14BattleText11, _Route14EndBattleText11, _Route14AfterBattleText11
Route14TrainerHeader11:
	trainer EVENT_BEAT_ROUTE_14_TRAINER_11, 4, _Route14BattleText12, _Route14EndBattleText12, _Route14AfterBattleText12
	db -1 ; end

Route14CooltrainerM1Text:
	script_trainer Route14TrainerHeader0

Route14CooltrainerM2Text:
	script_trainer Route14TrainerHeader1

Route14CooltrainerM3Text:
	script_trainer Route14TrainerHeader2

Route14CooltrainerM4Text:
	script_trainer Route14TrainerHeader3

Route14CooltrainerM5Text:
	script_trainer Route14TrainerHeader4

Route14CooltrainerM6Text:
	script_trainer Route14TrainerHeader5

Route14Biker1Text:
	script_trainer Route14TrainerHeader6

Route14Biker2Text:
	script_trainer Route14TrainerHeader7

Route14Biker3Text:
	script_trainer Route14TrainerHeader8

Route14Biker4Text:
	script_trainer Route14TrainerHeader9

Route14Text11:
	script_trainer Route14TrainerHeader10

Route14Text12:
	script_trainer Route14TrainerHeader11

DoesPlayerHaveLegendaryBird::
	CheckEvent FLAG_ARTICUNO_LEARNSET
	jr nz, .zapdosCheck
	ld d, ARTICUNO
	callfar IsMonInParty
	jr c, .hasLegendaryBird
.zapdosCheck
	CheckEvent FLAG_ZAPDOS_LEARNSET
	jr nz, .moltresCheck
	ld d, ZAPDOS
	callfar IsMonInParty
	jr c, .hasLegendaryBird
.moltresCheck
	CheckEvent FLAG_MOLTRES_LEARNSET
	jr nz, .noBird
	ld d, MOLTRES
	callfar IsMonInParty
	jr c, .hasLegendaryBird
.noBird
	and a
	ret
.hasLegendaryBird
	; d = still the pokemon the player has
	ld a, d
	ld [wPokedexNum], a
	ld hl, .whatYouHaveBirdAn
	cp ARTICUNO
	jr z, .gotText
	ld hl, .whatYouHaveBirdA
.gotText
	push hl
	call GetMonName
	pop hl
	rst _PrintText
	ld hl, .learnset2
	rst _PrintText
	call IndexToPokedex
	scf
	ret
.whatYouHaveBirdA
	text_far_end _LegendaryBirdLearnsetA
.whatYouHaveBirdAn
	text_far_end _LegendaryBirdLearnsetAn
.learnset2
	text_far_end _LegendaryBirdLearnset

Route14CooltrainerM5AfterBattleText:
	text_asm
	call DoesPlayerHaveLegendaryBird
	jr c, .hasLegendaryBird
	ld hl, .defaultAfterText
	rst _PrintText
	rst TextScriptEnd
.hasLegendaryBird
	ld a, [wPokedexNum]
	ld h, a
	ld l, BIRD_KEEPER
	ld de, TextNothing
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain
.defaultAfterText 
	text_far_end _Route14CooltrainerM5AfterBattleText
