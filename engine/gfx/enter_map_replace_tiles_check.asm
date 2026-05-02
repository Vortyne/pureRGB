; PureRGBnote: ADDED:
; when entering some maps in which we can replace tileblocks on loading it
; when we enter the map from an animation like falling through a hole or warping, 
; we need to still replace those tileblocks before doing the animation or the player will see them disappear / change
EnterMapAnimReplaceTileBlocks::
	ld a, [wCurMapConnections]
	bit BIT_DEFER_SHOWING_MAP, a
	ret z
	ld a, [wCurMapTileset]
	cp VOLCANO
	jr nz, .notVolcano1 ; volcano warp end animation
	callfar LavaFloodReset
	jpfar VolcanoDoRoomSpecificMapLoadCode ; TODO: should it be CinnabarVolcanoOnMapLoad?
.notVolcano1
	ld a, [wCurMap]
	ld hl, TileBlockMapLoadFuncs
	ld de, 4
	call IsInArray
	ret nc
	inc hl
	ld a, [hli]
	ld b, a
	hl_deref
	rst _Bankswitch
	ret

TileBlockMapLoadFuncs:
	db SEAFOAM_ISLANDS_B4F
	dba SeafoamIslandsB4FOnMapLoad
	db SEAFOAM_ISLANDS_B3F
	dba SeafoamIslandsB3FOnMapLoad
	db VICTORY_ROAD_2F
	dba VictoryRoad2FCheckBoulderEventScript
	db SILPH_CO_2F
	dba SilphCo2FGateCallbackScript
	db SILPH_CO_3F
	dba SilphCo3FGateCallbackScript
	db SILPH_CO_4F
	dba SilphCo4FGateCallbackScript
	db SILPH_CO_5F
	dba SilphCo5FGateCallbackScript
	db SILPH_CO_6F
	dba SilphCo6FGateCallbackScript
	db SILPH_CO_7F
	dba SilphCo7FGateCallbackScript
	db SILPH_CO_8F
	dba SilphCo8FGateCallbackScript
	db SILPH_CO_9F
	dba SilphCo9FGateCallbackScript
	db SILPH_CO_10F
	dba SilphCo10FGateCallbackScript
	db SILPH_CO_11F
	dba SilphCo11FGateCallbackScript
	db -1
