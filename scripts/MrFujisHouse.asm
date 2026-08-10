; PureRGBnote: CHANGED: some of this script was optimized a bit.
MrFujisHouse_Script:
	call CheckHideMrFujiInPokemonTower
	jp EnableAutoTextBoxDrawing

MrFujisHouse_TextPointers:
	def_text_pointers
	dba_const MrFujisHouseSuperNerdText,     TEXT_MRFUJISHOUSE_SUPER_NERD
	dba_const MrFujisHouseLittleGirlText,    TEXT_MRFUJISHOUSE_LITTLE_GIRL
	dba_const MrFujisHousePsyduckText,       TEXT_MRFUJISHOUSE_PSYDUCK
	dba_const MrFujisHouseNidorinoText,      TEXT_MRFUJISHOUSE_NIDORINO
	dba_const MrFujisHouseMrFujiText,        TEXT_MRFUJISHOUSE_MR_FUJI
	dba_const _MrFujisHouseMrFujiPokedexText, TEXT_MRFUJISHOUSE_POKEDEX
	dba_const _MagazinesText,                 TEXT_MRFUJISHOUSE_MAGAZINES

;;;;;;;;;; PureRGBnote: MOVED: moved this hiding routine here because it looks weird that mr fuji gets hidden before we warp to his house
CheckHideMrFujiInPokemonTower:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_RESCUED_MR_FUJI
	ret z
	ld c, TOGGLE_POKEMON_TOWER_7F_MR_FUJI
	jp HideObject
;;;;;;;;;;

MrFujisHouseSuperNerdText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	ld hl, .MrFujiHadBeenPrayingText
	jr nz, .printDone
	ld hl, .MrFujiIsntHereText
.printDone
	rst _PrintText
	rst TextScriptEnd

.MrFujiIsntHereText:
	text_far_end _MrFujisHouseSuperNerdMrFujiIsntHereText

.MrFujiHadBeenPrayingText:
	text_far_end _MrFujisHouseSuperNerdMrFujiHadBeenPrayingText

MrFujisHouseLittleGirlText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	ld hl, .PokemonAreNiceToHugText
	jr nz, .printDone
	ld hl, .ThisIsMrFujisHouseText
.printDone
	rst _PrintText
	rst TextScriptEnd

.ThisIsMrFujisHouseText:
	text_far_end _MrFujisHouseLittleGirlThisIsMrFujisHouseText

.PokemonAreNiceToHugText:
	text_far_end _MrFujisHouseLittleGirlPokemonAreNiceToHugText

MrFujisHousePsyduckText:
	text_far _MrFujisHousePsyduckText
	text_asm
	ld a, PSYDUCK
	call PlayCry
	ld c, DEX_PSYDUCK - 1
	callfar SetMonSeen
	call DisplayTextPromptButton
	ld hl, .thatsDucket
	rst _PrintText
	ld de, RescuerName
	call CopyTrainerName
	lb hl, DEX_PSYDUCK, $FF
	ld de, TextNothing
	ld bc, LearnsetPlayedAroundWith
	predef_jump LearnsetTrainerScriptMain
.thatsDucket
	text_far_end _MrFujisHousePsyduck2Text

MrFujisHouseNidorinoText:
	text_far _MrFujisHouseNidorinoText
	text_asm
	ld a, NIDORINO
	call PlayCry
	ld c, DEX_NIDORINO - 1
	callfar SetMonSeen
	call DisplayTextPromptButton
	ld a, MRFUJISHOUSE_LITTLE_GIRL
	call SetSpriteFacingLeft
	ld a, MRFUJISHOUSE_SUPER_NERD
	call SetSpriteFacingLeft
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld hl, .thatsSpike
	rst _PrintText
	ld de, RescuerName
	call CopyTrainerName
	lb hl, DEX_NIDORINO, $FF
	ld de, TextNothing
	ld bc, LearnsetShowedCoolMoves
	predef_jump LearnsetTrainerScriptMain
.thatsSpike
	text_far_end _MrFujisHouseNidorino2Text

RescuerName::
	db "RESCUERs@"

MrFujisHouseMrFujiText:
	text_asm
	CheckEvent EVENT_GOT_POKE_FLUTE
	ld hl, .HasMyFluteHelpedYouText
	jr nz, .printDone
	ld hl, .IThinkThisMayHelpYourQuestText
	rst _PrintText
	lb bc, POKE_FLUTE, 1
	call GiveItem
	ld hl, .PokeFluteNoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_POKE_FLUTE
	ld hl, .ReceivedPokeFluteText
.printDone
	rst _PrintText
	rst TextScriptEnd

.IThinkThisMayHelpYourQuestText:
	text_far_end _MrFujisHouseMrFujiIThinkThisMayHelpYourQuestText

.ReceivedPokeFluteText:
	text_far _MrFujisHouseMrFujiReceivedPokeFluteText
	sound_get_key_item
	text_far_end _MrFujisHouseMrFujiPokeFluteExplanationText

.PokeFluteNoRoomText:
	text_far_end _MrFujisHouseMrFujiPokeFluteNoRoomText

.HasMyFluteHelpedYouText:
	text_far_end _MrFujisHouseMrFujiHasMyFluteHelpedYouText
