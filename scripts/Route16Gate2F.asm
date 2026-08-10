Route16Gate2F_Script:
	jp DisableAutoTextBoxDrawing

Route16Gate2F_TextPointers:
	def_text_pointers
	dba_const Route16Gate2FLittleBoyText,       TEXT_ROUTE16GATE2F_LITTLE_BOY
	dba_const Route16Gate2FLittleGirlText,      TEXT_ROUTE16GATE2F_LITTLE_GIRL
	dba_const Route16Gate2FLeftBinocularsText,  TEXT_ROUTE16GATE2F_LEFT_BINOCULARS
	dba_const Route16Gate2FRightBinocularsText, TEXT_ROUTE16GATE2F_RIGHT_BINOCULARS

Route16Gate2FLittleBoyText:
	text_asm
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far_end _Route16Gate2FLittleBoyText

Route16Gate2FLittleGirlText:
	text_asm
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far_end _Route16Gate2FLittleGirlText

Route16Gate2FLeftBinocularsText:
	text_asm
	ld hl, .Text
	jp GateUpstairsScript_PrintIfFacingUp

.Text:
	text_far _GenericLookedIntoTheBinocularsText
	text_far_end _Route16Gate2FLeftBinocularsText

Route16Gate2FRightBinocularsText:
	text_asm
	ld hl, .Text
	jp GateUpstairsScript_PrintIfFacingUp

.Text:
	text_far _GenericLookedIntoTheBinocularsText
	text_far_end _Route16Gate2FRightBinocularsText
