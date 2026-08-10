IndigoPlateauStatues::
	text_asm
	ld hl, IndigoPlateauStatuesText1
	rst _PrintText
	ld a, [wXCoord]
	bit 0, a ; even or odd?
	ld hl, IndigoPlateauStatuesText2
	jr nz, .ok
	ld hl, IndigoPlateauStatuesText3
.ok
	rst _PrintText
	rst TextScriptEnd

IndigoPlateauStatuesText1:
	text_far_end _IndigoPlateauStatuesText1

IndigoPlateauStatuesText2:
	text_far_end _IndigoPlateauStatuesText2

IndigoPlateauStatuesText3:
	text_far_end _IndigoPlateauStatuesText3
