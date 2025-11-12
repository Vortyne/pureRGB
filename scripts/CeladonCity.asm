CeladonCity_Script:
	call EnableAutoTextBoxDrawing
	; fall through
	
; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
CeladonCityCheckHideCutTree:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl] ; did we load the map from a save/warp/door/battle, etc?
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z ; map wasn't just loaded
	ld de, CeladonCutAlcove1
	callfar FarArePlayerCoordsInRange
	call c, .removeTreeBlocker
	ld de, CeladonCutAlcove2
	callfar FarArePlayerCoordsInRange
	call c, .removeTreeBlocker
	ret
.removeTreeBlocker
	; if we're in the cut alcove, remove the tree
	lb bc, 16, 17
	ld a, $6D
	ld [wNewTileBlockID], a
	predef_jump ReplaceTileBlock

CeladonCity_TextPointers:
	def_text_pointers
	dw_const CeladonCityLittleGirlText,        TEXT_CELADONCITY_LITTLE_GIRL
	dw_const CeladonCityGramps1Text,           TEXT_CELADONCITY_GRAMPS1
	dw_const CeladonCityGirlText,              TEXT_CELADONCITY_GIRL
	dw_const CeladonCityGramps2Text,           TEXT_CELADONCITY_GRAMPS2
	dw_const CeladonCityGramps3Text,           TEXT_CELADONCITY_GRAMPS3
	dw_const CeladonCityFisherText,            TEXT_CELADONCITY_FISHER
	dw_const CeladonCityPoliwrathText,         TEXT_CELADONCITY_POLIWRATH
	dw_const CeladonCityRocket1Text,           TEXT_CELADONCITY_ROCKET1
	dw_const CeladonCityRocket2Text,           TEXT_CELADONCITY_ROCKET2
	dw_const DoRet,                            TEXT_CELADONCITY_ANIMATION_PROXY
	dw_const CeladonCityTrainerTips1Text,      TEXT_CELADONCITY_TRAINER_TIPS1
	dw_const CeladonCitySignText,              TEXT_CELADONCITY_SIGN
	dw_const PokeCenterSignText,               TEXT_CELADONCITY_POKECENTER_SIGN
	dw_const CeladonCityGymSignText,           TEXT_CELADONCITY_GYM_SIGN
	dw_const CeladonCityMansionSignText,       TEXT_CELADONCITY_MANSION_SIGN
	dw_const CeladonCityDeptStoreSignText,     TEXT_CELADONCITY_DEPTSTORE_SIGN
	dw_const CeladonCityTrainerTips2Text,      TEXT_CELADONCITY_TRAINER_TIPS2
	dw_const CeladonCityPrizeExchangeSignText, TEXT_CELADONCITY_PRIZEEXCHANGE_SIGN
	dw_const CeladonCityGameCornerSignText,    TEXT_CELADONCITY_GAMECORNER_SIGN
	dw_const CeladonCityText19,    TEXT_CELADONCITY_TRAINER_TIPS3

CeladonCityLittleGirlText:
	text_far _CeladonCityLittleGirlText
	text_asm
	CheckEvent FLAG_WEEZING_FAMILY_LEARNSET
	jr nz, .done
	CheckEvent EVENT_GOT_MOVEDEX
	jr z, .done
	call DisplayTextPromptButton
	ld hl, .wantToSee
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no
	ld hl, .prettyCool
	rst _PrintText
	ld a, [wPlayerDirection]
	cp PLAYER_DIR_RIGHT
	ld a, CELADONCITY_LITTLE_GIRL
	jr z, .down
	call SetSpriteFacingLeft
	jr .continue
.down
	call SetSpriteFacingDown
.continue
	ld de, .littleGirlName
	call CopyTrainerName
	lb hl, DEX_KOFFING, $FF
	ld de, KoffingLearnsetText
	ld bc, LearnsetShowedCoolMoves
	predef LearnsetTrainerScriptMain
	call WaitForSoundToFinish
	ld c, 20
	rst _DelayFrames
	lb hl, 55, 34
	ld de, vNPCSprites tile $78
	ld c, CELADONCITY_ANIMATION_PROXY
	predef MakePokemonDisappearInOverworld
	call UpdateSprites
	; reload the pokeball sprite we replaced with koffing
	ld hl, vNPCSprites tile $78
	ld de, PokeBallSprite
	lb bc, BANK(PokeBallSprite), 4
	call CopyVideoData
	rst TextScriptEnd
.no
	ld hl, CeladonSuitYourself
	rst _PrintText
.done
	rst TextScriptEnd
.wantToSee
	text_far _CeladonCityLittleGirlText2
	text_end
.prettyCool
	text_far _CeladonCityLittleGirlText3
	text_end
.littleGirlName
	db "LITTLE GIRL@"


CeladonSuitYourself::
	text_far _GenericSuitYourselfText
	text_end

CeladonCityGramps1Text:
	text_far _CeladonCityGramps1Text
	text_end

CeladonCityGirlText:
	text_far _CeladonCityGirlText
	text_end

CeladonCityGramps2Text:
	text_far _CeladonCityGramps2Text
	text_end

CeladonCityGramps3Text:
	text_asm
	CheckEvent EVENT_GOT_TM41
	jr nz, .gotTM41
	ld hl, .Text
	rst _PrintText
	lb bc, TM_CELADON_CITY_SURF_POOL_GRAMPS, 1
	call GiveItem
	jr c, .Success
	ld hl, .TM41NoRoomText
	rst _PrintText
	jr .Done
.Success
	ld hl, .ReceivedTM41Text
	rst _PrintText
	SetEvent EVENT_GOT_TM41
	jr .Done
.gotTM41
	ld hl, .TM41ExplanationText
	rst _PrintText
.Done
	rst TextScriptEnd

.Text:
	text_far _CeladonCityGramps3Text
	text_end

.ReceivedTM41Text:
	text_far _CeladonCityGramps3ReceivedTM41Text
	sound_get_item_1
	text_end

.TM41ExplanationText:
	text_far _CeladonCityGramps3TM41ExplanationText
	text_end

.TM41NoRoomText:
	text_far _CeladonCityGramps3TM41NoRoomText
	text_end

CeladonCityFisherText:
	text_far _CeladonCityFisherText
	text_asm
	ld a, DEX_POLIWRATH - 1
	callfar SetMonSeen
	CheckEvent FLAG_POLIWRATH_FAMILY_LEARNSET
	jr nz, .done
	CheckEvent EVENT_GOT_MOVEDEX
	jr z, .done
	call DisplayTextPromptButton
	ld hl, .seeMoves
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, CeladonSuitYourself
	jr nz, .printDone
	ld a, CELADONCITY_POLIWRATH
	call SetSpriteFacingDown
	ld hl, .letsDoThis
	rst _PrintText
.doneLoop
	ld de, .bigGuyName
	call CopyTrainerName
	lb hl, DEX_POLIWRATH, $FF
	ld de, PoliwrathLearnsetText
	ld bc, LearnsetShowedCoolMoves
	predef_jump LearnsetTrainerScriptMain
.printDone
	rst _PrintText
.done
	rst TextScriptEnd
.seeMoves
	text_far _CeladonCityFisher2Text
	text_end
.letsDoThis
	text_far _LetsDoThis
	text_end
.bigGuyName
	db "BIG GUY@"

PoliwrathAnimation::
	ld a, POLIWRATH
	call PlayCry
	ld b, 6
.loop
	push bc
	ld hl, vNPCSprites tile $18
	ld de, FightingSprite tile 12
	lb bc, BANK(FightingSprite), 12
	call CopyVideoData
	ld c, 3
	rst _DelayFrames
	ld hl, vNPCSprites tile $18
	ld de, FightingSprite
	lb bc, BANK(FightingSprite), 12
	call CopyVideoData
	pop bc
	dec b
	jr nz, .loop
	rst TextScriptEnd

CeladonCityPoliwrathText:
	text_far _CeladonCityPoliwrathText
	text_asm
	ld c, DEX_POLIWRATH - 1
	callfar SetMonSeen
	ld a, POLIWRATH
	call PlayCry
	rst TextScriptEnd

; d = which sprite
;FarToggleSpriteImageIndex::
;	ld a, d
;ToggleSpriteImageIndex:
;	ldh [hSpriteIndex], a
;	ld a, SPRITESTATEDATA1_IMAGEINDEX
;	ldh [hSpriteDataOffset], a
;	call GetPointerWithinSpriteStateData1
;	ld a, [hl]
;	xor 1
;	ld [hl], a
;	ret

CeladonCityRocket1Text:
	text_far _CeladonCityRocket1Text
	text_end

CeladonCityRocket2Text:
	text_far _CeladonCityRocket2Text
	text_end

CeladonCityTrainerTips1Text:
	text_far _CeladonCityTrainerTips1Text
	text_end

CeladonCitySignText:
;;;;; PureRGBnote: ADDED: can enable or disable the beta unused rainbow palette for celadon city by talking to the sign.
	text_asm
	ld hl, .text
	rst _PrintText
	CheckAndSetEvent EVENT_CELADON_RAINBOW_COLORS_ACTIVE
	jr z, .done
	ResetEventReuseHL EVENT_CELADON_RAINBOW_COLORS_ACTIVE
.done
	call RunDefaultPaletteCommand
	rst TextScriptEnd
.text
	text_far _CeladonCitySignText
	text_end
;;;;;

CeladonCityGymSignText:
	text_far _CeladonCityGymSignText
	text_end

CeladonCityMansionSignText:
	text_far _CeladonCityMansionSignText
	text_end

CeladonCityDeptStoreSignText:
	text_far _CeladonCityDeptStoreSignText
	text_end

CeladonCityTrainerTips2Text:
	text_far _CeladonCityTrainerTips2Text
	text_end

CeladonCityPrizeExchangeSignText:
	text_far _CeladonCityPrizeExchangeSignText
	text_end

CeladonCityGameCornerSignText:
	text_far _CeladonCityGameCornerSignText
	text_end

CeladonCityText19:
	text_far _CeladonCityText19
	text_end
