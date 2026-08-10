CeladonMansion3F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion3F_TextPointers:
	def_text_pointers
	dba_const _CeladonMansion3FProgrammerText,     TEXT_CELADONMANSION3F_PROGRAMMER
	dba_const _CeladonMansion3FGraphicArtistText,  TEXT_CELADONMANSION3F_GRAPHIC_ARTIST
	dba_const _CeladonMansion3FWriterText,         TEXT_CELADONMANSION3F_WRITER
	dba_const CeladonMansion3FGameDesignerText,   TEXT_CELADONMANSION3F_GAME_DESIGNER
	dba_const _CeladonMansion3FGameProgramPCText,  TEXT_CELADONMANSION3F_GAME_PROGRAM_PC
	dba_const _CeladonMansion3FPlayingGamePCText,  TEXT_CELADONMANSION3F_PLAYING_GAME_PC
	dba_const _CeladonMansion3FGameScriptPCText,   TEXT_CELADONMANSION3F_GAME_SCRIPT_PC
	dba_const _CeladonMansion3FDevRoomSignText,    TEXT_CELADONMANSION3F_DEV_ROOM_SIGN

CeladonMansion3FGameDesignerText:
	text_asm
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp NUM_POKEMON - 2 ; PureRGBnote: CHANGED: discount Mew and Missingno when checking for if the player has caught everything
	ld hl, .CompletedDexText
	jr nc, .printDone
	ld hl, .DefaultText
.printDone
	rst _PrintText
	rst TextScriptEnd

.CompletedDexText:
	text_far _CeladonMansion3FGameDesignerCompletedDexText
	text_promptbutton
	text_asm
	call ClearTextBox
	callfar DisplayDiploma
	ld hl, .congrats
	jr .printDone

.DefaultText:
	text_far_end _CeladonMansion3FGameDesignerText

.congrats
	text_far_end _CeladonMansion3FGameDesignerCongratsText
