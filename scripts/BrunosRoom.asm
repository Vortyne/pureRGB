BrunosRoom_Script:
	call BrunoShowOrHideExitBlock
	ld hl, BrunosRoomTrainerHeaders
	ld de, BrunosRoom_ScriptPointers
	ld bc, wBrunosRoomCurScript
	jp ExecuteCustomMapScriptInTable

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
	dba_const BrunosRoomBrunoText,            TEXT_BRUNOSROOM_BRUNO
	dba_const _EliteFourDontRunAwayText,       TEXT_BRUNOSROOM_BRUNO_DONT_RUN_AWAY

BrunosRoomTrainerHeaders:
	def_trainers
BrunosRoomTrainerHeader0:
	trainer EVENT_BEAT_BRUNOS_ROOM_TRAINER_0, 0, _BrunoBeforeBattleText, _BrunoEndBattleText, _BrunoAfterBattleText
	db -1 ; end

BrunosRoomBrunoText:
	text_asm
;;;;;;;;;; PureRGBnote: ADDED: makes the battle music the gym leader theme
	ld a, 10
;;;;;;;;;;
	ld hl, BrunosRoomTrainerHeader0
	jp EliteFourTalkToTrainer
