DisplayStartMenu::
	ld a, BANK(StartMenu_Pokedex)
	call SetCurBank
	ld a, SFX_START_MENU
	rst _PlaySound

RedisplayStartMenu::
	farcall DrawStartMenu
.loop
	callfar HandleInputForStartMenu
	bit B_PAD_SELECT, d
	jr nz, .selectPressed ; PureRGBnote: ADDED: if pressing SELECT while the cursor is over the SAVE option - we can change PC boxes.
	call PlaceUnfilledArrowMenuCursor
	bit B_PAD_A, d ; if A not pressed, only B or START are left at this point, which close the menu
	jp z, CloseTextDisplay
.AButtonPressed
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
	ld hl, StartMenuJumpTable
	call GetAddressFromPointerArray
	jp hl
;;;;;;;;;; PureRGBnote: ADDED: if pressing SELECT while the cursor is over the SAVE option - we can change PC boxes.
.selectPressed
	ld a, [wCurrentMenuItem]
	cp 4 ; are we currently on SAVE menu index?
	jr z, .continue
	cp 2 ; are we on the ITEM index?
	jr nz, .loop ; if not don't do anything when pressing select
	; we are on the ITEM index
	ld a, [wNumBagItems]
	cp 2
	jr c, .loop ; can't sort bag if less than 2 items
.continue
	jp StartMenu_SelectPressed ; we can jp to this since it's in the bank on we loaded at the start of DisplayStartMenu
;;;;;;;;;;

StartMenuJumpTable:
	dw StartMenu_Pokedex
	dw StartMenu_Pokemon
	dw StartMenu_Item
	dw StartMenu_TrainerInfo
	dw StartMenu_SaveReset
	dw StartMenu_Option
	dw CloseTextDisplay
