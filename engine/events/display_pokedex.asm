; Note: don't try to display missingno with this
_DisplayPokedex::
	call DisableTextDelay
	callfar ShowPokedexData
	call EnableTextDelay
	call ReloadMapData
	ld c, 10
	rst DelayFrames
	call IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexSeen
	call FlagAction
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret
