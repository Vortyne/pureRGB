VermilionPidgeyHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionPidgeyHouse_TextPointers:
	def_text_pointers
	dw_const VermilionPidgeyHouseYoungsterText, TEXT_VERMILIONPIDGEYHOUSE_YOUNGSTER
	dw_const VermilionPidgeyHousePidgeyText,    TEXT_VERMILIONPIDGEYHOUSE_PIDGEY
	dw_const VermilionPidgeyHouseLetterText,    TEXT_VERMILIONPIDGEYHOUSE_LETTER

VermilionPidgeyHouseYoungsterText:
	text_far _VermilionPidgeyHouseYoungsterText
	text_asm
	ld c, DEX_PIDGEY - 1
	callfar SetMonSeen
	ld de, YoungsterName
	call CopyTrainerName
	lb hl, DEX_PIDGEY, $FF
	ld de, VermilionPidgeyHouseYoungsterLearnset
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain

YoungsterName:
	db "PEN PAL@"

VermilionPidgeyHousePidgeyText:
	text_far _VermilionPidgeyHousePidgeyText
	text_asm
	ld c, DEX_PIDGEY - 1
	callfar SetMonSeen
	ld a, PIDGEY
	call PlayCry
	call WaitForSoundToFinish
	rst TextScriptEnd

VermilionPidgeyHouseLetterText:
	text_far _VermilionPidgeyHouseLetterText
	text_end
