VictoryRoad2F_Script:
	call VictoryRoad2FResetBoulderEventScript
	call VictoryRoad2FCheckBoulderEventScript
	ld hl, VictoryRoad2TrainerHeaders
	ld de, VictoryRoad2F_ScriptPointers
	ld bc, wVictoryRoad2FCurScript
	jp ExecuteCustomMapScriptInTable

VictoryRoad2FResetBoulderEventScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	ret z
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ret ; avoids running the below code twice because bit 5 of wCurrentMapScriptFlags is always set when bit 6 is set too

VictoryRoad2FCheckBoulderEventScript::
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	jr z, .not_on_switch
	push af
	ld a, $15
	lb bc, 4, 3
	call VictoryRoad2FReplaceTileBlockScript
	pop af
.not_on_switch
	CheckEventReuseA EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2
	ret z
	ld a, $1d
	lb bc, 7, 11
VictoryRoad2FReplaceTileBlockScript:
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

VictoryRoad2F_ScriptPointers:
	def_script_pointers
	dw_const VictoryRoad2FDefaultScript,            SCRIPT_VICTORYROAD2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VICTORYROAD2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VICTORYROAD2F_END_BATTLE

VictoryRoad2FDefaultScript:
	ld a, [wMiscFlags]
	bit BIT_BOULDER_DUST, a
	ret nz ; PureRGBnote: ADDED: if a boulder animation is playing forget doing this, helps reduce lag
	ld de, VictoryRoad2FBoulderSwitchCoords
	ld c, BANK(VictoryRoad2FBoulderSwitchCoords)
	callfar CheckBoulderCoords
	jp nc, CheckFightingMapTrainers
	EventFlagAddress hl, EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	ld a, [wCoordIndex]
	cp $2
	jr z, .second_switch
	CheckEventReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	SetEventReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	ret nz
	ld de, wSprite11StateData1YPixels
	jr .set_script_flag
.second_switch
	CheckEventAfterBranchReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2, EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	SetEventReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2
	ret nz
	ld de, wSprite13StateData1YPixels
.set_script_flag
	callfar BoulderOnButtonAnim
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ret

VictoryRoad2FBoulderSwitchCoords:
	dbmapcoord  1, 16
	dbmapcoord  9, 16
	db -1 ; end

VictoryRoad2F_TextPointers:
	def_text_pointers
	dba_const VictoryRoad2FHikerText,        TEXT_VICTORYROAD2F_HIKER
	dba_const VictoryRoad2FSuperNerd1Text,   TEXT_VICTORYROAD2F_SUPER_NERD1
	dba_const VictoryRoad2FCooltrainerMText, TEXT_VICTORYROAD2F_COOLTRAINER_M
	dba_const VictoryRoad2FSuperNerd2Text,   TEXT_VICTORYROAD2F_SUPER_NERD2
	dba_const VictoryRoad2FSuperNerd3Text,   TEXT_VICTORYROAD2F_SUPER_NERD3
	dba_const VictoryRoad2FMoltresText,      TEXT_VICTORYROAD2F_MOLTRES
	dba_const PickUpItemText,                TEXT_VICTORYROAD2F_ITEM1
	dba_const PickUpItemText,                TEXT_VICTORYROAD2F_ITEM2
	dba_const PickUpItemText,                TEXT_VICTORYROAD2F_ITEM3
	dba_const PickUpItemText,                TEXT_VICTORYROAD2F_ITEM4
	dba_const BoulderText,                   TEXT_VICTORYROAD2F_BOULDER1
	dba_const BoulderText,                   TEXT_VICTORYROAD2F_BOULDER2
	dba_const BoulderText,                   TEXT_VICTORYROAD2F_BOULDER3

VictoryRoad2TrainerHeaders:
	def_trainers
VictoryRoad2TrainerHeader0:
	trainer EVENT_BEAT_VICTORY_ROAD_2_TRAINER_0, 4, _VictoryRoad2FHikerBattleText, _VictoryRoad2FHikerEndBattleText, _VictoryRoad2FHikerAfterBattleText
VictoryRoad2TrainerHeader1:
	trainer EVENT_BEAT_VICTORY_ROAD_2_TRAINER_1, 3, _VictoryRoad2FSuperNerd1BattleText, _VictoryRoad2FSuperNerd1EndBattleText, _VictoryRoad2FSuperNerd1AfterBattleText
VictoryRoad2TrainerHeader2:
	trainer EVENT_BEAT_VICTORY_ROAD_2_TRAINER_2, 3, _VictoryRoad2FCooltrainerMBattleText, _VictoryRoad2FCooltrainerMEndBattleText, _VictoryRoad2FCooltrainerMAfterBattleText
VictoryRoad2TrainerHeader3:
	trainer EVENT_BEAT_VICTORY_ROAD_2_TRAINER_3, 1, _VictoryRoad2FSuperNerd2BattleText, _VictoryRoad2FSuperNerd2EndBattleText, _VictoryRoad2FSuperNerd2AfterBattleText
VictoryRoad2TrainerHeader4:
	trainer EVENT_BEAT_VICTORY_ROAD_2_TRAINER_4, 3, _VictoryRoad2FSuperNerd3BattleText, _VictoryRoad2FSuperNerd3EndBattleText, _VictoryRoad2FSuperNerd3AfterBattleText
MoltresTrainerHeader:
	trainer EVENT_BEAT_MOLTRES, 0, VictoryRoad2FMoltresBattleText, VictoryRoad2FMoltresBattleText, VictoryRoad2FMoltresBattleText
	db -1 ; end

VictoryRoad2FHikerText:
	script_trainer VictoryRoad2TrainerHeader0

VictoryRoad2FSuperNerd1Text:
	script_trainer VictoryRoad2TrainerHeader1

VictoryRoad2FCooltrainerMText:
	script_trainer VictoryRoad2TrainerHeader2

VictoryRoad2FSuperNerd2Text:
	script_trainer VictoryRoad2TrainerHeader3

VictoryRoad2FSuperNerd3Text:
	script_trainer VictoryRoad2TrainerHeader4

VictoryRoad2FMoltresText:
	script_trainer MoltresTrainerHeader

VictoryRoad2FMoltresBattleText:
	text_far _VictoryRoad2FMoltresBattleText
	text_asm
	ld a, MOLTRES
	call PlayCry
	call WaitForSoundToFinish
	rst TextScriptEnd
