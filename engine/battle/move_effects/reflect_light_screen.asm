; PureRGBnote: CHANGED: ACID ARMOR and CONVERSION defense mode apply both light screen and reflect when used.
ReflectLightScreenEffect_:
	ld hl, wPlayerBattleStatus3
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .reflectLightScreenEffect
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyMoveEffect
.reflectLightScreenEffect
	ld a, [de]
	cp ACID_ARMOR_EFFECT
	jr z, .acid_armor
	cp CONVERSION_EFFECT
	jr z, .acid_armor
	cp LIGHT_SCREEN_EFFECT
	jr nz, .reflect
	bit HAS_LIGHT_SCREEN_UP, [hl] ; is mon already protected by light screen?
	jr nz, .moveFailed
	set HAS_LIGHT_SCREEN_UP, [hl] ; mon is now protected by light screen
	ld hl, LightScreenProtectedText
	jr .playAnim
.reflect
	bit HAS_REFLECT_UP, [hl] ; is mon already protected by reflect?
	jr nz, .moveFailed
	set HAS_REFLECT_UP, [hl] ; mon is now protected by reflect
	ld hl, ReflectGainedArmorText
.playAnim
	push hl
	ld hl, PlayCurrentMoveAnimation
	call EffectCallBattleCore
	pop hl
.print
	rst _PrintText
	ret
.moveFailed
	ld c, 50
	rst DelayFrames
	ld hl, PrintButItFailedText_
	jp EffectCallBattleCore
.acid_armor
	bit HAS_REFLECT_UP, [hl]
	jr z, .canUseAcidArmor
	bit HAS_LIGHT_SCREEN_UP, [hl]
	jr z, .canUseAcidArmor
	jr .moveFailed
.canUseAcidArmor
	set HAS_REFLECT_UP, [hl]
	set HAS_LIGHT_SCREEN_UP, [hl]
	ld a, [de]
	cp CONVERSION_EFFECT
	ld hl, AllDamageHalvedText
	jr z, .print
	ld hl, AcidArmorShieldText
	jr .playAnim

LightScreenProtectedText:
	text_far_end _LightScreenProtectedText

ReflectGainedArmorText:
	text_far_end _ReflectGainedArmorText

AcidArmorShieldText:
	text_far_end _AcidArmorLiquifiedText

AllDamageHalvedText:
	text_far_end _AllDamageHalvedText

EffectCallBattleCore:
	ld b, BANK(BattleCore)
	jp Bankswitch
