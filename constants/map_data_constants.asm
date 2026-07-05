; width of east/west connections
; height of north/south connections
DEF MAP_BORDER EQU 3

; connection directions
	const_def
	const EAST_F ; 0
	const WEST_F ; 1
	const SOUTH_F ; 2
	const NORTH_F ; 3

; additional map header bit data
	const BIT_DEFER_SHOWING_MAP ; 4
	const BIT_EXTRA_MUSIC_MAP ; 5
	const BIT_SPECIAL_ANIMATION_MAP ; 6

; wCurMapConnections
	const_def
	shift_const EAST   ; 1 %1
	shift_const WEST   ; 2 %10
	shift_const SOUTH  ; 4 %100
	shift_const NORTH  ; 8 %1000
	shift_const DEFER_SHOWING_MAP ; 16 %10000
	shift_const EXTRA_MUSIC_MAP ; 32 %100000
	shift_const SPECIAL_ANIMATION_MAP ; 64 %1000000

; wWarpEntries
DEF MAX_WARP_EVENTS EQU 32

; wNumSigns
DEF MAX_BG_EVENTS EQU 16

; wMapSpriteData
DEF MAX_OBJECT_EVENTS EQU 16

; flower and water tile animations
	const_def
	const TILEANIM_NONE          ; 0
	const TILEANIM_WATER         ; 1
	const TILEANIM_WATER_FLOWER  ; 2
