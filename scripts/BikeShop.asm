; PureRGBnote: CHANGED: The Bike Shop was expanded a bit to use some of the trade center / collosseum tiles you wouldn't see ever in the entire
; game unless you played over link cable. Also a couple beta tiles are added to the tileset to make things look nice.
; Some text that wasn't fully translated from japanese is added in new signs here.
BikeShop_Script:
	jp EnableAutoTextBoxDrawing

BikeShop_TextPointers:
	def_text_pointers
	dba_const BikeShopClerkText,             TEXT_BIKESHOP_CLERK
	dba_const _BikeShopMiddleAgedWomanText,  TEXT_BIKESHOP_MIDDLE_AGED_WOMAN
	dba_const BikeShopYoungsterText,         TEXT_BIKESHOP_YOUNGSTER
; PureRGBnote: ADDED: some extra text for things that look like they should be interactable.
	dba_const _BikeShopBasketBikeText,        TEXT_BIKESHOP_BASKET_BIKE
	dba_const _BikeShopToolboxText,           TEXT_BIKESHOP_TOOLBOX
	dba_const _NewBicycleText,                TEXT_BIKESHOP_NEW_BIKE
	dba_const _BikeShopSignLeftText,          TEXT_BIKESHOP_ENTRANCE_SIGN1
	dba_const _BikeShopSignRightText,         TEXT_BIKESHOP_ENTRANCE_SIGN2
	dba_const _BikeShopArcade1Text,           TEXT_BIKESHOP_ARCADE1
	dba_const _BikeShopArcade2Text,           TEXT_BIKESHOP_ARCADE2
	dba_const _BikeShopArcade3Text,           TEXT_BIKESHOP_ARCADE3
	dba_const _BikeShopStatsText,             TEXT_BIKESHOP_STATS

BikeShopClerkText:
	text_asm
	CheckEvent EVENT_GOT_BICYCLE
	jr z, .dontHaveBike
	ld hl, BikeShopClerkHowDoYouLikeYourBicycleText
	jr .printDone
.dontHaveBike
	ld b, BIKE_VOUCHER
	call IsItemInBag
	jr z, .dontHaveVoucher
	ld hl, BikeShopClerkOhThatsAVoucherText
	rst _PrintText
	lb bc, BICYCLE, 1
	call GiveItem
	ld hl, BikeShopBagFullText
	jr nc, .printDone
	ld a, BIKE_VOUCHER
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	SetEvent EVENT_GOT_BICYCLE
	ld hl, BikeShopExchangedVoucherText
	jr .printDone
.dontHaveVoucher
	ld hl, BikeShopClerkWelcomeText
	rst _PrintText
	call .bikeShopMenu
	bit B_PAD_B, a
	; BUG: text stays with no delay if you cancel here.
	jr nz, .cancel
	call EnableTextDelay
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cancel
	ld hl, BikeShopCantAffordText
	rst _PrintText
.cancel
	ld hl, BikeShopComeAgainText
.printDone
	rst _PrintText
	rst TextScriptEnd
.bikeShopMenu
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, $1
	ld [wMaxMenuItem], a
	ld a, $2
	ld [wTopMenuItemY], a
	ld a, $1
	ld [wTopMenuItemX], a
	call DisableTextDelay
	hlcoord 0, 0
	lb bc, 4, 15
	call TextBoxBorderUpdateSprites
	hlcoord 2, 2
	ld de, BikeShopMenuText
	call PlaceString
	hlcoord 8, 3
	ld de, BikeShopMenuPrice
	call PlaceString
	ld hl, BikeShopClerkDoYouLikeItText
	rst _PrintText
	jp HandleMenuInput

BikeShopMenuText:
	db   "BICYCLE"
	next "CANCEL@"

BikeShopMenuPrice:
	db "¥1000000@"

BikeShopClerkWelcomeText:
	text_far_end _BikeShopClerkWelcomeText

BikeShopClerkDoYouLikeItText:
	text_far_end _BikeShopClerkDoYouLikeItText

BikeShopCantAffordText:
	text_far_end _BikeShopCantAffordText

BikeShopClerkOhThatsAVoucherText:
	text_far_end _BikeShopClerkOhThatsAVoucherText

BikeShopExchangedVoucherText:
	text_far_end _BikeShopExchangedVoucherText

BikeShopComeAgainText:
	text_far_end _BikeShopComeAgainText

BikeShopClerkHowDoYouLikeYourBicycleText:
	text_far_end _BikeShopClerkHowDoYouLikeYourBicycleText

BikeShopBagFullText:
	text_far_end _BikeShopBagFullText

BikeShopYoungsterText:
	text_asm
	CheckEvent EVENT_GOT_BICYCLE
	ld hl, .CoolBikeText
	jr nz, .gotBike
	ld hl, .TheseBikesAreExpensiveText
.gotBike
	rst _PrintText
	rst TextScriptEnd

.TheseBikesAreExpensiveText:
	text_far_end _BikeShopYoungsterTheseBikesAreExpensiveText

.CoolBikeText:
	text_far_end _BikeShopYoungsterCoolBikeText
