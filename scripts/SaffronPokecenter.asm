SaffronPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

SaffronPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,            TEXT_SAFFRONPOKECENTER_NURSE
	dba_const _SaffronPokecenterBeautyText,          TEXT_SAFFRONPOKECENTER_BEAUTY
	dba_const _SaffronPokecenterGentlemanText,       TEXT_SAFFRONPOKECENTER_GENTLEMAN
	dba_const GenericLinkReceptionistText,           TEXT_SAFFRONPOKECENTER_LINK_RECEPTIONIST
	dba_const SaffronPokecenterBenchGuyText,         TEXT_SAFFRONPOKECENTER_BENCH_GUY

SaffronPokecenterBenchGuyText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .afterSilphGone
	jr nz, .printText
	ld hl, .beforeSilphGone
.printText
	rst _PrintText
	rst TextScriptEnd

.beforeSilphGone
	text_far_end _SaffronCityPokecenterGuyText1

.afterSilphGone:
	text_far_end _SaffronCityPokecenterGuyText2
