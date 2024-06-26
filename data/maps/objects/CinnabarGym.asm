	object_const_def
	const_export CINNABARGYM_BLAINE
	const_export CINNABARGYM_SUPER_NERD1
	const_export CINNABARGYM_BURGLAR1
	const_export CINNABARGYM_SUPER_NERD2
	const_export CINNABARGYM_BURGLAR2
	const_export CINNERBARGYM_FIREFIGHTER1
	const_export CINNABARGYM_BURGLAR3
	const_export CINNERBARGYM_FIREFIGHTER2
	const_export CINNABARGYM_GYM_GUIDE

CinnabarGym_Object:
	db $2e ; border block

	def_warp_events
	warp_event 16, 17, LAST_MAP, 2
	warp_event 17, 17, LAST_MAP, 2

	def_bg_events

	def_object_events
	object_event  3,  3, SPRITE_BLAINE, STAY, DOWN, TEXT_CINNABARGYM_BLAINE, OPP_BLAINE, 1
	object_event 17,  2, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_CINNABARGYM_SUPER_NERD1, OPP_SUPER_NERD, 9
	object_event 17,  8, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_CINNABARGYM_BURGLAR1, OPP_BURGLAR, 4
	object_event 11,  4, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_CINNABARGYM_SUPER_NERD2, OPP_SUPER_NERD, 10
	object_event 11,  8, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_CINNABARGYM_BURGLAR2, OPP_BURGLAR, 5
	object_event 11, 14, SPRITE_GUARD, STAY, DOWN, TEXT_CINNERBARGYM_FIREFIGHTER1, OPP_FIREFIGHTER, 1
	object_event  3, 14, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_CINNABARGYM_BURGLAR3, OPP_BURGLAR, 6
	object_event  3,  8, SPRITE_GUARD, STAY, DOWN, TEXT_CINNERBARGYM_FIREFIGHTER2, OPP_FIREFIGHTER, 2
	object_event 16, 13, SPRITE_GYM_GUIDE, STAY, DOWN, TEXT_CINNABARGYM_GYM_GUIDE

	def_warps_to CINNABAR_GYM
