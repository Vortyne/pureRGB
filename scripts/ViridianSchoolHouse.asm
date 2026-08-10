ViridianSchoolHouse_Script:
	jp EnableAutoTextBoxDrawing

ViridianSchoolHouse_TextPointers:
	def_text_pointers
	dba_const _ViridianSchoolHouseBrunetteGirlText, TEXT_VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	dba_const _ViridianSchoolHouseCooltrainerFText, TEXT_VIRIDIANSCHOOLHOUSE_COOLTRAINER_F
	dba_const _SchoolText3,                         TEXT_VIRIDIANSCHOOLHOUSE_ROCKER
	dba_const _SchoolText4,                         TEXT_VIRIDIANSCHOOLHOUSE_DETENTION_SIGN
	dba_const ViridianSchoolNotebook,              TEXT_VIRIDIANSCHOOLHOUSE_NOTEBOOK
	dba_const ViridianSchoolBlackboard,            TEXT_VIRIDIANSCHOOLHOUSE_BLACKBOARD

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
	ld bc, 4
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
	text_far_end _TurnPageText

ViridianSchoolNotebookText5:
	text_far _ViridianSchoolNotebookText5
	text_waitbutton
	text_end

ViridianSchoolNotebookTextGus:
	text_far _ViridianSchoolNotebookTextGus
	text_waitbutton
	text_end

ViridianSchoolNotebookText1:
	text_far_end _ViridianSchoolNotebookText1
ViridianSchoolNotebookPages:
ViridianSchoolNotebookText2:
	text_far_end _ViridianSchoolNotebookText2
ViridianSchoolNotebookText3:
	text_far_end _ViridianSchoolNotebookText3
ViridianSchoolNotebookText4:
	text_far_end _ViridianSchoolNotebookText4

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
	call DisableTextDelay
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
	call EnableTextDelay
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMenuItemOffset]
	add b
	cp 5 ; cursor is pointing to "QUIT"
	jr z, .exitBlackboard
	; we must have pressed a on a status condition
	; so print the text
	ld hl, ViridianStatusTextData
	ld bc, 4
	call AddNTimes
	rst _PrintText
	jr .blackboardLoop
.exitBlackboard
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
	text_far_end _ViridianSchoolBlackboardText1

ViridianSchoolBlackboardText2:
	text_far_end _ViridianSchoolBlackboardText2

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
	text_far_end _ViridianBlackboardSleepText
ViridianBlackboardPoisonText:
	text_far_end _ViridianBlackboardPoisonText
ViridianBlackboardPrlzText:
	text_far_end _ViridianBlackboardPrlzText
ViridianBlackboardBurnText:
	text_far_end _ViridianBlackboardBurnText
ViridianBlackboardFrozenText:
	text_far_end _ViridianBlackboardFrozenText
