TitleMons:
; mons on the title screen are randomly chosen from here
IF DEF(_RED)
	db MR_MIME
	db STARTER1
	db CHARMELEON
	db CHARIZARD
	db NIDORAN_M
	db NIDORINO
	db NIDOKING
	db TAUROS
	db SNORLAX
	db GASTLY
	db HAUNTER
	db GENGAR
	db PINSIR
	db JOLTEON
	db ZAPDOS
	db MEW
ENDC
IF DEF(_BLUE)
	db MR_MIME
	db STARTER2
	db WARTORTLE
	db BLASTOISE
	db SLOWPOKE
	db SLOWBRO
	db KRABBY
	db KINGLER
	db POLIWAG
	db POLIWHIRL
	db POLIWRATH
	db MAGIKARP
	db GYARADOS
	db VAPOREON
	db ARTICUNO
	db MEWTWO
ENDC
IF DEF(_GREEN) ; PureRGBnote: GREENBUILD: the pokemon that appear on the start screen on green version.
	db MR_MIME
	db STARTER3
	db IVYSAUR
	db VENUSAUR
	db EXEGGCUTE
	db EXEGGUTOR
	db GRIMER
	db MUK
	db ABRA
	db KADABRA
	db ALAKAZAM
	db EKANS
	db ARBOK
	db LICKITUNG
	db CHANSEY
	db EEVEE
	db CHANSEY
	db SNORLAX
ENDC
