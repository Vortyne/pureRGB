VermilionPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp Serial_TryEstablishingExternallyClockedConnection
	
VermilionPokecenter_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,               TEXT_VERMILIONPOKECENTER_NURSE
	dba_const _VermilionPokecenterFishingGuruText,      TEXT_VERMILIONPOKECENTER_FISHING_GURU
	dba_const _VermilionPokecenterSailorText,           TEXT_VERMILIONPOKECENTER_SAILOR
	dba_const GenericLinkReceptionistText,              TEXT_VERMILIONPOKECENTER_LINK_RECEPTIONIST
	dba_const _VermilionPokecenterBenchGuyText,         TEXT_VERMILIONPOKECENTER_BENCH_GUY
