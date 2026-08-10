LoreleisRoom_Script:
	call LoreleiShowOrHideExitBlock
	ld hl, LoreleisRoomTrainerHeaders
	ld de, LoreleisRoom_ScriptPointers
	ld bc, wLoreleisRoomCurScript
	jp ExecuteCustomMapScriptInTable

LoreleiShowOrHideExitBlock:
	call WasMapJustLoaded
	ret z
	ld hl, wElite4Flags
	set BIT_STARTED_ELITE_4, [hl]
	CheckEvent EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	jp EliteFourOnMapLoad

LoreleisRoom_ScriptPointers:
	def_script_pointers
	dw_const LoreleisRoomDefaultScript,             SCRIPT_LORELEISROOM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_LORELEISROOM_LORELEI_START_BATTLE
	dw_const LoreleisRoomLoreleiEndBattleScript,    SCRIPT_LORELEISROOM_LORELEI_END_BATTLE
	dw_const LoreleisRoomPlayerIsMovingScript,      SCRIPT_LORELEISROOM_PLAYER_IS_MOVING

LoreleisRoomDefaultScript:
	lb bc, TEXT_LORELEISROOM_DONT_RUN_AWAY, SCRIPT_LORELEISROOM_PLAYER_IS_MOVING
	ld hl, wLoreleisRoomCurScript
	jp EliteFourDefaultScript

LoreleisRoomPlayerIsMovingScript:
	ld hl, wLoreleisRoomCurScript
	jp EliteFourIsPlayerMovingScript

LoreleisRoomLoreleiEndBattleScript:
	ld hl, wLoreleisRoomCurScript
	lb de, LORELEISROOM_LORELEI, TEXT_LORELEISROOM_LORELEI
	jp EliteFourEndTrainerBattleScript

LoreleisRoom_TextPointers:
	def_text_pointers
	dba_const LoreleisRoomLoreleiText,            TEXT_LORELEISROOM_LORELEI
	dba_const _EliteFourDontRunAwayText, 		  TEXT_LORELEISROOM_DONT_RUN_AWAY

LoreleisRoomTrainerHeaders:
	def_trainers
LoreleisRoomTrainerHeader0:
	trainer EVENT_BEAT_LORELEIS_ROOM_TRAINER_0, 0, _LoreleisRoomLoreleiBeforeBattleText, _LoreleisRoomLoreleiEndBattleText, _LoreleisRoomLoreleiAfterBattleText
	db -1 ; end

LoreleisRoomLoreleiText:
	text_asm
;;;;;;;;;; PureRGBnote: ADDED: makes the battle music the gym leader theme
	ld a, 9
;;;;;;;;;;
	ld hl, LoreleisRoomTrainerHeader0
	jp EliteFourTalkToTrainer
