GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
	ld a, b
	ld [wNamedObjectIndex], a
	ld [wCurItem], a
	ld a, c
	ld [wItemQuantity], a
	ld hl, wNumBagItems
	call AddItemToInventory
	ret nc
	call GetItemName
	call CopyToStringBuffer
	scf
	ret

; PureRGBnote: ADDED: when giving a pokemon we can choose what pokeball it is in and whether it is alternate palette by changing a
GivePokemon::
; Give the player monster b at level c.
	xor a
GivePokemonCommon::
	ld [wIsAltPalettePkmnData], a
	ld a, b
	ld [wCurPartySpecies], a
	ld a, c
	ld [wCurEnemyLevel], a
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	farjp _GivePokemon
