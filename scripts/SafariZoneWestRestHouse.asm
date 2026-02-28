SafariZoneWestRestHouse_Script:
	jp EnableAutoTextBoxDrawing

SafariZoneWestRestHouse_TextPointers:
	def_text_pointers
	dw_const SafariZoneWestRestHouseScientistText,    TEXT_SAFARIZONEWESTRESTHOUSE_SCIENTIST
	dw_const SafariZoneWestRestHouseCooltrainerMText, TEXT_SAFARIZONEWESTRESTHOUSE_COOLTRAINER_M
	dw_const SafariZoneWestRestHouseSilphWorkerFText, TEXT_SAFARIZONEWESTRESTHOUSE_SILPH_WORKER_F

SafariZoneWestRestHouseScientistText:
; PureRGBnote: ADDED: this NPC will display different text depending on what type of safari game you're playing
	text_asm
	ld hl, .default
.jumpText
	ld a, [wSafariType]
	ld bc, 5
	call AddNTimes
	rst _PrintText
	rst TextScriptEnd
.default:
	text_far _SafariZoneWestRestHouseScientistText
	text_end
.rangerHunt:
	text_far _SafariZoneRestHouse2TextRangerHunt
	text_end
.freeRoam:
	text_far _SafariZoneRestHouse2TextFreeRoam
	text_end

SafariZoneWestRestHouseCooltrainerMText:
; PureRGBnote: ADDED: this NPC will display different text depending on what type of safari game you're playing
	text_asm
	ld hl, .default
	jr SafariZoneWestRestHouseScientistText.jumpText
.default:
	text_far _SafariZoneWestRestHouseCooltrainerMText
	text_end
.rangerHunt:
	text_far _SafariZoneRestHouse2TextRangerHunt2
	text_end
.freeRoam:
	text_far _SafariZoneRestHouse2TextFreeRoam2
	text_end

SafariZoneWestRestHouseSilphWorkerFText:
	text_far _SafariZoneWestRestHouseSilphWorkerFText
	text_end
