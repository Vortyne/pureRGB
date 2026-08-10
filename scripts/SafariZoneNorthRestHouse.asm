SafariZoneNorthRestHouse_Script:
	jp EnableAutoTextBoxDrawing

SafariZoneNorthRestHouse_TextPointers:
	def_text_pointers
	dba_const SafariZoneNorthRestHouseScientistText,        TEXT_SAFARIZONENORTHRESTHOUSE_SCIENTIST
	dba_const _SafariZoneNorthRestHouseSafariZoneWorkerText, TEXT_SAFARIZONENORTHRESTHOUSE_SAFARI_ZONE_WORKER
	dba_const _SafariZoneNorthRestHouseGentlemanText,        TEXT_SAFARIZONENORTHRESTHOUSE_GENTLEMAN
	dba_const SafariZoneNorthRestHouseFitnessGirlText,      TEXT_SAFARIZONENORTHRESTHOUSE_FITNESS_GIRL

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
	text_far_end _SafariZoneNorthRestHouseScientistText
.rangerHunt:
	text_far_end _SafariZoneRestHouse4TextRangerHunt
.freeRoam:
	text_far_end _SafariZoneRestHouse4TextChansey

SafariZoneNorthRestHouseFitnessGirlText:
	text_asm 
	ld a, [wSafariType]
	and a ; SAFARI_TYPE_CLASSIC
	ld hl, .classic
	jr z, .printDone
	ld hl, .other
	.printDone
	rst _PrintText
	rst TextScriptEnd
.classic
	text_far_end _SafariZoneCatchGirl
.other
	text_far_end _SafariZoneCatchGirl2
