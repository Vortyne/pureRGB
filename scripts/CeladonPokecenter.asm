CeladonPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection ; TODO: parameterize?

CeladonPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,             TEXT_CELADONPOKECENTER_NURSE
	dba_const _CeladonPokecenterGentlemanText,        TEXT_CELADONPOKECENTER_GENTLEMAN
	dba_const _CeladonPokecenterBeautyText,           TEXT_CELADONPOKECENTER_BEAUTY
	dba_const GenericLinkReceptionistText,            TEXT_CELADONPOKECENTER_LINK_RECEPTIONIST
	dba_const _CeladonPokecenterBenchGuyText,         TEXT_CELADONPOKECENTER_BENCH_GUY
