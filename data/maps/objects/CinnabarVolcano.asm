; PureRGBnote: CHANGED: many maps had their objects (items, NPCs, maps) modified for new content

	object_const_def
	const_export CINNABAR_VOLCANO_PROSPECTOR
	const_export CINNABAR_VOLCANO_BLAINE
	const_export CINNABAR_VOLCANO_ARCANINE
	const_export CINNABAR_VOLCANO_MOLTRES
	const_export CINNABAR_VOLCANO_RUBY1
	const_export CINNABAR_VOLCANO_RUBY2
	const_export CINNABAR_VOLCANO_RUBY3
	const_export CINNABAR_VOLCANO_ANIMATION_PROXY
	const_export CINNABAR_VOLCANO_ITEM1
	const_export CINNABAR_VOLCANO_ITEM2
	const_export CINNABAR_VOLCANO_SURFING_RHYDON
	const_export CINNABAR_VOLCANO_HUNGRY_GRAVELER
	const_export CINNABAR_VOLCANO_SICK_RHYDON
	const_export CINNABAR_VOLCANO_BOSS_MAGMAR

CinnabarVolcano_Object:
	db $03 ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event  2,  1, CINNABAR_VOLCANO, 5
	warp_event  3,  1, CINNABAR_VOLCANO, 6
	warp_event 22, 17, CINNABAR_VOLCANO, 3
	warp_event 23, 17, CINNABAR_VOLCANO, 4
	warp_event 22,  3, CINNABAR_VOLCANO, 9
	warp_event 23,  3, CINNABAR_VOLCANO, 9
	warp_event  4, 23, CINNABAR_VOLCANO, 8
	warp_event 33,  2, CINNABAR_VOLCANO, 11
	warp_event 12, 22, CINNABAR_VOLCANO, 10
	warp_event 13, 24, CINNABAR_VOLCANO, 13
	warp_event 42, 32, CINNABAR_VOLCANO, 12
	warp_event 48, 34, CINNABAR_VOLCANO, 16
	warp_event 49, 34, CINNABAR_VOLCANO, 17
	warp_event 40,  1, CINNABAR_VOLCANO, 14
	warp_event 50,  1, CINNABAR_VOLCANO, 15
	warp_event 43, 34, CINNABAR_VOLCANO, 19
	warp_event  0, 28, CINNABAR_VOLCANO, 18
	warp_event  2, 37, CINNABAR_VOLCANO, 20 ; proxy "lava touch warp" 1
	warp_event 47, 47, CINNABAR_VOLCANO, 21 ; proxy "lava touch warp" 2
	warp_event  3, 30, CINNABAR_VOLCANO, 23
	warp_event  4, 54, CINNABAR_VOLCANO, 22
	warp_event 12,  2, CINNABAR_VOLCANO_WEST, 1

	def_bg_events

	def_object_events
	object_event  2,  2, SPRITE_SAILOR, STAY, DOWN, TEXT_CINNABAR_VOLCANO_PROSPECTOR ; prospector
	object_event 22, 13, SPRITE_BLAINE, STAY, RIGHT, TEXT_CINNABAR_VOLCANO_BLAINE
	object_event 21, 13, SPRITE_CAT, STAY, RIGHT, 3
	object_event  4, 14, SPRITE_BIRD2, STAY, DOWN, TEXT_CINNABAR_VOLCANO_MOLTRES, MOLTRES, 50 ; moltres
	object_event 15, 23, SPRITE_OLD_AMBER, STAY, DOWN, TEXT_CINNABAR_VOLCANO_RUBY1 ; ruby 1 
	object_event 28, 23, SPRITE_OLD_AMBER, STAY, DOWN, TEXT_CINNABAR_VOLCANO_RUBY2 ; ruby 2 / rock salts
	object_event 35, 22, SPRITE_OLD_AMBER, STAY, DOWN, TEXT_CINNABAR_VOLCANO_RUBY3 ; ruby 3 / limestone
	object_event  0,  0, SPRITE_OLD_AMBER, STAY, DOWN, 8 ; animation proxy sprite, hidden by default
	object_event 50, 27, SPRITE_POKE_BALL, STAY, NONE, TEXT_CINNABAR_VOLCANO_ITEM1, ITEM_VOLCANO_LEDGES_NEW
	object_event  2, 46, SPRITE_POKE_BALL, STAY, NONE, TEXT_CINNABAR_VOLCANO_ITEM2, TM_VOLCANO_LAVA_FLOOD_NEW
	object_event  4, 58, SPRITE_MONSTER_SWIMMING, STAY, NONE, TEXT_CINNABAR_VOLCANO_SURFING_RHYDON
	object_event 15, 61, SPRITE_GRAVELER, STAY, UP, TEXT_CINNABAR_VOLCANO_HUNGRY_GRAVELER
	object_event 31, 61, SPRITE_MONSTER_SWIMMING, STAY, LEFT, TEXT_CINNABAR_VOLCANO_SICK_RHYDON
	object_event 48, 65, SPRITE_MONSTER_SWIMMING, STAY, UP, TEXT_CINNABAR_VOLCANO_BOSS_MAGMAR

	def_warps_to CINNABAR_VOLCANO
