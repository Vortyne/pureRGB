PrepareTitleScreen::
	callfar _PrepareTitleScreen
	jr DisplayTitleScreen.continueFromTitle

DisplayTitleScreen::
	callfar _DisplayTitleScreen
.continueFromTitle
	ldh a, [hJoyHeld]
	ld b, a
	and PAD_UP | PAD_SELECT | PAD_B
	cp PAD_UP | PAD_SELECT | PAD_B
	jp z, .doClearSaveDialogue
IF DEF(_DEBUG)
	ld a, b
	bit B_PAD_SELECT, a
	jp z, .continue
	jp DebugMenu
.continue
ENDC
	jp MainMenu

.doClearSaveDialogue
	farjp DoClearSaveDialogue

