OpenOaksPC:
	call SaveScreenTilesToBuffer2
	ld hl, AccessedOaksPCText
	rst _PrintText
	ld hl, GetDexRatedText
	rst _PrintText
	call YesNoChoice
	jr nz, .closePC
	callfar DisplayDexRating
.closePC
	ld hl, ClosedOaksPCText
	rst _PrintText
	jp LoadScreenTilesFromBuffer2

GetDexRatedText:
	text_far_end _GetDexRatedText

ClosedOaksPCText:
	text_far_end _ClosedOaksPCText

AccessedOaksPCText:
	text_far_end _AccessedOaksPCText
