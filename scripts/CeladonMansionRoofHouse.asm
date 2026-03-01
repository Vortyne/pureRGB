CeladonMansionRoofHouse_Script:
	ld a, CELADON_CITY
	ld [wLastMap], a
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, RunDefaultPaletteCommand
	jp EnableAutoTextBoxDrawing

CeladonMansionRoofHouse_TextPointers:
	def_text_pointers
	dw_const CeladonMansionRoofHouseHikerText,         TEXT_CELADONMANSION_ROOF_HOUSE_HIKER
	dw_const CeladonRuffianHouseHooliganText,          TEXT_CELADON_RUFFIAN_HOUSE_HOOLIGAN
	dw_const CeladonRuffianHouseRockerText,            TEXT_CELADON_RUFFIAN_HOUSE_ROCKER
	dw_const CeladonRuffianHouseBikerText,             TEXT_CELADON_RUFFIAN_HOUSE_BIKER
	dw_const CeladonMansionRoofHouseEeveePokeballText, TEXT_CELADONMANSION_ROOF_HOUSE_EEVEE_POKEBALL

CeladonMansionRoofHouseHikerText:
	text_far _CeladonMansionRoofHouseHikerText
	text_end

CeladonMansionRoofHouseEeveePokeballText:
	text_asm
	lb bc, EEVEE, 25
	ld a, BALL_DATA_ULTRA << 3 | TRUE
	call GivePokemonCommon ; PureRGBnote: ADDED: this eevee uses alternate palette to be different than the ones you can catch at route 1
	jr nc, .party_full
	ld a, HS_CELADON_MANSION_EEVEE_GIFT
	ld [wMissableObjectIndex], a
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
