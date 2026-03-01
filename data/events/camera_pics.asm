MACRO dbits
	db \1 << 7 | \2 << 6 | \3 << 5 | \4 << 4 | \5 << 3 | \6 << 2 | \7 << 1 | \8
ENDM

DEF CUSTOM_BALL_PALETTE_DATA_LENGTH EQU 37

; Order of these matters
CustomPokeballCameraPicPalettes:
PokemonBreederMainPalette:
	RGB 27,31,18, 13,22,27, 00,18,00, 00,09,00
PokemonBreederSecondaryPalette:
	RGB 27,31,18, 22,21,05, 00,18,00, 00,09,00
PokemonBreederTertiaryPalette:
	RGB 27,31,18, 13,22,27, 26,08,00, 00,09,00

PokemonBreederCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 1, 0, 0
	dbits 0, 0, 0, 0, 0, 1, 0, 0
	dbits 0, 0, 0, 0, 1, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

PokemonBreederCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 1, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 1, 0, 1, 0, 0, 0, 0
	dbits 0, 1, 0, 0, 0, 0, 0, 0

	db PAL_TOWNMAP ; SGB Palette

PsyduckCameraPicMainPalette:
	RGB 31,31,09, 14,25,04, 00,14,13, 06,07,04
PsyduckCameraPicSecondaryPalette:
	RGB 31,31,09, 14,25,04, 27,18,00, 06,07,04
PsyduckCameraPicTertiaryPalette:
	RGB 31,31,09, 27,18,00, 13,09,04, 00,00,04

PsyduckCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 1, 0, 0, 0, 0, 0
	dbits 1, 1, 0, 0, 1, 0, 0, 0
	dbits 1, 1, 0, 0, 1, 0, 0, 0
	dbits 0, 0, 1, 1, 0, 1, 0, 0
	dbits 0, 0, 0, 1, 1, 1, 0, 0

PsyduckCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 1, 0, 0, 0, 0
	dbits 0, 0, 1, 1, 0, 0, 0, 0
	dbits 0, 0, 1, 1, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 1, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_YELLOWMON ; SGB Palette

FlareonCameraPicMainPalette:
	RGB 31,27,04, 31,13,04, 27,00,04, 00,00,09
FlareonCameraPicSecondaryPalette:
	RGB 31,27,04, 13,31,04, 00,27,04, 00,00,09
FlareonCameraPicTertiaryPalette:
	RGB 31,27,04, 04,13,31, 31,13,04, 00,00,09

FlareonCameraPicSecondaryPaletteBitmap:
	dbits 1, 1, 1, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0

FlareonCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 1, 1, 0, 0, 1
	dbits 0, 0, 1, 1, 1, 0, 1, 1

	db PAL_REDBAR ; SGB Palette

JigglypuffCameraPicMainPalette:
	RGB 31,29,05, 31,08,13, 02,21,07, 10,02,06
JigglypuffCameraPicSecondaryPalette:
	RGB 31,31,31, 31,08,13, 02,21,07, 10,02,06
JigglypuffCameraPicTertiaryPalette:
	RGB 31,31,31, 31,08,13, 02,21,07, 10,02,06 ; TODO: unused palette

JigglypuffCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 1, 1, 1, 1, 0
	dbits 0, 0, 0, 1, 1, 1, 1, 0
	dbits 0, 0, 0, 1, 1, 1, 1, 0
	dbits 0, 0, 0, 0, 1, 1, 0, 0
	dbits 1, 1, 1, 0, 0, 0, 0, 0

JigglypuffCameraPicTertiaryPaletteBitmap: ; TODO: unused palette
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_PINKMON ; SGB Palette

JolteonCameraPicMainPalette:
	RGB 31,31,31, 28,26,00, 26,14,01, 00,00,00
JolteonCameraPicSecondaryPalette:
	RGB 31,31,31, 28,26,00, 09,02,16, 00,00,00
JolteonCameraPicTertiaryPalette:
	RGB 31,31,31, 17,14,31, 09,02,16, 00,00,00

JolteonCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 1, 1, 1, 0, 0, 0
	dbits 0, 0, 1, 0, 0, 0, 1, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

JolteonCameraPicTertiaryPaletteBitmap:
	dbits 1, 1, 0, 0, 0, 1, 1, 1
	dbits 1, 1, 0, 0, 0, 0, 0, 1
	dbits 1, 1, 0, 0, 0, 0, 1, 1
	dbits 1, 1, 0, 0, 0, 0, 1, 1
	dbits 1, 1, 0, 0, 0, 1, 1, 1
	dbits 1, 1, 1, 0, 0, 1, 1, 1 

	db PAL_YELLOWMON ; SGB Palette

PorygonCameraPicMainPalette:
	RGB 31,31,31, 31,18,27, 31,04,09, 04,00,09
PorygonCameraPicSecondaryPalette:
	RGB 31,31,31, 12,28,15, 31,04,09, 04,00,09
PorygonCameraPicTertiaryPalette:
	RGB 31,31,31, 12,28,15, 03,15,19, 04,00,09

PorygonCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 1, 0, 0, 0
	dbits 0, 0, 1, 0, 1, 0, 0, 0
	dbits 0, 0, 0, 1, 0, 1, 0, 0
	dbits 0, 0, 0, 0, 1, 1, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

PorygonCameraPicTertiaryPaletteBitmap:
	dbits 1, 1, 1, 1, 1, 1, 1, 1
	dbits 1, 1, 1, 1, 0, 1, 1, 1
	dbits 1, 1, 0, 0, 0, 1, 1, 1
	dbits 1, 1, 1, 0, 0, 0, 1, 1
	dbits 1, 1, 1, 1, 0, 0, 1, 1
	dbits 1, 1, 1, 1, 1, 1, 1, 1

	db PAL_PINKMON ; SGB Palette

FossilCameraPicMainPalette:
	RGB 31,27,22, 27,13,09, 13,04,00, 04,00,00
FossilCameraPicSecondaryPalette:
	RGB 31,27,22, 15,22,09, 12,07,00, 04,00,00
FossilCameraPicTertiaryPalette:
	RGB 31,27,22, 19,13,21, 10,02,09, 04,00,00

FossilCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 1, 0, 0
	dbits 0, 0, 0, 0, 1, 1, 1, 1
	dbits 0, 0, 0, 0, 1, 1, 0, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

FossilCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 1, 1, 1
	dbits 0, 0, 0, 0, 1, 1, 1, 1
	dbits 0, 0, 0, 0, 1, 1, 1, 0

	db PAL_BROWNMON ; SGB Palette

ArticunoCameraPicMainPalette:
	RGB 27,31,31, 13,22,31, 04,13,22, 00,04,04
ArticunoCameraPicSecondaryPalette:
	RGB 27,31,31, 31,00,00, 04,13,22, 00,04,04
ArticunoCameraPicTertiaryPalette:
	RGB 27,31,31, 13,22,31, 04,13,22, 00,04,04 ; TODO: unused palette

ArticunoCameraPicCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 1, 1, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

ArticunoCameraPicCameraPicTertiaryPaletteBitmap: ; TODO: unused palette
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_CYANMON ; SGB Palette

AbraCameraPicMainPalette:
	RGB 31,31,18, 31,18,04, 27,09,04, 04,00,00
AbraCameraPicSecondaryPalette:
	RGB 31,31,18, 27,09,04, 05,02,24, 04,00,00
AbraCameraPicTertiaryPalette:
	RGB 31,31,18, 00,15,31, 05,02,24, 04,00,00

AbraCameraPicCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 1, 0, 0, 0
	dbits 0, 0, 0, 0, 1, 0, 0, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

AbraCameraPicCameraPicTertiaryPaletteBitmap:
	dbits 1, 1, 1, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 0, 0, 0, 0, 1
	dbits 1, 1, 0, 0, 0, 0, 0, 0
	dbits 1, 1, 0, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0

	db PAL_REDMON ; SGB Palette

PidgeotCameraPicMainPalette:
	RGB 29,31,23, 31,27,04, 22,09,04, 00,00,06
PidgeotCameraPicSecondaryPalette:
	RGB 29,31,23, 05,19,02, 02,09,00, 00,00,06
PidgeotCameraPicTertiaryPalette:
	RGB 29,31,23, 05,14,24, 02,01,18, 00,00,06

PidgeotCameraPicSecondaryPaletteBitmap:
	dbits 1, 1, 1, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 1, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

PidgeotCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0
	dbits 1, 1, 0, 0, 0, 0, 1, 1
	dbits 1, 1, 0, 0, 0, 1, 1, 1

	db PAL_REDBAR ; SGB Palette

GrimerCameraPicMainPalette:
	RGB 31,31,31, 24,15,31, 16,00,21, 00,00,00
GrimerCameraPicSecondaryPalette:
	RGB 31,31,31, 21,21,21, 10,10,10, 00,00,00
GrimerCameraPicTertiaryPalette:
	RGB 31,31,31, 26,24,11, 00,13,03, 00,00,00

GrimerCameraPicCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 1, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

GrimerCameraPicCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 1, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_PURPLEMON ; SGB Palette

GastlyCameraPicMainPalette:
	RGB 31,31,31, 25,10,29, 12,07,16, 00,00,00
GastlyCameraPicSecondaryPalette:
	RGB 31,31,31, 25,10,29, 12,07,16, 00,00,00 ; TODO: unused palette
GastlyCameraPicTertiaryPalette:
	RGB 31,31,31, 25,10,29, 12,07,16, 00,00,00 ; TODO: unused palette

GastlyCameraPicCameraPicSecondaryPaletteBitmap: ; TODO: unused palette
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

GastlyCameraPicCameraPicTertiaryPaletteBitmap: ; TODO: unused palette
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_PURPLEMON ; SGB Palette

ScytherCameraPicMainPalette:
	RGB 31,31,31, 07,31,31, 02,18,00, 00,08,00
ScytherCameraPicSecondaryPalette:
	RGB 07,31,31, 11,31,00, 02,18,00, 00,08,00
ScytherCameraPicTertiaryPalette:
	RGB 31,31,31, 11,31,00, 02,18,00, 00,08,00

ScytherCameraPicCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 1, 1, 0, 0, 0
	dbits 1, 0, 1, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 1, 1, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0

ScytherCameraPicCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 1, 1, 1, 1, 1

	db PAL_GREENMON ; SGB Palette

LassCameraPicMainPalette:
	RGB 31,31,22, 30,18,02, 24,04,00, 00,00,00
LassCameraPicSecondaryPalette:
	RGB 16,00,31, 30,18,02, 24,04,00, 00,00,00
LassCameraPicTertiaryPalette:
	RGB 31,31,22, 30,18,02, 30,00,20, 00,00,00

LassCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 1
	dbits 0, 0, 0, 0, 0, 1, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 1, 1
	dbits 0, 0, 0, 0, 0, 0, 0, 0

LassCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 1, 0, 0, 0, 0
	dbits 1, 1, 1, 1, 1, 0, 0, 0
	dbits 1, 1, 1, 0, 0, 0, 0, 0
	dbits 1, 1, 1, 0, 0, 0, 0, 0

	db PAL_REDMON ; SGB Palette

MankeyCameraPicMainPalette:
	RGB 31,31,22, 31,22,04, 22,09,00, 04,00,00
MankeyCameraPicSecondaryPalette:
	RGB 31,31,22, 19,20,00, 01,17,00, 04,00,00
MankeyCameraPicTertiaryPalette:
	RGB 31,31,22, 19,20,00, 01,17,00, 04,00,00 ; TODO: unused palette

MankeyCameraPicSecondaryPaletteBitmap:
	dbits 1, 1, 1, 1, 1, 1, 1, 1
	dbits 1, 0, 1, 0, 0, 0, 0, 1
	dbits 1, 1, 0, 0, 0, 0, 0, 1
	dbits 1, 1, 0, 0, 0, 0, 0, 1
	dbits 1, 1, 1, 0, 0, 1, 1, 1
	dbits 1, 1, 1, 1, 1, 1, 1, 1

MankeyCameraPicTertiaryPaletteBitmap: ; TODO: unused palette
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_BROWNMON ; SGB Palette

GamblerCameraPicMainPalette:
	RGB 29,29,26, 24,23,14, 00,09,00, 00,00,00
GamblerCameraPicSecondaryPalette:
	RGB 29,29,26, 24,23,14, 11,11,09, 00,00,00
GamblerCameraPicTertiaryPalette:
	RGB 29,29,26, 24,23,14, 31,05,00, 00,00,00

GamblerCameraPicSecondaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 1, 0, 0, 0, 0, 0
	dbits 0, 0, 1, 1, 1, 0, 1, 0
	dbits 0, 0, 0, 0, 0, 1, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

GamblerCameraPicTertiaryPaletteBitmap:
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 1, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_MEWMON ; SGB Palette

DragonairCameraPicMainPalette:
	RGB 31,31,31, 09,22,31, 04,09,18, 00,00,04
DragonairCameraPicSecondaryPalette:
	RGB 31,23,16, 21,06,15, 04,09,18, 00,00,04
DragonairCameraPicTertiaryPalette:
	RGB 31,23,16, 21,06,15, 04,09,18, 00,00,04 ; TODO: unused palette

DragonairCameraPicCameraPicSecondaryPaletteBitmap:
	dbits 1, 1, 0, 1, 1, 0, 0, 0
	dbits 1, 1, 0, 1, 0, 0, 0, 0
	dbits 1, 1, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 1, 0, 0, 1, 0, 0, 0, 0

DragonairCameraPicCameraPicTertiaryPaletteBitmap: ; TODO: unused palette
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0
	dbits 0, 0, 0, 0, 0, 0, 0, 0

	db PAL_0F ; SGB Palette
