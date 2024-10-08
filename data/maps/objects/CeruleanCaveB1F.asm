	object_const_def
	const_export CERULEANCAVEB1F_MEWTWO
	const_export CERULEANCAVEB1F_ITEM1
	const_export CERULEANCAVEB1F_ITEM2

CeruleanCaveB1F_Object:
	db $7d ; border block

	def_warp_events
	warp_event  3,  6, CERULEAN_CAVE_1F, 9
IF DEF(_DEBUG)
	warp_event 26, 13, CERULEAN_CAVE_1F, 1 ; allows easily warping to mewtwo
ENDC

	def_bg_events

	def_object_events
	object_event 27, 13, SPRITE_PSYCHIC, STAY, DOWN, TEXT_CERULEANCAVEB1F_MEWTWO
	object_event 16,  9, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVEB1F_ITEM1, ITEM_CERULEAN_CAVE_B1F_RIDGE_NORTH
	object_event 18,  1, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVEB1F_ITEM2, ITEM_CERULEAN_CAVE_B1F_RIDGE_CENTER

	def_warps_to CERULEAN_CAVE_B1F
