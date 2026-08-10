DEF FUCHSIA_OMANYTE_KABUTO_FOSSIL_TILE EQU $7C


FuchsiaCity_Script:
	call FuchsiaCityDefaultScript
	jp EnableAutoTextBoxDrawing

; PureRGBnote: ADDED: function that will remove all cut trees in fuchsia if we deleted them with the tree deleter
FuchsiaCityDefaultScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CROSSED_MAP_CONNECTION, [hl] ; did we enter the map by traversal from another route
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	jr nz, .removeAddCutTilesNoRedraw
	call WasMapJustLoaded
	jr nz, .removeAddCutTiles
; PureRGBnote: ADDED: ERIK can walk away after you tell him where SARA is.
	; check if ERIK is walking away
	CheckEventHL EVENT_ERIK_LEAVING
	ret z
	call DisableAllJoypad
	call IsNPCAutoMoving
	ret nz
	ResetEventReuseHL EVENT_ERIK_LEAVING
	call EnableAllJoypad
	; hide erik sprite
	ld c, TOGGLE_FUCHSIA_ERIK
	call HideExtraObject
	ld c, TOGGLE_SAFARI_ZONE_CENTER_REST_HOUSE_ERIK
	; show erik in safari zone sprite
	jp ShowExtraObject
.removeAddCutTiles
	CheckEvent EVENT_DELETED_FUCHSIA_TREES
	jr z, .firstLoadCommon
	ld de, FuchsiaCityCutTreeTileBlockReplacements
	callfar ReplaceMultipleTileBlocks
	jr .firstLoadCommon
.removeAddCutTilesNoRedraw
	; this guarantees avoiding redrawing the map because when going between areas these tiles are offscreen.
	CheckEvent EVENT_DELETED_FUCHSIA_TREES
	jr z, .firstLoadCommon
	ld de, FuchsiaCityCutTreeTileBlockReplacements
	callfar ReplaceMultipleTileBlocksForceNoRedraw
.firstLoadCommon
	ResetEvent EVENT_FOSSIL_FAN_TEXT_TOGGLE ; this is just a good place to clear this event so the guy says the first text every time you reload the area.
	; fall through
	
; PureRGBnote: ADDED: since we don't have enough space in the sprite sheet to add kabuto's icon, 
; we just replace omanyte's with it when loading fuchsia city if kabuto is supposed to be in the zoo

CheckLoadKabutoShell::
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	ret z
	CheckEvent EVENT_GOT_HELIX_FOSSIL
	ret z
	; fall through

LoadKabutoShellSprite:
	ld hl, vSprites tile FUCHSIA_OMANYTE_KABUTO_FOSSIL_TILE
	ld de, PartyMonSprites2 tile 66
	lb bc, BANK(PartyMonSprites2), 4
	predef_jump CopyMenuSpritesVideoDataFar


FuchsiaCity_TextPointers:
	def_text_pointers
	dba_const FuchsiaCityYoungster1Text,      TEXT_FUCHSIACITY_YOUNGSTER1
	dba_const _FuchsiaCityGamblerText,        TEXT_FUCHSIACITY_GAMBLER
	dba_const FuchsiaCityErikText,            TEXT_FUCHSIACITY_ERIK
	dba_const FuchsiaCityYoungster2Text,      TEXT_FUCHSIACITY_YOUNGSTER2
	dba_const _FuchsiaCityPokemonText,        TEXT_FUCHSIACITY_CHANSEY
	dba_const _FuchsiaCityPokemonText,        TEXT_FUCHSIACITY_VOLTORB
	dba_const _FuchsiaCityPokemonText,        TEXT_FUCHSIACITY_KANGASKHAN
	dba_const _FuchsiaCityPokemonText,        TEXT_FUCHSIACITY_SLOWPOKE
	dba_const _FuchsiaCityPokemonText,        TEXT_FUCHSIACITY_LAPRAS
	dba_const _FuchsiaCityPokemonText,        TEXT_FUCHSIACITY_FOSSIL
	dba_const FuchsiaCityFossilFanText,       TEXT_FUCHSIACITY_FOSSIL_FAN
	dba_const _FuchsiaCitySignText,           TEXT_FUCHSIACITY_SIGN
	dba_const _FuchsiaCitySafariGameSignText,  TEXT_FUCHSIACITY_SAFARI_GAME_SIGN
	dba_const MartSignText,                   TEXT_FUCHSIACITY_MART_SIGN
	dba_const PokeCenterSignText,             TEXT_FUCHSIACITY_POKECENTER_SIGN
	dba_const _FuchsiaCityWardensHomeSignText, TEXT_FUCHSIACITY_WARDENS_HOME_SIGN
	dba_const _FuchsiaCitySafariZoneSignText,  TEXT_FUCHSIACITY_SAFARI_ZONE_SIGN
	dba_const FuchsiaCityGymSignText,         TEXT_FUCHSIACITY_GYM_SIGN
	dba_const FuchsiaCityChanseySignText,     TEXT_FUCHSIACITY_CHANSEY_SIGN
	dba_const FuchsiaCityVoltorbSignText,     TEXT_FUCHSIACITY_VOLTORB_SIGN
	dba_const FuchsiaCityKangaskhanSignText,  TEXT_FUCHSIACITY_KANGASKHAN_SIGN
	dba_const FuchsiaCitySlowpokeSignText,    TEXT_FUCHSIACITY_SLOWPOKE_SIGN
	dba_const FuchsiaCityLaprasSignText,      TEXT_FUCHSIACITY_LAPRAS_SIGN
	dba_const FuchsiaCityFossilSignText,      TEXT_FUCHSIACITY_FOSSIL_SIGN

; PureRGBnote: CHANGED: this NPC will point out how alt palette pokemon appear in the safari zone
; but only if we have alt palette pokemon enabled in the game options.
FuchsiaCityYoungster1Text: 
	text_asm
	ld a, [wOptions2]
	bit BIT_ALT_PKMN_PALETTES, a ; do we have alt palettes enabled
	ld hl, .didYouTrySafariText
	jr z, .printDone
.altPalettes
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, .manyHaveUniqueColorsText
.printDone
	rst _PrintText
	rst TextScriptEnd

.didYouTrySafariText:
	text_far_end _FuchsiaCityYoungster1Text

.manyHaveUniqueColorsText:
	text_far_end _FuchsiaCityYoungster1TextColor

; PureRGBnote: CHANGED: ERIK can be sent off to find SARA once you find her in the SAFARI ZONE.
FuchsiaCityErikText:
	text_far _FuchsiaCityErikText
	text_asm
	SetEvent EVENT_MET_ERIK
	CheckEvent EVENT_MET_SARA
	jr z, .notMet
	call DisplayTextPromptButton
	ld hl, .ohShesInSafariZone
	rst _PrintText
	call .checkTreeBlockPresent
	jr z, .treePresent
	ld a, [wXCoord]
	cp 29
	ld de, ErikLeavesNoTreeLeft
	jr z, .gotDirections
	cp 30
	ld de, ErikLeavesNoTreeDown
	jr z, .gotDirections
	ld de, ErikLeavesNoTreeRight
	jr .gotDirections
.treePresent
	ld a, [wXCoord]
	cp 29
	ld de, ErikLeavesTreeLeft
	jr z, .gotDirections
	cp 30
	ld de, ErikLeavesTreeDown
	jr z, .gotDirections
	ld de, ErikLeavesTreeRight
	jr .gotDirections
.gotDirections
	ld hl, wNPCMovementDirections2
	call DecodeRLEList
	SetEvent EVENT_ERIK_LEAVING
	ld a, FUCHSIACITY_ERIK
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	callfar MoveSpriteButAllowAOrBPress
.notMet
	rst TextScriptEnd
.ohShesInSafariZone
	text_far_end _ErikSaraInSafariZoneText
.checkTreeBlockPresent
	ld a, [wXCoord]
	cp 29
	lb de, 1, 1
	jr z, .gotBlock
	lb de, 0, 1
.gotBlock
	callfar GetBlockAtCoord
	ld a, d
	cp $60 ; tree block
	ret

ErikLeavesNoTreeLeft:
	db NPC_MOVEMENT_DOWN, 1
	db NPC_MOVEMENT_LEFT, 4
	db NPC_MOVEMENT_UP, 5
	db -1

ErikLeavesNoTreeDown:
	db NPC_MOVEMENT_LEFT, 4
	db NPC_MOVEMENT_UP, 3
	db -1

ErikLeavesNoTreeRight:
	db NPC_MOVEMENT_LEFT, 3
	db -1

ErikLeavesTreeLeft:
	db NPC_MOVEMENT_RIGHT, 5
	db -1

ErikLeavesTreeDown:
	db NPC_MOVEMENT_RIGHT, 5
	db NPC_MOVEMENT_UP, 3
	db -1

ErikLeavesTreeRight:
	db NPC_MOVEMENT_DOWN, 1
	db NPC_MOVEMENT_RIGHT, 5
	db NPC_MOVEMENT_UP, 5
	db -1

FuchsiaCityYoungster2Text:
	text_asm
	ld hl, .Text
	rst _PrintText
;;;;;;;;;; PureRGBnote: ADDED: the voltorb will now move while talking to this NPC (but only if OGPlus icons option is turned on)
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a
	jr z, .done
	ld de, vChars0 + VOLTORB_POKEBALL_TILE1
	callfar LoadVoltorbSprite
	ld c, 10
	rst DelayFrames
	ld hl, vChars0 + VOLTORB_POKEBALL_TILE1
	ld de, PokeBallSprite
	lb bc, BANK(PokeBallSprite), 4
	call CopyVideoData
.done
;;;;;;;;;;
	rst TextScriptEnd
.Text:
	text_far_end _FuchsiaCityYoungster2Text

FuchsiaCityGymSignText:
	text_asm
	ld c, FUCHSIA_GYM
	ld de, FuchsiaGymOutsideSign
	jpfar GymOutsideSignTextScript

FuchsiaCitySoMuchInfoText:
	text_far_end _FuchsiaCitySoMuchInfo

FuchsiaCityPrintMonNameText:
	ld [wNamedObjectIndex], a
	push af
	push hl
	call GetMonName
	ld hl, .text
	rst _PrintText
	pop hl
	rst _PrintText
	pop af
	jp DisplayPokedex
.text
	text_far_end _GenericFuchsiaZooNameText

LearnsetFuchsiaZoo:
	ld [wPokedexNum], a
	call AreLearnsetsEnabled
	jr z, .done
	push de
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call GetMonName
	ld hl, FuchsiaCitySoMuchInfoText
	rst _PrintText
	pop de
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

FuchsiaCityChanseySignText:
	text_asm
	ld a, CHANSEY
	ld hl, .Text
	call FuchsiaCityPrintMonNameText
	CheckEvent FLAG_CHANSEY_LEARNSET
	jr nz, .done
	ld a, CHANSEY
	ld d, DEX_CHANSEY
	jr LearnsetFuchsiaZoo
.done
	rst TextScriptEnd
.Text:
	text_far_end _FuchsiaCityChanseySignText


FuchsiaCityVoltorbSignText:
	text_asm
	ld a, VOLTORB
	ld hl, .Text
	call FuchsiaCityPrintMonNameText
	CheckEvent FLAG_ELECTRODE_FAMILY_LEARNSET
	jr nz, .done
	ld a, VOLTORB
	ld d, DEX_VOLTORB
	jr LearnsetFuchsiaZoo
.done
	rst TextScriptEnd

.Text:
	text_far_end _FuchsiaCityVoltorbSignText

FuchsiaCityKangaskhanSignText:
	text_asm
	ld a, KANGASKHAN
	ld hl, .Text
	call FuchsiaCityPrintMonNameText
	CheckEvent FLAG_KANGASKHAN_LEARNSET
	jr nz, .done
	ld a, KANGASKHAN
	ld d, DEX_KANGASKHAN
	jr LearnsetFuchsiaZoo
.done
	rst TextScriptEnd

.Text:
	text_far_end _FuchsiaCityKangaskhanSignText

FuchsiaCitySlowpokeSignText:
	text_asm
	ld a, SLOWPOKE
	ld hl, .Text
	call FuchsiaCityPrintMonNameText
	CheckEvent FLAG_SLOWBRO_FAMILY_LEARNSET
	jr nz, .done
	ld a, SLOWPOKE
	ld d, DEX_SLOWPOKE
	jp LearnsetFuchsiaZoo
.done
	rst TextScriptEnd

.Text:
	text_far_end _FuchsiaCitySlowpokeSignText

FuchsiaCityLaprasSignText:
	text_asm
	ld a, LAPRAS
	ld hl, .Text
	call FuchsiaCityPrintMonNameText
	CheckEvent FLAG_LAPRAS_LEARNSET
	jr nz, .done
	ld a, LAPRAS
	ld d, DEX_LAPRAS
	jp LearnsetFuchsiaZoo
.done
	rst TextScriptEnd

.Text:
	text_far_end _FuchsiaCityLaprasSignText

FuchsiaCityFossilSignText:
	text_asm
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr nz, .got_dome_fossil
	CheckEventReuseA EVENT_GOT_HELIX_FOSSIL
	jr nz, .got_helix_fossil
	ld hl, .UndeterminedText
	rst _PrintText
	rst TextScriptEnd
.got_dome_fossil
	ld a, OMANYTE
	call .fossilIntroText
	CheckEvent FLAG_OMASTAR_FAMILY_LEARNSET
	jr nz, .done
	ld a, OMANYTE
	ld d, DEX_OMANYTE
	jr .learnset
.got_helix_fossil
	ld a, KABUTO
	call .fossilIntroText
	CheckEvent FLAG_KABUTOPS_FAMILY_LEARNSET
	jr nz, .done
	ld a, KABUTO
	ld d, DEX_KABUTO
.learnset
	jp LearnsetFuchsiaZoo
.done
	rst TextScriptEnd

.fossilIntroText
	ld hl, .fossilText
	jp FuchsiaCityPrintMonNameText

.fossilText:
	text_far_end _FuchsiaCityFossilSignText

.UndeterminedText:
	text_far_end _FuchsiaCityFossilSignUndeterminedText

FuchsiaCityFossilFanText:
	text_asm
	CheckEvent EVENT_FOSSIL_FAN_TEXT_TOGGLE
	jr nz, .moveFossil
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a 
	ld hl, FuchsiaCityFossilFanText1
	jr z, .noEvent
	CheckEitherEventSet EVENT_GOT_HELIX_FOSSIL, EVENT_GOT_DOME_FOSSIL
	jr z, .noEvent
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, FuchsiaCityFossilFanText2
	rst _PrintText
	SetEvent EVENT_FOSSIL_FAN_TEXT_TOGGLE
	jr .done
.moveFossil
	ResetEvent EVENT_FOSSIL_FAN_TEXT_TOGGLE
	ld a, [wSpriteOptions2]
	bit BIT_MENU_ICON_SPRITES, a 
	jr z, .noEvent
	call ShowFossilPokemon
	ld a, 11
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
  	ldh [hSpriteFacingDirection], a
  	call SetSpriteFacingDirection
	ld hl, FuchsiaCityFossilFanText3
	rst _PrintText
	ld c, 20
	rst DelayFrames
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	call MoveFossilPokemon
  	jr .done
.noEvent
	rst _PrintText
.done
	rst TextScriptEnd

FuchsiaCityFossilFanText1:
	text_far_end _FuchsiaCityFossilFanText

FuchsiaCityFossilFanText2:
	text_far_end _FuchsiaCityFossilFanText2

FuchsiaCityFossilFanText3:
	text_far_end _FuchsiaCityFossilFanText3

GetFossilSpriteData:
	CheckEvent EVENT_GOT_HELIX_FOSSIL
	jr nz, .domeFossil
	ld de, PartyMonSprites1 tile 16
	lb bc, BANK(PartyMonSprites1), 4
	jr .showSprite
.domeFossil
	ld de, PartyMonSprites2 tile 64
	lb bc, BANK(PartyMonSprites2), 4
.showSprite
	ld hl, vSprites tile FUCHSIA_OMANYTE_KABUTO_FOSSIL_TILE
	ret

ShowFossilPokemon:
	call GetFossilSpriteData
	predef_jump CopyMenuSpritesVideoDataFar

GetOmanyteSpriteDataFrame2:
	ld de, PartyMonSprites1 tile 18
	lb bc, BANK(PartyMonSprites1), 4
	ld hl, vSprites tile FUCHSIA_OMANYTE_KABUTO_FOSSIL_TILE
	ret

MoveFossilPokemon:
	CheckEvent EVENT_GOT_HELIX_FOSSIL
	jr nz, .hideKabuto
	; omanyte will wiggle a bit before hiding
	ld a, 4
	push af
	; make it move a bit by alternating frames
.loop
	call GetFossilSpriteData
	predef CopyMenuSpritesVideoDataFar
	call Delay3
	call GetOmanyteSpriteDataFrame2
	predef CopyMenuSpritesVideoDataFar
	call Delay3
	pop af
	dec a
	push af
	jr nz, .loop
	pop af
.hideOmanyte
	ld de, FossilSprite
	lb bc, BANK(FossilSprite), 4
	ld hl, vSprites tile FUCHSIA_OMANYTE_KABUTO_FOSSIL_TILE
	jp CopyVideoData
.hideKabuto:
	ld c, 20
	rst DelayFrames
	jp LoadKabutoShellSprite