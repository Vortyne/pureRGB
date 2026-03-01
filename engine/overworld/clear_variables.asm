ClearVariablesOnEnterMap::
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ldh [rWY], a
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld [wStepCounter], a
	ld [wLoneAttackNo], a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ldh [hJoyHeld], a
	ld [wMuteAudioAndPauseMusic], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wUnusedMapVariable], a
	ld [wIsAltPalettePkmn], a
	ld [wIsAltPalettePkmnData], a
	ld [wOverworldAnimationCounter], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wSavedY
	ld bc, wStandingOnWarpPadOrHole - wSavedY
	call FillMemory
;;;;;;;;;; PureRGBnote: ADDED: code that helps track which of the new music tracks is playing if any are
	ld a, [wCurrentMapScriptFlags]
	bit BIT_MAP_LOADED_AFTER_BATTLE, a
	jr nz, .clear
	ld a, [wCurMapConnections]
	bit BIT_EXTRA_MUSIC_MAP, a ; bit that indicates the map has extra music
	ret nz ; when going between maps that have extra music, we need to see the current music in case multiple maps have extra music and are connected
.clear
	xor a
	ld [wReplacedMapMusic], a ; clear this variable in places where we don't have replaced map music
;;;;;;;;;;
	ld hl, wStatusFlags2
	bit BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
	jr z, .skipGivingThreeStepsOfNoRandomBattles
	ld a, 3 ; minimum number of steps between battles
	ld [wNumberOfNoRandomBattleStepsLeft], a
.skipGivingThreeStepsOfNoRandomBattles
	ld hl, wStatusFlags3
	res BIT_NO_NPC_FACE_PLAYER, [hl]
	ret
