; PureRGBnote: ADDED: a stairway downstairs was added, but it is blocked by a new ROCKET who tells you to go away until you save mr fuji.

PokemonTower1F_Script:
	call WasMapJustLoaded
	jr z, .skipHideRocket
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr z, .skipHideRocket
	; to fix save transfers (forgot to conditionally update in save file updater), hide this rocket on map load after rescuing mr fuji
	ld c, TOGGLE_POKEMON_TOWER_1F_ROCKET
	call HideExtraObject
.skipHideRocket
	jp EnableAutoTextBoxDrawing

PokemonTower1F_TextPointers:
	def_text_pointers
	dba_const _PokemonTower1FReceptionistText,    TEXT_POKEMONTOWER1F_RECEPTIONIST
	dba_const _PokemonTower1FMiddleAgedWomanText, TEXT_POKEMONTOWER1F_MIDDLE_AGED_WOMAN
	dba_const _PokemonTower1FBaldingGuyText,      TEXT_POKEMONTOWER1F_BALDING_GUY
	dba_const PokemonTower1FGirlText,            TEXT_POKEMONTOWER1F_GIRL
	dba_const _PokemonTower1FChannelerText,       TEXT_POKEMONTOWER1F_CHANNELER
	dba_const PokemonTower1FRocketText,          TEXT_POKEMONTOWER1F_ROCKET

PokemonTower1FGirlText:
	text_far _PokemonTower1FGirlText
	text_asm
	ld c, DEX_GROWLITHE - 1
	callfar SetMonSeen
	ld de, .pensivegirl
	call CopyTrainerName
	lb hl, DEX_GROWLITHE, $FF
	ld de, PokemonTower1FGirl2Text
	ld bc, LearnsetRecountedFondMemories
	predef_jump LearnsetTrainerScriptMain

.pensivegirl
	db "SAD LADY@"

PokemonTower1FRocketText:
	text_asm
	ld hl, PokemonTower1FRocketText1
	rst _PrintText
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	ld hl, PokemonTower1FRocketText2
	jr z, .done
	ld hl, PokemonTower1FRocketText3
.done
	rst _PrintText
	rst TextScriptEnd

PokemonTower1FRocketText1:
	text_far_end _PokemonTower1FRocketText

PokemonTower1FRocketText2:
	text_far_end _PokemonTower1FRocketText2

PokemonTower1FRocketText3:
	text_far_end _PokemonTower1FRocketText3
