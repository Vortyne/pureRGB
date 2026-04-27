BrunosRoom_Script:
	call BrunoShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld hl, BrunosRoomTrainerHeaders
	ld de, BrunosRoom_ScriptPointers
	ld a, [wBrunosRoomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wBrunosRoomCurScript], a
	ret

BrunoShowOrHideExitBlock:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	jp EliteFourOnMapLoad

BrunosRoom_ScriptPointers:
	def_script_pointers
	dw_const BrunosRoomDefaultScript,               SCRIPT_BRUNOSROOM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_BRUNOSROOM_BRUNO_START_BATTLE
	dw_const BrunosRoomBrunoEndBattleScript,        SCRIPT_BRUNOSROOM_BRUNO_END_BATTLE
	dw_const BrunosRoomPlayerIsMovingScript,        SCRIPT_BRUNOSROOM_PLAYER_IS_MOVING

BrunosRoomDefaultScript:
	ld hl, wBrunosRoomCurScript
	lb bc, TEXT_BRUNOSROOM_BRUNO_DONT_RUN_AWAY, SCRIPT_BRUNOSROOM_PLAYER_IS_MOVING
	jp EliteFourDefaultScript

BrunosRoomPlayerIsMovingScript:
	ld hl, wBrunosRoomCurScript
	jp EliteFourIsPlayerMovingScript

BrunosRoomBrunoEndBattleScript:
	ld hl, wBrunosRoomCurScript
	lb de, BRUNOSROOM_BRUNO, TEXT_BRUNOSROOM_BRUNO
	jp EliteFourEndTrainerBattleScript

BrunosRoom_TextPointers:
	def_text_pointers
	dw_const BrunosRoomBrunoText,            TEXT_BRUNOSROOM_BRUNO
	dw_const EliteFourDontRunAwayText,       TEXT_BRUNOSROOM_BRUNO_DONT_RUN_AWAY

BrunosRoomTrainerHeaders:
	def_trainers
BrunosRoomTrainerHeader0:
	trainer EVENT_BEAT_BRUNOS_ROOM_TRAINER_0, 0, BrunoBeforeBattleText, BrunoEndBattleText, BrunoAfterBattleText
	db -1 ; end

BrunosRoomBrunoText:
	text_asm
;;;;;;;;;; PureRGBnote: ADDED: makes the battle music the gym leader theme
	ld a, 10
;;;;;;;;;;
	ld hl, BrunosRoomTrainerHeader0
	jp EliteFourTalkToTrainer

BrunoBeforeBattleText:
	text_far _BrunoBeforeBattleText
	text_end

BrunoEndBattleText:
	text_far _BrunoEndBattleText
	text_end

BrunoAfterBattleText:
	text_far _BrunoAfterBattleText
	text_end
