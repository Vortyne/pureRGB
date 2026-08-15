; PureRGBnote: CHANGED: since Old rod is obtained in cerulean and good rod in vermilion now, this fishing guru will give either
; the SUPER ROD or the FISHING GUIDE depending on which of the last two gurus you talked to first.
; PureRGBnote: ADDED: This map is also used for ERIK and SARA's house.
FuchsiaGoodRodHouse_Script:
	call FuchsiaGoodRodHouseOnMapLoad
	jp EnableAutoTextBoxDrawing

FuchsiaGoodRodHouse_TextPointers:
	def_text_pointers
	dba_const FuchsiaGoodRodHouseFishingGuruText, TEXT_FUCHSIAGOODRODHOUSE_FISHING_GURU
	dba_const FuchsiaFishingGuide,                TEXT_FUCHSIAGOODRODHOUSE_FISHING_GUIDE
	dba_const ErikSarasHouseSaraText,             TEXT_FUCHSIAGOODRODHOUSE_SARA
	dba_const ErikSarasHouseErikText,             TEXT_FUCHSIAGOODRODHOUSE_ERIK
	dba_const ErikSarasHouseNoteText,             TEXT_FUCHSIAGOODRODHOUSE_NOTE
	dba_const ErikSarasHouseSecondNoteText,       TEXT_FUCHSIAGOODRODHOUSE_NOTE2
	dba_const _FuchsiaGoodRodHouseGarbageText,    TEXT_FUCHSIAGOODRODHOUSE_GARBAGE
	dba_const _ErikSarasHousePhoneText,           TEXT_ERIKSARASHOUSE_PHONE
	dba_const ErikSarasHouseComputerText,         TEXT_ERIKSARASHOUSE_COMPUTER
	dba_const ErikSarasHouseNorthGarbageText,     TEXT_ERIKSARASHOUSE_NORTH_GARBAGE
	dba_const ErikSarasHouseLeftShelfText,        TEXT_ERIKSARASHOUSE_LEFT_SHELF
	dba_const ErikSarasHouseMiddleShelfText,      TEXT_ERIKSARASHOUSE_MIDDLE_SHELF
	dba_const ErikSarasHouseRightShelfText,       TEXT_ERIKSARASHOUSE_RIGHT_SHELF
	dba_const ErikSarasHouseLeftPeriscopeText,    TEXT_ERIKSARASHOUSE_LEFT_PERISCOPE
	dba_const ErikSarasHouseRightPeriscopeText,   TEXT_ERIKSARASHOUSE_RIGHT_PERISCOPE
	dba_const ErikSarasHouseSouthGarbageText,     TEXT_ERIKSARASHOUSE_SOUTH_GARBAGE
	dba_const ErikSarasHouseOpenBookText,         TEXT_ERIKSARASHOUSE_OPEN_BOOK
	dba_const _DragonairEventEnd,                 TEXT_ERIKSARASHOUSE_AFTER_EVENT

FuchsiaGoodRodHouseOnMapLoad:
	call WasMapJustLoaded
	ret z
	ld a, [wXCoord]
	cp 12
	ret c ; if we're less than 12 x coord we're in the good rod house not erik and sara's house
	; check if we should hide erik and sara in the safari zone (we do if they are in their house)
	call AreErikAndSaraAtHome
	ret nz
	call Random
	and %00110011
	ld [wMapMultiTextTracker], a
	CheckAndResetEvent EVENT_DRAGONAIR_EVENT_ENDING_TEXT_TRIGGER
	jr z, .noEndingText
	call UpdateSprites
	ld a, $4A
	call .replaceTileBlockEntry
	ld hl, vTileset tile $40
	ld de, FoodTiles
	lb bc, BANK(FoodTiles), 2
	call CopyVideoDataHBlank
	call DoErikSaraFacings
	ld a, TEXT_ERIKSARASHOUSE_AFTER_EVENT
	ldh [hTextID], a
	call DisplayTextID
	call GBFadeOutToBlack
	ld a, FUCHSIAGOODRODHOUSE_ERIK
	call SetSpriteFacingDown
	ld a, FUCHSIAGOODRODHOUSE_SARA
	call SetSpriteFacingDown
	call UpdateSprites
	ld a, $32
	call .replaceTileBlockEntry
	ld c, TOGGLE_ERIK_SARA_HOUSE_NOTE2
	call ShowExtraObject
	jp GBFadeInFromBlack
.replaceTileBlockEntry
	ld [wNewTileBlockID], a
	lb bc, 5, 10
	jp ReplaceTileBlock
.noEndingText
	ld c, TOGGLE_SAFARI_ZONE_CENTER_REST_HOUSE_SARA
	call HideExtraObject
	ld c, TOGGLE_SAFARI_ZONE_CENTER_REST_HOUSE_ERIK
	jp HideExtraObject

FuchsiaGoodRodHouseFishingGuruText:
	text_asm
	CheckEvent EVENT_GOT_FUCHSIA_FISHING_GURU_ITEM
	jr nz, .printEndText
	ld hl, FuchsiaGuruIntro
	rst _PrintText
	callfar LastTwoGurusScript
	rst TextScriptEnd
.printEndText
	ld hl, FuchsiaGuruEnd
	rst _PrintText
	rst TextScriptEnd

FuchsiaGuruIntro:
	text_far_end _FuchsiaGuruIntro

FuchsiaGuruEnd:
	text_far_end _FuchsiaGuruEnd

FuchsiaFishingGuide:
	text_asm
	callfar LastTwoGurusFishingGuideBookText
	rst TextScriptEnd

; PureRGBnote: ADDED: text entry for the garbage can in this room

; nz if they're not at home
AreErikAndSaraAtHome:
	CheckExtraHideShowState TOGGLE_ERIK_HOUSE
	ld hl, ErikSaraNoPokingAround
	ret

ErikSarasHouseNoteText:
	text_asm
	call AreErikAndSaraAtHome
	ld hl, .notHome
	jr nz, .printDone
	ld hl, .home
.printDone
	rst _PrintText
.done
	rst TextScriptEnd
.notHome
	text_far_end _ErikSarasHouseNoteNotHomeText
.home
	text_far _ErikSarasHouseNoteHomeText
	text_asm
	CheckEvent FLAG_DRAGONITE_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_DRATINI
	jpfar KeepReadingBookLearnset

ErikSarasHouseComputerText:
	text_asm
	call AreErikAndSaraAtHome
	jr nz, .printDone
	CheckEvent EVENT_DRAGONAIR_EVENT_CLEARED_ONCE
	ld hl, .dragonairStats
	jr nz, .printDone
	ld hl, .email
.printDone
	rst _PrintText
	rst TextScriptEnd
.email
	text_far _EmailHereText
	text_far_end _ErikSarasHouseDragonairEmailText
.dragonairStats
	text_far_end _ErikSarasHouseComputerAfterText

ErikSaraNoPokingAround:
	text_far_end _ShouldntLookNoOneHome

ErikSarasHouseNorthGarbageText:
	text_asm
	call AreErikAndSaraAtHome
	jr nz, .printDone
	ld hl, .home
.printDone
	rst _PrintText
	rst TextScriptEnd
.home
	text_far _GarbageCrumpledUpPaper
	text_far_end _ErikSarasHouseNorthGarbageText

ErikSarasHouseSouthGarbageText:
	text_asm
	call AreErikAndSaraAtHome
	jr nz, .printDone
	ld hl, .home
.printDone
	rst _PrintText
	rst TextScriptEnd
.home
	text_far_end _ErikSarasHouseSouthGarbageText

ErikSarasHouseLeftShelfText:
	text_far _ErikSarasHouseLeftBookText
	text_far _FlippedToARandomPage
	text_far_end _ErikSarasHouseLeftBookText2

ErikSarasHouseMiddleShelfText:
	text_far _ErikSarasHouseCenterBookText
	text_far _FlippedToARandomPage
	text_far_end _ErikSarasHouseCenterBookText2

ErikSarasHouseRightShelfText:
	text_far _ErikSarasHouseRightBookText
	text_far _FlippedToARandomPage
	text_far _ErikSarasHouseRightBookText2
	text_asm
	; book will teach you about the pokemon you got the fossil for
	CheckEvent EVENT_GOT_HELIX_FOSSIL
	jr nz, .omanyte
	CheckEvent FLAG_KABUTOPS_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_KABUTO
	jr z, .read
.omanyte
	CheckEvent FLAG_OMASTAR_FAMILY_LEARNSET
	ld d, DEX_OMANYTE
	jr nz, .done
.read
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

ErikSarasHouseOpenBookText: 
	text_asm
	call AreErikAndSaraAtHome
	jr nz, .printDone
	ld hl, .home
.printDone
	rst _PrintText
	rst TextScriptEnd
.home
	text_far_end _ErikSarasHouseBookText

ErikSarasHouseLeftPeriscopeText:
	text_asm
	call AreErikAndSaraAtHome
	ld hl, PeriscopeInitialText
	jr nz, .printDone
	CheckAndSetEvent EVENT_PERISCOPES_EXPLAINED
	jr z, .notExplained
	ld hl, .periscopeIntro
	rst _PrintText
	ld hl, wMapMultiTextTracker
	ld a, [hl]
	swap a
	and %00110011
	inc a
	swap a
	ld [hl], a
	swap a
	; 4 random texts can display
	and %11
	ld hl, .goldeen
	jr z, .printDone
	dec a
	ld hl, .staryu
	jr z, .printDone
	dec a
	ld hl, .horsea
	jr z, .printDone
	ld hl, .krabby
	jr .printDone
.notExplained
	ld a, FUCHSIAGOODRODHOUSE_ERIK
	call SetSpriteFacingLeft
	ld hl, ExplainPeriscopesText
.printDone
	rst _PrintText
	rst TextScriptEnd
.periscopeIntro
	text_far_end _ErikSarasHouseLeftPeriscopeIntro
.staryu
	text_far_end _CoralReefCameraStaryu
.horsea
	text_far_end _CoralReefCameraHorsea
.krabby
	text_far_end _CoralReefCameraKrabby
.goldeen
	text_far_end _CoralReefCameraGoldeen

ExplainPeriscopesText:
	text_far_end _ErikSarasHousePeriscopeExplanation

PeriscopeInitialText:
	text_far_end _PeriscopeInitialText

ErikSarasHouseRightPeriscopeText:
	text_asm
	call AreErikAndSaraAtHome
	ld hl, PeriscopeInitialText
	jr nz, .printDone
	CheckAndSetEvent EVENT_PERISCOPES_EXPLAINED
	jr z, ErikSarasHouseLeftPeriscopeText.notExplained
	ld hl, .periscopeIntro
	rst _PrintText
	; 4 random texts can display
	ld hl, wMapMultiTextTracker
	ld a, [hl]
	and %00110011
	inc a
	ld [hl], a
	and %11
	ld hl, .nothing
	jr z, .printDone
	dec a
	ld hl, .magikarp
	jr z, .printDone
	dec a
	ld hl, .tentacruel
	jr z, .printDone
	ld hl, .gyarados
	jr .printDone
.printDone
	rst _PrintText
	rst TextScriptEnd
.periscopeIntro
	text_far_end _ErikSarasHouseRightPeriscopeIntro
.magikarp
	text_far_end _DeepSeaCameraMagikarp
.tentacruel
	text_far_end _DeepSeaCameraTentacruel
.gyarados
	text_far_end _DeepSeaCameraGyarados
.nothing
	text_far_end _DeepSeaCameraBubbles

ErikSarasHouseSaraText:
	text_asm
	CheckEvent EVENT_DRAGONAIR_EVENT_CLEARED_ONCE
	jr z, .notAlreadyClearedDragonairEvent
	ld hl, .goBack
	rst _PrintText
.goBackQuestionEntry
	call DoErikSaraFacings
	ld hl, .goBackQuestion
	rst _PrintText
	jr .chooseDragonair
.notAlreadyClearedDragonairEvent
	CheckAndSetEvent EVENT_MET_ERIK_SARA_IN_HOUSE
	jr nz, .alreadyMet
	ld hl, .welcomeSara
	rst _PrintText
	rst TextScriptEnd
.alreadyMet
	ld hl, .interested
	rst _PrintText
.firstQuestionEntry
	call DoErikSaraFacings
	CheckEvent EVENT_ERIK_SARA_EXPLAINED_RESEARCH_ONCE
	jr z, .noFirstQuestion
	call YesNoChoice
	jr nz, .noResearch
	jr .skipFirstPrompt
.noFirstQuestion
	call DisplayTextPromptButton
.skipFirstPrompt
	SetEvent EVENT_ERIK_SARA_EXPLAINED_RESEARCH_ONCE
	ld hl, .researchExp
	rst _PrintText
	call YesNoChoice
	jr z, .noSeafoamInfo
	ld hl, .seafoamInfo
	rst _PrintText
.noSeafoamInfo
	ld hl, .researchExp2
	rst _PrintText
.noResearch
	ld hl, .wantDragonair
	rst _PrintText
.chooseDragonair
	call ChooseDragonairForEvent
	ld a, [wWhichPokemon]
	cp $FF
  	ld hl, .lowLevel
  	jr z, .printDone
  	cp $FD
  	jr nc, .done
  	ld hl, .perfectDragonair
  	rst _PrintText
  	call YesNoChoice
  	ld hl, .suitYourself
  	jr nz, .printDone
  	ld a, [wWhichPokemon]
  	push af
  	; heal your mons so dragonair can't be fainted
  	predef HealParty
  	pop af
  	ld [wWhichPokemon], a
	call GetPartyMonName2 ; have to re-get its name since healparty changes wNameBuffer
	ResetEvent EVENT_DRAGONAIR_EVENT_BEAT_CLOYSTER ; allows repeating of the dragonair event
	ResetEvent EVENT_DRAGONAIR_EVENT_FOUGHT_CLOYSTER_ONCE
  	; load scripted warp to seafoam islands b4f
  	ld a, 4 ; 5th warp
	ld [wDestinationWarpID], a
	ld a, SEAFOAM_ISLANDS_B4F
	ldh [hWarpDestinationMap], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl] ; scripted warp flag
	ld a, SCRIPT_SEAFOAMISLANDSB4F_DRAGONAIR_EVENT_START
	ld [wSeafoamIslandsB4FCurScript], a
  	ld hl, .letsDoThis
.printDone
	rst _PrintText
.done
	rst TextScriptEnd
.welcomeSara
	text_far_end _SaraHouseIntroText
.interested
	text_far_end _SaraInterestedQuestion
.researchExp
	text_far_end _SaraHouseFirstStepText
.seafoamInfo
	text_far_end _SaraSeafoamExplanationText
.researchExp2
	text_far_end _ErikDragonairResearch
.wantDragonair
	text_far_end _ErikWantsDragonairText
.lowLevel
	text_far_end _ShowedDragonairLowLevelText
.perfectDragonair
	text_far_end _ShowedDragonairText
.suitYourself
	text_far_end _FossilGuyDenied
.letsDoThis
	text_far_end _ShowedDragonairLetsDoThis
.goBack
	text_far_end _ErikSarasHouseGoBackSaraText
.goBackQuestion
	text_far_end _ErikSarasHouseGoBackQuestionText

ErikSarasHouseErikText:
	text_asm
	CheckEvent EVENT_DRAGONAIR_EVENT_CLEARED_ONCE
	jr z, .notAlreadyClearedDragonairEvent
	ld hl, .goBack
	rst _PrintText
	jp ErikSarasHouseSaraText.goBackQuestionEntry
.notAlreadyClearedDragonairEvent
	CheckAndSetEvent EVENT_MET_ERIK_SARA_IN_HOUSE
	jr nz, .alreadyMet
	ld hl, .welcomeErik
	rst _PrintText
	rst TextScriptEnd
.alreadyMet
	ld hl, .interested
	rst _PrintText
	jp ErikSarasHouseSaraText.firstQuestionEntry
.welcomeErik
	text_far_end _ErikHouseIntroText
.interested
	text_far_end _ErikInterestedQuestion
.goBack
	text_far_end _ErikSarasHouseGoBackErikText

DoErikSaraFacings:
	; face erik and sara based on player's x position
	ld a, [wXCoord]
	sub 19
	lb de, SPRITE_FACING_LEFT, SPRITE_FACING_LEFT
	jr z, .dofacings
	dec a
	ld d, SPRITE_FACING_UP
	jr z, .dofacings
	dec a
	ld d, SPRITE_FACING_RIGHT
	jr z, .dofacings
	dec a
	ld e, SPRITE_FACING_UP
	jr z, .dofacings
	ld e, SPRITE_FACING_RIGHT
.dofacings
	ld a, FUCHSIAGOODRODHOUSE_SARA
	ld b, d
	call ChangeSpriteFacing
	ld a, FUCHSIAGOODRODHOUSE_ERIK
	ld b, e
	jp ChangeSpriteFacing

ChooseDragonairForEvent::
	callfar GenericShowPartyMenuSelection
	ld a, $FD
	ld hl, .forgetIt
	jr c, .printDone
	call GetPartyMonName2
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Species
 	ld bc, wPartyMon2 - wPartyMon1
  	call AddNTimes
  	ld a, [hl]
  	cp DRAGONAIR
  	jr z, .dragonair
  	cp WINTER_DRAGONAIR
  	ld hl, .already
  	ld a, $FE
  	jr z, .printDone
  	ld hl, .wrongMon
  	jr .printDone
.dragonair
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Level
 	ld bc, wPartyMon2 - wPartyMon1
  	call AddNTimes
  	ld a, [hl]
  	cp 45
  	ld a, $FF
  	ret nc ; success
.failed
	ld [wWhichPokemon], a
	ret
.printDone
	ld [wWhichPokemon], a
	rst _PrintText
	ret
.forgetIt
	text_far_end _GenericForgetItText
.wrongMon
	text_far_end _SecretLabMewtwoReactionText4
.already
	text_far_end _DragonairEventAlready

ErikSarasHouseSecondNoteText:
	text_far _ErikSarasHouseSecondNoteText
	text_asm
	CheckEvent FLAG_DRAGONITE_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_DRAGONAIR
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
