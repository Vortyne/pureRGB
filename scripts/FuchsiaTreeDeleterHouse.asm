; PureRGBnote: ADDED: new house in fuchsia city. Has an NPC who will permanently remove specific annoying cut trees for a fee.
; also has his SNORLAX.
FuchsiaTreeDeleterHouse_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaTreeDeleterHouse_TextPointers:
	def_text_pointers
	dw_const TreeDeleterText,             TEXT_FUCHSIATREEDELETERHOUSE_TREE_DELETER
	dw_const TreeDeleterSnorlaxText,      TEXT_FUCHSIATREEDELETERHOUSE_SNORLAX

FuchsiaTreeDeleterHouseText1:
	text_far _FuchsiaTreeDeleterText1
	text_end

FuchsiaTreeDeleterHouseText2:
	text_far _FuchsiaTreeDeleterText2
	text_end

TreeDeleterSnorlaxText:
	text_far _FuchsiaTreeDeleterSnorlax
	text_asm
	ld a, SNORLAX
	call PlayCry
	call DisplayTextPromptButton
	ld hl, .couchPotato
	rst _PrintText
	call CheckAllTreesDeleted
	jr nz, .done
	call DisplayTextPromptButton
	ld de, TreeDeleterName
	call CopyTrainerName
	ld hl, .thatsMy
	rst _PrintText
	jp TreeDeleterText.snorlaxText
.done
	rst TextScriptEnd
.couchPotato
	text_far _FuchsiaTreeDeleterSnorlax2
	text_end
.thatsMy
	text_far _FuchsiaTreeDeleterSnorlax3
	text_end

CheckAllTreesDeleted:
	CheckBothEventsSet EVENT_DELETED_ROUTE2_TREES, EVENT_DELETED_CERULEAN_TREE
	ret nz
	CheckBothEventsSet EVENT_DELETED_ROUTE9_TREE, EVENT_DELETED_FUCHSIA_TREES
	ret

TreeDeleterText:
	text_asm
	call CheckAllTreesDeleted
	jr z, .finalText
	ld de, TreeDeleterName
	call CopyTrainerName
	ld hl, FuchsiaTreeDeleterHouseText1
	rst _PrintText
	xor a
	ld [wCurrentMenuItem], a
.listLoop
	call CheckAllTreesDeleted
	ld hl, FuchsiaTreeDeleterFinalText
	jr z, .doneList
	ld hl, FuchsiaTreeDeleterHouseText2
	rst _PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, TreeDeleterOptions
	ld b, PAD_A | PAD_B
	call DisplayMultiChoiceTextBoxNoMenuReset
	ld hl, FuchsiaTreeDeleterDoneText
	jr nz, .doneList
	ld hl, TextPointers_TreeDelete
	ld a, [wCurrentMenuItem]
	push af
	call GetAddressFromPointerArray
	rst _PrintText
	pop af
	ld [wCurrentMenuItem], a
	jr .listLoop
.doneList
	xor a
	ld [wListScrollOffset], a
	rst _PrintText
	rst TextScriptEnd
.finalText
	ld hl, FuchsiaTreeDeleterFinalText
	rst _PrintText
	call DisplayTextPromptButton
.snorlaxText
	ld hl, FuchsiaTreeDeleterFinalText2
	rst _PrintText
	ld de, TreeDeleterName
	call CopyTrainerName
	lb hl, DEX_SNORLAX, $FF
	ld de, TextNothing
	ld bc, LearnsetRecountedFondMemories
	predef_jump LearnsetTrainerScriptMain

TreeDeleterName:
	db "TREE DELETER@"

FuchsiaTreeDeleterDoneText:
	text_far _FuchsiaTreeDeleterDoneText
	text_end

FuchsiaTreeDeleterFinalText:
	text_far _FuchsiaTreeDeleterFinalText
	text_end

FuchsiaTreeDeleterFinalText2:
	text_far _FuchsiaTreeDeleterFinalText2
	text_end

TextPointers_TreeDelete:
	dw FuchsiaTreeDeleterRoute2
	dw FuchsiaTreeDeleterCeruleanCity
	dw FuchsiaTreeDeleterRoute9
	dw FuchsiaTreeDeleterFuchsiaCity

PurchasedTreeDeletion:  
	ld de, wPlayerMoney
	ld hl, hMoney
	ld c, 3 ; length of money in bytes
	call StringCmp
	jr c, .notEnoughMoneyTreeDeleter
	call SubtractAmountPaidFromMoney
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld hl, FuchsiaTreeDeleterTreeDelete
	rst _PrintText
	scf
	ret
.notEnoughMoneyTreeDeleter
	ld hl, NotEnoughMoneyTreeDeleterText
	rst _PrintText
	and a
	ret

NotEnoughMoneyTreeDeleterText:
	text_far _PokemartNotEnoughMoneyText
	text_end

FuchsiaTreeDeleterAlreadyDeletedText:
	text_far _FuchsiaTreeDeleterAlreadyDeletedText
	text_end

FuchsiaTreeDeleterTreeDelete:
	text_far _FuchsiaTreeDeleterTreeDelete
	text_end

FuchsiaTreeDeleterRoute2:
	text_asm
	lb bc, 0, $80
	ld hl, FuchsiaTreeDeleterRoute2Text
	CheckEvent EVENT_DELETED_ROUTE2_TREES
	call TreeDeleterTextScript
	jr nc, .done
	SetEvent EVENT_DELETED_ROUTE2_TREES
.done
	rst TextScriptEnd

TreeDeleterTextScript:
	jr nz, .alreadyDeleted
	push bc
	rst _PrintText
	call YesNoChoice
	pop bc
	jr nz, .done
	ld a, b
	ldh [hMoney], a 
	xor a
	ldh [hMoney + 2], a
	ld a, c
	ldh [hMoney + 1], a
	jp PurchasedTreeDeletion
.alreadyDeleted
	ld hl, FuchsiaTreeDeleterAlreadyDeletedText
	rst _PrintText
.done
	and a
	ret

FuchsiaTreeDeleterRoute2Text:
	text_far _FuchsiaTreeDeleterRoute2
	text_end

FuchsiaTreeDeleterCeruleanCity:
	text_asm
	lb bc, 0, $40
	ld hl, FuchsiaTreeDeleterCeruleanCityText
	CheckEvent EVENT_DELETED_CERULEAN_TREE
	call TreeDeleterTextScript
	jr nc, .done
	SetEvent EVENT_DELETED_CERULEAN_TREE
.done
	rst TextScriptEnd

FuchsiaTreeDeleterCeruleanCityText:
	text_far _FuchsiaTreeDeleterCerulean
	text_end

FuchsiaTreeDeleterRoute9:
	text_asm
	lb bc, 0, $40
	ld hl, FuchsiaTreeDeleterRoute9Text
	CheckEvent EVENT_DELETED_ROUTE9_TREE
	call TreeDeleterTextScript
	jr nc, .done
	SetEvent EVENT_DELETED_ROUTE9_TREE
.done
	rst TextScriptEnd

FuchsiaTreeDeleterRoute9Text:
	text_far _FuchsiaTreeDeleterRoute9
	text_end

FuchsiaTreeDeleterFuchsiaCity:
	text_asm
	lb bc, 1, 0
	ld hl, FuchsiaTreeDeleterFuchsiaCityText
	CheckEvent EVENT_DELETED_FUCHSIA_TREES
	call TreeDeleterTextScript
	jr nc, .done
	SetEvent EVENT_DELETED_FUCHSIA_TREES
.done
	rst TextScriptEnd

FuchsiaTreeDeleterFuchsiaCityText:
	text_far _FuchsiaTreeDeleterFuchsiaCity
	text_end