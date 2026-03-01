; To reduce amount of code that needs to be rewritten, when loading randomized fitness trainers in fitness battles,
; we will just use an existing party with the same number of pokemon chosen, and randomize the pokemon / set the level
GetFitnessTrainerPartyPointer::
	ld a, [wFitnessOpponentMonCount]
	dec a
	ld d, 0
	ld e, a
	ld hl, FitnessProxyParties
	add hl, de
	add hl, de
	de_deref
	ret

FitnessProxyParties:
	dw FitnessProxyParty1
	dw FitnessProxyParty2
	dw FitnessProxyParty3
	dw FitnessProxyParty4
	dw FitnessProxyParty5
	dw FitnessProxyParty6

; only pokemon that 
GetRandomFitnessPokemon::
	ld a, [wCurMap]
	cp VERMILION_FITNESS_CLUB
	ld hl, VermilionFitnessClubAllowedPokemon
	jr z, .gotPokemonSet
	cp CELADON_BACK_ALLEY
	ld hl, CeladonBackAlleyAllowedPokemon
	jr z, .gotPokemonSet
	ld hl, FightingDojoAllowedPokemon
.gotPokemonSet
	call Random
	and %11111 ; 32 possible results
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	ret

VermilionFitnessClubAllowedPokemon:
	db SHELLDER
	db HORSEA
	db TENTACOOL
	db GOLDEEN
	db CLEFAIRY
	db MACHOP
	db PONYTA
	db DODUO
	db KRABBY
	db CUBONE
	db EEVEE
	db DRATINI
	db PARAS
	db BULBASAUR
	db CHARMANDER
	db BELLSPROUT
	db DIGLETT
	db SANDSHREW
	db JIGGLYPUFF
	db VENONAT
	db PIKACHU
	db RATTATA
	db NIDORAN_F
	db NIDORAN_M 
	db FARFETCHD
	db VULPIX
	db ODDISH
	db ABRA
	db PIDGEY
	db PSYDUCK
	db METAPOD
	db KAKUNA

CeladonBackAlleyAllowedPokemon:
	db KOFFING
	db WEEZING
	db EKANS
	db ARBOK
	db MAGNEMITE
	db MAGNETON
	db ZUBAT
	db GOLBAT
	db DROWZEE
	db HYPNO
	db SPEAROW
	db FEAROW
	db VOLTORB
	db ELECTRODE
	db RATICATE
	db BEEDRILL
	db NIDORINO
	db ONIX
	db RHYHORN
	db PINSIR
	db SCYTHER
	db PIDGEOTTO
	db CHARMELEON
	db WARTORTLE
	db IVYSAUR
	db WEEPINBELL
	db EXEGGCUTE
	db POLIWHIRL
	db MEOWTH
	db MANKEY
	db GRIMER
	db DITTO

FightingDojoAllowedPokemon:
	db PRIMEAPE
	db MACHOKE
	db MACHAMP
	db POLIWRATH
	db CHANSEY
	db KINGLER
	db PIDGEOT
	db RAICHU
	db SANDSLASH
	db NIDOKING
	db NIDOQUEEN
	db NINETALES
	db PARASECT
	db DUGTRIO
	db PERSIAN
	db GOLDUCK
	db ARCANINE
	db ALAKAZAM
	db TENTACRUEL
	db GOLEM
	db RHYDON
	db RAPIDASH
	db DODRIO
	db MUK
	db CLOYSTER
	db ONIX
	db MAROWAK
	db HITMONLEE
	db HITMONCHAN
	db ELECTABUZZ
	db KANGASKHAN
	db TAUROS
