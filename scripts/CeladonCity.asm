CeladonCity_Script:
	call EnableAutoTextBoxDrawing
	; fall through
	
; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
CeladonCityCheckHideCutTree:
	call WasMapJustLoaded
	jr nz, .checkTileReplacements
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	ret z 
	SetFlag FLAG_SKIP_MAP_REDRAW
.checkTileReplacements
	ld hl, wTileBlockReplaceCount
	ld [hl], 0
	ld de, CeladonCutAlcove1
	callfar FarArePlayerCoordsInRange
	jr c, .replaceTree
	ld de, CeladonCutAlcove2
	callfar FarArePlayerCoordsInRange
	jr c, .replaceTree
	ld de, wTileBlockReplaceData
	jr .doneCheckingTreeReplace
.replaceTree
	call .addTreeRemovalData
.doneCheckingTreeReplace
	CheckEvent FLAG_CATCHUP_CLUBS_TURNED_OFF
	jr z, .doneCheckingTileBlockReplace
	; de = still the current index of wTileBlockReplaceData
	ld hl, wTileBlockReplaceCount
	inc [hl]
	ld hl, CeladonBackAlleyEntranceBlockData
	ld bc, 6
	call .copyDataAndTerminate
.doneCheckingTileBlockReplace
	ld a, [wTileBlockReplaceCount]
	and a
	jr z, .done
	ld de, wTileBlockReplaceData
	callfar ReplaceMultipleTileBlocks
.done
	ResetFlag FLAG_SKIP_MAP_REDRAW
	ret
.addTreeRemovalData
	; if we're in the cut alcove, remove the tree
	ld hl, wTileBlockReplaceCount
	inc [hl]
	ld hl, CutAlcoveBlockData
	ld de, wTileBlockReplaceData
	ld bc, 3
.copyDataAndTerminate
	rst _CopyData
	ld a, -1
	ld [de], a
	ret

CutAlcoveBlockData:
	db 16, 17, $6D

CeladonBackAlleyEntranceBlockData:
	db 9, 19, $37
	db 9, 21, $37

CeladonCity_TextPointers:
	def_text_pointers
	dba_const CeladonCityLittleGirlText,         TEXT_CELADONCITY_LITTLE_GIRL
	dba_const _CeladonCityGramps1Text,           TEXT_CELADONCITY_GRAMPS1
	dba_const _CeladonCityGirlText,              TEXT_CELADONCITY_GIRL
	dba_const _CeladonCityGramps2Text,           TEXT_CELADONCITY_GRAMPS2
	dba_const CeladonCityGramps3Text,            TEXT_CELADONCITY_GRAMPS3
	dba_const CeladonCityFisherText,             TEXT_CELADONCITY_FISHER
	dba_const CeladonCityPoliwrathText,          TEXT_CELADONCITY_POLIWRATH
	dba_const _CeladonCityRocket1Text,           TEXT_CELADONCITY_ROCKET1
	dba_const _CeladonCityRocket2Text,           TEXT_CELADONCITY_ROCKET2
	dba_const DoRet,                             TEXT_CELADONCITY_ANIMATION_PROXY
	dba_const _CeladonCityTrainerTips1Text,      TEXT_CELADONCITY_TRAINER_TIPS1
	dba_const CeladonCitySignText,               TEXT_CELADONCITY_SIGN
	dba_const PokeCenterSignText,                TEXT_CELADONCITY_POKECENTER_SIGN
	dba_const CeladonCityGymSignText,            TEXT_CELADONCITY_GYM_SIGN
	dba_const _CeladonCityMansionSignText,       TEXT_CELADONCITY_MANSION_SIGN
	dba_const _CeladonCityDeptStoreSignText,     TEXT_CELADONCITY_DEPTSTORE_SIGN
	dba_const _CeladonCityTrainerTips2Text,      TEXT_CELADONCITY_TRAINER_TIPS2
	dba_const _CeladonCityPrizeExchangeSignText, TEXT_CELADONCITY_PRIZEEXCHANGE_SIGN
	dba_const _CeladonCityGameCornerSignText,    TEXT_CELADONCITY_GAMECORNER_SIGN
	dba_const _CeladonCityText19,                TEXT_CELADONCITY_TRAINER_TIPS3

CeladonCityLittleGirlText:
	text_far _CeladonCityLittleGirlText
	text_asm
	CheckEvent FLAG_WEEZING_FAMILY_LEARNSET
	jr nz, .done
	call AreLearnsetsEnabled
	jr z, .done
	call DisplayTextPromptButton
	ld hl, .wantToSee
	rst _PrintText
	call YesNoChoice
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
	rst DelayFrames
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
	text_far_end _CeladonCityLittleGirlText2
.prettyCool
	text_far_end _CeladonCityLittleGirlText3
.littleGirlName
	db "LITTLE GIRL@"


CeladonSuitYourself::
	text_far_end _GenericSuitYourselfText

CeladonCityGramps3Text:
	text_asm
	CheckAndSetEvent EVENT_MET_CELADON_POOL_GRAMPS
	ld hl, .returnedGramps
	jr nz, .next
	ld hl, .metGramps
.next
	rst _PrintText
	CheckEvent EVENT_CELADON_POOL_GRAMPS_TUTORED_ONCE
	ld c, 0
	jr z, .gotEventState
	inc c
.gotEventState
	xor a
	ldh [hMoney], a 
	ldh [hMoney + 2], a
	ld a, $30
	ldh [hMoney + 1], a ; loads 3000 into the cost
	ld de, CeladonMoveTutorMoves
	callfar PaidMoveTutorScript
	ld a, d
	cp 1
	jr nz, .done
	SetEvent EVENT_CELADON_POOL_GRAMPS_TUTORED_ONCE
	ld hl, .coolMove
	rst _PrintText
.done
	rst TextScriptEnd
.metGramps:
	text_far_end _CeladonCityGramps3Text
.returnedGramps:
	text_far_end _CeladonCityGramps3Text2
.coolMove
	text_far_end _CeladonPoolGrampsAfterTeachText

CeladonCityFisherText:
	text_far _CeladonCityFisherText
	text_asm
	ld c, DEX_POLIWRATH - 1
	callfar SetMonSeen
	CheckEvent FLAG_POLIWRATH_FAMILY_LEARNSET
	jr nz, .done
	call AreLearnsetsEnabled
	jr z, .done
	call DisplayTextPromptButton
	ld hl, .seeMoves
	rst _PrintText
	call YesNoChoice
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
	text_far_end _CeladonCityFisher2Text
.letsDoThis
	text_far_end _LetsDoThis
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
	rst DelayFrames
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
	text_far_end _CeladonCitySignText
;;;;;

CeladonCityGymSignText:
	text_asm
	ld c, CELADON_GYM
	ld de, CeladonGymOutsideSign
	jpfar GymOutsideSignTextScript
