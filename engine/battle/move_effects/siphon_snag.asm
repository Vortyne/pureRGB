_SiphonSnagEffect::
	ldh a, [hWhoseTurn]
	ld b, a
	and a
	ld hl, wPlayerBattleStatus1
	ld de, wBattleMonStatus
	jr z, .playersTurn
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyMonStatus
.playersTurn
	ld a, [de]
	and a
	jr nz, .userStatus
	bit CONFUSED, [hl]
	jr z, .noUserStatus
.userStatus
	res CONFUSED, [hl]
	push de
	callfar UndoBurnParStats
	pop de
	xor a
	ld [de], a
	call AnimationSiphonSnagHealSelf
	ld hl, .healedUser
	jr .printReloadStatus
.noUserStatus
	ld a, b
	and a
	jr z, .continue
	ld a, [wIsInBattle]
	cp 1
	ret z ; wild battle enemy turn, can't heal party
.continue
	ld a, b
	and a
	ld hl, wPartyMon1Status
	ld a, [wPartyCount]
	jr z, .playersTurn1
	ld hl, wEnemyMon1Status
	ld a, [wEnemyPartyCount]
.playersTurn1
	ld b, a
	dec b
	ret z ; no other party members
	ld de, wPartyMon2Status - wPartyMon1Status
	ld c, 0
.loopFindStatus
	ld a, [hl]
	and a
	jr nz, .foundStatus
	add hl, de
	inc c
	dec b
	jr nz, .loopFindStatus
	ret
.foundStatus
	ld [hl], 0
	ldh a, [hWhoseTurn]
	and a
	ld hl, wPartyMon1Nick
	jr z, .playersTurn2
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld hl, wEnemyMon1Nick
	jr z, .playersTurn2
	ld hl, wEnemyMon1Species
	ld a, c
	ld bc, wEnemyMon2Species - wEnemyMon1Species
	call AddNTimes
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetMonName
	jr .gotName
.playersTurn2
	ld a, c
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wNameBuffer
	call CopyString
.gotName
	call AnimationSiphonSnagHealParty
	ld hl, .healedPartyMember
.printReloadStatus
	push hl
	callfar DrawHUDsAndHPBars
	pop hl
	rst _PrintText
	ret
.healedUser
	text_far _SiphonSnagHealedUserText
	text_end
.healedPartyMember
	text_far _SiphonSnagHealedPartyText
	text_end

_AnimationSiphonSnagAttack::
	ld hl, vSprites tile $31
	ld de, SiphonSnagTiles
	lb bc, BANK(SiphonSnagTiles), 3
	call CopyVideoData
	ld hl, vSprites tile $34
	ld de, MoveAnimationTiles0 tile 73
	lb bc, BANK(MoveAnimationTiles0), 1
	call CopyVideoData
	call ClearSprites
	ld hl, wShadowOAMSprite08TileID
	ld [hl], $33
	ldh a, [hWhoseTurn]
	and a
	jr z, .next
	inc hl
	ld [hl], OAM_HFLIP | OAM_VFLIP
.next
	ld hl, wShadowOAMSprite09TileID
	ld b, 4
.loopLoadOAM
	ld a, $31
	call .loadTendrilInit
	ld a, $32
	call .loadTendrilInit
	dec b
	jr nz, .loopLoadOAM
	ld hl, wShadowOAMSprite05TileID
	ld b, 3
.loopLoadOAM2
	ld [hl], $34
	call GoToNextOAMEntry4
	dec b
	jr nz, .loopLoadOAM2
	ld hl, wShadowOAMSprite09YCoord
	ldh a, [hWhoseTurn]
	and a
	ld de, SiphonSnagTendrilCoords
	jr z, .gotTendrilCoords
	ld de, SiphonSnagTendrilCoords + 14
.gotTendrilCoords
	lb bc, 8, 0
.loopAnimateTendril
	call .getTendrilCoordChange
	call GoToNextOAMEntry
	push hl
	push de
	ld hl, SiphonSnagTendrilTipCoords
	ldh a, [hWhoseTurn]
	and a
	ld e, c
	jr z, .playerTendrilTip
	ld e, b
	dec e
.playerTendrilTip
	ld d, 0
	add hl, de
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	ldh a, [hWhoseTurn]
	and a
	jr z, .continue
	ld a, d
	add 8
	ld d, a
	ld a, e
	sub 12
	ld e, a
.continue
	ld hl, wShadowOAMSprite08YCoord
	ld [hl], d
	inc hl
	ld [hl], e
	pop de
	pop hl
	rst _DelayFrame
	inc c
	dec b
	jr nz, .loopAnimateTendril
	ld a, $30
	ld [wFrequencyModifier], a
	xor a
	ld [wTempoModifier], a
	ld a, SFX_BATTLE_25
	call PlaySoundWaitForCurrent
	; sound effect
	ld b, 3
.loopSiphoning
	push bc
	ldh a, [hWhoseTurn]
	and a
	ld hl, SiphonSnagBallInitialCoordsPlayer
	jr z, .gotBallInitCoords
	ld hl, SiphonSnagBallInitialCoordsEnemy
.gotBallInitCoords
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld hl, wShadowOAMSprite05YCoord
	ld b, 3
.loopLoadBallCoords
	ld [hl], d
	inc hl
	ld [hl], e
	call GoToNextOAMEntry
	call .getBallInitCoordsDifference
	dec b
	jr nz, .loopLoadBallCoords
	ld b, 24
.animateBallMovement
	ld hl, wShadowOAMSprite05YCoord
	ld c, 3
.loopBallOAMEntries
	call .getBallPositionChange
	call GoToNextOAMEntry
	dec c
	jr nz, .loopBallOAMEntries
	rst _DelayFrame
	dec b
	jr nz, .animateBallMovement
	pop bc
	dec b
	jr nz, .loopSiphoning
	jp ClearSprites
.getBallPositionChange
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerBallChange
	dec [hl]
	inc hl
	inc [hl]
	inc [hl]
	ret
.playerBallChange
	inc [hl]
	inc hl
	dec [hl]
	dec [hl]
	ret
.getBallInitCoordsDifference
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerBallInitCoords
	ld a, d
	sub 4
	ld d, a
	ld a, e
	add 6
	ld e, a
	ret
.playerBallInitCoords
	ld a, d
	add 4
	ld d, a
	ld a, e
	sub 6
	ld e, a
	ret
.loadTendrilInit
	ld [hli], a
	ldh a, [hWhoseTurn]
	and a
	jr z, .skipTendrilInit
	ld [hl], OAM_HFLIP | OAM_VFLIP
.skipTendrilInit
	jp GoToNextOAMEntry
.getTendrilCoordChange
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTendrilCoordChange
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	dec de
	dec de
	dec de
	ld [hl], a
	ret
.playerTendrilCoordChange
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a
	ret

SiphonSnagBallInitialCoordsPlayer:
	db 51, 127

SiphonSnagBallInitialCoordsEnemy:
	db 85, 62

SiphonSnagTendrilCoords:
	db 80, 70
	db 80, 78
	db 72, 83
	db 72, 91
	db 64, 97
	db 64, 105
	db 56, 111
	db 56, 119

SiphonSnagTendrilTipCoords:
	db 77, 77
	db 74, 84
	db 69, 91
	db 66, 97
	db 61, 104
	db 59, 110
	db 54, 118
	db 51, 124

AnimationSiphonSnagHealSelf:
	ld a, SFX_HEAL_AILMENT
	call PlaySoundWaitForCurrent
	ld c, 3
	jpfar BlinkMonCommon

AnimationSiphonSnagHealParty:
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	ld d, PAL_YELLOWMON
	callfar TransferSpecificAnimPalette
.notGBC
	; heal party animation
	ld hl, vSprites tile $31
	ld de, MoveAnimationTiles0 tile 67
	lb bc, BANK(MoveAnimationTiles0), 1
	call CopyVideoData
	call ClearSprites
	ld hl, wShadowOAMSprite36TileID
	ld [hl], $31
	call GoToNextOAMEntry4
	ld [hl], $31
	inc hl
	ld [hl], OAM_HFLIP
	call GoToNextOAMEntry
	ld [hl], $31
	inc hl
	ld [hl], OAM_VFLIP
	call GoToNextOAMEntry
	ld [hl], $31
	inc hl
	ld [hl], OAM_VFLIP | OAM_HFLIP

	ld a, $d0
	ld [wFrequencyModifier], a
	ld a, $A0
	ld [wTempoModifier], a
	ld a, SFX_BATTLE_33
	call PlaySoundWaitForCurrent

	ldh a, [hWhoseTurn]
	and a
	lb de, 90, 36
	jr z, .playersTurn
	lb de, 40, 120
.playersTurn
	call LoadDefaultBallOAMCoords

	ld c, 10
.loopMoveBall
	dec d
	dec d
	call LoadDefaultBallOAMCoords
	rst _DelayFrame
	dec c
	jr nz, .loopMoveBall
	ld c, 20
	rst _DelayFrames
	ld c, 18
.loopMoveBallFast
	dec d
	dec d
	dec d
	dec d
	call LoadDefaultBallOAMCoords
	rst _DelayFrame
	dec c
	jr nz, .loopMoveBallFast
	ld c, 10
	rst _DelayFrames
	ld a, SFX_HEAL_AILMENT
	rst _PlaySound
	jpfar AnimationFlashLightScreen

