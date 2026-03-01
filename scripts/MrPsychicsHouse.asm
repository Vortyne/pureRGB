MrPsychicsHouse_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	jr z, .notFirstLoad
	call CheckInFightingBrosHouseAfterGiovanni
	jr nc, .notFirstLoad
	call LoadReplacedRocketFightingBrosHouse
	CheckEvent EVENT_BEAT_SABRINA
	jr z, .skipMoveCatalog
	; if you also beat sabrina, move the catalog into position
	lb bc, SPRITESTATEDATA2_MAPY, FIGHTINGBROSHOUSE_CATALOG
	call GetFromSpriteStateData2
	ld [hl], 4 + 4
.skipMoveCatalog
	ld a, $06
	ld [wNewTileBlockID], a
	lb bc, 3, 7
	predef ReplaceTileBlock
.notFirstLoad
	jp EnableAutoTextBoxDrawing

MrPsychicsHouse_TextPointers:
	def_text_pointers
	dw_const MrPsychicsHouseMrPsychicText, TEXT_MRPSYCHICSHOUSE_MR_PSYCHIC
	dw_const MrPsychicsHouseTableBook, TEXT_MRPSYCHICSHOUSE_TABLE_BOOK
	dw_const FightingBrosLeftBroText, TEXT_FIGHTINGBROSHOUSE_LEFT_BRO
	dw_const FightingBrosRightBroText, TEXT_FIGHTINGBROSHOUSE_RIGHT_BRO
	dw_const FightingBrosHouseRocketText, TEXT_FIGHTINGBROSHOUSE_ROCKET
	dw_const FightingBrosHouseCatalogue, TEXT_FIGHTINGBROSHOUSE_TABLE_BOOK

MrPsychicsHouseMrPsychicText:
	text_asm
	CheckEvent EVENT_BEAT_KARATE_MASTER
	ld hl, .IKnowWhatYouWant
	jr z, .printDone
	CheckEvent EVENT_GOT_TM29
	ld hl, .TM29ExplanationText
	jr nz, .printDone
	ld hl, .YouWantedThisText
	rst _PrintText
	lb bc, TM_SAFFRON_CITY_MR_PSYCHIC, 1
	call GiveItem
	ld hl, .TM29NoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_TM29
	ld hl, .ReceivedTM29Text
.printDone
	rst _PrintText
.done
	rst TextScriptEnd

.YouWantedThisText:
	text_far _MrPsychicsHouseMrPsychicYouWantedThisText
	text_end

.ReceivedTM29Text:
	text_far _MrPsychicsHouseMrPsychicReceivedTM29Text
	sound_get_item_1
	text_end

.TM29ExplanationText:
	text_far _MrPsychicsHouseMrPsychicTM29ExplanationText
	text_end

.TM29NoRoomText:
	text_far _MrPsychicsHouseMrPsychicTM29NoRoomText
	text_end

.IKnowWhatYouWant:
	text_far _MrPsychicsHouseIKnowWhatYouWantText
	text_end

MrPsychicsHouseTableBook:
	text_far _MrPsychicsHouseBookText
	text_far _FlippedToARandomPage
	text_far _MrPsychicsHouseBookText2
	text_asm
	CheckEvent FLAG_ALAKAZAM_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_KADABRA
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

FightingBrosHouseRocketText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .whiteBelt
	jr nz, .printDone
	ld hl, .rocket
	rst _PrintText
	ld a, FIGHTINGBROSHOUSE_LEFT_BRO
	call SetSpriteFacingDown
	ld hl, .needsGuidance
	rst _PrintText
	ld a, FIGHTINGBROSHOUSE_ROCKET
	call SetSpriteFacingUp
	ld hl, .yipes
.printDone
	rst _PrintText
	rst TextScriptEnd
.rocket
	text_far _FightingBrosRocketText
	text_end
.needsGuidance
	text_far _FightingBrosRocketText2
	text_end
.yipes
	text_far _FightingBrosRocketText3
	text_end
.whiteBelt
	text_far _FightingBrosRocketText4
	text_end

FightingBrosLeftBroText:
	text_asm
	call DoFightingBrosWelcome
	jr z, .done
	CheckAndSetEvent EVENT_FIGHTING_BROS_TUTELAGE_MENTIONED
	ld hl, .leftBroExplanationShort
	jr nz, .next
	ld hl, .leftBroExplanation
.next
	rst _PrintText
	CheckEvent EVENT_FIGHTING_BROS_TUTORED_ONCE
	ld c, 0
	jr z, .gotEventState
	inc c
.gotEventState
	xor a
	ldh [hMoney], a 
	ldh [hMoney + 2], a
	ld a, $50
	ldh [hMoney + 1], a ; loads 5000 into the cost
	ld de, SaffronMoveTutorMoves
	callfar PaidMoveTutorScript
	ld a, d
	cp 1
	jr nz, .done
	SetEvent EVENT_FIGHTING_BROS_TUTORED_ONCE
	ld hl, .coolMove
	rst _PrintText
.done
	rst TextScriptEnd
.leftBroExplanation
	text_far _FightingBrosLeftBro
	text_end
.leftBroExplanationShort
	text_far _FightingBrosLeftBroShort
	text_end
.coolMove
	text_far _FightingBrosLeftBroAfterTeachText
	text_end

FightingBrosRightBroText:
	text_asm
	call DoFightingBrosWelcome
	jr nz, .continue
	rst TextScriptEnd
.printDone
	rst _PrintText
	rst TextScriptEnd
.continue
	CheckEvent EVENT_FIGHTING_BROS_ALAKAZAM_TUTORED
	ld hl, .after
	jr nz, .printDone
	CheckAndSetEvent EVENT_FIGHTING_BROS_ALAKAZAM_MENTIONED
	ld hl, .RightBroExplanationShort
	jr nz, .next 
	ld hl, .RightBroExplanation
.next
	rst _PrintText
	call YesNoChoice
	jp nz, TextScriptEndNoButtonPress
	call ClearTextBox
	call SaveScreenTilesToBuffer2
	; first, choose the pokemon to see what moves can be tutored
	callfar GenericShowPartyMenuSelection
	push af
	call LoadScreenTilesFromBuffer2
	pop af
	jp c, TextScriptEndNoButtonPress
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Species
	ld bc, wPartyMon2Species - wPartyMon1Species
	call AddNTimes
	ld a, [hl]
	cp ALAKAZAM
	ld hl, .wrongMon
	jr nz, .printDone
	ld hl, .which
	rst _PrintText
	; draw the move selection menu on screen
	hlcoord 5, 8
	lb bc, 3, 13
	call TextBoxBorderUpdateSprites
	call DisableTextDelay
	hlcoord 7, 9
	ld de, FightingBrosAlakazamPunchMoves
.loopPrintNames
	ld a, [de]
	cp $FF
	jr z, .donePrintNames
	ld [wNamedObjectIndex], a
	inc de
	push de
	call GetMoveName
	call PlaceString
	pop de
	ld bc, SCREEN_WIDTH
	add hl, bc
	jr .loopPrintNames
.donePrintNames
	call EnableTextDelay
	; now trigger the move selection code
	ld a, 6
	ld [wTopMenuItemX], a
	ld a, 9
	ld [wTopMenuItemY], a
	ld a, 2
	ld [wMaxMenuItem], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, A_BUTTON
	ld [wMenuWatchedKeys], a
	ld hl, hUILayoutFlags
	set BIT_DOUBLE_SPACED_MENU, [hl]
	push hl
	call HandleMenuInput
	pop hl
	res BIT_DOUBLE_SPACED_MENU, [hl]
	ld a, [wCurrentMenuItem]
	ld hl, FightingBrosAlakazamPunchMoves
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	push af
	ld [wNamedObjectIndex], a
	call GetMoveName
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	push hl
	pop de
	call CopyToStringBuffer
	ld hl, .convene
	rst _PrintText
	call GBFadeOutToWhite
	call LoadScreenTilesFromBuffer2
	ld c, 120
	rst _DelayFrames
	call GBFadeInFromWhite
	ld hl, .convene2
	rst _PrintText
	; trigger learning the move
	pop af
	ld d, a
	callfar FarLearnArbitraryMove
	dec d
	jp nz, TextScriptEndNoButtonPress
	ld hl, .end
	rst _PrintText
	SetEvent EVENT_FIGHTING_BROS_ALAKAZAM_TUTORED
	rst TextScriptEnd
.RightBroExplanation
	text_far _FightingBrosRightBro
	text_end
.RightBroExplanationShort
	text_far _FightingBrosRightBroShort
	text_end
.which
	text_far _FightingBrosRightBroWhich
	text_end
.wrongMon
	text_far _GenericWrongMonText
	text_end
.convene
	text_far _FightingBrosRightBroConvene
	text_end
.convene2
	text_far _FightingBrosRightBroConvene2
	text_end
.end
	text_far _FightingBrosRightBroEnd
	text_end
.after
	text_far _FightingBrosRightBroAfter
	text_end

FightingBrosAlakazamPunchMoves:
	db FIRE_PUNCH
	db ICE_PUNCH
	db THUNDERPUNCH
	db -1


DoFightingBrosWelcome:
	CheckAndSetEvent EVENT_MET_FIGHTING_BROS
	jr nz, .next
	ld hl, .wereFightingBros
	rst _PrintText
.next
	CheckEvent EVENT_BEAT_SABRINA
	jr nz, .next2
	push af
	ld hl, .beatSabrina
	rst _PrintText
	pop af
	ret
.next2
	CheckAndSetEvent EVENT_FIGHTING_BROS_BEFRIENDED
	ret nz
	ld hl, .gotMarshBadge
	rst _PrintText
	or 1
	ret
.wereFightingBros
	text_far _FightingBrosWelcomeText
	text_end
.beatSabrina
	text_far _FightingBrosSabrinaText
	text_end
.gotMarshBadge
	text_far _FightingBrosGotMarshBadge
	text_end

FightingBrosHouseCatalogue::
	text_far _FightingBrosHouseCatalogueText
	text_asm
	xor a
	ldh [hMoney], a 
	ldh [hMoney + 2], a
	ld a, $50
	ldh [hMoney + 1], a ; loads 5000 into the cost
	ld de, SaffronMoveTutorMoves
	callfar ShowMoveTutorMoveList
	ld hl, .endText
	rst _PrintText
	rst TextScriptEnd
.endText
	text_far _FightingBrosHouseCatalogue2Text
	text_end

CheckInFightingBrosHouseAfterGiovanni::
	ld a, [wXCoord]
	cp 12
	jr c, .no ; not in fighting bros house
	; if in fighting bros house, check if we should turn the "rocket" into a "youngster"
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr z, .no
	scf
	ret
.no
	and a
	ret

CheckLoadReplacedRocketFightingBrosHouse::
	call CheckInFightingBrosHouseAfterGiovanni
	ret nc
LoadReplacedRocketFightingBrosHouse::
	ld hl, vNPCSprites tile $24
	ld de, CooltrainerMSprite
	lb bc, BANK(CooltrainerMSprite), 12
	jp CopyVideoData
