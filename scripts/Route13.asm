Route13_Script:
	call Route13CheckHideCutTree
	ld hl, Route13TrainerHeaders
	ld de, Route13_ScriptPointers
	ld bc, wRoute13CurScript
	jp ExecuteCustomMapScriptInTable

; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
Route13CheckHideCutTree:
	call WasMapJustLoaded
	jr nz, .next 
	ld hl, wCurrentMapScriptFlags
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	ret z
.movePidgeot
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_TORNADO_BALL
	ret nz
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	lb bc, SPRITESTATEDATA2_MAPX, ROUTE13_PIDGEOT
	call GetFromSpriteStateData2
	ld [hl], 6 + 4
	ret
.next
	call .movePidgeot
	ld de, Route13CutAlcove
	callfar FarArePlayerCoordsInRange
	call c, .removeTreeBlocker
	ret
.removeTreeBlocker
	; if we're in the cut alcove, remove the tree
	lb bc, 2, 17
	ld a, $6F
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

Route13_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE13_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE13_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE13_END_BATTLE

Route13_TextPointers:
	def_text_pointers
	dba_const Route13CooltrainerM1Text, TEXT_ROUTE13_COOLTRAINER_M1
	dba_const Route13CooltrainerF1Text, TEXT_ROUTE13_COOLTRAINER_F1
	dba_const Route13CooltrainerF2Text, TEXT_ROUTE13_COOLTRAINER_F2
	dba_const Route13CooltrainerF3Text, TEXT_ROUTE13_COOLTRAINER_F3
	dba_const Route13CooltrainerF4Text, TEXT_ROUTE13_COOLTRAINER_F4
	dba_const Route13CooltrainerM2Text, TEXT_ROUTE13_COOLTRAINER_M2
	dba_const Route13Beauty1Text,       TEXT_ROUTE13_BEAUTY1
	dba_const Route13Beauty2Text,       TEXT_ROUTE13_BEAUTY2
	dba_const Route13BikerText,         TEXT_ROUTE13_BIKER
	dba_const Route13CooltrainerM3Text, TEXT_ROUTE13_COOLTRAINER_M3
	dba_const _Route13PidgeotText,       TEXT_ROUTE13_PIDGEOT
	dba_const _Route13TrainerTips1Text,  TEXT_ROUTE13_TRAINER_TIPS1
	dba_const _Route13TrainerTips2Text,  TEXT_ROUTE13_TRAINER_TIPS2
	dba_const _Route13SignText,          TEXT_ROUTE13_SIGN

Route13TrainerHeaders:
	def_trainers
Route13TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_0, 2, _Route13CooltrainerM1BattleText, _Route13CooltrainerM1EndBattleText, _Route13CooltrainerM1AfterBattleText
Route13TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_1, 2, _Route13CooltrainerF1BattleText, _Route13CooltrainerF1EndBattleText, _Route13CooltrainerF1AfterBattleText
Route13TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_2, 2, _Route13CooltrainerF2BattleText, _Route13CooltrainerF2EndBattleText, _Route13CooltrainerF2AfterBattleText
Route13TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_3, 2, _Route13CooltrainerF3BattleText, _Route13CooltrainerF3EndBattleText, _Route13CooltrainerF3AfterBattleText
Route13TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_4, 4, _Route13CooltrainerF4BattleText, _Route13CooltrainerF4EndBattleText, _Route13CooltrainerF4AfterBattleText
Route13TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_5, 2, _Route13CooltrainerM2BattleText, _Route13CooltrainerM2EndBattleText, _Route13CooltrainerM2AfterBattleText
Route13TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_6, 4, _Route13Beauty1BattleText, _Route13Beauty1EndBattleText, _Route13Beauty1AfterBattleText
Route13TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_7, 2, _Route13Beauty2BattleText, _Route13Beauty2EndBattleText, _Route13Beauty2AfterBattleText
Route13TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_8, 2, _Route13BikerBattleText, _Route13BikerEndBattleText, _Route13BikerAfterBattleText
Route13TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_13_TRAINER_9, 4, _Route13CooltrainerM3BattleText, _Route13CooltrainerM3EndBattleText, Route13CooltrainerM3AfterBattleText
	db -1 ; end

Route13CooltrainerM1Text:
	script_trainer Route13TrainerHeader0

Route13CooltrainerF1Text:
	script_trainer Route13TrainerHeader1

Route13CooltrainerF2Text:
	script_trainer Route13TrainerHeader2

Route13CooltrainerF3Text:
	script_trainer Route13TrainerHeader3

Route13CooltrainerF4Text:
	script_trainer Route13TrainerHeader4

Route13CooltrainerM2Text:
	script_trainer Route13TrainerHeader5

Route13Beauty1Text:
	script_trainer Route13TrainerHeader6

Route13Beauty2Text:
	script_trainer Route13TrainerHeader7

Route13BikerText:
	script_trainer Route13TrainerHeader8

Route13CooltrainerM3Text:
	script_trainer Route13TrainerHeader9

Route13CooltrainerM3AfterBattleText:
	text_far _Route13CooltrainerM3AfterBattleText
	text_asm
	lb hl, DEX_FEAROW, BIRD_KEEPER
	ld de, FearowLearnset
	predef_jump LearnsetTrainerScript

PidgeotHiddenObject::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_TORNADO_BALL
	ret nz
	ld c, DEX_PIDGEOT - 1
  	callfar SetMonSeen
	ld a, TEXT_ROUTE13_PIDGEOT
.displayTextID
	ldh [hTextID], a
	jp DisplayTextID
