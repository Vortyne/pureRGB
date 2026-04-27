RedsHouse2F_Object:
	db $a ; border block

	def_warp_events
	warp_event  7,  1, REDS_HOUSE_1F, 3

	def_bg_events
	bg_event  0,  1, TEXT_REDSHOUSE2F_PLAYERS_PC
	bg_event  3,  5, TEXT_REDSHOUSE2F_SNES

	def_object_events

	def_warps_to REDS_HOUSE_2F
