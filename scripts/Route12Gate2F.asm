Route12Gate2F_Script:
	jp DisableAutoTextBoxDrawing

Route12Gate2F_TextPointers:
	def_text_pointers
	dba_const Route12Gate2FBrunetteGirlText,    TEXT_ROUTE12GATE2F_BRUNETTE_GIRL
	dba_const Route12Gate2FLeftBinocularsText,  TEXT_ROUTE12GATE2F_LEFT_BINOCULARS
	dba_const Route12Gate2FRightBinocularsText, TEXT_ROUTE12GATE2F_RIGHT_BINOCULARS

Route12Gate2FBrunetteGirlText:
	text_asm
	CheckEvent EVENT_GOT_TM39, 1
	jr c, .got_item
	ld hl, .YouCanHaveThisText
	rst _PrintText
	lb bc, TM_ROUTE_12_GATE_2F_MOURNING_GIRL, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .ReceivedTM39Text
	rst _PrintText
	SetEvent EVENT_GOT_TM39
	rst TextScriptEnd
.bag_full
	ld hl, .TM39NoRoomText
	rst _PrintText
	rst TextScriptEnd
.got_item
	ld hl, .TM39ExplanationText
	rst _PrintText
	ld de, .mourningGirl
	call CopyTrainerName
	ld c, DEX_ARBOK - 1
	callfar SetMonSeen
	lb hl, DEX_ARBOK, $FF
	ld de, ArbokLearnset
	ld bc, LearnsetRecountedFondMemories
	predef_jump LearnsetTrainerScriptMain

.YouCanHaveThisText:
	text_far_end _Route12Gate2FBrunetteGirlYouCanHaveThisText

.ReceivedTM39Text:
	text_far_end _GenericPlayerReceivedTextSFX1

.TM39ExplanationText:
	text_far_end _Route12Gate2FBrunetteGirlTM39ExplanationText

.TM39NoRoomText:
	text_far_end _Route12Gate2FBrunetteGirlTM39NoRoomText

.mourningGirl
	db "SAD GIRL@"

Route12Gate2FLeftBinocularsText:
	text_asm
	ld hl, .Text
	jr GateUpstairsScript_PrintIfFacingUp

.Text:
	text_far _GenericLookedIntoTheBinocularsText
	text_far_end _Route12Gate2FLeftBinocularsText

Route12Gate2FRightBinocularsText:
	text_asm
	ld hl, .Text
	jr GateUpstairsScript_PrintIfFacingUp

.Text:
	text_far _GenericLookedIntoTheBinocularsText
	text_far_end _Route12Gate2FRightBinocularsText

GateUpstairsScript_PrintIfFacingUp:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jp nz, TextScriptEndNoButtonPress
	rst _PrintText
	rst TextScriptEnd
