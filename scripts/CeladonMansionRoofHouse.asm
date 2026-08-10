CeladonMansionRoofHouse_Script:
	ld a, CELADON_CITY
	ld [wLastMap], a
	call WasMapJustLoaded
	call nz, RunDefaultPaletteCommand
	jp EnableAutoTextBoxDrawing

CeladonMansionRoofHouse_TextPointers:
	def_text_pointers
	dba_const _CeladonMansionRoofHouseHikerText,        TEXT_CELADONMANSION_ROOF_HOUSE_HIKER
	dba_const _CeladonRuffianHouseHooliganText,         TEXT_CELADON_RUFFIAN_HOUSE_HOOLIGAN
	dba_const _CeladonRuffianHouseRockerText,           TEXT_CELADON_RUFFIAN_HOUSE_ROCKER
	dba_const _CeladonRuffianHouseBikerText,            TEXT_CELADON_RUFFIAN_HOUSE_BIKER
	dba_const CeladonMansionRoofHouseEeveePokeballText, TEXT_CELADONMANSION_ROOF_HOUSE_EEVEE_POKEBALL
	dba_const TMNotebookText,                           TEXT_CELADONMANSION_ROOF_HOUSE_NOTEBOOK
	dba_const LinkCableHelp,                            TEXT_CELADONMANSION_ROOF_HOUSE_BLACKBOARD

CeladonMansionRoofHouseEeveePokeballText:
	text_asm
	lb bc, EEVEE, 25
	ld a, BALL_DATA_ULTRA << 3 | TRUE
	call GivePokemonCommon ; PureRGBnote: ADDED: this eevee uses alternate palette to be different than the ones you can catch at route 1
	jr nc, .party_full
	ld c, TOGGLE_CELADON_MANSION_EEVEE_GIFT
	call c, HideObject
.party_full
	rst TextScriptEnd

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
	call DisableTextDelay
	hlcoord 0, 0
	lb bc, 8, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, HowToLinkText
	call PlaceString
	ld hl, LinkCableHelpText2
	rst _PrintText
	call HandleMenuInput
	call EnableTextDelay
	bit B_PAD_B, a
	jr nz, .exit
	ld a, [wCurrentMenuItem]
	cp 3 ; pressed a on "STOP READING"
	jr z, .exit
	ld hl, LinkCableInfoTexts
	ld bc, TEXT_FAR_TABLE_ENTRY_SIZE
	call AddNTimes
	rst _PrintText
	jp .linkHelpLoop
.exit
	call LoadScreenTilesFromBuffer1
	jp TextScriptEndNoButtonPress

LinkCableHelpText1:
	text_far_end _LinkCableHelpText1

LinkCableHelpText2:
	text_far_end _LinkCableHelpText2

HowToLinkText:
	db   "HOW TO LINK"
	next "COLOSSEUM"
	next "TRADE CENTER"
	next "STOP READING@"

LinkCableInfoTexts:
LinkCableInfoText1:
	text_far_end _LinkCableInfoText1
LinkCableInfoText2:
	text_far_end _LinkCableInfoText2
LinkCableInfoText3:
	text_far_end _LinkCableInfoText3
