ViridianForestSouthGate_Script:
	jp EnableAutoTextBoxDrawing

ViridianForestSouthGate_TextPointers:
	def_text_pointers
	dba_const _ViridianForestSouthGateGirlText,       TEXT_VIRIDIANFORESTSOUTHGATE_GIRL
	dba_const ViridianForestSouthGateLittleGirlText, TEXT_VIRIDIANFORESTSOUTHGATE_LITTLE_GIRL

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
	text_far_end _ViridianForestSouthGateLittleGirl2Text
