TitleMons:
; mons on the title screen are randomly chosen from here
IF DEF(_RED)
	db STARTER1
	db STARTER2
	db STARTER3
	db MR_MIME
	db CHARMELEON
	db CHARIZARD
	db NIDORAN_M
	db NIDORINO
	db NIDOKING
	db TAUROS
	db GASTLY
	db HAUNTER
	db GENGAR
	db JOLTEON
	db ZAPDOS
	db MEW
ENDC
IF DEF(_BLUE)
	db STARTER2
	db STARTER1
	db STARTER3
	db MR_MIME
	db WARTORTLE
	db BLASTOISE
	db SLOWPOKE
	db SLOWBRO
	db KRABBY
	db KINGLER
	db ABRA
	db KADABRA
	db ALAKAZAM
	db VAPOREON
	db ARTICUNO
	db MEWTWO
ENDC
IF DEF(_GREEN) ; PureRGBnote: GREENBUILD: the pokemon that appear on the start screen on green version.
	db STARTER3
	db STARTER1
	db STARTER2
	db MR_MIME
	db IVYSAUR
	db VENUSAUR
	db EXEGGCUTE
	db EXEGGUTOR
	db GRIMER
	db MUK
	db MEOWTH
	db PERSIAN
	db PORYGON
	db EEVEE
	db CHANSEY
	db SNORLAX
ENDC
