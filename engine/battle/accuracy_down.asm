_AccuracyDownEffect::
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonType1
	ld a, [wPlayerMoveNum]
	jr z, .playersTurn
	ld hl, wBattleMonType1
	ld a, [wEnemyMoveNum]
.playersTurn
	call AccuracyDownEffectivenessCheck
	jr nc, .noEffect
	jpfar StatModifierDownEffect
.noEffect
	ld c, 30
	rst _DelayFrames
	jpfar PrintDidntAffectText

FarAccuracyDownEffectivenessCheck::
	ld h, d
	ld l, e
	ld a, c
AccuracyDownEffectivenessCheck::
	cp SAND_ATTACK
	jr nz, .smokescreen
.sandattack
	ld a, [hli]
	call .compareSandAttack
	ret z
	ld a, [hl]
	jr .compareSandAttack
.smokescreen
	ld a, [hli]
	cp FIRE
	ret z
	ld a, [hl]
	cp FIRE
	ret z
	scf
	ret
.compareSandAttack
	cp GROUND
	ret z
	cp FLYING
	ret z
	scf
	ret