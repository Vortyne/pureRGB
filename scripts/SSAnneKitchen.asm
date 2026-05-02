; PureRGBnote: ADDED: You can now eat in the SS Anne Kitchen.
SSAnneKitchen_Script:
	call EnableAutoTextBoxDrawing
	call WasMapJustLoaded
	jr z, .notLoaded
.reroll
	; get a random value which will decide what text the randomized text chef will say first.
	call Random
	and %00000011
	jr z, .reroll
	ld [wMapMultiTextTracker], a
.notLoaded
	CheckEvent EVENT_GENERIC_NPC_WALKING_FLAG
	ret z
	call DisableAllJoypad
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, SSANNEKITCHEN_WAITER
	call GetMapSpriteLocation
	ld a, e
	cp 7
	jr nz, .done
	; Hide waiter sprite, then wait a bit
	ld c, SSANNEKITCHEN_WAITER
	lb de, 12, 12
	callfar FarMoveSpriteOffScreen
	call UpdateSprites
	ld c, 60
	rst _DelayFrames
	ld c, SSANNEKITCHEN_WAITER
	lb de, 6, 0
	callfar FarMoveSpriteInRelationToPlayer
	; Make Waiter come back
	ld de, MovementWaiterWalksLeft
	ld hl, wNPCMovementDirections2
	call DecodeRLEList
	ld a, SSANNEKITCHEN_WAITER
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	jpfar MoveSprite
.done
	ResetEvent EVENT_GENERIC_NPC_WALKING_FLAG
	; Waiter done walking
	ld d, SSANNEKITCHEN_WAITER
	callfar FarNPCSpriteQuickSpin
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, $2B
	call KitchenReplaceFoodTileBlock
	ld a, SFX_NOISE_INSTRUMENT02
	rst _PlaySound
	ld a, SFX_59
	call PlaySoundWaitForCurrent
	ld c, 60
	rst _DelayFrames
	call EnableAllJoypad
	ld a, TEXT_SSANNEKITCHEN_WAITER_RETURNS
	ldh [hTextID], a
	jp DisplayTextID


SSAnneKitchen_TextPointers:
	def_text_pointers
	dw_const SSAnneKitchenCook1Text, TEXT_SSANNEKITCHEN_COOK1
	dw_const SSAnneKitchenCook2Text, TEXT_SSANNEKITCHEN_COOK2
	dw_const SSAnneKitchenCook3Text, TEXT_SSANNEKITCHEN_COOK3
	dw_const SSAnneKitchenCook4Text, TEXT_SSANNEKITCHEN_COOK4
	dw_const SSAnneKitchenCook5Text, TEXT_SSANNEKITCHEN_COOK5
	dw_const SSAnneKitchenCook6Text, TEXT_SSANNEKITCHEN_COOK6
	dw_const SSAnneKitchenCook7Text, TEXT_SSANNEKITCHEN_COOK7
	dw_const SSAnneKitchenWaiterText, TEXT_SSANNEKITCHEN_WAITER
	dw_const SSAnneKitchenOnlyTrashHereText, TEXT_SSANNEKITCHEN_ONLY_TRASH_HERE
	dw_const SSAnneKitchenWaiterReturnsText, TEXT_SSANNEKITCHEN_WAITER_RETURNS

SSAnneKitchenCook1Text:
	text_far _SSAnneKitchenCook1Text
	text_end

SSAnneKitchenCook2Text:
	text_far _SSAnneKitchenCook2Text
	text_end

SSAnneKitchenCook3Text:
	text_far _SSAnneKitchenCook3Text
	text_end

SSAnneKitchenCook4Text:
	text_far _SSAnneKitchenCook4Text
	text_end

SSAnneKitchenCook5Text:
	text_far _SSAnneKitchenCook5Text
	text_end

SSAnneKitchenCook6Text:
	text_far _SSAnneKitchenCook6Text
	text_end

SSAnneKitchenCook7Text:
	text_asm
	ld hl, .MainCourseIsText
	rst _PrintText
	ld a, [wMapMultiTextTracker]
	dec a
	push af
	ld hl, .SalmonDuSaladText
	ld bc, 5
	call AddNTimes
	pop af
	jr nz, .not0
	ld a, 3
.not0
	ld [wMapMultiTextTracker], a
	rst _PrintText
	rst TextScriptEnd

.MainCourseIsText:
	text_far _SSAnneKitchenCook7MainCourseIsText
	text_end

; keep these 3 text entries next to each other and in the same format
.SalmonDuSaladText:
	text_far SSAnneKitchenCook7SalmonDuSaladText
	text_end
.EelsAuBarbecueText:
	text_far SSAnneKitchenCook7EelsAuBarbecueText
	text_end
.PrimeBeefSteakText:
	text_far SSAnneKitchenCook7PrimeBeefSteakText
	text_end

SSAnneKitchenWaiterText:
	text_far _SSAnneKitchenWaiter
	text_asm
	call YesNoChoice
	jr nz, .suitYourself
	ld a, [wYCoord]
	cp 13
	jr nz, .haveSeat
	ld a, [wXCoord]
	cp 1
	jr nz, .haveSeat
	; player is in seat
	ld hl, .whatWouldYouLike
	rst _PrintText
	call SaveScreenTilesToBuffer2
	ld hl, SSAnneFoodMenu
	ld b, PAD_A | PAD_B
	call DisplayMultiChoiceTextBox
	call LoadScreenTilesFromBuffer2
	call Delay3
	jr nz, .suitYourself
	ld hl, .comingRightUp
	rst _PrintText
	ld de, MovementWaiterWalksRight
	ld hl, wNPCMovementDirections2
	call DecodeRLEList
	SetEvent EVENT_GENERIC_NPC_WALKING_FLAG
	ld a, SSANNEKITCHEN_WAITER
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	callfar MoveSpriteButAllowAOrBPress
	rst TextScriptEnd
.suitYourself
	ld hl, .suitYourselfText
	jr .printDone
.haveSeat
	ld a, SSANNEKITCHEN_WAITER
	call SetSpriteFacingLeft
	ld hl, .haveSeatText
.printDone
	rst _PrintText
	rst TextScriptEnd
.suitYourselfText
	text_far _FossilGuyDenied
	text_end
.haveSeatText
	text_far _SSAnneKitchenWaiterHaveSeat
	text_end
.whatWouldYouLike
	text_far _WhatWouldYouLikeText
	text_end
.comingRightUp
	text_far _SSAnneKitchenWaiterComingRightUp
	text_end

SSAnneKitchenWaiterReturnsText:
	text_far _MomFoodBonAppetit
	text_asm
	call GBFadeOutToWhite
	callfar MomHealPokemonImmediate
	ld a, $3F
	call KitchenReplaceFoodTileBlock
	call GBFadeInFromWhite
	ld a, SSANNEKITCHEN_WAITER
	call SetSpriteFacingLeft
	ld hl, .comeAgain
	rst _PrintText
	rst TextScriptEnd
.comeAgain
	text_far _CableClubNPCPleaseComeAgainText
	text_end

KitchenReplaceFoodTileBlock:
	lb bc, 7, 0
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

MovementWaiterWalksRight:
	db NPC_MOVEMENT_RIGHT, 5
	db -1

MovementWaiterWalksLeft:
	db NPC_MOVEMENT_LEFT, 5
	db -1

; output hl = pointer to sprite location data
; output d = y location e = x location
FarGetMapSpriteLocation::
	ld a, d
GetMapSpriteLocation::
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA2_MAPY
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData2
	ld a, [hli]
	sub 4
	ld d, a
	ld a, [hld]
	sub 4
	ld e, a
	ret

SSAnneKitchenOnlyTrashHereText:
	text_far _VermilionGymTrashText
	text_end
