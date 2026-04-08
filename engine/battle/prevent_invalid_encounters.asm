PreventInvalidEncounters::
	; prevents encountering non-catchable pokemon via glitches (these will break the game to use anyway)
	ld a, [wCurMap]
	cp POKEMON_TOWER_B1F
	ret z
	ld a, [wEnemyMonSpecies2]
	ld hl, NonCatchablePokemon
	call IsInSingleByteArray
	ret nc
	ld a, CATERPIE
	ld [wEnemyMonSpecies2], a
	ret

NonCatchablePokemon:
	db SPIRIT_TORCHED
	db SPIRIT_IRRADIATED
	db SPIRIT_CHUNKY
	db SPIRIT_PAINLESS
	db SPIRIT_THE_MAW
	db FOSSIL_KABUTOPS
	db FOSSIL_AERODACTYL
	db MON_GHOST
	db -1
