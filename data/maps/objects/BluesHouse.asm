	object_const_def
	const_export BLUESHOUSE_DAISY_SITTING
	const_export BLUESHOUSE_DAISY_WALKING
	const_export BLUESHOUSE_TOWN_MAP

BluesHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 2
IF DEF(_DEBUG)
	warp_event  3,  7, BLUES_HOUSE_1F_DEBUG_WARP_MAP, BLUES_HOUSE_1F_DEBUG_WARP_WHICH
ELSE
	warp_event  3,  7, LAST_MAP, 2
ENDC

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_DAISY, STAY, RIGHT, TEXT_BLUESHOUSE_DAISY_SITTING
	object_event  6,  4, SPRITE_DAISY, WALK, UP_DOWN, TEXT_BLUESHOUSE_DAISY_WALKING, 0
	object_event  3,  3, SPRITE_POKEDEX, STAY, NONE, TEXT_BLUESHOUSE_TOWN_MAP, 0

	def_warps_to BLUES_HOUSE
