EchoingScreeches::
	ld c, 20
	rst _DelayFrames
	xor a
	ld [wTempoModifier], a
	ld a, 2
	ld [wFrequencyModifier], a
	ld a, SFX_BATTLE_31
	rst _PlaySound
	ld hl, .screechesPrevented
	rst _PrintText
	ret
.screechesPrevented
	text_far _ScreechesPreventedSleepText
	text_end

_SleepEffect::
	ld de, wEnemyMonStatus
	ld hl, wEnemyMonMoves
	ldh a, [hWhoseTurn]
	and a
	jp z, .sleepEffect
	ld de, wBattleMonStatus
	ld hl, wBattleMonMoves
.sleepEffect
	; are screeches echoing? If so prevent sleep status.
	ld a, [wBattleFunctionalFlags]
	bit 2, a
	jr nz, EchoingScreeches
	ld a, [de]
	ld b, a
	and $7
	jr z, .notAlreadySleeping ; can't affect a mon that is already asleep
	ld hl, AlreadyAsleepText
	rst _PrintText
	ret
.notAlreadySleeping
	ld a, b
	and a
	jr nz, .didntAffect ; can't affect a mon that is already statused
	; does the target have screech? If so, trigger the screech effect automatically
	ld b, NUM_MOVES
.loopCheckMoves
	ld a, [hli]
	cp SCREECH
	jr z, .opponentHasScreech
	dec b
	jr nz, .loopCheckMoves
	; no, it doesn't have screech
	ld bc, wEnemyBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jp z, .checkRecharge
	ld bc, wPlayerBattleStatus2
.checkRecharge
	ld a, [bc]
	bit NEEDS_TO_RECHARGE, a ; does the target need to recharge? (hyper beam)
	res NEEDS_TO_RECHARGE, a ; target no longer needs to recharge
	ld [bc], a
	jr nz, .setSleepCounter ; if the target had to recharge, all hit tests will be skipped
	push de
	callfar MoveHitTest ; apply accuracy tests
	pop de
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
.setSleepCounter
; set target's sleep counter to a random number between 1 and 7
	push de
	callfar FarBattleRandom
	ld a, d
	pop de
	and $7
	jr z, .setSleepCounter
	ld [de], a
	callfar PlayCurrentMoveAnimation2
	ld hl, FellAsleepText
	rst _PrintText
	jpfar DrawTargetHPBar
.didntAffect
	jpfar PrintDidntAffectText
.opponentHasScreech
	callfar PlayCurrentMoveAnimation2
	ld hl, .letOutAScreech
	rst _PrintText
	; make the opponent use screech automatically, and this doesn't use up their turn
	ldh a, [hWhoseTurn]
	ld hl, wEnemyMoveNum
	ld de, wEnemyMoveEffect
	and a
	jr z, .playersTurn2
	ld hl, wPlayerMoveNum
	ld de, wPlayerMoveEffect
.playersTurn2
	push af
	xor 1 ; toggle whose turn it is so the opponent uses the attack
	ldh [hWhoseTurn], a
	ld a, [hl]
	push af
	ld a, [de]
	push af
	ld [hl], SCREECH
	ld a, SCREECH_EFFECT
	ld [de], a
	push hl
	push de
	callfar _ScreechEffect
	pop de
	pop hl
	pop af
	ld [de], a
	pop af
	ld [hl], a
	pop af
	ldh [hWhoseTurn], a
	ret
.letOutAScreech
	text_far _LetOutAScreechText
	text_end
	

FellAsleepText:
	text_far _FellAsleepText
	text_end

AlreadyAsleepText:
	text_far _AlreadyAsleepText
	text_end

