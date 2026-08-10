LavenderPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection

LavenderPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,              TEXT_LAVENDERPOKECENTER_NURSE
	dba_const _LavenderPokecenterGentlemanText,        TEXT_LAVENDERPOKECENTER_GENTLEMAN
	dba_const _LavenderPokecenterLittleGirlText,       TEXT_LAVENDERPOKECENTER_LITTLE_GIRL
	dba_const GenericLinkReceptionistText,             TEXT_LAVENDERPOKECENTER_LINK_RECEPTIONIST
	dba_const _LavenderPokecenterBenchGuyText,         TEXT_LAVENDERPOKECENTER_BENCH_GUY
