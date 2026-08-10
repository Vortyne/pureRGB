ViridianNicknameHouse_Script:
	jp EnableAutoTextBoxDrawing

ViridianNicknameHouse_TextPointers:
	def_text_pointers
	dba_const _ViridianNicknameHouseBaldingGuyText, TEXT_VIRIDIANNICKNAMEHOUSE_BALDING_GUY
	dba_const _ViridianNicknameHouseLittleGirlText, TEXT_VIRIDIANNICKNAMEHOUSE_LITTLE_GIRL
	dba_const ViridianNicknameHouseSpearowText,    TEXT_VIRIDIANNICKNAMEHOUSE_SPEAROW
	dba_const ViridianNicknameHouseSpearySignText, TEXT_VIRIDIANNICKNAMEHOUSE_SPEARY_SIGN

ViridianNicknameHouseSpearowText:
	text_asm
	ld hl, .Text
	rst _PrintText
	ld a, SPEAROW
	call PlayCry
.done
	ld c, DEX_SPEAROW - 1
	callfar SetMonSeen
	rst TextScriptEnd

.Text:
	text_far_end _ViridianNicknameHouseSpearowText

ViridianNicknameHouseSpearySignText:
	text_far _ViridianNicknameHouseSpearySignText
	text_asm
	jr ViridianNicknameHouseSpearowText.done
