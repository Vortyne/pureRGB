; PureRGBnote: CHANGED: different in-game trades
MACRO npctrade
; give mon, get mon, dialog id, nickname
	db \1, \2, \3
	dname \4, NAME_LENGTH
ENDM

TradeMons:
; entries correspond to TRADE_FOR_* constants
	table_width 3 + NAME_LENGTH
	; post-trade text. English Yellow changed _AfterTrade2Text to
	; not mention evolution.
	npctrade ODDISH,     PONYTA,    TRADE_DIALOGSET_CASUAL, "Seabiscuit" ; route 11
	npctrade DROWZEE,    GRIMER,    TRADE_DIALOGSET_CASUAL, "Goopinator" ; route 2
	npctrade ALAKAZAM,   MAGNETON,  TRADE_DIALOGSET_SPROCKET, "SPROCKET" ; cerulean city rocket house basement
	npctrade PONYTA,     MACHOP,    TRADE_DIALOGSET_CASUAL_COLOR, "HulkSmash" ; cinnabar lab
	npctrade ONIX,       GASTLY,    TRADE_DIALOGSET_HAPPY,  "Nebula" ; vermilion city
	npctrade TAUROS,     LICKITUNG, TRADE_DIALOGSET_CASUAL_COLOR, "Saliva" ; route 18 
	npctrade PIDGEOTTO,  SEEL,      TRADE_DIALOGSET_EVOLUTION, "Slappy" ; cerulean city
	npctrade KRABBY,     ZUBAT,     TRADE_DIALOGSET_EVOLUTION_COLOR, "EmeraldSDB" ; cinnabar lab
	npctrade LAPRAS,     SNORLAX,   TRADE_DIALOGSET_HAPPY_COLOR,  "Fatso" ; cinnabar lab 
	npctrade VOLTORB,    TANGELA,   TRADE_DIALOGSET_HAPPY,  "Discombob" ; route 5
	assert_table_length NUM_NPC_TRADES

; PureRGBnote: ADDED: some received pokemon use alternate color palettes if the feature is enabled
TradeMonFlags:
	table_width 1
	db BALL_DATA_POKE << 3 | FALSE ; PONYTA route 11
	db BALL_DATA_GREAT << 3 | FALSE ; GRIMER route 2
	db BALL_DATA_MASTER << 3 | TRUE ; MAGNETON rocket basement
	db BALL_DATA_SAFARI << 3 | TRUE ; MACHOP cinnabar lab
	db BALL_DATA_ULTRA << 3 | FALSE ; GASTLY vermilion city
	db BALL_DATA_ULTRA << 3 | TRUE ; LICKITUNG route 18
	db BALL_DATA_GREAT << 3 | FALSE ; SEEL cerulean city
	db BALL_DATA_HYPER << 3 | TRUE ; ZUBAT cinnabar lab
	db BALL_DATA_ULTRA << 3 | TRUE ; SNORLAX cinnabar lab
	db BALL_DATA_ULTRA << 3 | FALSE ; TANGELA route 5
