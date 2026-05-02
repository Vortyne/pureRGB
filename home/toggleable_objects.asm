; removes toggleable object (items, leg. pokemon, etc.) from the map
; c: index of the toggleable object to be removed (global index)

HideObject::
	ld hl, wToggleableObjectFlags
	ld b, FLAG_SET
	; fall through
HideShowObjectCommon::
	call FlagAction
	jp UpdateSprites

HideExtraObject::
	ld hl, wExtraToggleableObjectFlags
	ld b, FLAG_SET
	jr HideShowObjectCommon

; adds toggleable object (items, leg. pokemon, etc.) to the map
; c: index of the toggleable object to be added (global index)

ShowObject::
	ld hl, wToggleableObjectFlags
	ld b, FLAG_RESET
	jr HideShowObjectCommon

ShowExtraObject::
	ld hl, wExtraToggleableObjectFlags
	ld b, FLAG_RESET
	jr HideShowObjectCommon
