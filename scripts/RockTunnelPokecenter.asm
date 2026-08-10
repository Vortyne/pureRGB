RockTunnelPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection
	
RockTunnelPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,               TEXT_ROCKTUNNELPOKECENTER_NURSE
	dba_const _RockTunnelPokecenterGentlemanText,       TEXT_ROCKTUNNELPOKECENTER_GENTLEMAN
	dba_const _RockTunnelPokecenterFisherText,          TEXT_ROCKTUNNELPOKECENTER_FISHER
	dba_const GenericLinkReceptionistText,              TEXT_ROCKTUNNELPOKECENTER_LINK_RECEPTIONIST
	dba_const RockTunnelCharityNurseText,               TEXT_ROCKTUNNELPOKECENTER_NURSE2
	dba_const _RockTunnelPokecenterBenchGuyText,        TEXT_ROCKTUNNELPOKECENTER_BENCH_GUY

; PureRGBnote: ADDED: by donating to this nurse you unlock the ability to speed up pokemon center healing by holding B before talking to the nurse
RockTunnelCharityNurseText: 
	text_asm
	ld hl, RockTunnelCharityNurseText1
	rst _PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld hl, RockTunnelCharityNurseFarewellText
	jr nz, .printDone
	xor a
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, $30
	ldh [hMoney + 1], a
	call HasEnoughMoney
	ld hl, RockTunnelCharityNurseNotEnoughMoneyText
	jr c, .printDone
.success
	SetEvent EVENT_DONATED_TO_POKECENTER_CHARITY
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $30
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, RockTunnelCharityNurseText2
.printDone
	rst _PrintText
	rst TextScriptEnd

RockTunnelCharityNurseText1:
	text_far_end _RockTunnelCharityNurseText1

RockTunnelCharityNurseText2:
	text_far_end _RockTunnelCharityNurseText2

RockTunnelCharityNurseFarewellText:
	text_far_end _PokemonCenterFarewellText

RockTunnelCharityNurseNotEnoughMoneyText:
	text_far_end _GenericNotEnoughMoneyText
