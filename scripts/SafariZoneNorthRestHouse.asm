SafariZoneNorthRestHouse_Script:
	jp EnableAutoTextBoxDrawing

SafariZoneNorthRestHouse_TextPointers:
	def_text_pointers
	dw_const SafariZoneNorthRestHouseScientistText,        TEXT_SAFARIZONENORTHRESTHOUSE_SCIENTIST
	dw_const SafariZoneNorthRestHouseSafariZoneWorkerText, TEXT_SAFARIZONENORTHRESTHOUSE_SAFARI_ZONE_WORKER
	dw_const SafariZoneNorthRestHouseGentlemanText,        TEXT_SAFARIZONENORTHRESTHOUSE_GENTLEMAN

SafariZoneNorthRestHouseScientistText:
; PureRGBnote: ADDED: this NPC will display different text depending on what type of safari game you're playing
	text_asm
	ld hl, .default
	ld a, [wSafariType]
	ld bc, 5
	call AddNTimes
	rst _PrintText
	rst TextScriptEnd
.default:
	text_far _SafariZoneNorthRestHouseScientistText
	text_end
.rangerHunt:
	text_far _SafariZoneRestHouse4TextRangerHunt
	text_end
.freeRoam:
	text_far _SafariZoneRestHouse4TextChansey
	text_end

SafariZoneNorthRestHouseSafariZoneWorkerText:
	text_far _SafariZoneNorthRestHouseSafariZoneWorkerText
	text_end

SafariZoneNorthRestHouseGentlemanText:
	text_far _SafariZoneNorthRestHouseGentlemanText
	text_end
