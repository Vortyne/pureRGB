ViridianForestSouthGate_Script:
	jp EnableAutoTextBoxDrawing

ViridianForestSouthGate_TextPointers:
	def_text_pointers
	dw_const ViridianForestSouthGateGirlText,       TEXT_VIRIDIANFORESTSOUTHGATE_GIRL
	dw_const ViridianForestSouthGateLittleGirlText, TEXT_VIRIDIANFORESTSOUTHGATE_LITTLE_GIRL

ViridianForestSouthGateGirlText:
	text_far _ViridianForestSouthGateGirlText
	text_end

ViridianForestSouthGateLittleGirlText:
	text_far _ViridianForestSouthGateLittleGirlText
	text_asm
	ld d, RATTATA
	callfar IsMonInParty
	jr nc, .done
	call DisplayTextPromptButton
	ld hl, .rightOn
	rst _PrintText
.done
	rst TextScriptEnd
.rightOn
	text_far _ViridianForestSouthGateLittleGirl2Text
	text_end
