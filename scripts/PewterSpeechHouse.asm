PewterSpeechHouse_Script:
	jp EnableAutoTextBoxDrawing

PewterSpeechHouse_TextPointers:
	def_text_pointers
	dba_const _PewterSpeechHouseGamblerText,           TEXT_PEWTERSPEECHHOUSE_GAMBLER
	dba_const _PewterSpeechHouseYoungsterText,         TEXT_PEWTERSPEECHHOUSE_YOUNGSTER
	dba_const PewterSpeechHouseLostWalletBeautyText,  TEXT_PEWTERSPEECHHOUSE_LOST_WALLET_BEAUTY

; PureRGBnote: ADDED: new NPC who will give you POCKET ABRA once you return their LOST WALLET
PewterSpeechHouseLostWalletBeautyText: 
	text_asm
		CheckEvent EVENT_RETURNED_LOST_WALLET
		ld hl, PewterHouse2Text3HowsAbra
		jr nz, .printDone
		ld b, LOST_WALLET
		call IsItemInBag
		jr z, .intro
	.have_lost_wallet
		ld hl, PewterHouse2Text3Found
		rst _PrintText
		ld a, LOST_WALLET
		ldh [hItemToRemoveID], a
		farcall RemoveItemByID
		lb bc, POCKET_ABRA, 1
		call GiveItem ; not possible to have no room for this item because you just gave the LOST WALLET away
		ld hl, ReceivedPocketAbraText
		rst _PrintText
		SetEvent EVENT_RETURNED_LOST_WALLET
		ld a, ABRA
		ld [wCurPartySpecies], a
		ld [wPokedexNum], a
		call PlayCry
		ld a, SFX_GET_ITEM_2
		call PlaySoundWaitForCurrent
		call WaitForSoundToFinish
		ld a, NAME_MON_SCREEN
		ld [wNamingScreenType], a
		ld hl, wPocketAbraNick
		predef AskName
		call DisableWaitingAfterTextDisplay
		rst TextScriptEnd
	.intro
		SetEvent EVENT_MET_POCKET_ABRA_LADY
		ld hl, PewterHouse2Text3Intro
	.printDone
		rst _PrintText
		rst TextScriptEnd

PewterHouse2Text3Intro:
	text_far_end _PewterHouse2Text3Intro

PewterHouse2Text3Found:
	text_far_end _PewterHouse2Text3Found

PewterHouse2Text3HowsAbra:
	text_far_end _PewterHouse2Text3After

ReceivedPocketAbraText:
	text_far_end _ReceivedPocketAbraText
