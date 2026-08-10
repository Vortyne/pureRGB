ViridianMart_Script:
	ld hl, ViridianMart_ScriptPointers
	ld de, wViridianMartCurScript
	jp CallMapScriptInTable

ViridianMart_ScriptPointers:
	def_script_pointers
	dw_const ViridianMartDefaultScript,    SCRIPT_VIRIDIANMART_DEFAULT
	dw_const ViridianMartOaksParcelScript, SCRIPT_VIRIDIANMART_OAKS_PARCEL
	dw_const DoRet,                        SCRIPT_VIRIDIANMART_NOOP

ViridianMartDefaultScript:
	call UpdateSprites
	ld a, TEXT_VIRIDIANMART_CLERK_YOU_CAME_FROM_PALLET_TOWN
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wSimulatedJoypadStatesEnd
	ld de, .PlayerMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_VIRIDIANMART_OAKS_PARCEL
	ld [wViridianMartCurScript], a
	ret

.PlayerMovement:
	db PAD_LEFT, 1
	db PAD_UP, 2
	db -1 ; end

ViridianMartOaksParcelScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, TEXT_VIRIDIANMART_CLERK_PARCEL_QUEST
	ldh [hTextID], a
	call DisplayTextID
	lb bc, OAKS_PARCEL, 1
	call GiveItem
	SetEvent EVENT_GOT_OAKS_PARCEL
	ld a, SCRIPT_VIRIDIANMART_NOOP
	ld [wViridianMartCurScript], a
	ret

ViridianMart_TextPointers:
	def_text_pointers
	dba_const ViridianMartClerkChoiceText,                TEXT_VIRIDIANMART_CLERK
	dba_const _ViridianMartYoungsterText,                  TEXT_VIRIDIANMART_YOUNGSTER
	dba_const _ViridianMartCooltrainerMText,               TEXT_VIRIDIANMART_COOLTRAINER_M
	dba_const ViridianMartTMKid,                          TEXT_VIRIDIANMART_TM_KID
	dba_const _ViridianMartClerkYouCameFromPalletTownText, TEXT_VIRIDIANMART_CLERK_YOU_CAME_FROM_PALLET_TOWN
	dba_const _ViridianMartClerkParcelQuestText,           TEXT_VIRIDIANMART_CLERK_PARCEL_QUEST

ViridianMartTMKid: ; PureRGBnote: ADDED: new NPC who will talk about TMs
	text_asm
	; if we haven't beat misty yet, tm kid is yet to start selling anything
	CheckEvent EVENT_BEAT_MISTY
	ld hl, ViridianMartTMKidBefore
	jr z, .printDone
	; if we have, they will greet the player as the tm kid
	ld hl, TMKidGreet8
	rst _PrintText
	ld hl, TMKidStockingUp
	; if we haven't beat blaine yet, or have encountered the tm kid at indigo plateau, he'll say a generic line about restocking tms
	CheckEvent EVENT_MET_GYM_GUIDE_SON
	jr nz, .printDone
	CheckEvent EVENT_BEAT_BLAINE
	jr z, .printDone
	; if we beat blaine and haven't met the tm kid at indigo plateau yet, the tm kid will say he's stocking up for indigo plateau
	ld hl, TMKidBigStockIndigo
.printDone
	rst _PrintText
	rst TextScriptEnd

TMKidGreet8:
	text_far_end _TMKidGreet

TMKidStockingUp:
	text_far_end _TMKidStockingUp

TMKidBigStockIndigo:
	text_far_end _TMKidBigStockIndigo

ViridianMartTMKidBefore:
	text_far_end _ViridianMartTMKid

ViridianMartClerkChoiceText:
	text_asm
	CheckEvent EVENT_GOT_POKEDEX
	ld hl, .sayHiToOak
	jr z, .printDone
	ld hl, ViridianMartClerkText
	call DisplayPokemartDialogue
	rst TextScriptEnd
.printDone
	rst _PrintText
	rst TextScriptEnd

.sayHiToOak
	text_far_end _ViridianMartClerkSayHiToOakText

INCLUDE "data/items/marts/viridian.asm"
