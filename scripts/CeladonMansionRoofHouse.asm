CeladonMansionRoofHouse_Script:
	ld a, CELADON_CITY
	ld [wLastMap], a
	call WasMapJustLoaded
	call nz, RunDefaultPaletteCommand
	jp EnableAutoTextBoxDrawing

CeladonMansionRoofHouse_TextPointers:
	def_text_pointers
	dw_const CeladonMansionRoofHouseHikerText,         TEXT_CELADONMANSION_ROOF_HOUSE_HIKER
	dw_const CeladonRuffianHouseHooliganText,          TEXT_CELADON_RUFFIAN_HOUSE_HOOLIGAN
	dw_const CeladonRuffianHouseRockerText,            TEXT_CELADON_RUFFIAN_HOUSE_ROCKER
	dw_const CeladonRuffianHouseBikerText,             TEXT_CELADON_RUFFIAN_HOUSE_BIKER
	dw_const CeladonMansionRoofHouseEeveePokeballText, TEXT_CELADONMANSION_ROOF_HOUSE_EEVEE_POKEBALL
	dw_const TMNotebook,                               TEXT_CELADONMANSION_ROOF_HOUSE_NOTEBOOK
	dw_const LinkCableHelp,                            TEXT_CELADONMANSION_ROOF_HOUSE_BLACKBOARD

CeladonMansionRoofHouseHikerText:
	text_far _CeladonMansionRoofHouseHikerText
	text_end

CeladonMansionRoofHouseEeveePokeballText:
	text_asm
	lb bc, EEVEE, 25
	ld a, BALL_DATA_ULTRA << 3 | TRUE
	call GivePokemonCommon ; PureRGBnote: ADDED: this eevee uses alternate palette to be different than the ones you can catch at route 1
	jr nc, .party_full
	ld a, TOGGLE_CELADON_MANSION_EEVEE_GIFT
	ld [wToggleableObjectIndex], a
	predef HideObject
.party_full
	rst TextScriptEnd

CeladonRuffianHouseHooliganText:
	text_far _CeladonRuffianHouseHooliganText
	text_end

CeladonRuffianHouseRockerText:
	text_far _CeladonRuffianHouseRockerText
	text_end

CeladonRuffianHouseBikerText:
	text_far _CeladonRuffianHouseBikerText
	text_end

TMNotebook::
	text_far TMNotebookText
	text_end

LinkCableHelp::
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, LinkCableHelpText1
	rst _PrintText
	xor a
	ld [wMenuItemOffset], a ; not used
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 3
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
.linkHelpLoop
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 0
	lb bc, 8, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, HowToLinkText
	call PlaceString
	ld hl, LinkCableHelpText2
	rst _PrintText
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, .exit
	ld a, [wCurrentMenuItem]
	cp 3 ; pressed a on "STOP READING"
	jr z, .exit
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld hl, LinkCableInfoTexts
	ld bc, 5
	call AddNTimes
	rst _PrintText
	jp .linkHelpLoop
.exit
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call LoadScreenTilesFromBuffer1
	jp TextScriptEndNoButtonPress

LinkCableHelpText1:
	text_far _LinkCableHelpText1
	text_end

LinkCableHelpText2:
	text_far _LinkCableHelpText2
	text_end

HowToLinkText:
	db   "HOW TO LINK"
	next "COLOSSEUM"
	next "TRADE CENTER"
	next "STOP READING@"

LinkCableInfoTexts:
LinkCableInfoText1:
	text_far _LinkCableInfoText1
	text_end
LinkCableInfoText2:
	text_far _LinkCableInfoText2
	text_end
LinkCableInfoText3:
	text_far _LinkCableInfoText3
	text_end
