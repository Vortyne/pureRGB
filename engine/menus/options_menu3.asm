; PureRGBnote: ADDED: Accessed from your PC. This options page changes what areas are in the world. Currently only Volcano can be turned off/on.
DEF OPTIONS_PAGE_5_COUNT EQU 4 ; number of options on this page
DEF OPTIONS_PAGE_5_NUMBER EQU 5 ; must be 1 digit.

; format: "bit set" x position, "bit not set" x position, which bit it is, pointer to wram variable
Options3XPosBitData:
	db 15, 12, FLAG_LEARNSETS_DISABLED % 8
	dw wEventFlags + (FLAG_LEARNSETS_DISABLED / 8)
	db 14, 11, BIT_SKIP_INTRO
	dw wSpriteOptions2
	db 14, 11, FLAG_FLASHING_REDUCED % 8
	dw wEventFlags + (FLAG_FLASHING_REDUCED / 8)
	db 15, 11, FLAG_IMPERIAL_METRIC % 8
	dw wEventFlags + (FLAG_IMPERIAL_METRIC / 8)


OptionsMenu3Header:
	dw DrawOptionsMenu3
	dw Options3SetCursorPositionActions
	dw SetOptions3FromCursorPositions
	dw Options3LeftRightFuncs
	dw DisplayOptionMenu
	dw DisplaySpriteOptions
	dw OptionsPageAorSelectButtonDefault
	dw Options3InfoTextJumpTable
	; fall through
DisplayOptions3:
	ld hl, OptionsMenu3Header
	ld bc, OptionsMenu3Data
	jp DisplayOptionMenuCommon

; first byte = y coord
; second byte = which option on the page it is (cancel always = max option value)
Options3CoordOffsetList:
	db 3, 0
	db 5, 1
	db 7, 2
	db 9, 3
	db PAGE_CONTROLS_Y_COORD, MAX_OPTIONS_PER_PAGE

OptionsMenu3Data:
	db OPTIONS_PAGE_5_COUNT ; length of list
	db OPTIONS_PAGE_5_NUMBER ; current page
	db HOW_MANY_MAIN_OPTIONS_PAGES ; how many pages in total
	dw Options3CoordOffsetList

Options3SetCursorPositionActions:
	dw SetCursorPositionFromOptions3
	dw SetCursorPositionFromOptions3
	dw SetCursorPositionFromOptions3
	dw SetCursorPositionFromOptions3

OptionsMenu3Text:
	db   "OPTIONS 3"
	next " LEARNSETS: ON OFF"
	next " INTRO:    ON SKIP"
	next " FLASHING: OG LESS"
	next " UNITS:    IMP MET@"

DrawOptionsMenu3:
	hlcoord 0, 0
	lb bc, 15, 18
	call TextBoxBorder
	hlcoord 1, 1
	ld de, OptionsMenu3Text
	jp PlaceString

Options3LeftRightFuncs:
	dw Options3CursorToggleFunc15
	dw Options3CursorToggleFunc14
	dw Options3CursorToggleFunc14
	dw Options3CursorToggleFunc15b
	dw CursorCancelRow

Options3CursorToggleFunc14:
	ld b, %101
	jp GenericOptionsCursorToggleFunc

Options3CursorToggleFunc15:
	ld b, %11
	jp GenericOptionsCursorToggleFunc

Options3CursorToggleFunc15b:
	ld b, %100
	jp GenericOptionsCursorToggleFunc

SetOptions3FromCursorPositions:
	ld de, wOptions1CursorX
	ld hl, Options3XPosBitData
	ld b, OPTIONS_PAGE_5_COUNT
	jp LoopGenericSetOptionsFromCursorPositions

SetCursorPositionFromOptions3:
	ld hl, Options3XPosBitData
	jp SetGenericCursorPositionFromOptions


Options3InfoTextJumpTable:
	dw LearnsetsInfoText
	dw IntroInfoText
	dw FlashingInfoText
	dw UnitsInfoText

LearnsetsInfoText:
	text_far _LearnsetsInfoText
	text_end

IntroInfoText:
	text_far _IntroInfoText
	text_end

FlashingInfoText:
	text_far _FlashingInfoText
	text_end

UnitsInfoText:
	text_far _UnitsInfoText
	text_end
