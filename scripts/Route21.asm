; PureRGBnote: ADDED: The volcano was added in this route, so we need to check whether to remove it if the player turned it off, along with
; checking whether to remove the lava suit and a couple other things when leaving the volcano.
Route21_Script:
	call CheckRemoveVolcano
	ld hl, Route21TrainerHeaders
	ld de, Route21_ScriptPointers
	ld bc, wRoute21CurScript
	jp ExecuteCustomMapScriptInTable

CheckRemoveVolcano:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	jr nz, .replaceTiles
	call WasMapJustLoaded
	ret z
.checkRemoveLavaSuit
	; if we just exited the volcano, remove lava suit
	ld a, [wWalkBikeSurfState]
	cp WEARING_LAVA_SUIT
	jr nz, .replaceTiles
	ld a, WALKING
	ld [wWalkBikeSurfState], a
	call LoadWalkingPlayerSpriteGraphics
	; also turn on autosurf bit since we are guaranteed to have surfed to here and to prevent softlocks should have surf turned on again
	ld hl, wStatusFlags1
	set BIT_AUTOSURF, [hl] ; set autosurf bit
.replaceTiles
	CheckFlag FLAG_VOLCANO_AREA_TURNED_OFF
	ret z
	ld a, $43
	ld [wNewTileBlockID], a ; water block
	ld de, Route21TileBlockReplacements
	jpfar ReplaceMultipleTileBlockLineHorizontalWithOneBlock
	

Route21_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE21_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE21_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE21_END_BATTLE

Route21_TextPointers:
	def_text_pointers
	dba_const Route21Fisher1Text,  TEXT_ROUTE21_FISHER1
	dba_const Route21Fisher2Text,  TEXT_ROUTE21_FISHER2
	dba_const Route21Swimmer1Text, TEXT_ROUTE21_SWIMMER1
	dba_const Route21Swimmer2Text, TEXT_ROUTE21_SWIMMER2
	dba_const Route21Swimmer3Text, TEXT_ROUTE21_SWIMMER3
	dba_const Route21Swimmer4Text, TEXT_ROUTE21_SWIMMER4
	dba_const Route21Swimmer5Text, TEXT_ROUTE21_SWIMMER5
	dba_const Route21Fisher3Text,  TEXT_ROUTE21_FISHER3
	dba_const Route21Fisher4Text,  TEXT_ROUTE21_FISHER4
	dba_const PickUpItemText,      TEXT_ROUTE21_ITEM1 ; PureRGBnote: ADDED: new item on this route.
	dba_const _Route21CinnabarVolcanoSignText, TEXT_ROUTE21_CINNABAR_VOLCANO_SIGN

Route21TrainerHeaders:
	def_trainers
Route21TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_0, 0, _Route21Fisher1BattleText, _Route21Fisher1EndBattleText, _Route21Fisher1AfterBattleText
Route21TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_1, 0, _Route21Fisher2BattleText, _Route21Fisher2EndBattleText, _Route21Fisher2AfterBattleText
Route21TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_2, 4, _Route21Swimmer1BattleText, _Route21Swimmer1EndBattleText, _Route21Swimmer1AfterBattleText
Route21TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_3, 4, _Route21Swimmer2BattleText, _Route21Swimmer2EndBattleText, _Route21Swimmer2AfterBattleText
Route21TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_4, 4, _Route21Swimmer3BattleText, _Route21Swimmer3EndBattleText, _Route21Swimmer3AfterBattleText
Route21TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_5, 4, _Route21Swimmer4BattleText, _Route21Swimmer4EndBattleText, _Route21Swimmer4AfterBattleText
Route21TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_6, 3, _Route21Swimmer5BattleText, _Route21Swimmer5EndBattleText, _Route21Swimmer5AfterBattleText
Route21TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_7, 0, _Route21Fisher3BattleText, _Route21Fisher3EndBattleText, _Route21Fisher3AfterBattleText
Route21TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_21_TRAINER_8, 0, _Route21Fisher4BattleText, _Route21Fisher4EndBattleText, _Route21Fisher4AfterBattleText
	db -1 ; end

Route21Fisher1Text:
	script_trainer Route21TrainerHeader0

Route21Fisher2Text:
	script_trainer Route21TrainerHeader1

Route21Swimmer1Text:
	script_trainer Route21TrainerHeader2

Route21Swimmer2Text:
	script_trainer Route21TrainerHeader3

Route21Swimmer3Text:
	script_trainer Route21TrainerHeader4

Route21Swimmer4Text:
	script_trainer Route21TrainerHeader5

Route21Swimmer5Text:
	script_trainer Route21TrainerHeader6

Route21Fisher3Text:
	script_trainer Route21TrainerHeader7

Route21Fisher4Text:
	script_trainer Route21TrainerHeader8

Route21CinnabarVolcanoSign::
	CheckFlag FLAG_VOLCANO_AREA_TURNED_OFF
	ret nz
	ld a, TEXT_ROUTE21_CINNABAR_VOLCANO_SIGN
	ldh [hTextID], a
	jp DisplayTextID
