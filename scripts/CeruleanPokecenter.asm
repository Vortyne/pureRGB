CeruleanPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

CeruleanPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,             TEXT_CERULEANPOKECENTER_NURSE
	dba_const _CeruleanPokecenterSuperNerdText,        TEXT_CERULEANPOKECENTER_SUPER_NERD
	dba_const _CeruleanPokecenterGentlemanText,        TEXT_CERULEANPOKECENTER_GENTLEMAN
	dba_const GenericLinkReceptionistText,             TEXT_CERULEANPOKECENTER_LINK_RECEPTIONIST
	dba_const _CeruleanPokecenterBenchGuyText,         TEXT_CERULEANPOKECENTER_BENCH_GUY
