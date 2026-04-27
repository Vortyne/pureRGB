ViridianSchoolHouse_Script:
	jp EnableAutoTextBoxDrawing

ViridianSchoolHouse_TextPointers:
	def_text_pointers
	dw_const ViridianSchoolHouseBrunetteGirlText, TEXT_VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	dw_const ViridianSchoolHouseCooltrainerFText, TEXT_VIRIDIANSCHOOLHOUSE_COOLTRAINER_F
	dw_const SchoolText3,                         TEXT_VIRIDIANSCHOOLHOUSE_ROCKER
	dw_const SchoolText4,                         TEXT_VIRIDIANSCHOOLHOUSE_DETENTION_SIGN
	dw_const ViridianSchoolNotebook,              TEXT_VIRIDIANSCHOOLHOUSE_NOTEBOOK
	dw_const ViridianSchoolBlackboard,            TEXT_VIRIDIANSCHOOLHOUSE_BLACKBOARD

ViridianSchoolHouseBrunetteGirlText:
	text_far _ViridianSchoolHouseBrunetteGirlText
	text_end

ViridianSchoolHouseCooltrainerFText:
	text_far _ViridianSchoolHouseCooltrainerFText
	text_end

SchoolText3:
	text_far _SchoolText3
	text_end

SchoolText4:
	text_far _SchoolText4
	text_end

ViridianSchoolNotebook::
	text_asm
	ld hl, ViridianSchoolNotebookText1
	rst _PrintText
	ld b, 0
	ld c, 3
.notebookLoop
	push bc
	ld hl, TurnPageText
	rst _PrintText
	call YesNoChoice
	pop bc
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookPages
	ld a, b
	push bc
	ld bc, 5
	call AddNTimes
	rst _PrintText
	pop bc
	inc b
	dec c
	jr nz, .notebookLoop
;;;;;;;;;; PureRGBnote: CHANGED: since someone else can be sitting in the chair based on event flags, this text need to be modified in that case
	CheckEvent EVENT_GUS_IN_DETENTION
	ld hl, ViridianSchoolNotebookText5
	jr z, .print
	ld hl, ViridianSchoolNotebookTextGus
;;;;;;;;;;
.print
	rst _PrintText
.doneReading
	jp TextScriptEndNoButtonPress

TurnPageText:
	text_far _TurnPageText
	text_end

ViridianSchoolNotebookText5:
	text_far _ViridianSchoolNotebookText5
	text_waitbutton
	text_end

ViridianSchoolNotebookTextGus:
	text_far _ViridianSchoolNotebookTextGus
	text_waitbutton
	text_end

ViridianSchoolNotebookText1:
	text_far _ViridianSchoolNotebookText1
	text_end
ViridianSchoolNotebookPages:
ViridianSchoolNotebookText2:
	text_far _ViridianSchoolNotebookText2
	text_end
ViridianSchoolNotebookText3:
	text_far _ViridianSchoolNotebookText3
	text_end
ViridianSchoolNotebookText4:
	text_far _ViridianSchoolNotebookText4
	text_end

ViridianSchoolBlackboard::
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, ViridianSchoolBlackboardText1
	rst _PrintText
	xor a
	ld [wMenuItemOffset], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_LEFT | PAD_RIGHT | PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 2
	ld [wMaxMenuItem], a
	call .loadDefaultMenuData
.blackboardLoop
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 0
	lb bc, 6, 10
	call TextBoxBorder
	hlcoord 1, 2
	ld de, StatusAilmentText1
	call PlaceString
	hlcoord 6, 2
	ld de, StatusAilmentText2
	call PlaceString
	ld hl, ViridianSchoolBlackboardText2
	rst _PrintText
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call HandleMenuInput ; pressing up and down is handled in here
	bit B_PAD_B, a ; pressed b
	jr nz, .exitBlackboard
	bit B_PAD_RIGHT, a
	jr z, .didNotPressRight
	; move cursor to right column
	lb bc, 2, 6
	call .loadMenuData
	ld a, 3
	ld [wMenuItemOffset], a
	jr .blackboardLoop
.didNotPressRight
	bit B_PAD_LEFT, a
	jr z, .didNotPressLeftOrRight
	; move cursor to left column
	call .loadDefaultMenuData
	xor a
	ld [wMenuItemOffset], a
	jr .blackboardLoop
.didNotPressLeftOrRight
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMenuItemOffset]
	add b
	cp 5 ; cursor is pointing to "QUIT"
	jr z, .exitBlackboard
	; we must have pressed a on a status condition
	; so print the text
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld hl, ViridianStatusTextData
	ld bc, 5
	call AddNTimes
	rst _PrintText
	jr .blackboardLoop
.exitBlackboard
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call LoadScreenTilesFromBuffer1
	jp TextScriptEndNoButtonPress
.loadDefaultMenuData
	lb bc, 2, 1
.loadMenuData
	ld hl, wTopMenuItemY
	ld [hl], b
	inc hl
	ld [hl], c
	ret

ViridianSchoolBlackboardText1:
	text_far _ViridianSchoolBlackboardText1
	text_end

ViridianSchoolBlackboardText2:
	text_far _ViridianSchoolBlackboardText2
	text_end

StatusAilmentText1:
	db   " SLP"
	next " PSN"
	next " PAR@"

StatusAilmentText2:
	db   " BRN"
	next " FRZ"
	next " QUIT@"

ViridianStatusTextData:
ViridianBlackboardSleepText:
	text_far _ViridianBlackboardSleepText
	text_end
ViridianBlackboardPoisonText:
	text_far _ViridianBlackboardPoisonText
	text_end
ViridianBlackboardPrlzText:
	text_far _ViridianBlackboardPrlzText
	text_end
ViridianBlackboardBurnText:
	text_far _ViridianBlackboardBurnText
	text_end
ViridianBlackboardFrozenText:
	text_far _ViridianBlackboardFrozenText
	text_end
