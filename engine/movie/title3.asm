PrepareTitleScreen::
	callfar _PrepareTitleScreen
	jr DisplayTitleScreen.continueFromTitle

DisplayTitleScreen::
	callfar _DisplayTitleScreen
.continueFromTitle
	ldh a, [hJoyHeld]
	ld b, a
	and D_UP | SELECT | B_BUTTON
	cp D_UP | SELECT | B_BUTTON
	jp z, .doClearSaveDialogue
IF DEF(_DEBUG)
	ld a, b
	bit BIT_SELECT, a
	jp z, .continue
	jp DebugMenu
.continue
ENDC
	jp MainMenu

.doClearSaveDialogue
	farjp DoClearSaveDialogue

