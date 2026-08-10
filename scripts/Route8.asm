Route8_Script:
	call Route8CheckHideCutTrees
	ld hl, Route8TrainerHeaders
	ld de, Route8_ScriptPointers
	ld bc, wRoute8CurScript
	jp ExecuteCustomMapScriptInTable

; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
Route8CheckHideCutTrees:

	call WasMapJustLoaded
	call nz, .checkReplaceTiles
	ld hl, wCurrentMapScriptFlags
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	call nz, .moveJolteon
	ret
.checkReplaceTiles
	call .moveJolteon
	ld de, Route8CutAlcove
	callfar FarArePlayerCoordsInRange
	jr c, .removeTreeBlockers
	; if the map is loaded outside of the alcove, reset the cut tree events
	ResetEvent EVENT_CUT_DOWN_ROUTE8_LEFT_TREE
	ResetEvent EVENT_CUT_DOWN_ROUTE8_RIGHT_TREE
	ret
.removeTreeBlockers
	CheckEvent EVENT_CUT_DOWN_ROUTE8_LEFT_TREE
	jr z, .rightTreeCheck
	; if we're in the cut alcove, remove the tree
	lb bc, 6, 14
	ld a, $4C
	ld [wNewTileBlockID], a
	call ReplaceTileBlock
.rightTreeCheck
	CheckEvent EVENT_CUT_DOWN_ROUTE8_RIGHT_TREE
	ret z
	; if we're in the cut alcove, remove the tree
	lb bc, 5, 20
	ld a, $4C
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock
.moveJolteon
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	lb bc, SPRITESTATEDATA2_MAPY, ROUTE8_JOLTEON
	call GetFromSpriteStateData2 ; TODO: use this function more
	ld [hl], 8 + 4
	ret


Route8_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE8_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE8_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE8_END_BATTLE

Route8_TextPointers:
	def_text_pointers
	dba_const Route8SuperNerd1Text,      TEXT_ROUTE8_SUPER_NERD1
	dba_const Route8Gambler1Text,        TEXT_ROUTE8_GAMBLER1
	dba_const Route8SuperNerd2Text,      TEXT_ROUTE8_SUPER_NERD2
	dba_const Route8CooltrainerF1Text,   TEXT_ROUTE8_COOLTRAINER_F1
	dba_const Route8SuperNerd3Text,      TEXT_ROUTE8_SUPER_NERD3
	dba_const Route8CooltrainerF2Text,   TEXT_ROUTE8_COOLTRAINER_F2
	dba_const Route8CooltrainerF3Text,   TEXT_ROUTE8_COOLTRAINER_F3
	dba_const Route8Gambler2Text,        TEXT_ROUTE8_GAMBLER2
	dba_const Route8CooltrainerF4Text,   TEXT_ROUTE8_COOLTRAINER_F4
	dba_const _Route8JolteonText,         TEXT_ROUTE8_JOLTEON 
	dba_const PickUp5ItemText,           TEXT_ROUTE8_ITEM1 ; PureRGBnote: ADDED: new item on this route.
	dba_const _Route8UndergroundSignText, TEXT_ROUTE8_UNDERGROUND_SIGN
	dba_const _Route8JolteonCameraAngleText,    TEXT_ROUTE8_JOLTEON_RIGHT

Route8TrainerHeaders:
	def_trainers
Route8TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_0, 4, _Route8SuperNerd1BattleText, _Route8SuperNerd1EndBattleText, _Route8SuperNerd1AfterBattleText
Route8TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_1, 4, _Route8Gambler1BattleText, _Route8Gambler1EndBattleText, _Route8Gambler1AfterBattleText
Route8TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_2, 4, _Route8SuperNerd2BattleText, _Route8SuperNerd2EndBattleText, Route8SuperNerd2AfterBattleText 
Route8TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_3, 2, _Route8CooltrainerF1BattleText, _Route8CooltrainerF1EndBattleText, Route8CooltrainerF1AfterBattleText 
Route8TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_4, 3, _Route8SuperNerd3BattleText, _Route8SuperNerd3EndBattleText, _Route8SuperNerd3AfterBattleText
Route8TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_5, 3, _Route8CooltrainerF2BattleText, _Route8CooltrainerF2EndBattleText, Route8CooltrainerF2AfterBattleText 
Route8TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_6, 2, _Route8CooltrainerF3BattleText, _Route8CooltrainerF3EndBattleText, _Route8CooltrainerF3AfterBattleText
Route8TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_7, 2, _Route8Gambler2BattleText, _Route8Gambler2EndBattleText, _Route8Gambler2AfterBattleText
Route8TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_8_TRAINER_8, 4, _Route8CooltrainerF4BattleText, _Route8CooltrainerF4EndBattleText, Route8CooltrainerF4AfterBattleText 
	db -1 ; end

Route8SuperNerd1Text:
	script_trainer Route8TrainerHeader0

Route8Gambler1Text:
	script_trainer Route8TrainerHeader1

Route8SuperNerd2Text:
	script_trainer Route8TrainerHeader2

Route8CooltrainerF1Text:
	script_trainer Route8TrainerHeader3

Route8SuperNerd3Text:
	script_trainer Route8TrainerHeader4

Route8CooltrainerF2Text:
	script_trainer Route8TrainerHeader5

Route8CooltrainerF3Text:
	script_trainer Route8TrainerHeader6

Route8Gambler2Text:
	script_trainer Route8TrainerHeader7

Route8CooltrainerF4Text:
	script_trainer Route8TrainerHeader8

Route8SuperNerd2AfterBattleText:
	text_far _Route8SuperNerd2AfterBattleText
	text_asm
	lb hl, DEX_MUK, SUPER_NERD
	ld de, MukLearnset
	ld bc, LearnsetMukFade
	predef_jump LearnsetTrainerScriptMain

Route8CooltrainerF1AfterBattleText:
	text_far _Route8CooltrainerF1AfterBattleText
	text_asm
	lb hl, DEX_NIDORINA, LASS
	ld de, LearnsetNidorina
	jr Route8LearnsetScript

Route8CooltrainerF2AfterBattleText:
	text_far _Route8CooltrainerF2AfterBattleText
	text_asm
	lb hl, DEX_MEOWTH, LASS
	ld de, MeowthLearnset
	jr Route8LearnsetScript

Route8CooltrainerF4AfterBattleText:
	text_far _Route8CooltrainerF4AfterBattleText
	text_asm
	lb hl, DEX_CLEFAIRY, LASS
	ld de, ClefableLearnset
	; fall through
Route8LearnsetScript:
	predef_jump LearnsetTrainerScript

JolteonRightSide::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	ld a, TEXT_ROUTE8_JOLTEON_RIGHT
	jr JolteonLeftSide.displayTextID

JolteonLeftSide::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	ld c, DEX_JOLTEON - 1
  	callfar SetMonSeen
	ld a, TEXT_ROUTE8_JOLTEON
.displayTextID
	ldh [hTextID], a
	jp DisplayTextID
