CeruleanBadgeHouse_Script:
	call WasMapJustLoaded
	jr z, .notFirstLoad
	CheckEvent FLAG_LEARNSETS_DISABLED
	jr z, .notFirstLoad
	; move papers offscreen if learnsets disabled
	lb bc, SPRITESTATEDATA2_MAPY, CERULEANBADGEHOUSE_PAPER1
	call GetFromSpriteStateData2
	ld bc, wSprite02StateData2MapY - wSprite01StateData2MapY
	ld d, 4
.loop
	ld [hl], -1
	add hl, bc
	dec d
	jr nz, .loop
	ASSERT CERULEANBADGEHOUSE_PAPER2 == (CERULEANBADGEHOUSE_PAPER1 + 1)
	ASSERT CERULEANBADGEHOUSE_PAPER3 == (CERULEANBADGEHOUSE_PAPER2 + 1)
	ASSERT CERULEANBADGEHOUSE_PAPER4 == (CERULEANBADGEHOUSE_PAPER3 + 1)
.notFirstLoad
	jp EnableAutoTextBoxDrawing

CeruleanBadgeHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanBadgeHouseMiddleAgedManText, TEXT_CERULEANBADGEHOUSE_MIDDLE_AGED_MAN
	dw_const CeruleanBadgeHouseLeftPaperText, TEXT_CERULEANBADGEHOUSE_PAPER_LEFT
	dw_const CeruleanBadgeHouseCenterLeftPaperText, TEXT_CERULEANBADGEHOUSE_PAPER_CENTER_LEFT
	dw_const CeruleanBadgeHouseCenterRightPaperText, TEXT_CERULEANBADGEHOUSE_PAPER_CENTER_RIGHT
	dw_const CeruleanBadgeHouseRightPaperText, TEXT_CERULEANBADGEHOUSE_PAPER_RIGHT
	dw_const CeruleanBadgeHouseGarbageText, TEXT_CERULEANBADGEHOUSE_GARBAGE

CeruleanBadgeHouseMiddleAgedManText:
	text_asm
	ld hl, .Text
	rst _PrintText
	ld a, [wListScrollOffset]
	push af ; save list scroll offset for item menu index
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld hl, .WhichBadgeText
	jr .loopEntry
.loop
	ld hl, .AnyMoreBadgeInfo
.loopEntry
	rst _PrintText
	ld hl, .BadgeItemList
	call LoadItemList
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld [wMenuItemToSwap], a
	ld a, CUSTOMLISTMENU
	ld [wListMenuID], a
	ld a, 3 ; badge menu
	ld [wListMenuCustomType], a
	call DisplayListMenuID
	jr c, .done
	ld a, [wCurListMenuItem]
	cp 5
	jr nc, .noHMName
	ld hl, BadgeHMMapping
	ld d, 0
	ld e, a
	add hl, de
	push af
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetMoveName
	pop af
.noHMName
	ld b, a
	ld c, a
	and a
	ld a, 20
	jr z, .gotMaxLevel
.loopMaxLevel
	add 10
	dec c
	jr nz, .loopMaxLevel
.gotMaxLevel
	ld [w2CharStringBuffer], a
	ld hl, CeruleanBadgeHouseBadgeTextPointers
	ld d, 0
	ld e, b
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	rst _PrintText
	jr .loop
.done
	ld hl, .VisitAnyTimeText
	rst _PrintText
	pop af
	ld [wListScrollOffset], a ; restore list scroll offset to preserve item menu index
	rst TextScriptEnd

.BadgeItemList:
	db NUM_BADGES ; #
	table_width 1
	db BOULDERBADGE
	db CASCADEBADGE
	db THUNDERBADGE
	db RAINBOWBADGE
	db SOULBADGE
	db MARSHBADGE
	db VOLCANOBADGE
	db EARTHBADGE
	assert_table_length NUM_BADGES
	db -1 ; end

.Text:
	text_far _CeruleanBadgeHouseMiddleAgedManText
	text_end

.WhichBadgeText:
	text_far _CeruleanBadgeHouseNowThenText
	text_far _CeruleanBadgeHouseMiddleAgedManWhichBadgeText
	text_end

.VisitAnyTimeText:
	text_far _CeruleanBadgeHouseMiddleAgedManVisitAnyTimeText
	text_end

.AnyMoreBadgeInfo:
	text_far _CeruleanBadgeHouseNowThenText
	text_far _CeruleanBadgeHouseAnyMoreText
	text_end

BadgeHMMapping:
	db FLASH
	db CUT
	db FLY
	db STRENGTH
	db SURF

CeruleanBadgeHouseBadgeTextPointers:
	table_width 5
CeruleanBadgeHouseBoulderBadgeText:
	text_far _CeruleanBadgeHouseBoulderBadgeText
	text_end
CeruleanBadgeHouseCascadeBadgeText:
	text_far _CeruleanBadgeHouseCascadeBadgeText
	text_end
CeruleanBadgeHouseThunderBadgeText:
	text_far _CeruleanBadgeHouseThunderBadgeText
	text_end
CeruleanBadgeHouseRainbowBadgeText:
	text_far _CeruleanBadgeHouseRainbowBadgeText
	text_end
CeruleanBadgeHouseSoulBadgeText:
	text_far _CeruleanBadgeHouseSoulBadgeText
	text_end
CeruleanBadgeHouseMarshBadgeText:
	text_far _CeruleanBadgeHouseMarshBadgeText
	text_end
CeruleanBadgeHouseVolcanoBadgeText:
	text_far _CeruleanBadgeHouseVolcanoBadgeText
	text_end
CeruleanBadgeHouseEarthBadgeText:
	text_far _CeruleanBadgeHouseEarthBadgeText
	text_end
	assert_table_length NUM_BADGES

; PureRGBnote: ADDED: some text where it seems like there should be an interaction.

CeruleanBadgeHouseGarbageText:
	text_far _GarbageCrumpledUpPaper
	text_far _CeruleanBadgeHouseGarbageText
	text_end

CeruleanBadgeHouseLeftPaperText:
	text_far _CeruleanBadgeHouseLeftPaperText
	text_end

CeruleanBadgeHouseCenterLeftPaperText:
	text_far _CeruleanBadgeHouseCenterLeftPaperText
	text_end

CeruleanBadgeHouseCenterRightPaperText:
	text_far _CeruleanBadgeHouseCenterRightPaperText
	text_end

CeruleanBadgeHouseRightPaperText:
	text_far _CeruleanBadgeHouseRightPaperText
	text_end
