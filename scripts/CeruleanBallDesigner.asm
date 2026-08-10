CeruleanBallDesigner_Script:
	call WasMapJustLoaded
	call nz, CeruleanBallDesignerLoadExtraTiles
	jp EnableAutoTextBoxDrawing

CeruleanBallDesignerLoadExtraTiles::
	ld hl, vTileset tile $2C
	ld de, HouseBetaTiles
	lb bc, BANK(HouseBetaTiles), 8
	call CopyVideoData
	ld hl, vTileset tile $3C
	ld de, SmallPCPic
	lb bc, BANK(SmallPCPic), 4
	call CopyVideoData
	; fall through
CeruleanBallDesignerLoadExtraSprites::
	ld a, [wXCoord]
	cp 14
	ld b, 0
	jr c, .skip
	CheckExtraHideShowState TOGGLE_CERULEAN_BALL_DESIGNER_CAMERA
	ld b, 3
	jr nz, .skip
	ld hl, vNPCSprites tile $7C
	ld de, CameraSprite
	lb bc, BANK(CameraSprite), 4
	call CopyVideoData
	ld b, 3
.skip
	ld a, [wOnSGB]
	and a
	ret nz
	; on GB we will darken the palette in this room since we dont have the dark red color to use
	ld a, b
	ld [wMapPalOffset], a
	jp LoadGBPal

CeruleanBallDesigner_TextPointers:
	def_text_pointers
	dba_const CeruleanBallDesignerDesignerText, TEXT_CERULEANBALLDESIGNER_DESIGNER
	dba_const TextScriptEnd, TEXT_CERULEANBALLDESIGNER_NONE
	dba_const TextScriptEnd, TEXT_CERULEANBALLDESIGNER_NONE2
	dba_const TextScriptEnd, TEXT_CERULEANBALLDESIGNER_NONE3
	dba_const _CeruleanBallDesignerBlankPokeballText, TEXT_CERULEANBALLDESIGNER_BALL
	dba_const CeruleanBallDesignerClipboardText, TEXT_CERULEANBALLDESIGNER_CLIPBOARD
	dba_const CeruleanBallDesignerCameraText, TEXT_CERULEANBALLDESIGNER_CAMERA
	dba_const CeruleanBallDesignerClipboard2Text, TEXT_CERULEANBALLDESIGNER_CLIPBOARD2
	dba_const CeruleanBallDesignerCustomizeBallMenu, TEXT_CERULEANBALLDESIGNER_BALL_CUSTOMIZE
	dba_const CeruleanBallDesignerSwitchBallMenu, TEXT_CERULEANBALLDESIGNER_BALL_SWITCH
	dba_const _CeruleanBallDesignerDarkRoomSignText, TEXT_CERULEANBALLDESIGNER_DARK_ROOM_SIGN
	dba_const _CeruleanBallDesignerBallDisplayText, TEXT_CERULEANBALLDESIGNER_BALL_DISPLAY1
	dba_const _CeruleanBallDesignerBallDisplayText, TEXT_CERULEANBALLDESIGNER_BALL_DISPLAY2
	dba_const _CeruleanBallDesignerPhotosText, TEXT_CERULEANBALLDESIGNER_PHOTOS1
	dba_const _CeruleanBallDesignerPhotosText, TEXT_CERULEANBALLDESIGNER_PHOTOS2
	dba_const _CeruleanBallDesignerSinkText, TEXT_CERULEANBALLDESIGNER_SINK1
	dba_const _CeruleanBallDesignerSinkText, TEXT_CERULEANBALLDESIGNER_SINK2
	dba_const _CeruleanBallDesignerPosterText, TEXT_CERULEANBALLDESIGNER_POSTER
	dba_const _CeruleanBallDesignerBookshelfText, TEXT_CERULEANBALLDESIGNER_BOOKSHELF
	dba_const CeruleanBallDesignerPCText, TEXT_CERULEANBALLDESIGNER_PC

CeruleanBallDesignerCameraText:
	text_asm
	CheckEvent EVENT_BECAME_CERULEAN_BALL_DESIGNER_ASSISTANT
	ld hl, .camera
	ret z
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, .cameraphotos
	rst _PrintText
	lb bc, CAMERA, 1
	call GiveItem
	ld hl, .noMoreRoom
	jr nc, .printDone
	ld c, TOGGLE_CERULEAN_BALL_DESIGNER_CAMERA
	call HideExtraObject
	ld c, TOGGLE_CERULEAN_BALL_DESIGNER_CLIPBOARD
	call ShowExtraObject
	SetEvent EVENT_CERULEAN_BALL_DESIGNER_GOT_CAMERA
	ld hl, CeruleanBallDesignerDesignerText.received
.printDone
	rst _PrintText
	rst TextScriptEnd
.camera
	text_far_end _CeruleanBallDesignerCameraText
.cameraphotos
	text_far_end _CeruleanBallDesignerCamera2Text
.noMoreRoom
	text_far_end _NoMoreRoomForItemText


CeruleanBallDesignerClipboardText:
	text_asm
	callfar CeruleanBallDesignerPhotoHintMenu
	jp TextScriptEndNoButtonPress

CeruleanBallDesignerPCText:
	text_asm
	callfar OpenPokemonCenterPC
	rst TextScriptEnd

CeruleanBallDesignerDesignerText:
	text_asm
	CheckEvent EVENT_MET_CERULEAN_BALL_DESIGNER
	jr nz, .metOnce
	ld hl, .firstGreeting
	rst _PrintText
	lb bc, GREAT_BALL, 1
	call GiveItem
	ld hl, .noRoom
	jr nc, .printDone
	SetEvent EVENT_MET_CERULEAN_BALL_DESIGNER
	ld hl, .received
.printDone
	rst _PrintText
.done
	rst TextScriptEnd
.metOnce
	CheckEvent EVENT_CERULEAN_BALL_DESIGNER_HEARD_ABOUT_CLIPBOARD
	jr nz, .readyForPhotos
	CheckEvent EVENT_CERULEAN_BALL_DESIGNER_GOT_CAMERA
	jr nz, .gotCameraScript
	CheckEvent EVENT_BECAME_CERULEAN_BALL_DESIGNER_ASSISTANT
	ld hl, .goGetCamera
	jr nz, .printDone
	ld hl, .brainstorming
	rst _PrintText
	call YesNoChoice
	jr nz, .endNoButtonPress
	SetEvent EVENT_BECAME_CERULEAN_BALL_DESIGNER_ASSISTANT
	ld hl, .becameAssistant
	rst _PrintText
	rst TextScriptEnd
.endNoButtonPress
	jp TextScriptEndNoButtonPress
.gotCameraScript
	SetEvent EVENT_CERULEAN_BALL_DESIGNER_HEARD_ABOUT_CLIPBOARD
	ld hl, .gotCamera
	jr .printDone
.readyForPhotos
	ld hl, wCustomBallUnlockFlags
	ld a, $FF
	cp [hl]
	jr nz, .notAllBallsUnlocked
	inc hl
	cp [hl]
	jr nz, .notAllBallsUnlocked
	; all custom balls unlocked
	ld hl, .thanksForHelpMakeYourOwn
	rst _PrintText
	CheckExtraHideShowState TOGGLE_CERULEAN_BALL_DESIGNER_CAMERA
	jr z, .done
	call DisplayTextPromptButton
	ld hl, .cameraBack
	rst _PrintText
	call YesNoChoice
	jr nz, .endNoButtonPress
	jr .giveBackCamera
.notAllBallsUnlocked
	call .checkForBallUnlockEvent
	jr c, .ballUnlockEvent
	ld hl, .byTheWayChangeBall
	jr .printDone
.giveBackCamera
	ld b, CAMERA
	call IsItemInBag
	ld hl, .cameraInPC
	jr z, .printDone
	ld a, CAMERA
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld c, TOGGLE_CERULEAN_BALL_DESIGNER_CAMERA
	call ShowExtraObject
	ld hl, .thanksBorrowCameraAgain
	rst _PrintText
	rst TextScriptEnd
.ballUnlockEvent
	push af
	ld hl, .aNewPhoto
	rst _PrintText
	pop af
	push af
	; two possible pics for this ball
	cp BALL_ID_SUBZERO
	jr nz, .noDragonairCheck
	CheckEventHL EVENT_SNAPPED_PIC_OF_DRAGONAIR
	jr z, .noDragonairCheck
	ld a, 16 ; dragonair pic
.noDragonairCheck
	ld d, a
	callfar ShowCustomBallUnlockPicture
	pop af
	push af
	ld hl, BallDesignerPictureReactions
	ld bc, TEXT_FAR_TABLE_ENTRY_SIZE
	call AddNTimes
	rst _PrintText
	; reload from image
	callfar ReloadAfterCameraPic
	; ball designer writes on her paper
	ld hl, .wait
	rst _PrintText
	call CeruleanBallDesignerGetsAnIdeaAnimation
	call PauseMusic
	ld hl, .eureka
	rst _PrintText
	call CeruleanBallDesignerZoomsAwayAnimation
	call ResumeMusic
	callfar CopyCustomBallNamesFromSRAM
	pop af
	push af
	ld d, a
	callfar CopyFullCustomBallNameToStringBuffer
	ld hl, .designedBall
	rst _PrintText
	ld c, TOGGLE_CERULEAN_BALL_DESIGNER_CLIPBOARD2
	call ShowExtraObject
	SetEvent EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	pop af
	ld b, FLAG_SET
	ld c, a
	ld hl, wCustomBallUnlockFlags
	call FlagAction
	rst TextScriptEnd
.checkForBallUnlockEvent
	; compare unlocked custom balls to snapped pictures, if we've snapped one but not unlocked it, do the associated unlock event
	ld c, 0
	ld b, FLAG_TEST
.loopTestBallUnlocks
	push bc
	ld hl, wCustomBallPhotoSnappedFlags
	call FlagAction
	pop bc
	jr z, .goToNextBall
	push bc
	ld hl, wCustomBallUnlockFlags
	call FlagAction
	pop bc
	jr z, .foundNotUnlockedBall
.goToNextBall
	inc c
	ld a, c
	cp 16
	ret z
	jr .loopTestBallUnlocks
.foundNotUnlockedBall
	ld a, c
	; a = which ball should have its unlock event triggered from 0 to 15
	scf
	ret
.firstGreeting
	text_far_end _CeruleanBallDesignerDesignerGreeting
.noRoom
	text_far_end _LastTwoGurusTextBagFull
.received
	text_far _GenericReceivedItemA
	sound_get_item_1
	text_end
.brainstorming
	text_far_end _CeruleanBallDesignerDesignerSecondTime
.becameAssistant
	text_far_end _CeruleanBallDesignerDesignerBecameAssistant
.goGetCamera
	text_far_end _CeruleanBallDesignerGoGetCamera
.gotCamera
	text_far_end _CeruleanBallDesignerDesignerGotCamera
.byTheWayChangeBall
	text_far_end _CeruleanBallDesignerDesignerWaitingForPhotos
.aNewPhoto
	text_far_end _CeruleanBallDesignerNewPhoto
.wait
	text_far_end _CeruleanBallDesignerWait
.eureka
	text_far_end _CeruleanBallDesignerEureka
.designedBall
	text_far _CeruleanBallDesignerDesigned
	sound_get_item_2
	text_far_end _CeruleanBallDesignerDesigned2
.thanksForHelpMakeYourOwn
	text_far_end _CeruleanBallDesignerThanksForHelp
.cameraBack
	text_far_end _BallDesignerCameraBack
.cameraInPC
	text_far_end _BallDesignerCameraBackPC
.thanksBorrowCameraAgain
	text_far_end _BallDesignerCameraBorrowAgain

CeruleanBallDesignerGetsAnIdeaAnimation:
	ld a, CERULEANBALLDESIGNER_DESIGNER
	call SetSpriteFacingDown
	call UpdateSpritesAndDelay3
	ld a, SFX_FLY
	rst _PlaySound
	lb bc, SPRITESTATEDATA1_XPIXELS, CERULEANBALLDESIGNER_DESIGNER
	call GetFromSpriteStateData1
	ld b, 4
	ld c, 0
	ld d, [hl]
.loopWriting
	ld a, c
	xor 1
	ld c, a
	push bc
	ld a, d
	ld b, -1
	jr z, .loopWritingNext
	ld b, 1
.loopWritingNext
	add b
	ld [hl], a
	ld c, 10
	rst DelayFrames
	pop bc
	dec b
	jr nz, .loopWriting
	ld [hl], d
	rst _DelayFrame
	ld c, 60
	rst DelayFrames
	ld a, CERULEANBALLDESIGNER_DESIGNER
	call SetSpriteFacingUp
	call UpdateSprites
	ld b, BANK(ExclamationBubbleSFX)
	call MuteAudioAndChangeAudioBank
	call .emotionBubble
	call DisableSpriteUpdates
	ld de, wShadowOAMSprite04
	callfar FlipSpriteOAM
	call .emotionBubble
	call EnableSpriteUpdates
	call .emotionBubble
	call UnmuteAudioAndRestoreAudioBank
	ret
.emotionBubble
	ld de, ExclamationBubbleSFX
	call PlayNewSoundChannel5
	ld a, CERULEANBALLDESIGNER_DESIGNER
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
  	ld [wWhichEmotionBubble], a
	jpfar EmotionBubbleVeryFast

CeruleanBallDesignerZoomsAwayAnimation:
	ld a, [wXCoord]
	cp 7
	ld b, 0
	jr nz, .skipPlayerUpdate
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSpritesAndDelay3
	ld b, 1
.skipPlayerUpdate
	call DisableSpriteUpdates
	ld hl, wShadowOAMSprite04
	ld d, [hl]
	inc hl
	ld e, [hl]
	dec hl
	ld c, 47
.loopMoveLeft
	ld a, b
	and a
	push bc
	jr z, .noPlayerMove2
	ld a, c
	cp 39
	jr c, .noPlayerMove2
	push de
	ld hl, wShadowOAMSprite00
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc d
	inc d 
	ld c, 0
	callfar LoadSpecificOAMSpriteCoords
	pop de
.noPlayerMove2
	dec e
	dec e
	ld c, 4
	callfar LoadSpecificOAMSpriteCoords
	rst _DelayFrame
	pop bc
	dec c
	jr nz, .loopMoveLeft
	call GBFadeOutToBlack
	call EnableSpriteUpdates
	ld d, CERULEANBALLDESIGNER_DESIGNER
	callfar MakeSpriteFacePlayer
	ld a, [wXCoord]
	cp 7
	jr nz, .noPlayerMove3
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
.noPlayerMove3
	call UpdateSprites
	ld a, 40 ; 40 random sound effects will play
.loopPlayRandomSounds
	push af
	call StopSFXChannels
	ld hl, BallDesignerRandomSounds
	call Random
	and %111
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	rst _PlaySound
	call Random
	and %11
	add 4 ; between 4 and 8 frames delay
	ld c, a
	rst DelayFrames
	pop af
	dec a
	jr nz, .loopPlayRandomSounds
	ld c, 30
	rst DelayFrames
	ld a, SFX_GET_ITEM_1
	rst _PlaySound
	call WaitForSoundToFinish
	call ClearTextBox
	jp GBFadeInFromBlack

BallDesignerRandomSounds:
	db SFX_TRADE_MACHINE
	db SFX_SWITCH
	db SFX_LEDGE
	db SFX_SWAP
	db SFX_59
	db SFX_HEALING_MACHINE
	db SFX_TELEPORT_ENTER_2
	db SFX_ARROW_TILES

CeruleanBallDesignerClipboard2Text:
	text_far _NeedWorkBenchInfo
	text_asm
	xor a
	ld [wCurrentMenuItem], a
.loopMenu
	call DisableTextDelay
	hlcoord 5, 6
	lb bc, 5, 13
	call TextBoxBorderUpdateSprites
	hlcoord 7, 7
	ld de, WorkbenchInfoText
	call PlaceString
	ld a, 2
	ld [wMaxMenuItem], a
	ld a, 6
	ld [wTopMenuItemX], a
	ld a, 7
	ld [wTopMenuItemY], a
	xor a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	call HandleMenuInput
	call EnableTextDelay
	ldh a, [hJoy5]
	bit B_PAD_B, a
	jp nz, TextScriptEndNoButtonPress
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld bc, 4
	ld hl, WorkbenchInfoBasic
	call AddNTimes
	rst _PrintText
	call ClearTextBox
	jr .loopMenu

WorkbenchInfoText:
	db   "Basic Info"
	next "Changing"
	next "Customizing@"

;;;; keep these 3 text references in the same order with nothing in between
WorkbenchInfoBasic::
	text_far_end _WorkbenchInfoBasic

WorkbenchInfoChangingBalls:
	text_far_end _WorkbenchInfoChangingBalls

WorkbenchInfoCustomizingBalls:
	text_far_end _WorkbenchInfoCustomizingBalls
;;;;

CeruleanBallDesignerSwitchBallMenu:
	text_far _CeruleanBallDesignerSwitchBallMenuStart
	text_asm
	call YesNoChoice
	jp nz, TextScriptEndNoButtonPress
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	jp nz, TextScriptEndNoButtonPress
	xor a
	ld [wWhichCustomBallSelected], a
	CheckEvent EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	jr nz, .foundBall
	; check if player has any balls in their bag to switch into
	ld hl, BallItemsToCheck
.loop
	ld b, [hl]
	push hl
	call IsItemInBag
	pop hl
	jr nz, .foundBall
	inc hl
	ld a, [hl]
	cp -1
	jr nz, .loop
.didntFindBall
	ld hl, .noBallsToSwitch
.printDone
	rst _PrintText
	rst TextScriptEnd
.foundBall
	call ClearTextBox
	call SaveScreenTilesToBuffer2
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	dec a
	ld [wUpdateSpritesEnabled], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call ReloadTilesetTilePatterns
	call CeruleanBallDesignerLoadExtraTiles
	call LoadGBPal
	pop af
	jp c, TextScriptEndNoButtonPress
	call DisableTextDelay
	hlcoord 3, 3
	lb bc, 7, 15
	call TextBoxBorder
	hlcoord 3, 0
	lb bc, 1, 15
	call TextBoxBorder
	hlcoord 4, 1
	ld de, .chooseNewBall
	call PlaceString
	CheckEvent EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	jr z, .skipFirstEntryCustomBall
	callfar CopyCustomBallNamesFromSRAM
	hlcoord 5, 4
	ld de, .customBallOptionText
	call PlaceString
.skipFirstEntryCustomBall
	; get the ball the current pokemon chosen is in
	ld hl, wItemList
	ld [hl], -1
	call .getSelectedMonFlags
	; a = which BALL_DATA constant the pokemon is using
	cp FIRST_CUSTOM_BALL_DATA_CONST
	jr c, .notCustomBall
	sub FIRST_CUSTOM_BALL_DATA_CONST
	ld d, a
	callfar CopyFullCustomBallNameToNameBuffer
	ld c, $FF ; $ff = source ball is a custom ball
	push bc
	jr .gotSourceBallName
.notCustomBall
	ld hl, BallItemsToCheck
	ld d, 0
	ld e, a
	add hl, de
	ld c, [hl] ; c = which ball the pokemon chosen is in
	push bc
	ld a, c
	ld [wNamedObjectIndex], a
	call GetItemName
	pop bc
	push bc
	ld a, c
	cp MASTER_BALL
	jr z, .warningSourceBall
	cp HYPER_BALL
	jr z, .warningSourceBall
	jr .gotSourceBallName
.warningSourceBall
	call EnableTextDelay
	ld hl, .warningSourceBallText
	rst _PrintText
	call YesNoChoice
	call DisableTextDelay
	jr z, .gotSourceBallName
	pop bc
	jp .exitNoButtonPress
.gotSourceBallName
	ld hl, .currentlyInA
	rst _PrintText
	pop bc
	CheckEvent EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	decoord 5, 5
	jr nz, .gotMenuBaseCoord
	decoord 5, 4
.gotMenuBaseCoord
	ld hl, BallItemsToCheck
.loopAddBallNames
	ld a, [hl]
	ld b, a
	push hl
	push bc
	call IsItemInBag
	jr z, .skipAddBallName
	pop bc
	ld hl, wItemList
.loopFindLastEntryInItemList
	ld a, [hli]
	cp -1
	jr nz, .loopFindLastEntryInItemList
	ld a, -1
	ld [hld], a
	ld [hl], b
	; write the pokeball name at decoord
	ld a, b
	ld [wNamedObjectIndex], a
	push bc
	ld h, d
	ld l, e
	call GetItemName
	; de = wNameBuffer, hl = coord
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld d, h
	ld e, l
.skipAddBallName
	pop bc
	pop hl
	inc hl
	ld a, [hl]
	cp -1
	jr nz, .loopAddBallNames
	push bc
	call Delay3
.reshowBallList
	xor a
	ld [wCurrentMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wLastMenuItem], a
	inc a
	ldh [hJoy7], a
	ld [wMenuWrappingEnabled], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 4
	ld [wTopMenuItemY], a
	ld a, 4
	ld [wTopMenuItemX], a
	CheckEvent EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	ld b, -1
	jr nz, .gotInitialMaxItemCount
	dec b
.gotInitialMaxItemCount
	ld hl, wItemList
.loopFindMaxMenuItem
	ld a, [hli]
	inc b
	cp -1
	jr nz, .loopFindMaxMenuItem
	ld a, b
	ld [wMaxMenuItem], a
.selectBall
	ld hl, hUILayoutFlags
	set BIT_DOUBLE_SPACED_MENU, [hl]
	call HandleMenuInput
	ld hl, hUILayoutFlags
	res BIT_DOUBLE_SPACED_MENU, [hl]
	xor a
	ldh [hJoy7], a
	pop bc
	ldh a, [hJoy5]
	bit B_PAD_B, a
	jp nz, .exitNoButtonPress
	ld a, [wCurrentMenuItem]
	CheckEventHL EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	jr z, .skipCustomBallMenu
	and a
	jr nz, .notCustomBallMenu
	push bc
	call SaveScreenTilesToBuffer2
	callfar ChooseCustomBallMenu
	ld a, [wWhichCustomBallSelected]
	and a
	jr nz, .tryGiveBackBall
	call LoadScreenTilesFromBuffer2
	jr .reshowBallList
.notCustomBallMenu
	dec a
.skipCustomBallMenu
	ld hl, wItemList
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp c
	jp z, .alreadyInIt
	ld b, a ; b = target ball
	push bc
	ld a, b
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
	pop bc
	push bc
	ld a, b
	cp MASTER_BALL
	jr z, .showTargetBallWarning
	cp HYPER_BALL
	jr z, .showTargetBallWarning
	jr .skipTargetBallWarning
.showTargetBallWarning
	push bc
	call EnableTextDelay
	call SaveScreenTilesToBuffer2
	ld hl, .targetBallWarningText
	rst _PrintText
	call YesNoChoice
	call DisableTextDelay
	pop bc
	jr z, .skipTargetBallWarning
	call LoadScreenTilesFromBuffer2
	hlcoord 4, 4
	lb bc, 7, 1
	call ClearScreenArea
	jp .reshowBallList
.skipTargetBallWarning
	ld a, [wWhichPokemon]
	push af
	ld a, b
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	pop af
	ld [wWhichPokemon], a
.tryGiveBackBall
	pop bc
	ld a, c
	cp $FF ; source ball was custom ball
	jr z, .skipGiveBackBall
	cp HYPER_BALL
	jr z, .skipGiveBackBall
	cp MASTER_BALL
	jr z, .skipGiveBackBall
	push bc
	ld b, c ; c = source ball
	ld c, 1
	call GiveItem
	pop bc
	jr nc, .noRoom
.skipGiveBackBall
	call .getSelectedMonFlags
	ld a, [hl]
	and %111
	ld d, a
	ld a, [wWhichCustomBallSelected]
	and a
	jr z, .notCustomBall2
	add FIRST_CUSTOM_BALL_DATA_CONST - 1
	and %00011111
	rla
	rla
	rla
	jr .gotBallData
.notCustomBall2
	push de
	push hl
	ld hl, BallDataMap2 - 1
	ld d, 0
	ld e, b
	add hl, de
	ld a, [hl]
	pop hl
	pop de
.gotBallData
	or d
	ld [hl], a
	push bc
	ld a, [wWhichCustomBallSelected]
	and a
	jr z, .ballNameIsntCustomBall
	dec a
	ld d, a
	callfar CopyFullCustomBallNameToStringBuffer
	jr .ballNameCopied
.ballNameIsntCustomBall
	ld a, b
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
.ballNameCopied
	call GetPartyMonName2
	call EnableTextDelay
	ld hl, .changed
	rst _PrintText
	ld a, SFX_TRADE_MACHINE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	pop bc
	ld a, c ; c = source ball
	cp $FF ; $FF = source ball was custom ball
	jr z, .exit
	cp HYPER_BALL
	jr z, .exit
	cp MASTER_BALL
	jr z, .exit
	ld [wNamedObjectIndex], a
	call GetItemName
	call DisplayTextPromptButton
	ld hl, .changed2
	rst _PrintText
	jr .exit
.noRoom
	ld a, [wWhichCustomBallSelected]
	and a
	jr nz, .skipGiveBackTarget
	ld c, 1
	call GiveItem ; give back target ball since player had no room
.skipGiveBackTarget
	ld hl, .noRoomText
	jr .printDone2
.exit
	call EnableTextDelay
	rst TextScriptEnd
.alreadyInIt
	push bc
	ld hl, .already
	rst _PrintText
	jp .selectBall
.printDone2
	rst _PrintText
	rst TextScriptEnd
.getSelectedMonFlags
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Flags
	and a
	jr z, .gotFlags
	ld de, wPartyMon2Flags - wPartyMon1Flags
.loopIterateParty
	add hl, de
	dec a
	jr nz, .loopIterateParty
.gotFlags
	ld a, [hl]
	rra
	rra
	rra
	and %11111
	cp PAST_LAST_CUSTOM_BALL_DATA_CONST
	ret c
	xor a ; force it to be considered a pokeball if an invalid value
	ret
.exitNoButtonPress
	call EnableTextDelay
	jp TextScriptEndNoButtonPress
.noBallsToSwitch
	text_far_end _NoBallsToSwitch
.currentlyInA
	text_far_end _CurrentlyInABall
.already
	text_far_end _AlreadyInThatBall
.noRoomText
	text_far_end _NoRoomForBall
.changed
	text_far_end _ChangedBallText1
.changed2
	text_far_end _ChangedBallText2
.warningSourceBallText
	text_far_end _ChangeOutOfWarning
.targetBallWarningText
	text_far_end _ChangeIntoWarning
.chooseNewBall
	db "Choose a BALL!@"
.customBallOptionText
	db "CUSTOM BALL@"

BallItemsToCheck:
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db SAFARI_BALL
	db HYPER_BALL
	db MASTER_BALL
	db -1

BallDataMap2: 
	db BALL_DATA_MASTER << 3
	db BALL_DATA_ULTRA << 3
	db BALL_DATA_GREAT << 3
	db BALL_DATA_POKE << 3
	db BALL_DATA_HYPER << 3
	db 0
	db 0
	db BALL_DATA_SAFARI << 3

CeruleanBallDesignerCustomizeBallMenu:
	text_asm
	CheckEvent EVENT_UNLOCKED_AT_LEAST_ONE_CUSTOM_BALL
	ld hl, .doodads
	ret z
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	jr nz, .done
	ld hl, .customize
	rst _PrintText
	call YesNoChoice
	jr nz, .done
  	call ClearTextBox
	xor a
	ld [wCurrentMenuItem], a
	callfar CopyCustomBallNamesFromSRAM
  .loopBallSelection
  	hlcoord 0, 0
  	lb bc, 18, 2
  	call ClearScreenArea
	callfar ChooseCustomBallMenu
	ld a, [wWhichCustomBallSelected]
	and a
	jr z, .done
	callfar BallCustomizationMenu
	jr .loopBallSelection
.done
	jp TextScriptEndNoButtonPress
.customize
	text_far_end _CeruleanBallDesignerCustomizeBallMenuStart
.doodads
	text_far_end _CeruleanBallDesignerBenchCustomizeNoPermission

InitializeCustomPokeballData::
	; initialize the custom pokeball names in the sram save data. We cannot permanently store them in wram due to their size.
	; instead we will copy them over to wram only when displaying the customization menus.
	ld a, RAMG_SRAM_ENABLE
  	ld [rRAMG], a
  	ld a, $1
  	ld [rBMODE], a
  	xor a
	ld [rRAMB], a
	; initialize the ball names to be blank
	ld hl, sCustomBallNames
	ld a, '@'
	ld bc, NUM_CUSTOM_BALLS * NAME_LENGTH
	call FillMemory
	; then copy over the default names
	lb bc, NUM_CUSTOM_BALLS, NAME_LENGTH
	ld hl, sCustomBallNames
	ld de, InitialCustomBallNames
.loopCopyNames
	push hl
	call CopyString
	pop hl
	push bc
	ld b, 0
	add hl, bc
	pop bc 
	dec b
	jr nz, .loopCopyNames
   	xor a
  	ld [rBMODE], a
  	ld [rRAMG], a
  	; also initialize the data associated with them, aka the settings for each ball that can be customized
  	ld hl, InitialCustomBallData
  	ld de, wCustomPokeballSettings
  	ld bc, NUM_CUSTOM_BALLS * CUSTOM_BALL_DATA_SIZE
  	rst _CopyData
  	ret

BallDesignerPictureReactions:
BallDesignerPokemonBreederReaction:
	text_far_end _BallDesignerPokemonBreederReaction

BallDesignerPsyduckReaction::
	text_far_end _BallDesignerPsyduckReaction

BallDesignerFlareonReaction::
	text_far_end _BallDesignerFlareonReaction

BallDesignerJigglypuffReaction::
	text_far_end _BallDesignerJigglypuffReaction

BallDesignerJolteonReaction::
	text_far_end _BallDesignerJolteonReaction

BallDesignerPorygonReaction::
	text_far_end _BallDesignerPorygonReaction

BallDesignerFossilReaction::
	text_far_end _BallDesignerFossilReaction

BallDesignerArticunoReaction::
	text_far_end _BallDesignerArticunoReaction

BallDesignerAbraReaction::
	text_far_end _BallDesignerAbraReaction

BallDesignerPidgeotReaction::
	text_far_end _BallDesignerPidgeotReaction

BallDesignerGrimerReaction::
	text_far_end _BallDesignerGrimerReaction

BallDesignerGastlyReaction::
	text_far_end _BallDesignerGastlyReaction

BallDesignerScytherReaction::
	text_far_end _BallDesignerScytherReaction

BallDesignerLassReaction::
	text_far_end _BallDesignerLassReaction

BallDesignerMankeyReaction::
	text_far_end _BallDesignerMankeyReaction

BallDesignerGamblerReaction::
	text_far_end _BallDesignerGamblerReaction

InitialCustomBallNames::
	db "FOREST@" 
	db "DRENCH@" 
	db "BLAZE@"  
	db "CUTE@"   
	db "BOLT@"   
	db "TRI@"   
	db "BOULDER@"
	db "SUBZERO@"
	db "MIND@"   
	db "TORNADO@"
	db "VENOM@"  
	db "SPOOKY@" 
	db "CLEAVE@" 
	db "ANGEL@"  
	db "BOMB@"   
	db "PRISM@"  

; c = which nybble
; d = which property to look for
IsBallPropertyUnlocked::
	push bc
	ld a, c
	and a
	ld hl, AutoUnlockedColors
	jr z, .check
	dec c
	ld hl, AutoUnlockedTiles
	jr z, .check
	dec c
	ld hl, AutoUnlockedSFX
	jr z, .check
	dec c
	ld hl, AutoUnlockedThrowAnims
	jr z, .check
	ld hl, AutoUnlockedPoofs
.check
	pop bc
	push bc
	push de
	ld a, d
	call IsInSingleByteArray
	pop de
	pop bc
	ret c
	; check which properties are unlocked by which custom balls
	ld hl, InitialCustomBallData
	ld b, 0
.loop
	push hl
	push bc
	ld e, 0
	ld b, 0
	srl c
	rl e
	add hl, bc
	ld a, [hl]
	dec e
	inc e
	jr z, .skipSwap
	swap a
.skipSwap
	and %1111
	cp d
	jr z, .foundBall
	pop bc
	pop hl
.continue
	inc hl
	inc hl
	inc hl
	inc b
	ld a, b
	cp 16
	jr nz, .loop
	and a
	ret
.foundBall
	pop bc
	push bc
	ld c, b
	ld b, FLAG_TEST
	ld hl, wCustomBallUnlockFlags
	call FlagAction
	pop bc
	pop hl
	jr z, .continue
	scf
	ret

AutoUnlockedThrowAnims:
	db BALL_THROW_NONE
	db BALL_THROW_APPEAR
	db BALL_THROW_SHAKE
	db BALL_THROW_VIBRATE
	db -1

AutoUnlockedSFX:
	db BALL_SFX_ORIGINAL
	db BALL_SFX_POWER_UP
	db -1

AutoUnlockedTiles:
	db BALL_TILE_SPHERE
	db BALL_TILE_SPARKLE
	db -1

AutoUnlockedPoofs:
	db BALL_POOF_ORIGINAL
	db -1

AutoUnlockedColors:
	db BALL_COLOR_WHITE
	db -1

; when you unlock custom balls, they have default settings for each one
InitialCustomBallData:
	; FOREST BALL
	dn BALL_TILE_LEAF, BALL_COLOR_GREEN
	dn BALL_THROW_ROLL, BALL_SFX_WHOOSH
	dn BALL_POOF_CIRCLE_SPREAD, %0000
	; DRENCH BALL
	dn BALL_TILE_DROPLET, BALL_COLOR_BLUE
	dn BALL_THROW_DROP, BALL_SFX_SQUIRT
	dn BALL_POOF_GRAVITY, %0000
	; BLAZE BALL
	dn BALL_TILE_FIRE, BALL_COLOR_RED
	dn BALL_THROW_THROW, BALL_SFX_EXPLODE
	dn BALL_POOF_SPREAD, %0000
	; CUTE BALL
	dn BALL_TILE_HEART, BALL_COLOR_PINK
	dn BALL_THROW_EMOTION, BALL_SFX_CUTE
	dn BALL_POOF_CIRCLE_AROUND, %0000
	; BOLT BALL
	dn BALL_TILE_BOLT, BALL_COLOR_YELLOW
	dn BALL_THROW_ZIGZAG, BALL_SFX_THUNDER
	dn BALL_POOF_STRIKE, %0001
	; TRI BALL
	dn BALL_TILE_TRI, BALL_COLOR_REDYELLOW
	dn BALL_THROW_THROW, BALL_SFX_MACHINE
	dn BALL_POOF_SCAN, %0000
	; BOULDER BALL
	dn BALL_TILE_ROCK, BALL_COLOR_GRAY
	dn BALL_THROW_BOUNCE, BALL_SFX_SMASH
	dn BALL_POOF_GRAVITY, %0000
	; SUBZERO BALL
	dn BALL_TILE_CRYSTAL, BALL_COLOR_CYAN
	dn BALL_THROW_SHAKE, BALL_SFX_ICY
	dn BALL_POOF_SPECKLE, %0010
	; MIND BALL
	dn BALL_TILE_EYE, BALL_COLOR_INDIGO
	dn BALL_THROW_THE_MERGING, BALL_SFX_PSY
	dn BALL_POOF_WINDMILL, %0110
	; TORNADO BALL
	dn BALL_TILE_CONE, BALL_COLOR_PALE
	dn BALL_THROW_FAKEOUT, BALL_SFX_WIND
	dn BALL_POOF_TORNADO, %0000
	; VENOM BALL
	dn BALL_TILE_DROPLET, BALL_COLOR_PURPLE
	dn BALL_THROW_VIBRATE, BALL_SFX_FLOOD
	dn BALL_POOF_SPIRAL, %0100
	; SPOOKY BALL
	dn BALL_TILE_GHOST, BALL_COLOR_CRIMSON
	dn BALL_THROW_THE_MERGING, BALL_SFX_EVIL
	dn BALL_POOF_HELIX, %0101
	; CLEAVE BALL
	dn BALL_TILE_SWORD, BALL_COLOR_GREENYELLOW
	dn BALL_THROW_SLICE, BALL_SFX_SHWING
	dn BALL_POOF_CRISSCROSS, %0000
	; ANGEL BALL
	dn BALL_TILE_SHINE, BALL_COLOR_YELLOW
	dn BALL_THROW_ANGELIC, BALL_SFX_SPARKLE
	dn BALL_POOF_CONFETTI, %0010
	; BOMB BALL
	dn BALL_TILE_SPHERE, BALL_COLOR_BLACK
	dn BALL_THROW_FLASH, BALL_SFX_EXPLODE
	dn BALL_POOF_EXPLOSION, %0000
	; PRISM BALL
	dn BALL_TILE_SKULL, BALL_COLOR_MULTI
	dn BALL_THROW_RANDOM, BALL_SFX_POWER_UP
	dn BALL_POOF_RANDOM, %0100
