LoreleisRoom_Script:
	call LoreleiShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld hl, LoreleisRoomTrainerHeaders
	ld de, LoreleisRoom_ScriptPointers
	ld a, [wLoreleisRoomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wLoreleisRoomCurScript], a
	ret

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
	dw_const LoreleisRoomLoreleiText,            TEXT_LORELEISROOM_LORELEI
	dw_const EliteFourDontRunAwayText, 			 TEXT_LORELEISROOM_DONT_RUN_AWAY

LoreleisRoomTrainerHeaders:
	def_trainers
LoreleisRoomTrainerHeader0:
	trainer EVENT_BEAT_LORELEIS_ROOM_TRAINER_0, 0, LoreleisRoomLoreleiBeforeBattleText, LoreleisRoomLoreleiEndBattleText, LoreleisRoomLoreleiAfterBattleText
	db -1 ; end

LoreleisRoomLoreleiText:
	text_asm
;;;;;;;;;; PureRGBnote: ADDED: makes the battle music the gym leader theme
	ld a, 9
;;;;;;;;;;
	ld hl, LoreleisRoomTrainerHeader0
	jp EliteFourTalkToTrainer

LoreleisRoomLoreleiBeforeBattleText:
	text_far _LoreleisRoomLoreleiBeforeBattleText
	text_end

LoreleisRoomLoreleiEndBattleText:
	text_far _LoreleisRoomLoreleiEndBattleText
	text_end

LoreleisRoomLoreleiAfterBattleText:
	text_far _LoreleisRoomLoreleiAfterBattleText
	text_end
