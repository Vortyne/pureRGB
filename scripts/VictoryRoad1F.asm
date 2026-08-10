VictoryRoad1F_Script:
	call VictoryRoad1FMapLoadScript
	ld hl, VictoryRoad1TrainerHeaders
	ld de, VictoryRoad1F_ScriptPointers
	ld bc, wVictoryRoad1FCurScript
	jp ExecuteCustomMapScriptInTable

VictoryRoad1FMapLoadScript::
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ret z
	ld a, $1d
	ld [wNewTileBlockID], a
	lb bc, 6, 4
	jp ReplaceTileBlock

VictoryRoad1F_ScriptPointers:
	def_script_pointers
	dw_const VictoryRoad1FDefaultScript,            SCRIPT_VICTORYROAD1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VICTORYROAD1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VICTORYROAD1F_END_BATTLE

VictoryRoad1FDefaultScript:
	ld a, [wMiscFlags]
	bit BIT_BOULDER_DUST, a
	ret nz ; PureRGBnote: ADDED: if a boulder animation is playing forget doing the rest, helps reduce lag
	CheckEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	jp nz, CheckFightingMapTrainers
	ld de, Boulder1FSwitchCoords
	ld c, BANK(Boulder1FSwitchCoords)
	callfar CheckBoulderCoords
	jp nc, CheckFightingMapTrainers
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	SetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
;;;;;;;;;; PureRGBnote: ADDED: sound effect + animation when boulder presses switch
	ld de, wSprite05StateData1YPixels
	; fall through
BoulderOnButtonAnim:
	push de
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
	pop hl
	; make the boulder move up and down so it looks like it pressed the switch
	dec [hl]
	call Delay3
	inc [hl]
	ld c, 20
	rst DelayFrames
	lb de, SFX_GO_INSIDE, 20
	jpfar FarShakeScreen
;;;;;;;;;;


Boulder1FSwitchCoords:
	dbmapcoord 17, 13
	db -1 ; end


VictoryRoad1F_TextPointers:
	def_text_pointers
	dba_const VictoryRoad1FCooltrainerFText, TEXT_VICTORYROAD1F_COOLTRAINER_F
	dba_const VictoryRoad1FCooltrainerMText, TEXT_VICTORYROAD1F_COOLTRAINER_M
	dba_const PickUpItemText,                TEXT_VICTORYROAD1F_ITEM1
	dba_const PickUpItemText,                TEXT_VICTORYROAD1F_ITEM2
	dba_const BoulderText,                   TEXT_VICTORYROAD1F_BOULDER1
	dba_const BoulderText,                   TEXT_VICTORYROAD1F_BOULDER2
	dba_const BoulderText,                   TEXT_VICTORYROAD1F_BOULDER3

VictoryRoad1TrainerHeaders:
	def_trainers
VictoryRoad1TrainerHeader0:
	trainer EVENT_BEAT_VICTORY_ROAD_1_TRAINER_0, 2, _VictoryRoad1FCooltrainerFBattleText, _VictoryRoad1FCooltrainerFEndBattleText, _VictoryRoad1FCooltrainerFAfterBattleText
VictoryRoad1TrainerHeader1:
	trainer EVENT_BEAT_VICTORY_ROAD_1_TRAINER_1, 2, _VictoryRoad1FCooltrainerMBattleText, _VictoryRoad1FCooltrainerMEndBattleText, _VictoryRoad1FCooltrainerMAfterBattleText
	db -1 ; end

VictoryRoad1FCooltrainerFText:
	script_trainer VictoryRoad1TrainerHeader0

VictoryRoad1FCooltrainerMText:
	script_trainer VictoryRoad1TrainerHeader1
