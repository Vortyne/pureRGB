ViridianPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

ViridianPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,              TEXT_VIRIDIANPOKECENTER_NURSE
	dba_const _ViridianPokecenterGentlemanText,        TEXT_VIRIDIANPOKECENTER_GENTLEMAN
	dba_const _ViridianPokecenterCooltrainerMText,     TEXT_VIRIDIANPOKECENTER_COOLTRAINER_M
	dba_const GenericLinkReceptionistText,             TEXT_VIRIDIANPOKECENTER_LINK_RECEPTIONIST
	dba_const _ViridianPokecenterBenchGuyText,         TEXT_VIRIDIANPOKECENTER_BENCH_GUY
