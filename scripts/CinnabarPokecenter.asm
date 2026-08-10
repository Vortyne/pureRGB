CinnabarPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

CinnabarPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,              TEXT_CINNABARPOKECENTER_NURSE
	dba_const _CinnabarPokecenterCooltrainerFText,     TEXT_CINNABARPOKECENTER_COOLTRAINER_F
	dba_const _CinnabarPokecenterGentlemanText,        TEXT_CINNABARPOKECENTER_GENTLEMAN
	dba_const GenericLinkReceptionistText,             TEXT_CINNABARPOKECENTER_LINK_RECEPTIONIST
	dba_const _CinnabarPokecenterBenchGuyText,         TEXT_CINNABARPOKECENTER_BENCH_GUY
