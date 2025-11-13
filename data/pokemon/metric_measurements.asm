; input wPokedexNum = which pokemon's dex number
; output de = weight in 1/10 of a kg, h = height in 1/10 of a meter
GetMetricMeasurements::
	ld a, [wPokedexNum]
	dec a
	ld hl, MetricMeasurements
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, c
	ret

MetricMeasurements::
	dbw 7 , 69  ; BULBASAUR  ; 1
	dbw 10 , 130  ; IVYSAUR    ; 2
	dbw 20 , 1000 ; VENUSAUR   ; 3
	dbw 6 , 85 ; CHARMANDER ; 4
	dbw 11 , 190 ; CHARMELEON ; 5
	dbw 17 , 905 ; CHARIZARD  ; 6
	dbw 5 , 90 ; SQUIRTLE   ; 7
	dbw 10 , 225 ; WARTORTLE  ; 8
	dbw 16 , 855 ; BLASTOISE  ; 9
	dbw 3 , 29 ; CATERPIE   ; 10
	dbw 7 , 99 ; METAPOD    ; 11
	dbw 11 , 320 ; BUTTERFREE ; 12
	dbw 3 , 32 ; WEEDLE     ; 13
	dbw 6 , 100 ; KAKUNA     ; 14
	dbw 10 , 295 ; BEEDRILL   ; 15
	dbw 3 , 18 ; PIDGEY     ; 16
	dbw 11 , 300 ; PIDGEOTTO  ; 17
	dbw 15 , 395 ; PIDGEOT    ; 18
	dbw 3 , 35 ; RATTATA    ; 19
	dbw 7 , 185 ; RATICATE   ; 20
	dbw 3 , 20 ; SPEAROW    ; 21
	dbw 12 , 380 ; FEAROW     ; 22
	dbw 20 , 69 ; EKANS      ; 23
	dbw 35 , 650 ; ARBOK      ; 24
	dbw 4 , 60 ; PIKACHU    ; 25
	dbw 8 , 300 ; RAICHU     ; 26
	dbw 6 , 120 ; SANDSHREW  ; 27
	dbw 10 , 295 ; SANDSLASH  ; 28
	dbw 4 , 70 ; NIDORAN_F  ; 29
	dbw 8 , 200 ; NIDORINA   ; 30
	dbw 13 , 600 ; NIDOQUEEN  ; 31
	dbw 5 , 90 ; NIDORAN_M  ; 32
	dbw 9 , 195 ; NIDORINO   ; 33
	dbw 14 , 620 ; NIDOKING   ; 34
	dbw 6 , 75 ; CLEFAIRY   ; 35
	dbw 13 , 400 ; CLEFABLE   ; 36
	dbw 6 , 99 ; VULPIX     ; 37
	dbw 11 , 199 ; NINETALES  ; 38
	dbw 5 , 55 ; JIGGLYPUFF ; 39
	dbw 10 , 120 ; WIGGLYTUFF ; 40
	dbw 8 , 75 ; ZUBAT      ; 41
	dbw 16 , 550 ; GOLBAT     ; 42
	dbw 5 , 54 ; ODDISH     ; 43
	dbw 8 , 86 ; GLOOM      ; 44
	dbw 12 , 186 ; VILEPLUME  ; 45
	dbw 3 , 54 ; PARAS      ; 46
	dbw 10 , 295 ; PARASECT   ; 47
	dbw 10 , 300 ; VENONAT    ; 48
	dbw 15 , 125 ; VENOMOTH   ; 49
	dbw 2 , 8 ; DIGLETT    ; 50
	dbw 7 , 333 ; DUGTRIO    ; 51
	dbw 4 , 42 ; MEOWTH     ; 52
	dbw 10 , 320 ; PERSIAN    ; 53
	dbw 8 , 196 ; PSYDUCK    ; 54
	dbw 17 , 766 ; GOLDUCK    ; 55
	dbw 5 , 280 ; MANKEY     ; 56
	dbw 10 , 320 ; PRIMEAPE   ; 57
	dbw 7 , 190 ; GROWLITHE  ; 58
	dbw 19 , 1550 ; ARCANINE   ; 59
	dbw 6 , 124 ; POLIWAG    ; 60
	dbw 10 , 200 ; POLIWHIRL  ; 61
	dbw 13 , 540 ; POLIWRATH  ; 62
	dbw 9 , 195 ; ABRA       ; 63
	dbw 13 , 565 ; KADABRA    ; 64
	dbw 15 , 480 ; ALAKAZAM   ; 65
	dbw 8 , 195 ; MACHOP     ; 66
	dbw 15 , 705 ; MACHOKE    ; 67
	dbw 16 , 1300 ; MACHAMP    ; 68
	dbw 7 , 40 ; BELLSPROUT ; 69
	dbw 10 , 64 ; WEEPINBELL ; 70
	dbw 17 , 155 ; VICTREEBEL ; 71
	dbw 9 , 455 ; TENTACOOL  ; 72
	dbw 16 , 550 ; TENTACRUEL ; 73
	dbw 4 , 200 ; GEODUDE    ; 74
	dbw 10 , 1050 ; GRAVELER   ; 75
	dbw 14 , 3000 ; GOLEM      ; 76
	dbw 10 , 300 ; PONYTA     ; 77
	dbw 17 , 950 ; RAPIDASH   ; 78
	dbw 12 , 360 ; SLOWPOKE   ; 79
	dbw 16 , 785 ; SLOWBRO    ; 80
	dbw 3 , 60 ; MAGNEMITE  ; 81
	dbw 10 , 600 ; MAGNETON   ; 82
	dbw 8 , 150 ; FARFETCHD  ; 83
	dbw 14 , 392 ; DODUO      ; 84
	dbw 18 , 852 ; DODRIO     ; 85
	dbw 11 , 900 ; SEEL       ; 86
	dbw 17 , 1200 ; DEWGONG    ; 87
	dbw 9 , 300 ; GRIMER     ; 88
	dbw 12 , 300 ; MUK        ; 89
	dbw 3 , 40 ; SHELLDER   ; 90
	dbw 15 , 1325 ; CLOYSTER   ; 91
	dbw 13 , 1 ; GASTLY     ; 92
	dbw 16 , 1 ; HAUNTER    ; 93
	dbw 15 , 405 ; GENGAR     ; 94
	dbw 88 , 2100 ; ONIX       ; 95
	dbw 10 , 324 ; DROWZEE    ; 96
	dbw 16 , 756 ; HYPNO      ; 97
	dbw 4 , 65 ; KRABBY     ; 98
	dbw 13 , 600 ; KINGLER    ; 99
	dbw 5 , 104 ; VOLTORB    ; 100
	dbw 12 , 666 ; ELECTRODE  ; 101
	dbw 4 , 25 ; EXEGGCUTE  ; 102
	dbw 20 , 1200 ; EXEGGUTOR  ; 103
	dbw 4 , 65 ; CUBONE     ; 104
	dbw 10 , 450 ; MAROWAK    ; 105
	dbw 15 , 498 ; HITMONLEE  ; 106
	dbw 14 , 502 ; HITMONCHAN ; 107
	dbw 12 , 655 ; LICKITUNG  ; 108
	dbw 6 , 10 ; KOFFING    ; 109
	dbw 12 , 95 ; WEEZING    ; 110
	dbw 10 , 1150 ; RHYHORN    ; 111
	dbw 19 , 1200 ; RHYDON     ; 112
	dbw 11 , 346 ; CHANSEY    ; 113
	dbw 10 , 350 ; TANGELA    ; 114
	dbw 22 , 800 ; KANGASKHAN ; 115
	dbw 4 , 80 ; HORSEA     ; 116
	dbw 12 , 250 ; SEADRA     ; 117
	dbw 6 , 150 ; GOLDEEN    ; 118
	dbw 13 , 390 ; SEAKING    ; 119
	dbw 8 , 345 ; STARYU     ; 120
	dbw 11 , 800 ; STARMIE    ; 121
	dbw 13 , 545 ; MR_MIME    ; 122
	dbw 15 , 560 ; SCYTHER    ; 123
	dbw 14 , 406 ; JYNX       ; 124
	dbw 11 , 300 ; ELECTABUZZ ; 125
	dbw 13 , 445 ; MAGMAR     ; 126
	dbw 15 , 550 ; PINSIR     ; 127
	dbw 14 , 884 ; TAUROS     ; 128
	dbw 9 , 100 ; MAGIKARP   ; 129
	dbw 65 , 2350 ; GYARADOS   ; 130
	dbw 25 , 2200 ; LAPRAS     ; 131
	dbw 3 , 40 ; DITTO      ; 132
	dbw 3 , 65 ; EEVEE      ; 133
	dbw 10 , 290 ; VAPOREON   ; 134
	dbw 8 , 245 ; JOLTEON    ; 135
	dbw 9 , 250 ; FLAREON    ; 136
	dbw 8 , 365 ; PORYGON    ; 137
	dbw 4 , 75 ; OMANYTE    ; 138
	dbw 10 , 350 ; OMASTAR    ; 139
	dbw 5 , 115 ; KABUTO     ; 140
	dbw 13 , 405 ; KABUTOPS   ; 141
	dbw 18 , 590 ; AERODACTYL ; 142
	dbw 21 , 4600 ; SNORLAX    ; 143
	dbw 17 , 554 ; ARTICUNO   ; 144
	dbw 16 , 526 ; ZAPDOS     ; 145
	dbw 20 , 600 ; MOLTRES    ; 146
	dbw 18 , 33 ; DRATINI    ; 147
	dbw 40 , 165 ; DRAGONAIR  ; 148
	dbw 22 , 2100 ; DRAGONITE  ; 149
	dbw 20 , 1220 ; MEWTWO     ; 150
	dbw 4 , 40 ; MEW        ; 151