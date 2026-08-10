FuchsiaPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

FuchsiaPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,             TEXT_FUCHSIAPOKECENTER_NURSE
	dba_const _FuchsiaPokecenterRockerText,           TEXT_FUCHSIAPOKECENTER_ROCKER
	dba_const _FuchsiaPokecenterCooltrainerFText,     TEXT_FUCHSIAPOKECENTER_COOLTRAINER_F
	dba_const GenericLinkReceptionistText,            TEXT_FUCHSIAPOKECENTER_LINK_RECEPTIONIST
	dba_const _FuchsiaPokecenterBenchGuyText,         TEXT_FUCHSIAPOKECENTER_BENCH_GUY
