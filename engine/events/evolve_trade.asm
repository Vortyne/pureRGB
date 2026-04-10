;InGameTrade_CheckForTradeEvo:
;	ld a, [wInGameTradeReceiveMonName]
;	cp 'G' ; GRAVELER
;	jr z, .nameMatched
;	; "SPECTRE" (HAUNTER)
;	cp 'S'
;	ret nz
;	ld a, [wInGameTradeReceiveMonName + 1]
;	cp 'P'
;	ret nz
;.nameMatched
;	ld a, [wPartyCount]
;	dec a
;	ld [wWhichPokemon], a
;	ld a, TRUE
;	ld [wForceEvolution], a
;	ld a, LINK_STATE_TRADING
;	ld [wLinkState], a
;	callfar TryEvolvingMon
;	xor a ; LINK_STATE_NONE
;	ld [wLinkState], a
;	jp PlayDefaultMusic

; PureRGBnote: REMOVED: pointless code
