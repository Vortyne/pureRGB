LavenderTown_Script:
	jp EnableAutoTextBoxDrawing

LavenderTown_TextPointers:
	def_text_pointers
	dba_const LavenderTownLittleGirlText,       TEXT_LAVENDERTOWN_LITTLE_GIRL
	dba_const _LavenderTownCooltrainerMText,     TEXT_LAVENDERTOWN_COOLTRAINER_M
	dba_const _LavenderTownSuperNerdText,        TEXT_LAVENDERTOWN_SUPER_NERD
	dba_const _LavenderTownSignText,             TEXT_LAVENDERTOWN_SIGN
	dba_const _LavenderTownSilphScopeSignText,   TEXT_LAVENDERTOWN_SILPH_SCOPE_SIGN
	dba_const MartSignText,                     TEXT_LAVENDERTOWN_MART_SIGN
	dba_const PokeCenterSignText,               TEXT_LAVENDERTOWN_POKECENTER_SIGN
	dba_const _LavenderTownPokemonHouseSignText, TEXT_LAVENDERTOWN_POKEMON_HOUSE_SIGN
	dba_const _LavenderTownPokemonTowerSignText, TEXT_LAVENDERTOWN_POKEMON_TOWER_SIGN

LavenderTownLittleGirlText:
	text_asm
	ld hl, .DoYouBelieveInGhostsText
	rst _PrintText
	call YesNoChoice
	ld hl, .HaHaGuessNotText
	jr nz, .got_text
	ld hl, .SoThereAreBelieversText
.got_text
	rst _PrintText
	rst TextScriptEnd

.DoYouBelieveInGhostsText:
	text_far_end _LavenderTownLittleGirlDoYouBelieveInGhostsText

.SoThereAreBelieversText:
	text_far_end _LavenderTownLittleGirlSoThereAreBelieversText

.HaHaGuessNotText:
	text_far_end _LavenderTownLittleGirlHaHaGuessNotText
