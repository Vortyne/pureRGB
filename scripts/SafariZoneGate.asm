; PureRGBnote: ADDED: lots of code pertaining to the new safari zone game types.

SafariZoneGate_Script:
	ld hl, SafariZoneGate_ScriptPointers
	ld de, wSafariZoneGateCurScript
	jp CallMapScriptInTable

SafariZoneGate_ScriptPointers:
	def_script_pointers
	dw_const SafariZoneGateDefaultScript,                SCRIPT_SAFARIZONEGATE_DEFAULT
	dw_const SafariZoneGatePlayerMovingRightScript,      SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_RIGHT
	dw_const SafariZoneGateWouldYouLikeToJoinScript,     SCRIPT_SAFARIZONEGATE_WOULD_YOU_LIKE_TO_JOIN
	dw_const SafariZoneGatePlayerMovingUpScript,         SCRIPT_SAFARIZONEGATE_PLAYER_MOVING
	dw_const SafariZoneGatePlayerMovingDownScript,       SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	dw_const SafariZoneGateLeavingSafariScript,          SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	dw_const SafariZoneGateSetScriptAfterMoveScript,     SCRIPT_SAFARIZONEGATE_SET_SCRIPT_AFTER_MOVE
	dw_const SafariZoneGateScript7,                      SCRIPT_SAFARIZONEGATE_7
	EXPORT SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI ; used by engine/events/hidden_events/safari_game.asm

SafariZoneGateDefaultScript:
	ld hl, .PlayerNextToSafariZoneWorker1CoordsArray
	call ArePlayerCoordsInArray
	ret nc
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_1
	ldh [hTextID], a
	call DisplayTextID
	call DisableAllJoypad
	xor a
	ldh [hJoyHeld], a
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, [wCoordIndex]
	cp 1 ; index of second, lower entry in .PlayerNextToSafariZoneWorker1CoordsArray
	jr z, .player_not_next_to_worker
	ld a, SCRIPT_SAFARIZONEGATE_WOULD_YOU_LIKE_TO_JOIN
	ld [wSafariZoneGateCurScript], a
	ret
.player_not_next_to_worker
	ld a, PAD_RIGHT
	ld c, 1
	call SafariZoneEntranceAutoWalk
	call DisableDpad
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_RIGHT
	ld [wSafariZoneGateCurScript], a
	ret

.PlayerNextToSafariZoneWorker1CoordsArray:
	dbmapcoord  3,  2
	dbmapcoord  4,  2
	db -1 ; end

SafariZoneGatePlayerMovingRightScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
SafariZoneGateWouldYouLikeToJoinScript:
	call EnableAllJoypad
	ldh [hJoyHeld], a
	call UpdateSprites
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_WOULD_YOU_LIKE_TO_JOIN
	ldh [hTextID], a
	call DisplayTextID
	jp DisableAllJoypad

SafariZoneGatePlayerMovingUpScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	call EnableAllJoypad
	ld a, SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneGateLeavingSafariScript:
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	CheckAndResetEvent EVENT_SAFARI_GAME_OVER
	jr z, .leaving_early
	ResetEventReuseHL EVENT_IN_SAFARI_ZONE
	call UpdateSprites
	call DisableDpad
	ld a, [wSafariType]
	and a
	jr nz, .rangerHuntDone
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_GOOD_HAUL_COME_AGAIN
	jr .doneSafari
.rangerHuntDone
	ld a, [wNumRangersLeft] ; if wNumRangersLeft = 0 at the end of Ranger Hunt safari, we've defeated all rangers and won
	and a
	jr z, .rangerHuntSuccess
	ld a, TEXT_SAFARIZONEGATE_FAILED_RANGER_HUNT
	jr .doneSafari
.rangerHuntSuccess
	ld a, TEXT_SAFARIZONEGATE_RANGER_HUNT_SUCCESS
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wNumRangersLeft], a
	ld a, PAD_DOWN
	ld c, $2
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_7
	ld [wSafariZoneGateCurScript], a
	ret
.doneSafari
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wNumSafariBalls], a
	ld a, PAD_DOWN
	ld c, 3
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	ld [wSafariZoneGateCurScript], a
	ret
.leaving_early
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_LEAVING_EARLY
	ldh [hTextID], a
	jp DisplayTextID

SafariZoneGatePlayerMovingDownScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	call EnableAllJoypad
	ld a, SCRIPT_SAFARIZONEGATE_DEFAULT
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneGateSetScriptAfterMoveScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	call Delay3
	ld a, [wNextSafariZoneGateScript]
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneGateScript7:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $9
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_DOWN
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	ld [wSafariZoneGateCurScript], a
	ret	

SafariZoneEntranceAutoWalk:
	push af
	ld b, 0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneGateReturnSimulatedJoypadStateScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret

SafariZoneGate_TextPointers:
	def_text_pointers
	dba_const SafariZoneGateSafariZoneWorker1Text,                   TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1
	dba_const SafariZoneGateSafariZoneWorker2Text,                   TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER2
	dba_const SafariZoneGateSafariZoneWorker1Text,                   TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_1
	dba_const SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_WOULD_YOU_LIKE_TO_JOIN
	dba_const SafariZoneGateSafariZoneWorker1LeavingEarlyText,       TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_LEAVING_EARLY
	dba_const SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText,  TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_GOOD_HAUL_COME_AGAIN
	dba_const _RangerHuntDoneFailText,                               TEXT_SAFARIZONEGATE_FAILED_RANGER_HUNT
	dba_const SafariZoneEntranceText8,                               TEXT_SAFARIZONEGATE_RANGER_HUNT_SUCCESS
	dba_const SafariZoneEntranceText9,                               TEXT_SAFARIZONEGATE_OWED_HYPER_BALL

SafariZoneEntranceText1Get:
	text_far_end _SafariZoneGateSafariZoneWorker1Text

SafariZoneEntranceHyperBallOwedText:
	text_far_end _SafariZoneEntranceHyperBallOwedText

SafariZoneGateSafariZoneWorker1Text:
	text_asm
	CheckEvent EVENT_OWED_HYPER_BALL
	ld hl, SafariZoneEntranceText1Get
	jr z, .done
	ld hl, SafariZoneEntranceHyperBallOwedText
.done
	rst _PrintText
	rst TextScriptEnd
	

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinTextGet:
	text_far_end _SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText	

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText:
	text_asm
	CheckEvent EVENT_OWED_HYPER_BALL
	jr z, .default4
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	call GiveHyperBall
	jp .CantPayWalkDown
.default4
	ld hl, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinTextGet
	rst _PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	jp nz, .PleaseComeAgain
	xor a
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, 5
	ldh [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .success
	ld hl, .NotEnoughMoneyText
	rst _PrintText
	jr .CantPayWalkDown

.success
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, 5
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, .MakePaymentText
	rst _PrintText
	call AskGameType
	jr c, .PleaseComeAgain ; if we cancelled, don't continue
	ld a, PAD_UP
	ld c, 3
	call SafariZoneEntranceAutoWalk
	SetEvent EVENT_IN_SAFARI_ZONE
	ResetEventReuseHL EVENT_SAFARI_GAME_OVER
	ResetEventRange EVENT_BEAT_SAFARI_ZONE_CENTER_RANGER_0, EVENT_BEAT_SAFARI_ZONE_WEST_TRAINER_4 ;reset all trainers in the safari zone so they can be battled again
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING
	ld [wSafariZoneGateCurScript], a
	jr .done
.PleaseComeAgain
	ld hl, PleaseComeAgainText
	rst _PrintText
.CantPayWalkDown
	ld a, PAD_DOWN
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	ld [wSafariZoneGateCurScript], a
.done
	rst TextScriptEnd

.MakePaymentText
	text_far_end _SafariZoneGateSafariZoneWorker1ThatllBe500PleaseText

.NotEnoughMoneyText
	text_far_end _SafariZoneGateSafariZoneWorker1NotEnoughMoneyText

SafariZoneGateSafariZoneWorker1LeavingEarlyText:
	text_far _SafariZoneGateSafariZoneWorker1LeavingEarlyText
	text_asm
	call YesNoChoice
	jr nz, .not_ready_to_leave
	ld hl, .ReturnSafariBallsText
	rst _PrintText
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, PAD_DOWN
	ld c, 3
	call SafariZoneEntranceAutoWalk
	ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
	ld a, SCRIPT_SAFARIZONEGATE_DEFAULT
	ld [wNextSafariZoneGateScript], a
	jr .set_current_script
.not_ready_to_leave
	ld hl, .GoodLuckText
	rst _PrintText
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, PAD_UP
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	ld [wNextSafariZoneGateScript], a
.set_current_script
	ld a, SCRIPT_SAFARIZONEGATE_SET_SCRIPT_AFTER_MOVE
	ld [wSafariZoneGateCurScript], a
	rst TextScriptEnd

.ReturnSafariBallsText
	text_far_end _SafariZoneGateSafariZoneWorker1ReturnSafariBallsText

.GoodLuckText
	text_far_end _SafariZoneGateSafariZoneWorker1GoodLuckText

SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText:
	text_far_end _SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText
SafariZoneEntranceText8:
	text_asm 
	ld hl, .RangerHuntDoneSuccessText
	rst _PrintText
	SetEvent EVENT_OWED_HYPER_BALL
	rst TextScriptEnd

.RangerHuntDoneSuccessText
	text_far_end _RangerHuntDoneSuccessText

SafariZoneGateSafariZoneWorker2Text:
	text_asm
	ld hl, .FirstTimeHereText
	rst _PrintText
	call YesNoChoice
	ld hl, .YoureARegularHereText
	jr nz, .print_text
	call AskGameTypeExplanation
	jr c, .noSelection
	rst TextScriptEnd
.noSelection
	ld hl, PleaseComeAgainText
.print_text
	rst _PrintText
	rst TextScriptEnd

.FirstTimeHereText
	text_far_end _SafariZoneGateSafariZoneWorker2FirstTimeHereText

.YoureARegularHereText
	text_far_end _SafariZoneGateSafariZoneWorker2YoureARegularHereText

SafariZoneEntranceText9:
	text_asm
	call GiveHyperBall
	rst TextScriptEnd

AskGameType:
	ld hl, SafariZoneEntranceWhatGame
	rst _PrintText
	ld hl, SafariTypeOptions
	ld b, PAD_A | PAD_B
	call DisplayMultiChoiceTextBox
	jr nz, .goodbye
	ld hl, TextPointers_SafariGames
	ld a, [wCurrentMenuItem]
	call GetAddressFromPointerArray
	rst _PrintText
	and a
	ret
.goodbye
	; give back the 500 that was just deducted
	ld de, wPlayerMoney + 2
	ld hl, hMoney + 2 ; total price of items
	ld c, 3 ; length of money in bytes
	predef AddBCDPredef ; add total price to money
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID ; redraw money text box
	scf
	ret

TextPointers_SafariGames:
	dw SafariClassicPaidInfo
	dw SafariRangerHuntPaidInfo
	dw SafariFreeRoamPaidInfo

SafariZoneEntranceWhatGame:
	text_far_end _SafariZoneEntranceWhatGame

PleaseComeAgainText:
	text_far_end _SafariZoneGateSafariZoneWorker1PleaseComeAgainText

SafariClassicPaidInfo:
	text_asm
	ld hl, SafariZoneClassicText
	rst _PrintText
	ld hl, SafariZoneEntranceSafariBallsReceived
	rst _PrintText
	ld hl, SafariZonePAText
	rst _PrintText
	ld a, 30
	ld [wNumSafariBalls], a
	ld a, HIGH(702)
	ld [wSafariSteps], a
	ld a, LOW(702)
	ld [wSafariSteps + 1], a
	ld a, SAFARI_TYPE_CLASSIC
	ld [wSafariType], a
	call HideAllTrainers
	rst TextScriptEnd

SafariRangerHuntPaidInfo:
	text_asm
	ld hl, SafariZoneRangerHunt
	rst _PrintText
	ld hl, SafariZonePATextNoBalls
	rst _PrintText
	ld a, 5
	ld [wNumRangersLeft], a
	ld a, HIGH(702)
	ld [wSafariSteps], a
	ld a, LOW(702)
	ld [wSafariSteps + 1], a
	ld a, SAFARI_TYPE_RANGER_HUNT
	ld [wSafariType], a
	call ShowAllTrainers
	rst TextScriptEnd

SafariFreeRoamPaidInfo:
	text_asm
	ld hl, SafariZoneFreeRoam
	rst _PrintText
	xor a
	ld [wNumSafariBalls], a
	ld a, SAFARI_TYPE_FREE_ROAM
	ld [wSafariType], a
	call ShowAllTrainers
	call HideRangers
	rst TextScriptEnd

SafariZoneClassicText:
	text_far_end _SafariZoneClassic

SafariZoneEntranceSafariBallsReceived:
	text_far_end _SafariZoneEntranceSafariBallsReceived

SafariZonePAText:
	text_far_end _SafariZoneEntranceText_75360

SafariZonePATextNoBalls:
	text_far_end _SafariZonePATextNoBalls

GiveHyperBall:
	lb bc, ITEM_RANGER_HUNT_COMPLETION_PRIZE_NEW, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedHyperBallText
	rst _PrintText
	ResetEvent EVENT_OWED_HYPER_BALL
	ret
.BagFull
	ld hl, HyperBallNoRoomText
	rst _PrintText
	ret

ReceivedHyperBallText:
	text_far _ReceivedHyperBallText
	text_far _GenericReceivedItemA
	sound_get_key_item
	text_end

HyperBallNoRoomText:
	text_far_end _PewterGymTM34NoRoomText

HideShowRangers:
	db TOGGLE_SAFARI_ZONE_NORTH_RANGER_0
	db TOGGLE_SAFARI_ZONE_WEST_RANGER_0
	db TOGGLE_SAFARI_ZONE_WEST_RANGER_1
	db TOGGLE_SAFARI_ZONE_CENTER_RANGER_0
	db TOGGLE_SAFARI_ZONE_EAST_RANGER_0
	db -1 ; end

HideShowTrainers:
	db TOGGLE_SAFARI_ZONE_EAST_RANGER_0     
	db TOGGLE_SAFARI_ZONE_EAST_TRAINER_0    
	db TOGGLE_SAFARI_ZONE_EAST_TRAINER_1    
	db TOGGLE_SAFARI_ZONE_EAST_TRAINER_2    
	db TOGGLE_SAFARI_ZONE_EAST_TRAINER_3    
	db TOGGLE_SAFARI_ZONE_NORTH_RANGER_0    
	db TOGGLE_SAFARI_ZONE_NORTH_TRAINER_0   
	db TOGGLE_SAFARI_ZONE_NORTH_TRAINER_1   
	db TOGGLE_SAFARI_ZONE_NORTH_TRAINER_2   
	db TOGGLE_SAFARI_ZONE_NORTH_TRAINER_3   
	db TOGGLE_SAFARI_ZONE_NORTH_TRAINER_4   
	db TOGGLE_SAFARI_ZONE_WEST_RANGER_0    
	db TOGGLE_SAFARI_ZONE_WEST_RANGER_1    
	db TOGGLE_SAFARI_ZONE_WEST_TRAINER_0   
	db TOGGLE_SAFARI_ZONE_WEST_TRAINER_1   
	db TOGGLE_SAFARI_ZONE_WEST_TRAINER_2   
	db TOGGLE_SAFARI_ZONE_WEST_TRAINER_3   
	db TOGGLE_SAFARI_ZONE_WEST_TRAINER_4   
	db TOGGLE_SAFARI_ZONE_CENTER_RANGER_0     
	db TOGGLE_SAFARI_ZONE_CENTER_TRAINER_0    
	db TOGGLE_SAFARI_ZONE_CENTER_TRAINER_1    
	db TOGGLE_SAFARI_ZONE_CENTER_TRAINER_2    
	db TOGGLE_SAFARI_ZONE_CENTER_TRAINER_3
	db -1 ; end 

ShowAllTrainers:
	ld hl, HideShowTrainers         ; table items to hide
	; fall through
ShowAllHl:
.loop
	ld a, [hli]                  ; read move from move table
	cp -1
	ret z
	ld c, a
	push hl
	call ShowExtraObject
	pop hl
	jr .loop


HideAllTrainers:
	ld hl, HideShowTrainers         ; table items to hide
	jr HideAllHl

HideRangers:
	ld hl, HideShowRangers
	; fall through
HideAllHl:
.loop
	ld a, [hli]                  ; read move from move table
	cp -1
	ret z
	ld c, a
	push hl
	call HideExtraObject
	pop hl
	jr .loop

AskGameTypeExplanation:
	ld hl, SafariZoneHelp
	rst _PrintText
	ld hl, SafariTypeOptions
	ld b, PAD_A | PAD_B
	call DisplayMultiChoiceTextBox
	jr nz, .goodbye
	ld hl, TextPointers_SafariExplanations
	ld a, [wCurrentMenuItem]
	add a
	add a ; multiply by TEXT_FAR_TABLE_ENTRY_SIZE
	ld d, 0
	ld e, a
	add hl, de
	rst _PrintText
	and a
	ret
.goodbye
	scf
	ret

SafariZoneHelp:
	text_far_end _SafariZoneHelp

TextPointers_SafariExplanations:
ExplanationText:
	text_far_end _SafariZoneGateSafariZoneWorker2SafariZoneExplanationText
SafariZoneRangerHunt:
	text_far_end _SafariZoneRangerHunt
SafariZoneFreeRoam:
	text_far_end _SafariZoneFreeRoam
