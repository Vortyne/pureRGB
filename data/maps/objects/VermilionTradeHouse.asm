	object_const_def
	const_export VERMILIONTRADEHOUSE_LITTLE_GIRL
	const_export VERMILIONTRADEHOUSE_GAMEBOY_KID
	const_export VERMILIONTRADEHOUSE_DUX

VermilionTradeHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 7
	warp_event  3,  7, LAST_MAP, 7

	def_bg_events

	def_object_events
	object_event  3,  5, SPRITE_LITTLE_GIRL, STAY, UP, TEXT_VERMILIONTRADEHOUSE_LITTLE_GIRL
	object_event  5,  3, SPRITE_GAMEBOY_KID, STAY, LEFT, TEXT_VERMILIONTRADEHOUSE_GAMEBOY_KID
	object_event  6,  3, SPRITE_BIRD, WALK, ANY_DIR, TEXT_VERMILIONTRADEHOUSE_DUX
	object_event  4,  3, SPRITE_CLIPBOARD, STAY, NONE, TEXT_VERMILIONTRADEHOUSE_CLIPBOARD

	def_warps_to VERMILION_TRADE_HOUSE
