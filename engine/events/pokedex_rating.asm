DisplayDexRating::
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	ldh [hDexRatingNumMonsSeen], a
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ldh [hDexRatingNumMonsOwned], a
	ld hl, DexRatingsTable
	ld c, 0
.findRating
	ld a, [hli]
	ld b, a
	ldh a, [hDexRatingNumMonsOwned]
	cp b
	jr c, .foundRating
	inc c
	jr .findRating
.foundRating
	ld hl, DexRatingTextPointerList
	ld a, c
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	ld b, 0
	ld c, a
	add hl, bc
	CheckAndResetEventA EVENT_HALL_OF_FAME_DEX_RATING
	jr nz, .hallOfFame
	push hl
	ld hl, DexCompletionText
	rst _PrintText
	pop hl
	rst _PrintText
	farcall PlayPokedexRatingSfx
	jp WaitForTextScrollButtonPress
.hallOfFame
	ld de, wDexRatingNumMonsSeen
	ldh a, [hDexRatingNumMonsSeen]
	ld [de], a
	inc de
	ldh a, [hDexRatingNumMonsOwned]
	ld [de], a
	inc de
	ld bc, TEXT_FAR_TABLE_ENTRY_SIZE
	rst _CopyData
	ret

DexCompletionText:
	text_far_end _DexCompletionText

DexRatingsTable:
	db 10
	db 20
	db 30
	db 40
	db 50
	db 60
	db 70
	db 80
	db 90
	db 100
	db 110
	db 120
	db 130
	db 140
	db 150
	db NUM_POKEMON + 1

DexRatingTextPointerList:
DexRatingText_Own0To9:
	text_far_end _DexRatingText_Own0To9
DexRatingText_Own10To19:
	text_far_end _DexRatingText_Own10To19
DexRatingText_Own20To29:
	text_far_end _DexRatingText_Own20To29
DexRatingText_Own30To39:
	text_far_end _DexRatingText_Own30To39
DexRatingText_Own40To49:
	text_far_end _DexRatingText_Own40To49
DexRatingText_Own50To59:
	text_far_end _DexRatingText_Own50To59
DexRatingText_Own60To69:
	text_far_end _DexRatingText_Own60To69
DexRatingText_Own70To79:
	text_far_end _DexRatingText_Own70To79
DexRatingText_Own80To89:
	text_far_end _DexRatingText_Own80To89
DexRatingText_Own90To99:
	text_far_end _DexRatingText_Own90To99
DexRatingText_Own100To109:
	text_far_end _DexRatingText_Own100To109
DexRatingText_Own110To119:
	text_far_end _DexRatingText_Own110To119
DexRatingText_Own120To129:
	text_far_end _DexRatingText_Own120To129
DexRatingText_Own130To139:
	text_far_end _DexRatingText_Own130To139
DexRatingText_Own140To149:
	text_far_end _DexRatingText_Own140To149
DexRatingText_Own150To151:
	text_far_end _DexRatingText_Own150To151
