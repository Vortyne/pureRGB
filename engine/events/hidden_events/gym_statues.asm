GymStatues:
; if in a gym and have the corresponding badge, a = GymStatueText2_id and jp PrintPredefTextID
; if in a gym and don't have the corresponding badge, a = GymStatueText1_id and jp PrintPredefTextID
; else ret
	call EnableAutoTextBoxDrawing
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	tx_pre_id GymStatueTextScript
	jp PrintPredefTextID

INCLUDE "data/maps/badge_maps.asm"

GymStatueTextScript::
	text_asm
	call GetStatueNames
	ld hl, MapBadgeFlags
	ld a, [wCurMap]
	ld de, 2
	call IsInArray
	jr nc, .done
	inc hl
	ld b, [hl]
	ld a, [wObtainedBadges]
	and b
	cp b
	ld hl, .text2
	jr z, .haveBadge
	ld hl, .text1
.haveBadge
	rst _PrintText
.done
	rst TextScriptEnd
.text1
	text_far _GymStatueText
	text_far _GymStatueRival
	text_end
.text2
	text_far _GymStatueText
	text_far _GymStatueRivalPlayer
	text_end

; PureRGBnote: CHANGED: Previously gym statue name data was loaded by the respective gym's map script into wram, 
; but it was wasteful because it's not even hard to load without even using wram values right when you read the statue.
; this was refactored from some free wram space.

GetStatueNames:
	ld hl, StatueTextMap
	ld a, [wCurMap]
	ld de, 4
	call IsInArray
	ret nc
	inc hl
	push hl
	hl_deref
	ld de, wStringBuffer
	ld bc, 17 ; original byte length of wGymCityName
	ld a, BANK(PewterCityName)
	call FarCopyData2
	pop hl
	inc hl
	inc hl
	ld a, [hl]
	ld [wTrainerClass], a
	jpfar GetTrainerName

StatueTextMap::
	db PEWTER_GYM
	dwb PewterCityName, BROCK 
	db CERULEAN_GYM 
	dwb CeruleanCityName, MISTY
	db VERMILION_GYM
	dwb VermilionCityName, LT_SURGE
	db CELADON_GYM
	dwb CeladonCityName, ERIKA
	db FUCHSIA_GYM
	dwb FuchsiaCityName, KOGA
	db SAFFRON_GYM
	dwb SaffronCityName, SABRINA
	db CINNABAR_GYM
	dwb CinnabarIslandName, BLAINE
	db VIRIDIAN_GYM
	dwb ViridianCityName, GIOVANNI
