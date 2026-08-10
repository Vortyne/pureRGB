SaffronPidgeyHouse_Script:
	jp EnableAutoTextBoxDrawing

SaffronPidgeyHouse_TextPointers:
	def_text_pointers
	dba_const _SaffronPidgeyHouseBrunetteGirlText, TEXT_SAFFRONPIDGEYHOUSE_BRUNETTE_GIRL
	dba_const SaffronPidgeyHousePidgeyText,        TEXT_SAFFRONPIDGEYHOUSE_PIDGEY
	dba_const _SaffronPidgeyHouseYoungsterText,    TEXT_SAFFRONPIDGEYHOUSE_YOUNGSTER
	dba_const _SaffronPidgeyHousePaperText,        TEXT_SAFFRONPIDGEYHOUSE_PAPER
	dba_const SaffronPidgeyHouseTVText,            TEXT_SAFFRONPIDGEYHOUSE_TV

SaffronPidgeyHousePidgeyText:
	text_far _SaffronPidgeyHousePidgeyText
	text_asm
	ld a, PIDGEY
	call PlayCry
	rst TextScriptEnd

SaffronPidgeyHouseTVText::
	text_asm
	jpfar PorygonTVScreenText
