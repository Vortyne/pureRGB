; PureRGBnote: ADDED: in this file, code for using the telephones in the mart were added.
CeladonMart1F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart1F_TextPointers:
	def_text_pointers
	dba_const CeladonMart1FReceptionistText,     TEXT_CELADONMART1F_RECEPTIONIST
	dba_const CeladonMart1FDirectorySignText,    TEXT_CELADONMART1F_DIRECTORY_SIGN
	dba_const CeladonMart1FCurrentFloorSignText, TEXT_CELADONMART1F_CURRENT_FLOOR_SIGN
	dba_const CeladonMart1PhoneLeft,             TEXT_CELADONMART1F_PHONE_LEFT
	dba_const CeladonMart1PhoneRight,            TEXT_CELADONMART1F_PHONE_RIGHT

CeladonMart1FReceptionistText:
	text_far _CeladonMart1FReceptionistText
	text_asm
	call YesNoChoice
	jr nz, .done
	ld b, 6
	ld de, CeladonDirectoryClerkText
	ld hl, CeladonMart1FCurrentFloorClerkText
	call CeladonMartDirectoryMenu
.done
	ld hl, .atYourService
	rst _PrintText
	rst TextScriptEnd
.atYourService
	text_far_end _CeladonMart1FReceptionistText2


; PureRGBnote: CHANGED: this was made into a menu because it's just nicer that way
CeladonMart1FDirectorySignText:
	text_asm
	ld b, 5
	ld de, CeladonDirectoryText
	ld hl, CeladonMart1FCurrentFloorSignText
	call CeladonMartDirectoryMenu
	jp TextScriptEndNoButtonPress

CeladonMartDirectoryMenu:
	push bc
	push hl
	push de
	call DisableTextDelay
	hlcoord 0, 0
	lb bc, 11, 5
	call TextBoxBorder
	hlcoord 7, 0
	lb bc, 1, 10
	call TextBoxBorderUpdateSprites
	hlcoord 2, 1
	ld de, CeladonDirectoryMenu
	call PlaceString
	hlcoord 8, 1
	pop de
	call PlaceString
	pop hl
	rst _PrintText
	pop bc
	ld a, [wCurrentMenuItem]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld a, b
	ld [wListMenuHoverTextType], a
	ld a, 5
	ld [wMaxMenuItem], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld a, 1
	ld [wTopMenuItemY], a
	xor a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	inc a
	ldh [hJoy7], a ; allow holding down the menu navigation buttons
	ld a, PAD_B
	ld [wMenuWatchedKeys], a
	callfar HandleMenuInputFromBank1
	call EnableTextDelay
	xor a
	ldh [hJoy7], a
	ld [wListMenuHoverTextType], a
	pop af
	ld [wCurrentMenuItem], a
	ret

CeladonDirectoryMenu:
	db "1F"
	next "2F"
	next "3F"
	next "4F"
	next "5F"
	next "ROOF@"

CeladonDirectoryText:
	db "STORE INFO@"

CeladonDirectoryClerkText:
	db "I'll help!@"

ShowDeptStoreFloorInfo::
	ld hl, ShowDeptStoreTextEntry.floorTextData
ShowDeptStoreTextEntry:
	ld bc, TEXT_FAR_TABLE_ENTRY_SIZE
	ld a, [wCurrentMenuItem]
	call AddNTimes
	rst _PrintText
	ret
.floorTextData
CeladonMart1FCurrentFloorSignText:
	text_far_end _CeladonMart1FCurrentFloorSignText
.2f
	text_far_end _CeladonMart2FDirectorySignText
.3f
	text_far_end _CeladonMart3FCurrentFloorSignText
.4f
	text_far_end _CeladonMart4FDirectorySignText
.5f
	text_far_end _CeladonMart5FCurrentFloorSignText
.roof
	text_far_end _CeladonMartRoofCurrentFloorSignText

ShowDeptStoreFloorInfoClerk::
	ld hl, .floorTextData
	jr ShowDeptStoreTextEntry
.floorTextData
CeladonMart1FCurrentFloorClerkText:
.1f
	text_far_end _CeladonMart1FCurrentFloorClerkText
.2f
	text_far_end _CeladonMart2FDirectoryClerkText
.3f
	text_far_end _CeladonMart3FCurrentFloorClerkText
.4f
	text_far_end _CeladonMart4FDirectoryClerkText
.5f
	text_far_end _CeladonMart5FCurrentFloorClerkText
.roof
	text_far_end _CeladonMartRoofCurrentFloorClerkText

CeladonMart1PhoneLeft:
CeladonMart1PhoneRight:
	text_asm
	call SaveScreenTilesToBuffer2
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, CeladonMart1PhoneQuestion
	rst _PrintText
	xor a
	ld [wCurrentMenuItem], a
	call YesNoChoice
	jr nz, .no
	xor a
	ldh [hMoney], a
	ldh [hMoney + 1], a
	ld a, $25
	ldh [hMoney + 2], a
	call HasEnoughMoney
	jr nc, .success
	ld hl, CeladonMart1PhoneNotEnoughCash
	jr .printText
.success
	ld hl, CeladonMart1CallWhoQuestion
	rst _PrintText
	ld hl, CeladonMartPhoneList
	ld b, PAD_A | PAD_B
	call DisplayMultiChoiceTextBox
	jr nz, .no

	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	call SubtractMoney
	call LoadScreenTilesFromBuffer2
	call UpdateSprites
	ld hl, CeladonMartUsePhoneCallStart
	rst _PrintText
	call DialPhone
	call StartCall
	ld a, SFX_NOISE_INSTRUMENT03
	call PlaySoundWaitForCurrent
	ld c, 5
	rst DelayFrames
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld a, SFX_NOISE_INSTRUMENT10
	rst _PlaySound
	ld hl, CeladonMartUsePhoneCallEnd
	rst _PrintText
	call PlayDefaultMusic
	rst TextScriptEnd
.no
	ld hl, CeladonMartUsePhoneTextNo
.printText
	rst _PrintText
.done
	rst TextScriptEnd

CeladonMart1PhoneQuestion:
	text_far_end _CeladonMartUsePhoneText

CeladonMart1PhoneNotEnoughCash:
	text_far_end _GenericNotEnoughMoneyText

CeladonMart1CallWhoQuestion:
	text_far_end _CeladonMartCallWhoText

CeladonMartUsePhoneTextNo:
	text_far_end _CeladonMartUsePhoneTextNo

CeladonMartUsePhoneCallStart:
	text_far_end _CeladonMartCallStartText

CeladonMartUsePhoneCallEnd:
	text_far_end _CeladonMartUsePhoneCallEnd

SubtractMoney:
	; put coin in
	ld a, SFX_59
	call PlaySoundWaitForCurrent
	; subtract money
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 1], a
	ld a, $25
	ld [wPriceTemp + 2], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	; wait a little bit
	ld c, 40
	rst DelayFrames
	ret

DialPhone:
	; dial
	ld b, 4
.loopdial
	ld a, SFX_SWITCH
	rst _PlaySound
	dec b
	jr z, .donedial
	ld c, 20
	rst DelayFrames
	jr .loopdial
.donedial
	ld c, 50
	rst DelayFrames

	; call outgoing sounds 
	call Random
	and %11 ; 0-3 rings
	ld b, a
	jr nz, .loop
	inc b ; if it's 0, increase it to 2
	inc b ; 50% of the time we'll get 2 rings
.loop
	push bc
	ld b, 60
.loop2
	push bc
	ld a, SFX_TURN_OFF_PC
	rst _PlaySound
	ld c, 2
	rst DelayFrames
	pop bc
	dec b
	jr nz, .loop2
	pop bc
	dec b
	jr z, .doneOutgoing
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld c, 120
	rst DelayFrames
	jr .loop
.doneOutgoing
	; phone gets picked up
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld c, 10
	rst DelayFrames
	ld a, SFX_NOISE_INSTRUMENT01
	rst _PlaySound
	ld c, 5
	rst DelayFrames
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld a, SFX_NOISE_INSTRUMENT06
	rst _PlaySound
	ld c, 10
	rst DelayFrames
	ret

StartCall:
	ld a, [wCurrentMenuItem]
	add a
	ld d, 0
	ld e, a
	ld hl, CallScriptList
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

CallScriptList:
	dw CallHome
	dw CallOak
	dw CallRival
	db -1

CallHome:
	ld c, BANK(Music_PalletTown)
	ld a, MUSIC_PALLET_TOWN
	call PlayMusic
	call Random
	and %11
	jp z, .dad ; 25% chance of getting dad on the phone
	; mom picks up instead
	ld hl, CeladonMartCallMomText
	rst _PrintText
	ld hl, CeladonMartCallMomQuestion1
	ld b, PAD_A
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	ld a, [wCurrentMenuItem]
	and a
	ld hl, CeladonMartCallMomGreatText
	jr z, .printTextGoodByeMom
	dec a
	jr z, .bored
	; homesick
	ResetEventRange EVENT_CALLED_MOM_RICE_BALLS, EVENT_CALLED_MOM_LASAGNA
	ld hl, CeladonMartCallMomHomesickText
	rst _PrintText
	ld hl, CeladonMartCallMomQuestion3
	ld b, PAD_A
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	ld a, [wCurrentMenuItem]
	and a
	ld hl, CeladonMartCallMomRiceBallsText
	jr z, .printTextGoodByeMom
	dec a
	ld hl, CeladonMartCallMomJellyDonutsText
	jr z, .printTextGoodByeMom
	dec a
	ld hl, CeladonMartCallMomBrisketText
	jr z, .printTextGoodByeMom
	ld hl, CeladonMartCallMomLasagnaText
	jr .printTextGoodByeMom
.bored
	ld hl, CeladonMartCallMomBoredText
	rst _PrintText
	ld hl, CeladonMartCallMomQuestion2
	ld b, PAD_A
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	ld a, [wCurrentMenuItem]
	and a
	ld hl, CeladonMartCallMomGoodIdeaText
	jr z, .printTextGoodByeMom
	ld hl, CeladonMartCallMomGamblingText
.printTextGoodByeMom
	rst _PrintText
	ld hl, CeladonMartCallMomGoodbyeText
	rst _PrintText
	ld hl, CeladonMartCallMomQuestion4
	ld b, PAD_A
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	ld a, [wCurrentMenuItem]
	cp 2
	ld hl, CeladonMartCallMomGoodbyeSweetSon
	jr z, .done
	ld hl, CeladonMartCallMomGoodbyeComplete
	jr .done
.dad
	ld a, [wPlayerStarter]
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, CeladonMartCallDadText
	rst _PrintText
	ld a, [wPlayerStarter]
	cp STARTER3
	ld hl, CeladonMartCallDadBulbasaurText
	jr z, .dadPart2
	cp STARTER2
	ld hl, CeladonMartCallDadSquirtleText
	jr z, .dadPart2
	ld hl, CeladonMartCallDadCharmanderText
.dadPart2
	rst _PrintText
	ld hl, wObtainedBadges
	ld b, 1
	call CountSetBits
	ld a, [wNumSetBits]
	add NUMBER_CHAR_OFFSET
	ld [w2CharStringBuffer], a
	ld a, '@'
	ld [w2CharStringBuffer + 1], a
	SetEvent EVENT_CALLED_DAD_WAITING
	ld hl, CeladonMartCallDadText2
.done
	rst _PrintText
	ret

CeladonMartCallMomText:
	text_far_end _CeladonMartCallMomText

CeladonMartCallMomGreatText:
	text_far_end _CeladonMartCallMomGreatText

CeladonMartCallMomBoredText:
	text_far_end _CeladonMartCallMomBoredText

CeladonMartCallMomGoodIdeaText:
	text_far_end _CeladonMartCallMomGoodIdeaText

CeladonMartCallMomGamblingText:
	text_far_end _CeladonMartCallMomGamblingText

CeladonMartCallMomHomesickText:
	text_far_end _CeladonMartCallMomHomesickText

CeladonMartCallMomRiceBallsText:
	text_far _CeladonMartCallMomRiceBallsText
	text_asm
	SetEvent EVENT_CALLED_MOM_RICE_BALLS
	rst TextScriptEnd

CeladonMartCallMomJellyDonutsText:
	text_far _CeladonMartCallMomJellyDonutsText
	text_asm
	SetEvent EVENT_CALLED_MOM_JELLY_DONUTS
	rst TextScriptEnd

CeladonMartCallMomBrisketText:
	text_asm
	ld hl, CeladonMartCallMomBrisketText1
	rst _PrintText
	CheckEvent EVENT_MET_DAD
	ld hl, CeladonMartCallMomBrisketText2
	jr z, .noDad
	ld hl, CeladonMartDadBrisketText
.noDad
	rst _PrintText
	ld hl, CeladonMartCallMomBrisketText3
	rst _PrintText
	SetEvent EVENT_CALLED_MOM_BRISKET
	rst TextScriptEnd

CeladonMartCallMomBrisketText1:
	text_far_end _CeladonMartCallMomBrisketText

CeladonMartCallMomBrisketText2:
	text_far_end _CeladonMartCallMomBrisketText2

CeladonMartDadBrisketText:
	text_far_end _CeladonMartDadBrisketText

CeladonMartCallMomBrisketText3:
	text_far_end _CeladonMartCallMomBrisketText3

CeladonMartCallMomLasagnaText:
	text_far _CeladonMartCallMomLasagnaText
	text_asm
	SetEvent EVENT_CALLED_MOM_LASAGNA
	rst TextScriptEnd

CeladonMartCallMomGoodbyeText:
	text_far_end _CeladonMartCallMomGoodbyeText

CeladonMartCallMomGoodbyeSweetSon:
	text_far_end _CeladonMartCallMomGoodbyeSweetSon

CeladonMartCallMomGoodbyeComplete:
	text_far_end _CeladonMartCallMomGoodbyeComplete

CeladonMartCallDadText:
	text_far_end _CeladonMartCallDadText

CeladonMartCallDadBulbasaurText:
	text_far_end _CeladonMartCallDadBulbasaurText

CeladonMartCallDadCharmanderText:
	text_far_end _CeladonMartCallDadCharmanderText

CeladonMartCallDadSquirtleText:
	text_far_end _CeladonMartCallDadSquirtleText

CeladonMartCallDadText2:
	text_far_end _CeladonMartCallDadText2

CallOak:
	ld c, BANK(Music_MeetProfOak)
	ld a, MUSIC_MEET_PROF_OAK
	call PlayMusic
	ld a, [wPlayerStarter]
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, CeladonMartCallOakText
	rst _PrintText

	ld hl, CeladonMartCallOakQuestion1
	ld b, PAD_A
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	ld a, [wCurrentMenuItem]
	and a
	ld hl, CeladonMartCallOakTextItEvolved
	jr z, .question2
	ld hl, CeladonMartCallOakTextILoveIt
.question2
	rst _PrintText
	ld hl, CeladonMartCallOakQuestion2
	ld b, PAD_A
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	ld a, [wCurrentMenuItem]
	and a
	ld hl, CeladonMartCallOakTextKeepingBusy
	jr z, .done
	ld hl, CeladonMartCallOakTextHowsDaisy
.done
	rst _PrintText
	ld hl, CeladonMartCallOakTextGottaGo
	rst _PrintText
	ret

CeladonMartCallOakText:
	text_far_end _CeladonMartCallOakText

CeladonMartCallOakTextItEvolved:
	text_far_end _CeladonMartCallOakTextItEvolved

CeladonMartCallOakTextILoveIt:
	text_far_end _CeladonMartCallOakTextILoveIt

CeladonMartCallOakTextKeepingBusy:
	text_far_end _CeladonMartCallOakTextKeepingBusy

CeladonMartCallOakTextHowsDaisy:
	text_far_end _CeladonMartCallOakTextHowsDaisy

CeladonMartCallOakTextGottaGo:
	text_far_end _CeladonMartCallOakTextGottaGo

CallRival:
	ld c, BANK(Music_PalletTown)
	ld a, MUSIC_PALLET_TOWN
	call PlayMusic
	ld hl, CeladonMartCallRivalText
	rst _PrintText
	CheckEvent EVENT_GOT_TOWN_MAP
	jr nz, .haveMap
	call .rivalPart1
	jr .rivalPart2
.haveMap
	ld hl, CeladonMartCallRivalText2
	rst _PrintText
	call .rivalPart1
	ld hl, CeladonMartCallRivalText3map
	rst _PrintText
.rivalPart2
	ld a, SFX_NOISE_INSTRUMENT04
	rst _PlaySound
	ld a, SFX_NOISE_INSTRUMENT05
	call PlaySoundWaitForCurrent
	ld hl, CeladonMartCallRivalText4
	rst _PrintText
	ret
.rivalPart1
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld hl, CeladonMartCallRivalText3
	rst _PrintText
	SetEvent EVENT_CALLED_RIVAL_FROM_CELADON
	; make sure daisy sitting is the NPC that is shown because she can be walking around at this point
	ld c, TOGGLE_DAISY_SITTING
	call ShowObject
	ld c, TOGGLE_DAISY_WALKING
	jp HideObject

CeladonMartCallRivalText:
	text_far_end _CeladonMartCallRivalText

CeladonMartCallRivalText2:
	text_far_end _CeladonMartCallRivalText2

CeladonMartCallRivalText3:
	text_far_end _CeladonMartCallRivalText3

CeladonMartCallRivalText3map:
	text_far_end _CeladonMartCallRivalText3map

CeladonMartCallRivalText4:
	text_far_end _CeladonMartCallRivalText4
