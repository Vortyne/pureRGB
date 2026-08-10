Route9_Script:
	call Route9ReplaceCutTile
	ld hl, Route9TrainerHeaders
	ld de, Route9_ScriptPointers
	ld bc, wRoute9CurScript
	jp ExecuteCustomMapScriptInTable

; PureRGBnote: ADDED: function that will remove the cut tree if we deleted it with the tree deleter
Route9ReplaceCutTile:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	jr nz, .replaceTileNoRedraw
	call WasMapJustLoaded
	jr nz, .replaceTile
	ret
.replaceTile
	CheckEvent EVENT_DELETED_ROUTE9_TREE
	ret z
	call .loadTile
	jp ReplaceTileBlock
.replaceTileNoRedraw
	CheckEvent EVENT_DELETED_ROUTE9_TREE
	ret z
	; this avoids redrawing the map because when going between areas these tiles are offscreen.
	call .loadTile
	ld d, b
	ld e, c
	jpfar ReplaceTileBlockNoRedraw
.loadTile
	lb bc, 4, 3
	ld a, $4C
	ld [wNewTileBlockID], a
	ret

Route9_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE9_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE9_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE9_END_BATTLE

Route9_TextPointers:
	def_text_pointers
	dba_const Route9CooltrainerF1Text, TEXT_ROUTE9_COOLTRAINER_F1
	dba_const Route9CooltrainerM1Text, TEXT_ROUTE9_COOLTRAINER_M1
	dba_const Route9CooltrainerM2Text, TEXT_ROUTE9_COOLTRAINER_M2
	dba_const Route9CooltrainerF2Text, TEXT_ROUTE9_COOLTRAINER_F2
	dba_const Route9Hiker1Text,        TEXT_ROUTE9_HIKER1
	dba_const Route9Hiker2Text,        TEXT_ROUTE9_HIKER2
	dba_const Route9Youngster1Text,    TEXT_ROUTE9_YOUNGSTER1
	dba_const Route9Hiker3Text,        TEXT_ROUTE9_HIKER3
	dba_const Route9Youngster2Text,    TEXT_ROUTE9_YOUNGSTER2
	dba_const PickUpItemText,          TEXT_ROUTE9_ITEM1
	dba_const _Route9SignText,          TEXT_ROUTE9_SIGN

Route9TrainerHeaders:
	def_trainers
Route9TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_0, 3, _Route9CooltrainerF1BattleText, _Route9CooltrainerF1EndBattleText, Route9CooltrainerF1AfterBattleText
Route9TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_1, 2, _Route9CooltrainerM1BattleText, _Route9CooltrainerM1EndBattleText, Route9CooltrainerM1AfterBattleText
Route9TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_2, 4, _Route9CooltrainerM2BattleText, _Route9CooltrainerM2EndBattleText, _Route9CooltrainerM2AfterBattleText
Route9TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_3, 2, _Route9CooltrainerF2BattleText, _Route9CooltrainerF2EndBattleText, _Route9CooltrainerF2AfterBattleText
Route9TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_4, 2, _Route9Hiker1BattleText, _Route9Hiker1EndBattleText, Route9Hiker1AfterBattleText
Route9TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_5, 3, _Route9Hiker2BattleText, _Route9Hiker2EndBattleText, Route9Hiker2AfterBattleText
Route9TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_6, 4, _Route9Youngster1BattleText, _Route9Youngster1EndBattleText, _Route9Youngster1AfterBattleText
Route9TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_7, 2, _Route9Hiker3BattleText, _Route9Hiker3EndBattleText, _Route9Hiker3AfterBattleText
Route9TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_9_TRAINER_8, 2, _Route9Youngster2BattleText, _Route9Youngster2EndBattleText, Route9Youngster2AfterBattleText
	db -1 ; end

Route9CooltrainerF1Text:
	script_trainer Route9TrainerHeader0

Route9CooltrainerM1Text:
	script_trainer Route9TrainerHeader1

Route9CooltrainerM2Text:
	script_trainer Route9TrainerHeader2

Route9CooltrainerF2Text:
	script_trainer Route9TrainerHeader3

Route9Hiker1Text:
	script_trainer Route9TrainerHeader4

Route9Hiker2Text:
	script_trainer Route9TrainerHeader5

Route9Youngster1Text:
	script_trainer Route9TrainerHeader6

Route9Hiker3Text:
	script_trainer Route9TrainerHeader7

Route9Youngster2Text:
	script_trainer Route9TrainerHeader8

Route9CooltrainerF1AfterBattleText:
	text_far _Route9CooltrainerF1AfterBattleText
	text_asm
	lb hl, DEX_GLOOM, JR_TRAINER_F
	ld de, LearnsetGloom
	jr Route9LearnsetScript

Route9CooltrainerM1AfterBattleText:
	text_far _Route9CooltrainerM1AfterBattleText
	text_asm
	lb hl, DEX_RHYHORN, JR_TRAINER_M
	ld de, RhyhornLearnset
	jr Route9LearnsetScript

Route9Hiker1AfterBattleText:
	text_far _Route9Hiker1AfterBattleText
	text_asm
	lb hl, DEX_SANDSLASH, HIKER
	ld de, LearnsetSandslash
	jr Route9LearnsetScript

Route9Hiker2AfterBattleText:
	text_far _Route9Hiker2AfterBattleText
	text_asm
	lb hl, DEX_GEODUDE, HIKER
	ld de, GeodudeLearnset
	jr Route9LearnsetScript

Route9Youngster2AfterBattleText:
	text_far _Route9Youngster2AfterBattleText
	text_asm	
	lb hl, DEX_BEEDRILL, BUG_CATCHER
	ld de, LearnsetBoring
Route9LearnsetScript:
	predef_jump LearnsetTrainerScript
