CeladonMart3F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart3F_TextPointers:
	def_text_pointers
	dba_const CeladonMart3FClerkText,            TEXT_CELADONMART3F_CLERK
	dba_const _CeladonMart3FGameBoyKid1Text,      TEXT_CELADONMART3F_GAMEBOY_KID1
	dba_const _CeladonMart3FGameBoyKid2Text,      TEXT_CELADONMART3F_GAMEBOY_KID2
	dba_const _CeladonMart3FGameBoyKid3Text,      TEXT_CELADONMART3F_GAMEBOY_KID3
	dba_const _CeladonMart3FLittleBoyText,        TEXT_CELADONMART3F_LITTLE_BOY
	dba_const CeladonMartTMKid,                  TEXT_CELADONMART3F_TM_KID ; PureRGbnote: ADDED: new NPC, it's the TM kid from other pokemarts, he doesn't sell anything though this time
	dba_const _CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES1
	dba_const _CeladonMart3FRPGText,              TEXT_CELADONMART3F_RPG
	dba_const _CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES2
	dba_const _CeladonMart3FSportsGameText,       TEXT_CELADONMART3F_SPORTS_GAME
	dba_const _CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES3
	dba_const _CeladonMart3FPuzzleGameText,       TEXT_CELADONMART3F_PUZZLE_GAME
	dba_const _CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES4
	dba_const _CeladonMart3FFightingGameText,     TEXT_CELADONMART3F_FIGHTING_GAME
	dba_const _CeladonMart3FCurrentFloorSignText, TEXT_CELADONMART3F_CURRENT_FLOOR_SIGN
	dba_const _CeladonMart3FPokemonPosterText,    TEXT_CELADONMART3F_POKEMON_POSTER1
	dba_const _CeladonMart3FPokemonPosterText,    TEXT_CELADONMART3F_POKEMON_POSTER2
	dba_const _CeladonMart3FPokemonPosterText,    TEXT_CELADONMART3F_POKEMON_POSTER3 
; PureRGBnote: ADDED: some flavour text for one block that was changed to have more TVs
	dba_const _CeladonMart3FPartyGameText,        TEXT_CELADONMART3F_PARTY_GAME 
	dba_const _CeladonMart3FPlatformerGameText,   TEXT_CELADONMART3F_PLATFORMER_GAME

CeladonMart3FClerkText:
	text_asm
	CheckEvent EVENT_GOT_TM18
	ld hl, .TM18ExplanationText
	jr nz, .done
	ld hl, .TM18PreReceiveText
	rst _PrintText
	lb bc, TM_CELADON_MART_GAME_SHOP_GUY, 1
	call GiveItem
	ld hl, .TM18NoRoomText
	jr nc, .done
	SetEvent EVENT_GOT_TM18
	ld hl, .ReceivedTM18Text
.done
	rst _PrintText
	rst TextScriptEnd

.TM18PreReceiveText:
	text_far_end _CeladonMart3FClerkTM18PreReceiveText

.ReceivedTM18Text:
	text_far_end _GenericPlayerReceivedTextSFX1

.TM18ExplanationText:
	text_far_end _CeladonMart3FClerkTM18ExplanationText

.TM18NoRoomText:
	text_far_end _CeladonMart3FClerkTM18NoRoomText

CeladonMartTMKid:
	text_asm
	ld hl, TMKidGreet4
	rst _PrintText
	ld hl, CeladonMartTMKidFlavor
	rst _PrintText
	rst TextScriptEnd
	
TMKidGreet4::
	text_far_end _TMKidGreet

CeladonMartTMKidFlavor:
	text_far_end _CeladonMartTMKidFlavor
