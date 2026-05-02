PewterCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PewterCity_ScriptPointers
	ld a, [wPewterCityCurScript]
	jp CallFunctionInTable

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
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
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
	dw_const PewterCityCooltrainerFText,           TEXT_PEWTERCITY_COOLTRAINER_F
	dw_const PewterCityCooltrainerMText,           TEXT_PEWTERCITY_COOLTRAINER_M
	dw_const PewterCitySuperNerd1Text,             TEXT_PEWTERCITY_SUPER_NERD1
	dw_const PewterCitySuperNerd2Text,             TEXT_PEWTERCITY_SUPER_NERD2
	dw_const PewterCityYoungsterText,              TEXT_PEWTERCITY_YOUNGSTER
	dw_const PickUp2ItemText,                      TEXT_PEWTERCITY_ITEM1 ; PureRGBnote: ADDED: new item in this location
	dw_const PewterCityTrainerTipsText,            TEXT_PEWTERCITY_TRAINER_TIPS
	dw_const PewterCityPoliceNoticeSignText,       TEXT_PEWTERCITY_POLICE_NOTICE_SIGN
	dw_const MartSignText,                         TEXT_PEWTERCITY_MART_SIGN
	dw_const PokeCenterSignText,                   TEXT_PEWTERCITY_POKECENTER_SIGN
	dw_const PewterCityMuseumSignText,             TEXT_PEWTERCITY_MUSEUM_SIGN
	dw_const PewterCityGymSignText,                TEXT_PEWTERCITY_GYM_SIGN
	dw_const PewterCitySignText,                   TEXT_PEWTERCITY_SIGN
	dw_const PewterCitySuperNerd1ItsRightHereText, TEXT_PEWTERCITY_SUPER_NERD1_ITS_RIGHT_HERE
	dw_const PewterCityYoungsterGoTakeOnBrockText, TEXT_PEWTERCITY_YOUNGSTER_GO_TAKE_ON_BROCK

PewterCityCooltrainerFText:
	text_far _PewterCityCooltrainerFText
	text_end

PewterCityCooltrainerMText:
	text_far _PewterCityCooltrainerMText
	text_end

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
	text_far _PewterCitySuperNerd1DidYouCheckOutMuseumText
	text_end

.WerentThoseFossilsAmazingText:
	text_far _PewterCitySuperNerd1WerentThoseFossilsAmazingText
	text_end

.YouHaveToGoText:
	text_far _PewterCitySuperNerd1YouHaveToGoText
	text_end

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
	text_far _PewterCityYoungsterYoureATrainerFollowMeText
	text_end

PewterCitySuperNerd1ItsRightHereText:
	text_far _PewterCitySuperNerd1ItsRightHereText
	text_end

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
	text_far _PewterCitySuperNerd2DoYouKnowWhatImDoingText
	text_end

.ThatsRightText:
	text_far _PewterCitySuperNerd2ThatsRightText
	text_end

.ImSprayingRepelText:
	text_far _PewterCitySuperNerd2ImSprayingRepelText
	text_end

PewterCityYoungsterGoTakeOnBrockText:
	text_far _PewterCityYoungsterGoTakeOnBrockText
	text_end

PewterCityTrainerTipsText:
	text_far _PewterCityTrainerTipsText
	text_end

PewterCityPoliceNoticeSignText:
	text_far _PewterCityPoliceNoticeSignText
	text_end

PewterCityMuseumSignText:
	text_far _PewterCityMuseumSignText
	text_end

PewterCityGymSignText:
	text_far _PewterCityGymSignText
	text_end

PewterCitySignText:
	text_far _PewterCitySignText
	text_end
