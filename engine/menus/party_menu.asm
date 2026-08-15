DrawPartyMenu_::
	xor a
	ldh [hAutoBGTransferEnabled], a
	call ClearScreen
	call UpdateSprites
RedrawPartyMenu_ReloadSprites:
	callfar LoadPartyMonSprites ; mechanicalpennote: CHANGED: load pokemon icon graphics with the new code

RedrawPartyMenu_::
	ld a, [wPartyMenuTypeOrMessageID]
	cp SWAP_MONS_PARTY_MENU
	jp z, .printMessage
	call ErasePartyMenuCursors
	farcall InitPartyMenuBlkPacket
	hlcoord 3, 0
	ld de, wPartySpecies
	xor a
	ld c, a
	ldh [hPartyMonIndex], a
	ld [wWhichPartyMenuHPBar], a
.loop
	ld a, [de]
	cp $FF ; reached the terminator?
	jp z, .afterDrawingMonEntries
	push bc
	push de
	push hl
	ld a, c
	push hl
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	call PlaceString ; print the pokemon's name
	callfar ShowPartyMonSprite ; mechanicalpennote: CHANGED: place the appropriate pokemon icon with the new code
	ldh a, [hPartyMonIndex] ; loop counter
	ld [wWhichPokemon], a
	inc a
	ldh [hPartyMonIndex], a
	call LoadMonData
	pop hl
	push hl
	ld a, [wMenuItemToSwap]
	and a ; is the player swapping pokemon positions?
	jr z, .skipUnfilledRightArrow
; if the player is swapping pokemon positions
	dec a
	ld b, a
	ld a, [wWhichPokemon]
	cp b ; is the player swapping the current pokemon in the list?
	jr nz, .skipUnfilledRightArrow
; the player is swapping the current pokemon in the list
	dec hl
	dec hl
	dec hl
	ld a, '▷' ; unfilled right arrow menu cursor
	ld [hli], a ; place the cursor
	inc hl
	inc hl
.skipUnfilledRightArrow
	ld a, [wPartyMenuTypeOrMessageID] ; menu type
	cp TMHM_PARTY_MENU
	jr z, .teachMoveMenu
	cp EVO_STONE_PARTY_MENU
	jr z, .evolutionStoneMenu
	push hl
	ld bc, 14 ; 14 columns to the right
	add hl, bc
	ld de, wLoadedMonStatus
	call PrintStatusCondition
	pop hl
	push hl
	ld bc, SCREEN_WIDTH + 1 ; down 1 row and right 1 column
	ldh a, [hUILayoutFlags]
	set BIT_PARTY_MENU_HP_BAR, a
	ldh [hUILayoutFlags], a
	add hl, bc
	ld d, h
	ld e, l
	ld c, 2
	callfar DrawHP ; draw HP bar and prints current / max HP
	ldh a, [hUILayoutFlags]
	res BIT_PARTY_MENU_HP_BAR, a
	ldh [hUILayoutFlags], a
	call SetPartyMenuHPBarColor ; color the HP bar (on SGB)
	pop hl
	jr .printLevel
.teachMoveMenu
	push hl
	call CanLearnTM ; check if the pokemon can learn the move
	pop hl
	ld de, .ableToLearnMoveOrEvolveText
	jr nz, .placeMoveLearnabilityString
	ld de, .notAbleToLearnMoveOrEvolveText
.placeMoveLearnabilityString
	ld bc, SCREEN_WIDTH + 9 ; 1 row down and 9 columns right
	push hl
	add hl, bc
	call PlaceString
	pop hl
.printLevel
	ld bc, 10 ; move 10 columns to the right
	add hl, bc
	call PrintLevel
	pop hl
	pop de
	inc de
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	inc c
	jp .loop
.ableToLearnMoveOrEvolveText
	db "ABLE@"
.notAbleToLearnMoveOrEvolveText
	db "NOT ABLE@"
.evolutionStoneMenu
	push hl
	ld hl, EvosMovesPointerTable
	ld b, 0
	ld a, [wLoadedMonSpecies]
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld de, wEvoDataBuffer
	ld a, BANK(EvosMovesPointerTable)
	ld bc, 2
	call FarCopyData
	ld hl, wEvoDataBuffer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wEvoDataBuffer
	ld a, BANK(EvosMovesPointerTable)
	ld bc, wEvoDataBufferEnd - wEvoDataBuffer
	call FarCopyData
	ld hl, wEvoDataBuffer
	ld de, .notAbleToLearnMoveOrEvolveText
; loop through the pokemon's evolution entries
.checkEvolutionsLoop
	ld a, [hli]
	and a ; reached terminator?
	jr z, .placeEvolutionStoneString ; if so, place the "NOT ABLE" string
	inc hl
	inc hl
	cp EVOLVE_ITEM
	jr nz, .checkEvolutionsLoop
; if it's a stone evolution entry
	dec hl
	dec hl
	ld b, [hl]
	ld a, [wEvoStoneItemID] ; the stone the player used
	inc hl
	inc hl
	inc hl
	cp b ; does the player's stone match this evolution entry's stone?
	jr nz, .checkEvolutionsLoop
; if it does match
	ld de, .ableToLearnMoveOrEvolveText
.placeEvolutionStoneString
	ld bc, 20 + 9 ; down 1 row and right 9 columns
	pop hl
	push hl
	add hl, bc
	call PlaceString
	pop hl
	jr .printLevel
.afterDrawingMonEntries
	ld d, SET_PAL_PARTY_MENU
	call RunPaletteCommandWithoutGBCDelay
.printMessage
	ld hl, wStatusFlags5
	ld a, [hl]
	push af
	push hl
	set BIT_NO_TEXT_DELAY, [hl]
	ld a, [wPartyMenuTypeOrMessageID] ; message ID
	cp FIRST_PARTY_MENU_TEXT_ID
	jr nc, .printItemUseMessage
	cp USE_ITEM_PARTY_MENU
	jr z, .itemNameNeeded
	cp USE_ITEM_PARTY_MENU_BATTLE
	jr nz, .noItemNameNeeded
.itemNameNeeded
	push af
	ld a, [wPartyItemID]
	ld [wNamedObjectIndex], a
	call GetItemName
	pop af
.noItemNameNeeded
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	ld hl, PartyMenuMessagePointers
	ld b, 0
	ld c, a
	add hl, bc
	rst _PrintText
	ld a, [wPartyMenuTypeOrMessageID]
	cp USE_ITEM_PARTY_MENU
	jr nz, .done
	hlcoord 15, 15
	lb bc, 1, 3
	call TextBoxBorder
	hlcoord 16, 16
	ld [hl], '×'
	ld a, [wPartyItemID]
	ld b, a
	predef GetQuantityOfItemInBag
	ld a, b
	ld de, w2CharStringBuffer
	ld [de], a
	hlcoord 17, 16
	lb bc, 1 | LEADING_ZEROES, 2
	call PrintNumber
.done
	pop hl
	pop af
	ld [hl], a
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	jp GBPalNormal
.printItemUseMessage
	and $0F
	ld hl, PartyMenuItemUseMessagePointers
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	ld c, a
	ld b, 0
	add hl, bc
	push hl
	ld a, [wUsedItemOnWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	rst _PrintText
	jr .done

PartyMenuItemUseMessagePointers:
AntidoteText:
	text_far_end _AntidoteText
BurnHealText:
	text_far_end _BurnHealText
IceHealText:
	text_far_end _IceHealText
AwakeningText:
	text_far_end _AwakeningText
ParlyzHealText:
	text_far_end _ParlyzHealText
PotionText:
	text_far_end _PotionText
FullHealText:
	text_far_end _FullHealText
ReviveText:
	text_far_end _ReviveText
RareCandyText:
	text_far_end _RareCandyText

PartyMenuMessagePointers:
PartyMenuNormalText:
	text_far_end _PartyMenuNormalText
PartyMenuItemUseText:
	text_far_end _PartyMenuItemUseText
PartyMenuBattleText:
	text_far_end _PartyMenuBattleText
PartyMenuUseTMText:
	text_far_end _PartyMenuUseTMText
PartyMenuSwapMonText:
	text_far_end _PartyMenuSwapMonText
PartyMenuItemUseText2:
	text_far_end _PartyMenuItemUseText
PartyMenuEmptyText:
	text_far_end _PartyMenuEmptyText
PartyMenuItemUseBattleText:
	text_far_end _PartyMenuItemUseBattleText


SetPartyMenuHPBarColor:
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld c, a
	ld b, 0
	add hl, bc
	call GetHealthBarColor
	ld d, SET_PAL_PARTY_MENU_HP_BARS
	call RunPaletteCommand
	ld hl, wWhichPartyMenuHPBar
	inc [hl]
	ret

GetPartyMenuWatchedKeys::
	ld a, [wIsInBattle]
	and a
	jr nz, .inBattle
	ld a, [wPartyMenuTypeOrMessageID]
	and a ; NORMAL_PARTY_MENU
	ld d, PAD_A | PAD_B | PAD_SELECT
	ret z
	cp SWAP_MONS_PARTY_MENU
	ret z
.inBattle
	ld a, [wForcePlayerToChooseMon]
	and a
	ld d, PAD_A | PAD_B
	ret z
	xor a
	ld [wForcePlayerToChooseMon], a
	ld d, PAD_A
	ret
