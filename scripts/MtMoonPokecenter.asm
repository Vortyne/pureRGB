MtMoonPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

MtMoonPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,            TEXT_MTMOONPOKECENTER_NURSE
	dba_const _MtMoonPokecenterYoungsterText,        TEXT_MTMOONPOKECENTER_YOUNGSTER
	dba_const _MtMoonPokecenterGentlemanText,        TEXT_MTMOONPOKECENTER_GENTLEMAN
	dba_const MtMoonPokecenterMagikarpSalesmanText,  TEXT_MTMOONPOKECENTER_MAGIKARP_SALESMAN
	dba_const _MtMoonPokecenterGentlemanText,        TEXT_MTMOONPOKECENTER_CLIPBOARD
	dba_const GenericLinkReceptionistText,           TEXT_MTMOONPOKECENTER_LINK_RECEPTIONIST
	dba_const _MtMoonPokecenterBenchGuyText,         TEXT_MTMOONPOKECENTER_BENCH_GUY

MtMoonPokecenterMagikarpSalesmanText:
	text_asm
	CheckEvent EVENT_BOUGHT_MAGIKARP, 1
	jp c, .alreadyBoughtMagikarp
	ld hl, .IGotADealText
	rst _PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	jp nz, .choseNo
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, $5
	ldh [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, .NoMoneyText
	jr .printText
.enoughMoney
	lb bc, MAGIKARP, 5
	call GivePokemon
	jr nc, .done
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $5
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	SetEvent EVENT_BOUGHT_MAGIKARP
	rst TextScriptEnd
.choseNo
	ld hl, .NoText
	jr .printText
.alreadyBoughtMagikarp
	ld hl, .NoRefundsText
	rst _PrintText
	ld d, GYARADOS
	callfar IsMonInParty
	jr nc, .done
	CheckEvent FLAG_GYARADOS_FAMILY_LEARNSET
	jr nz, .done
	ld de, SalesManName
	call CopyTrainerName
	lb hl, DEX_GYARADOS, $FF
	ld de, MtMoonPokecenterMagikarpSalesmanArentYouGladText
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain
.printText
	rst _PrintText
.done
	rst TextScriptEnd

.IGotADealText
	text_far_end _MtMoonPokecenterMagikarpSalesmanIGotADealText

.NoText
	text_far_end _MtMoonPokecenterMagikarpSalesmanNoText

.NoMoneyText
	text_far_end _MtMoonPokecenterMagikarpSalesmanNoMoneyText

.NoRefundsText
	text_far_end _MtMoonPokecenterMagikarpSalesmanNoRefundsText


SalesManName:
	db "SALESMAN@"
