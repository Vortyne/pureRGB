PewterCity_Script:
	ld hl, PewterCity_ScriptPointers
	ld de, wPewterCityCurScript
	jp CallMapScriptInTable

PewterCity_ScriptPointers:
	def_script_pointers
	dw_const PewterCityDefaultScript,                     SCRIPT_PEWTERCITY_DEFAULT
	dw_const PewterCitySuperNerd1ShowsPlayerMuseumScript, SCRIPT_PEWTERCITY_SUPER_NERD1_SHOWS_PLAYER_MUSEUM
	dw_const PewterCityHideSuperNerd1Script,              SCRIPT_PEWTERCITY_HIDE_SUPER_NERD1
	dw_const PewterCityResetSuperNerd1Script,             SCRIPT_PEWTERCITY_RESET_SUPER_NERD1
	dw_const PewterCityYoungsterShowsPlayerGymScript,     SCRIPT_PEWTERCITY_YOUNGSTER_SHOWS_PLAYER_GYM
	dw_const PewterCityHideYoungsterScript,               SCRIPT_PEWTERCITY_HIDE_YOUNGSTER
	dw_const PewterCityResetYoungsterScript,              SCRIPT_PEWTERCITY_RESET_YOUNGSTER

PewterCityDefaultScript:
	xor a
	ld [wMuseum1FCurScript], a
	ResetEvent EVENT_BOUGHT_MUSEUM_TICKET
	; fall through
PewterCityCheckPlayerLeavingEastScript:
	CheckEvent EVENT_BEAT_BROCK
	ret nz
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	ld hl, PewterCityPlayerLeavingEastCoords
	call ArePlayerCoordsInArray
	ret nc
	call DisableDpad
	ld a, TEXT_PEWTERCITY_YOUNGSTER
	ldh [hTextID], a
	jp DisplayTextID

PewterCityPlayerLeavingEastCoords:
	dbmapcoord 35, 17
	dbmapcoord 36, 17
	dbmapcoord 37, 18
	dbmapcoord 37, 19
	db -1 ; end

MuseumGuideDudeData:
	db SCRIPT_PEWTERCITY_HIDE_SUPER_NERD1
	dw MovementData_PewterMuseumGuyExit
MuseumGuideDudeDataStart:
	db PEWTERCITY_SUPER_NERD1
	db SPRITE_FACING_UP
	db ($3 << 4) | SPRITE_FACING_UP
	db TEXT_PEWTERCITY_SUPER_NERD1_ITS_RIGHT_HERE
	db $3c
	db $30
	db 12
	db 17

GymGuideDudeData:
	db SCRIPT_PEWTERCITY_HIDE_YOUNGSTER
	dw MovementData_PewterGymGuyExit
GymGuideDudeDataStart:
	db PEWTERCITY_YOUNGSTER
	db SPRITE_FACING_LEFT
	db ($1 << 4) | SPRITE_FACING_LEFT
	db TEXT_PEWTERCITY_YOUNGSTER_GO_TAKE_ON_BROCK
	db $3c
	db $50
	db 22
	db 16

PewterCityYoungsterShowsPlayerGymScript:
	ld hl, GymGuideDudeDataStart
	jr PewterGuideScript

PewterCitySuperNerd1ShowsPlayerMuseumScript:
	ld hl, MuseumGuideDudeDataStart
PewterGuideScript:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	push hl ; push which sprite will guide the user
	ld a, [hli] ; get the map sprite id
	ldh [hSpriteIndex], a
	ld a, [hli] ; get the desired facing direction
	ldh [hSpriteFacingDirection], a
	push hl
	call SetSpriteFacingDirectionAndDelay
	pop de ; hl is in use so we will temporarily pop into de
	ld a, [de] ; get the desired image index data
	inc de
	ldh [hSpriteImageIndex], a
	push de
	call SetSpriteImageIndexAfterSettingFacingDirection
	call PlayDefaultMusic
	ld hl, wMiscFlags
	set BIT_NO_SPRITE_UPDATES, [hl]
	pop hl ; pop de back into hl
	ld a, [hli] ; get the desired text to display
	ldh [hTextID], a
	push hl
	call DisplayTextID
	pop hl
	; hl = start of 4-byte coord data
	ld de, hSpriteScreenYCoord
	ld bc, 4
	rst _CopyData
	pop hl ; get back the sprite id
	ld a, [hl]
	ld [wSpriteIndex], a
	push hl
	call SetSpritePosition1
	pop hl
	ld a, [hld]
	ldh [hSpriteIndex], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	push hl
	; de = movement directions for the guide to take
	call MoveSprite
	pop hl
	dec hl
	ld a, [hl] ; script to run after
	ld [wPewterCityCurScript], a
	ret

MovementData_PewterMuseumGuyExit:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

MovementData_PewterGymGuyExit:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

PewterCityHideSuperNerd1Script:
	lb bc, TOGGLE_MUSEUM_GUY, SCRIPT_PEWTERCITY_RESET_SUPER_NERD1
	jr PewterCityHideNPCScript

PewterCityHideYoungsterScript:
	lb bc, TOGGLE_GYM_GUY, SCRIPT_PEWTERCITY_RESET_YOUNGSTER
	; fall through
PewterCityHideNPCScript:
	call IsNPCAutoMoving
	ret nz
	ld a, c
	ld [wPewterCityCurScript], a
	ld c, b
	jp HideObject

PewterCityResetSuperNerd1Script:
	lb bc, PEWTERCITY_SUPER_NERD1, TOGGLE_MUSEUM_GUY
	; fall through
PewterCityResetNPCScript:
	ld a, b
	ld [wSpriteIndex], a
	push bc
	call SetSpritePosition2
	pop bc ; c = which to hide
	call ShowObject
	; fall through
ResetPewterScripts:
	call EnableAllJoypad
	; a = 0 from EnableAllJoypad
	ld [wPewterCityCurScript], a ; SCRIPT_PEWTERCITY_DEFAULT
	ret

PewterCityResetYoungsterScript:
	lb bc, PEWTERCITY_YOUNGSTER, TOGGLE_GYM_GUY
	call PewterCityResetNPCScript
;;;;; PureRGBnote: FIXED: After the youngster shows you to the gym, they need to have their movement data reset so they face DOWN instead of NONE.
	ld hl, wMapSpriteData + (PEWTERCITY_YOUNGSTER - 1) * 2 ; movement byte of youngster
	ld [hl], DOWN ; reset behaviour to facing down
;;;;;
	ret

PewterCity_TextPointers:
	def_text_pointers
	dba_const _PewterCityCooltrainerFText,           TEXT_PEWTERCITY_COOLTRAINER_F
	dba_const _PewterCityCooltrainerMText,           TEXT_PEWTERCITY_COOLTRAINER_M
	dba_const PewterCitySuperNerd1Text,             TEXT_PEWTERCITY_SUPER_NERD1
	dba_const PewterCitySuperNerd2Text,             TEXT_PEWTERCITY_SUPER_NERD2
	dba_const PewterCityYoungsterText,              TEXT_PEWTERCITY_YOUNGSTER
	dba_const PickUp2ItemText,                      TEXT_PEWTERCITY_ITEM1 ; PureRGBnote: ADDED: new item in this location
	dba_const _PewterCityTrainerTipsText,            TEXT_PEWTERCITY_TRAINER_TIPS
	dba_const _PewterCityPoliceNoticeSignText,       TEXT_PEWTERCITY_POLICE_NOTICE_SIGN
	dba_const MartSignText,                         TEXT_PEWTERCITY_MART_SIGN
	dba_const PokeCenterSignText,                   TEXT_PEWTERCITY_POKECENTER_SIGN
	dba_const _PewterCityMuseumSignText,             TEXT_PEWTERCITY_MUSEUM_SIGN
	dba_const PewterCityGymSignText,                TEXT_PEWTERCITY_GYM_SIGN
	dba_const _PewterCitySignText,                   TEXT_PEWTERCITY_SIGN
	dba_const _PewterCitySuperNerd1ItsRightHereText, TEXT_PEWTERCITY_SUPER_NERD1_ITS_RIGHT_HERE
	dba_const _PewterCityYoungsterGoTakeOnBrockText, TEXT_PEWTERCITY_YOUNGSTER_GO_TAKE_ON_BROCK

PewterCitySuperNerd1Text:
	text_asm
	ld hl, .DidYouCheckOutMuseumText
	rst _PrintText
	call YesNoChoice
	jr nz, .playerDidNotGoIntoMuseum
	ld hl, .WerentThoseFossilsAmazingText
	rst _PrintText
	rst TextScriptEnd
.playerDidNotGoIntoMuseum
	ld hl, .YouHaveToGoText
	rst _PrintText
	xor a
	ldh [hJoyPressed], a
	lb bc, PEWTERCITY_SUPER_NERD1, SCRIPT_PEWTERCITY_SUPER_NERD1_SHOWS_PLAYER_MUSEUM
	ld d, 2
	jr PewterCityStartMovementFromTextScript

.DidYouCheckOutMuseumText:
	text_far_end _PewterCitySuperNerd1DidYouCheckOutMuseumText

.WerentThoseFossilsAmazingText:
	text_far_end _PewterCitySuperNerd1WerentThoseFossilsAmazingText

.YouHaveToGoText:
	text_far_end _PewterCitySuperNerd1YouHaveToGoText

PewterCityStartMovementFromTextScript:
	xor a
	ldh [hJoyHeld], a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, d
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [hLoadedROMBank]
	ld [wNPCMovementScriptBank], a
	ld a, b
	ld [wSpriteIndex], a
	ld a, c
	ld [wPewterCityCurScript], a
	call GetSpritePosition2
	rst TextScriptEnd

PewterCityYoungsterText:
	text_asm
	ld hl, .YoureATrainerFollowMeText
	rst _PrintText
	lb bc, PEWTERCITY_YOUNGSTER, SCRIPT_PEWTERCITY_YOUNGSTER_SHOWS_PLAYER_GYM
	ld d, 3
	jr PewterCityStartMovementFromTextScript

.YoureATrainerFollowMeText:
	text_far_end _PewterCityYoungsterYoureATrainerFollowMeText

PewterCitySuperNerd2Text:
	text_asm
	ld hl, .DoYouKnowWhatImDoingText
	rst _PrintText
	call YesNoChoice
	ld hl, .ImSprayingRepelText
	jr nz, .printDone
	ld hl, .ThatsRightText
.printDone
	rst _PrintText
	rst TextScriptEnd

.DoYouKnowWhatImDoingText:
	text_far_end _PewterCitySuperNerd2DoYouKnowWhatImDoingText

.ThatsRightText:
	text_far_end _PewterCitySuperNerd2ThatsRightText

.ImSprayingRepelText:
	text_far_end _PewterCitySuperNerd2ImSprayingRepelText

PewterCityGymSignText:
	text_asm
	ld c, PEWTER_GYM
	ld de, PewterGymOutsideSign
	jpfar GymOutsideSignTextScript
