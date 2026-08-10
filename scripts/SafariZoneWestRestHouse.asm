SafariZoneWestRestHouse_Script:
	jp EnableAutoTextBoxDrawing

SafariZoneWestRestHouse_TextPointers:
	def_text_pointers
	dba_const SafariZoneWestRestHouseScientistText,    TEXT_SAFARIZONEWESTRESTHOUSE_SCIENTIST
	dba_const SafariZoneWestRestHouseCooltrainerMText, TEXT_SAFARIZONEWESTRESTHOUSE_COOLTRAINER_M
	dba_const _SafariZoneWestRestHouseSilphWorkerFText, TEXT_SAFARIZONEWESTRESTHOUSE_SILPH_WORKER_F
	dba_const _SafariZoneTiredGuyText,                  TEXT_SAFARIZONEWESTRESTHOUSE_TIRED_GUY

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
	text_far_end _SafariZoneWestRestHouseScientistText
.rangerHunt:
	text_far_end _SafariZoneRestHouse2TextRangerHunt
.freeRoam:
	text_far_end _SafariZoneRestHouse2TextFreeRoam

SafariZoneWestRestHouseCooltrainerMText:
; PureRGBnote: ADDED: this NPC will display different text depending on what type of safari game you're playing
	text_asm
	ld hl, .default
	jr SafariZoneWestRestHouseScientistText.jumpText
.default:
	text_far_end _SafariZoneWestRestHouseCooltrainerMText
.rangerHunt:
	text_far_end _SafariZoneRestHouse2TextRangerHunt2
.freeRoam:
	text_far_end _SafariZoneRestHouse2TextFreeRoam2
