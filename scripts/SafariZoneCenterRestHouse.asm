; PureRGBnote: ADDED: Erik and Sara can now be reunited in this map. After they will go to their house on ROUTE 19.
SafariZoneCenterRestHouse_Script:
	jp EnableAutoTextBoxDrawing

SafariZoneCenterRestHouse_TextPointers:
	def_text_pointers
	dba_const SafariZoneCenterRestHouseSaraText,      TEXT_SAFARIZONECENTERRESTHOUSE_SARA
	dba_const _SafariZoneCenterRestHouseScientistText, TEXT_SAFARIZONECENTERRESTHOUSE_SCIENTIST
	dba_const SafariZoneCenterRestHouseErikText,      TEXT_SAFARIZONECENTERRESTHOUSE_ERIK

SafariZoneCenterRestHouseSaraText:
	text_asm
	CheckExtraHideShowState TOGGLE_SAFARI_ZONE_CENTER_REST_HOUSE_ERIK
	jr z, .reunited
	SetEvent EVENT_MET_SARA
	ld hl, .whereErik
	rst _PrintText
	CheckEvent EVENT_MET_ERIK
	jr z, .done
	call DisplayTextPromptButton
	ld hl, .goGetErik
	rst _PrintText
.done
	rst TextScriptEnd	
.reunited
	ld hl, .reunitedText
	rst _PrintText
	ld a, SAFARIZONECENTERRESTHOUSE_SARA
	call SetSpriteFacingRight
	ld hl, .okayRicky
	rst _PrintText
	call ShowHouseSaraErik
	rst TextScriptEnd
.whereErik
	text_far_end _SafariZoneCenterRestHouseGirlText
.goGetErik
	text_far_end _SaraErikOutsideText
.reunitedText
	text_far_end _SaraReunitedText
.okayRicky
	text_far_end _SaraOkayRicky

SafariZoneCenterRestHouseErikText:
	text_far _ErikReunitedText
	text_asm
	call ShowHouseSaraErik
	rst TextScriptEnd

ShowHouseSaraErik:
	ld c, TOGGLE_ERIK_HOUSE
	call ShowExtraObject
	ld c, TOGGLE_SARA_HOUSE
	jp ShowExtraObject