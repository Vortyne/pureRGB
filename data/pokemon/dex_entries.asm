DEF DEX_ENTRY_SIZE EQU 9 ; 9 bytes per dex entry

; PureRGBnote: CHANGED: separated out the pokemon categories, which means the dex entries become a fixed size. 
; This means there is no need for a jump table, saving a lot of space.
GetDexEntryData:
	ld a, [wPokedexNum]
	dec a
	ld hl, DexEntryData
	ld b, 0
	ld c, a
	ld d, DEX_ENTRY_SIZE
.loopFindDexEntry
	add hl, bc
	dec d
	jr nz, .loopFindDexEntry
	ld d, h
	ld e, l
	ret

; \1 = height in feet, \2 = inches
; \3 = weight in tenths of a pound
; \4 = pokemon text description label
MACRO dex_entry
	db \1, \2
	dw \3
	text_far \4
	text_end
ENDM

DexEntryData:
	table_width DEX_ENTRY_SIZE
	dex_entry  2,  4,   150, _BulbasaurDexEntry  ; DEX_BULBASAUR  ; 1
	dex_entry  3,  3,   290, _IvysaurDexEntry    ; DEX_IVYSAUR    ; 2
	dex_entry  6,  7,  2210, _VenusaurDexEntry   ; DEX_VENUSAUR   ; 3
	dex_entry  2,  0,   190, _CharmanderDexEntry ; DEX_CHARMANDER ; 4
	dex_entry  3,  7,   420, _CharmeleonDexEntry ; DEX_CHARMELEON ; 5
	dex_entry  5,  7,  2000, _CharizardDexEntry  ; DEX_CHARIZARD  ; 6
	dex_entry  1,  8,   200, _SquirtleDexEntry   ; DEX_SQUIRTLE   ; 7
	dex_entry  3,  3,   500, _WartortleDexEntry  ; DEX_WARTORTLE  ; 8
	dex_entry  5,  3,  1890, _BlastoiseDexEntry  ; DEX_BLASTOISE  ; 9
	dex_entry  1,  0,    60, _CaterpieDexEntry   ; DEX_CATERPIE   ; 10
	dex_entry  2,  4,   220, _MetapodDexEntry    ; DEX_METAPOD    ; 11
	dex_entry  3,  7,   710, _ButterfreeDexEntry ; DEX_BUTTERFREE ; 12
	dex_entry  1,  0,    70, _WeedleDexEntry     ; DEX_WEEDLE     ; 13
	dex_entry  2,  0,   220, _KakunaDexEntry     ; DEX_KAKUNA     ; 14
	dex_entry  3,  3,   650, _BeedrillDexEntry   ; DEX_BEEDRILL   ; 15
	dex_entry  1,  0,    40, _PidgeyDexEntry     ; DEX_PIDGEY     ; 16
	dex_entry  3,  7,   660, _PidgeottoDexEntry  ; DEX_PIDGEOTTO  ; 17
	dex_entry  4, 11,   870, _PidgeotDexEntry    ; DEX_PIDGEOT    ; 18
	dex_entry  1,  0,    80, _RattataDexEntry    ; DEX_RATTATA    ; 19
	dex_entry  2,  4,   410, _RaticateDexEntry   ; DEX_RATICATE   ; 20
	dex_entry  1,  0,    40, _SpearowDexEntry    ; DEX_SPEAROW    ; 21
	dex_entry  3, 11,   840, _FearowDexEntry     ; DEX_FEAROW     ; 22
	dex_entry  6,  7,   150, _EkansDexEntry      ; DEX_EKANS      ; 23
	dex_entry 11,  6,  1430, _ArbokDexEntry      ; DEX_ARBOK      ; 24
	dex_entry  1,  4,   130, _PikachuDexEntry    ; DEX_PIKACHU    ; 25
	dex_entry  2,  7,   660, _RaichuDexEntry     ; DEX_RAICHU     ; 26
	dex_entry  2,  0,   260, _SandshrewDexEntry  ; DEX_SANDSHREW  ; 27
	dex_entry  3,  3,   650, _SandslashDexEntry  ; DEX_SANDSLASH  ; 28
	dex_entry  1,  4,   150, _NidoranFDexEntry   ; DEX_NIDORAN_F  ; 29
	dex_entry  2,  7,   440, _NidorinaDexEntry   ; DEX_NIDORINA   ; 30
	dex_entry  4,  3,  1320, _NidoqueenDexEntry  ; DEX_NIDOQUEEN  ; 31
	dex_entry  1,  8,   200, _NidoranMDexEntry   ; DEX_NIDORAN_M  ; 32
	dex_entry  2, 11,   430, _NidorinoDexEntry   ; DEX_NIDORINO   ; 33
	dex_entry  4,  7,  1370, _NidokingDexEntry   ; DEX_NIDOKING   ; 34
	dex_entry  2,  0,   170, _ClefairyDexEntry   ; DEX_CLEFAIRY   ; 35
	dex_entry  4,  3,   880, _ClefableDexEntry   ; DEX_CLEFABLE   ; 36
	dex_entry  2,  0,   220, _VulpixDexEntry     ; DEX_VULPIX     ; 37
	dex_entry  3,  7,   440, _NinetalesDexEntry  ; DEX_NINETALES  ; 38
	dex_entry  1,  8,   120, _JigglypuffDexEntry ; DEX_JIGGLYPUFF ; 39
	dex_entry  3,  3,   260, _WigglytuffDexEntry ; DEX_WIGGLYTUFF ; 40
	dex_entry  2,  7,   170, _ZubatDexEntry      ; DEX_ZUBAT      ; 41
	dex_entry  5,  3,  1210, _GolbatDexEntry     ; DEX_GOLBAT     ; 42
	dex_entry  1,  8,   120, _OddishDexEntry     ; DEX_ODDISH     ; 43
	dex_entry  2,  7,   190, _GloomDexEntry      ; DEX_GLOOM      ; 44
	dex_entry  3, 11,   410, _VileplumeDexEntry  ; DEX_VILEPLUME  ; 45
	dex_entry  1,  0,   120, _ParasDexEntry      ; DEX_PARAS      ; 46
	dex_entry  3,  3,   650, _ParasectDexEntry   ; DEX_PARASECT   ; 47
	dex_entry  3,  3,   660, _VenonatDexEntry    ; DEX_VENONAT    ; 48
	dex_entry  4, 11,   280, _VenomothDexEntry   ; DEX_VENOMOTH   ; 49
	dex_entry  0,  8,    20, _DiglettDexEntry    ; DEX_DIGLETT    ; 50
	dex_entry  2,  4,   730, _DugtrioDexEntry    ; DEX_DUGTRIO    ; 51
	dex_entry  1,  4,    90, _MeowthDexEntry     ; DEX_MEOWTH     ; 52
	dex_entry  3,  3,   710, _PersianDexEntry    ; DEX_PERSIAN    ; 53
	dex_entry  2,  7,   430, _PsyduckDexEntry    ; DEX_PSYDUCK    ; 54
	dex_entry  5,  7,  1690, _GolduckDexEntry    ; DEX_GOLDUCK    ; 55
	dex_entry  1,  8,   620, _MankeyDexEntry     ; DEX_MANKEY     ; 56
	dex_entry  3,  3,   710, _PrimeapeDexEntry   ; DEX_PRIMEAPE   ; 57
	dex_entry  2,  4,   420, _GrowlitheDexEntry  ; DEX_GROWLITHE  ; 58
	dex_entry  6,  3,  3420, _ArcanineDexEntry   ; DEX_ARCANINE   ; 59
	dex_entry  2,  0,   270, _PoliwagDexEntry    ; DEX_POLIWAG    ; 60
	dex_entry  3,  3,   440, _PoliwhirlDexEntry  ; DEX_POLIWHIRL  ; 61
	dex_entry  4,  3,  1190, _PoliwrathDexEntry  ; DEX_POLIWRATH  ; 62
	dex_entry  2, 11,   430, _AbraDexEntry       ; DEX_ABRA       ; 63
	dex_entry  4,  3,  1250, _KadabraDexEntry    ; DEX_KADABRA    ; 64
	dex_entry  4, 11,  1060, _AlakazamDexEntry   ; DEX_ALAKAZAM   ; 65
	dex_entry  2,  7,   430, _MachopDexEntry     ; DEX_MACHOP     ; 66
	dex_entry  4, 11,  1550, _MachokeDexEntry    ; DEX_MACHOKE    ; 67
	dex_entry  5,  3,  2870, _MachampDexEntry    ; DEX_MACHAMP    ; 68
	dex_entry  2,  4,    90, _BellsproutDexEntry ; DEX_BELLSPROUT ; 69
	dex_entry  3,  3,   140, _WeepinbellDexEntry ; DEX_WEEPINBELL ; 70
	dex_entry  5,  7,   340, _VictreebelDexEntry ; DEX_VICTREEBEL ; 71
	dex_entry  2, 11,  1000, _TentacoolDexEntry  ; DEX_TENTACOOL  ; 72
	dex_entry  5,  3,  1210, _TentacruelDexEntry ; DEX_TENTACRUEL ; 73
	dex_entry  1,  4,   440, _GeodudeDexEntry    ; DEX_GEODUDE    ; 74
	dex_entry  3,  3,  2320, _GravelerDexEntry   ; DEX_GRAVELER   ; 75
	dex_entry  3,  7,  6620, _GolemDexEntry      ; DEX_GOLEM      ; 76
	dex_entry  3,  3,   660, _PonytaDexEntry     ; DEX_PONYTA     ; 77
	dex_entry  5,  7,  2090, _RapidashDexEntry   ; DEX_RAPIDASH   ; 78
	dex_entry  3, 11,   790, _SlowpokeDexEntry   ; DEX_SLOWPOKE   ; 79
	dex_entry  5,  3,  1730, _SlowbroDexEntry    ; DEX_SLOWBRO    ; 80
	dex_entry  1,  0,   130, _MagnemiteDexEntry  ; DEX_MAGNEMITE  ; 81
	dex_entry  3,  3,  1320, _MagnetonDexEntry   ; DEX_MAGNETON   ; 82
	dex_entry  2,  7,   330, _FarfetchdDexEntry  ; DEX_FARFETCHD  ; 83
	dex_entry  4,  7,   860, _DoduoDexEntry      ; DEX_DODUO      ; 84
	dex_entry  5, 11,  1880, _DodrioDexEntry     ; DEX_DODRIO     ; 85
	dex_entry  3,  7,  1980, _SeelDexEntry       ; DEX_SEEL       ; 86
	dex_entry  5,  7,  2650, _DewgongDexEntry    ; DEX_DEWGONG    ; 87
	dex_entry  2, 11,   660, _GrimerDexEntry     ; DEX_GRIMER     ; 88
	dex_entry  3, 11,   660, _MukDexEntry        ; DEX_MUK        ; 89
	dex_entry  1,  0,    90, _ShellderDexEntry   ; DEX_SHELLDER   ; 90
	dex_entry  4, 11,  2920, _CloysterDexEntry   ; DEX_CLOYSTER   ; 91
	dex_entry  4,  3,     2, _GastlyDexEntry     ; DEX_GASTLY     ; 92
	dex_entry  5,  3,     2, _HaunterDexEntry    ; DEX_HAUNTER    ; 93
	dex_entry  4, 11,   890, _GengarDexEntry     ; DEX_GENGAR     ; 94
	dex_entry 28, 10,  4630, _OnixDexEntry       ; DEX_ONIX       ; 95
	dex_entry  3,  3,   710, _DrowzeeDexEntry    ; DEX_DROWZEE    ; 96
	dex_entry  5,  3,  1670, _HypnoDexEntry      ; DEX_HYPNO      ; 97
	dex_entry  1,  4,   140, _KrabbyDexEntry     ; DEX_KRABBY     ; 98
	dex_entry  4,  3,  1320, _KinglerDexEntry    ; DEX_KINGLER    ; 99
	dex_entry  1,  8,   230, _VoltorbDexEntry    ; DEX_VOLTORB    ; 100
	dex_entry  3, 11,  1470, _ElectrodeDexEntry  ; DEX_ELECTRODE  ; 101
	dex_entry  1,  4,    60, _ExeggcuteDexEntry  ; DEX_EXEGGCUTE  ; 102
	dex_entry  6,  7,  2650, _ExeggutorDexEntry  ; DEX_EXEGGUTOR  ; 103
	dex_entry  1,  4,   140, _CuboneDexEntry     ; DEX_CUBONE     ; 104
	dex_entry  3,  3,   990, _MarowakDexEntry    ; DEX_MAROWAK    ; 105
	dex_entry  4, 11,  1100, _HitmonleeDexEntry  ; DEX_HITMONLEE  ; 106
	dex_entry  4,  7,  1110, _HitmonchanDexEntry ; DEX_HITMONCHAN ; 107
	dex_entry  3, 11,  1440, _LickitungDexEntry  ; DEX_LICKITUNG  ; 108
	dex_entry  2,  0,    20, _KoffingDexEntry    ; DEX_KOFFING    ; 109
	dex_entry  3, 11,   210, _WeezingDexEntry    ; DEX_WEEZING    ; 110
	dex_entry  3,  3,  2540, _RhyhornDexEntry    ; DEX_RHYHORN    ; 111
	dex_entry  6,  3,  2650, _RhydonDexEntry     ; DEX_RHYDON     ; 112
	dex_entry  3,  7,   760, _ChanseyDexEntry    ; DEX_CHANSEY    ; 113
	dex_entry  3,  3,   770, _TangelaDexEntry    ; DEX_TANGELA    ; 114
	dex_entry  7,  3,  1760, _KangaskhanDexEntry ; DEX_KANGASKHAN ; 115
	dex_entry  1,  4,   180, _HorseaDexEntry     ; DEX_HORSEA     ; 116
	dex_entry  3, 11,   550, _SeadraDexEntry     ; DEX_SEADRA     ; 117
	dex_entry  2,  0,   330, _GoldeenDexEntry    ; DEX_GOLDEEN    ; 118
	dex_entry  4,  3,   860, _SeakingDexEntry    ; DEX_SEAKING    ; 119
	dex_entry  2,  7,   760, _StaryuDexEntry     ; DEX_STARYU     ; 120
	dex_entry  3,  7,  1760, _StarmieDexEntry    ; DEX_STARMIE    ; 121
	dex_entry  4,  3,  1200, _MrMimeDexEntry     ; DEX_MR_MIME    ; 122
	dex_entry  4, 11,  1230, _ScytherDexEntry    ; DEX_SCYTHER    ; 123
	dex_entry  4,  7,   900, _JynxDexEntry       ; DEX_JYNX       ; 124
	dex_entry  3,  7,   660, _ElectabuzzDexEntry ; DEX_ELECTABUZZ ; 125
	dex_entry  4,  3,   980, _MagmarDexEntry     ; DEX_MAGMAR     ; 126
	dex_entry  4, 11,  1210, _PinsirDexEntry     ; DEX_PINSIR     ; 127
	dex_entry  4,  7,  1950, _TaurosDexEntry     ; DEX_TAUROS     ; 128
	dex_entry  2, 11,   220, _MagikarpDexEntry   ; DEX_MAGIKARP   ; 129
	dex_entry 21,  4,  5180, _GyaradosDexEntry   ; DEX_GYARADOS   ; 130
	dex_entry  8,  2,  4850, _LaprasDexEntry     ; DEX_LAPRAS     ; 131
	dex_entry  1,  0,    90, _DittoDexEntry      ; DEX_DITTO      ; 132
	dex_entry  1,  0,   140, _EeveeDexEntry      ; DEX_EEVEE      ; 133
	dex_entry  3,  3,   640, _VaporeonDexEntry   ; DEX_VAPOREON   ; 134
	dex_entry  2,  7,   540, _JolteonDexEntry    ; DEX_JOLTEON    ; 135
	dex_entry  2, 11,   550, _FlareonDexEntry    ; DEX_FLAREON    ; 136
	dex_entry  2,  7,   800, _PorygonDexEntry    ; DEX_PORYGON    ; 137
	dex_entry  1,  4,   170, _OmanyteDexEntry    ; DEX_OMANYTE    ; 138
	dex_entry  3,  3,   770, _OmastarDexEntry    ; DEX_OMASTAR    ; 139
	dex_entry  1,  8,   250, _KabutoDexEntry     ; DEX_KABUTO     ; 140
	dex_entry  4,  3,   890, _KabutopsDexEntry   ; DEX_KABUTOPS   ; 141
	dex_entry  5, 11,  1300, _AerodactylDexEntry ; DEX_AERODACTYL ; 142
	dex_entry  6, 11, 10140, _SnorlaxDexEntry    ; DEX_SNORLAX    ; 143
	dex_entry  5,  7,  1220, _ArticunoDexEntry   ; DEX_ARTICUNO   ; 144
	dex_entry  5,  3,  1160, _ZapdosDexEntry     ; DEX_ZAPDOS     ; 145
	dex_entry  6,  7,  1320, _MoltresDexEntry    ; DEX_MOLTRES    ; 146
	dex_entry  5, 11,    60, _DratiniDexEntry    ; DEX_DRATINI    ; 147
	dex_entry 13,  1,   360, _DragonairDexEntry  ; DEX_DRAGONAIR  ; 148
	dex_entry  7,  3,  4630, _DragoniteDexEntry  ; DEX_DRAGONITE  ; 149
	dex_entry  6,  7,  2690, _MewtwoDexEntry     ; DEX_MEWTWO     ; 150
	dex_entry  1,  4,    90, _MewDexEntry        ; DEX_MEW        ; 151
	assert_table_length NUM_POKEMON - 1

;MissingNoDexEntry:
;	db "???@"
;	db 10 ; 1.0 m
;	dw 100 ; 10.0 kg
;	db "コメント　さくせいちゅう@" ; コメント作成中 (Comment to be written)

