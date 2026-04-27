GameCorner_Script:
	call GameCornerSelectLuckySlotMachine
	call GameCornerSetRocketHideoutDoorTile
	call EnableAutoTextBoxDrawing
	ld hl, GameCorner_ScriptPointers
	ld a, [wGameCornerCurScript]
	jp CallFunctionInTable

GameCornerSelectLuckySlotMachine:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	ret z
	call Random
	ldh a, [hRandomAdd]
	cp $7
	jr nc, .not_max
	ld a, 8
.not_max
	srl_a_3x
	ld [wLuckySlotHiddenEventIndex], a
	ret

GameCornerSetRocketHideoutDoorTile:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_FOUND_ROCKET_HIDEOUT
	ret nz
	ld a, $2a
	ld [wNewTileBlockID], a
	lb bc, 2, 8
	predef ReplaceTileBlock
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	ret z
	jp GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here

GameCorner_ScriptPointers:
	def_script_pointers
	dw_const DoRet,                        SCRIPT_GAMECORNER_DEFAULT
	dw_const GameCornerRocketBattleScript, SCRIPT_GAMECORNER_ROCKET_BATTLE
	dw_const GameCornerRocketExitScript,   SCRIPT_GAMECORNER_ROCKET_EXIT

GameCornerReenterMapAfterPlayerLoss:
	call ResetMapScripts
	; a = 0 from ResetMapScripts
	ld [wGameCornerCurScript], a ; SCRIPT_GAMECORNER_DEFAULT
	ret

GameCornerRocketBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, GameCornerReenterMapAfterPlayerLoss
	call DisableDpad
	ld d, GAMECORNER_ROCKET
	callfar MakeSpriteFacePlayer
	ld a, TEXT_GAMECORNER_ROCKET_AFTER_BATTLE
	ldh [hTextID], a
	call DisplayTextID
	ld a, GAMECORNER_ROCKET
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, GameCornerMovement_Rocket_WalkAroundPlayer
	ld a, [wYCoord]
	cp 6
	jr nz, .not_direct_movement
	ld de, GameCornerMovement_Rocket_WalkDirect
	jr .got_rocket_movement
.not_direct_movement
	ld a, [wXCoord]
	cp 8
	jr nz, .got_rocket_movement
	ld de, GameCornerMovement_Rocket_WalkDirect
.got_rocket_movement
	ld a, GAMECORNER_ROCKET
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_GAMECORNER_ROCKET_EXIT
	ld [wGameCornerCurScript], a
	ret

GameCornerMovement_Rocket_WalkAroundPlayer:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

GameCornerMovement_Rocket_WalkDirect:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

GameCornerRocketExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call EnableAllJoypad
	ld a, TOGGLE_GAME_CORNER_ROCKET
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	xor a ; SCRIPT_GAMECORNER_DEFAULT
	ld [wGameCornerCurScript], a
	ret

GameCorner_TextPointers:
	def_text_pointers
	dw_const GameCornerBeauty1Text,           TEXT_GAMECORNER_BEAUTY1
	dw_const GameCornerClerk1Text,            TEXT_GAMECORNER_CLERK1
	dw_const GameCornerMiddleAgedMan1Text,    TEXT_GAMECORNER_MIDDLE_AGED_MAN1
	dw_const GameCornerBeauty2Text,           TEXT_GAMECORNER_BEAUTY2
	dw_const GameCornerFishingGuruText,       TEXT_GAMECORNER_FISHING_GURU
	dw_const GameCornerMiddleAgedWomanText,   TEXT_GAMECORNER_MIDDLE_AGED_WOMAN
	dw_const GameCornerGymGuideText,          TEXT_GAMECORNER_GYM_GUIDE
	dw_const GameCornerGamblerText,           TEXT_GAMECORNER_GAMBLER
	dw_const GameCornerClerk2Text,            TEXT_GAMECORNER_CLERK2
	dw_const GameCornerGentlemanText,         TEXT_GAMECORNER_GENTLEMAN
	dw_const GameCornerRocketText,            TEXT_GAMECORNER_ROCKET
	dw_const GameCornerPosterText,            TEXT_GAMECORNER_POSTER
	dw_const GameCornerRocketAfterBattleText, TEXT_GAMECORNER_ROCKET_AFTER_BATTLE
	dw_const GameCornerOutOfOrderText,        TEXT_GAMECORNER_OUT_OF_ORDER
	dw_const GameCornerOutToLunchText,        TEXT_GAMECORNER_OUT_TO_LUNCH
	dw_const GameCornerSomeonesKeysText,      TEXT_GAMECORNER_SOMEONES_KEYS
	dw_const GameCornerCoinCaseText,          TEXT_GAMECORNER_NEED_COIN_CASE
	dw_const GameCornerNoCoinsText,           TEXT_GAMECORNER_NO_COINS
	dw_const FoundHiddenCoinsText,            TEXT_GAMECORNER_FOUND_HIDDEN_COINS
	EXPORT TEXT_GAMECORNER_FOUND_HIDDEN_COINS
	dw_const DroppedHiddenCoinsText,          TEXT_GAMECORNER_DROPPED_HIDDEN_COINS
	EXPORT TEXT_GAMECORNER_DROPPED_HIDDEN_COINS

GameCornerBeauty1Text:
	text_far _GameCornerBeauty1Text
	text_end

GameCornerClerk1Text:
	text_asm
	; Show player's coins
	call GameCornerDrawCoinBox
	ld hl, .DoYouNeedSomeGameCoins
	rst _PrintText
	call YesNoChoice
	jr nz, .declined
.wantsToBuyMoreCoins
	CheckEvent EVENT_GOT_COIN_CASE ; PureRGBnote: CHANGED: coin case is an event instead of an item
	jr z, .no_coin_case
	; - have room in the Coin Case for at least 9 coins
	call Has9990Coins
	jr nc, .coin_case_full
	; - have at least 1000 yen
	xor a
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, $80 ; PureRGBnote: CHANGED: 8000 pokebucks for 500 coins.
	ldh [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .buy_coins
	ld hl, .CantAffordTheCoins
	jr .print_ret
.buy_coins
	; Spend 1000 yen
	xor a
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, $80 ; PureRGBnote: CHANGED: 8000 pokebucks for 500 coins.
	ldh [hMoney + 1], a
	ld hl, hMoney + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	; Receive 50 coins
	xor a
	ldh [hUnusedCoinsByte], a
	ldh [hCoins + 1], a
	ldh [hCoins + 2], a
	ld a, $05 ; PureRGBnote: CHANGED: 8000 pokebucks for 500 coins.
	ldh [hCoins], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, 2
	predef AddBCDPredef
	call GameCornerDrawCoinBox
	ld hl, .ThanksHereAre50Coins
;;;;;;;;;; PureRGBnote: CHANGED: the clerk will allow you to repeatedly buy 500 coins without long dialog repeat
	rst _PrintText
	ld hl, .CeladonGameCornerText_another500
	rst _PrintText
	call YesNoChoice
	jr z, .wantsToBuyMoreCoins
	ld hl, .CeladonGameCornerThanks
;;;;;;;;;;
	jr .print_ret
.declined
	ld hl, .PleaseComePlaySometime
	jr .print_ret
.coin_case_full
	ld hl, .CoinCaseIsFull
	jr .print_ret
.no_coin_case
	ld hl, .DontHaveCoinCase
.print_ret
	rst _PrintText
.done
	rst TextScriptEnd

.CeladonGameCornerThanks:
	text_far _Thanks2Text
	text_end

.CeladonGameCornerText_another500:
	text_far _CeladonGameCornerText_another500
	text_end

.DoYouNeedSomeGameCoins:
	text_far _GameCornerClerk1DoYouNeedSomeGameCoinsText
	text_end

.ThanksHereAre50Coins:
	text_far _GameCornerClerk1ThanksHereAre50CoinsText
	text_end

.PleaseComePlaySometime:
	text_far _GameCornerClerk1PleaseComePlaySometimeText
	text_end

.CantAffordTheCoins:
	text_far _GameCornerClerk1CantAffordTheCoinsText
	text_end

.CoinCaseIsFull:
	text_far _GameCornerClerk1CoinCaseIsFullText
	text_end

.DontHaveCoinCase:
	text_far _GameCornerClerk1DontHaveCoinCaseText
	text_end

GameCornerMiddleAgedMan1Text:
	text_far _GameCornerMiddleAgedMan1Text
	text_end

GameCornerBeauty2Text:
	text_far _GameCornerBeauty2Text
	text_end

GameCornerFishingGuruText:
	text_asm
	CheckEvent EVENT_GOT_10_COINS
	jr nz, .alreadyGotNpcCoins
	ld hl, .WantToPlayText
	rst _PrintText
	CheckEvent EVENT_GOT_COIN_CASE ; PureRGBnote: CHANGED: coin case is an event instead of an item
	jr z, .dontHaveCoinCase
	call Has9990Coins
	jr nc, .coinCaseFull
	xor a
	ldh [hUnusedCoinsByte], a
	ldh [hCoins], a
	ld a, $10
	ldh [hCoins + 1], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	SetEvent EVENT_GOT_10_COINS
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .Received10CoinsText
	jr .print_ret
.alreadyGotNpcCoins
	ld hl, .WinsComeAndGoText
	jr .print_ret
.coinCaseFull
	ld hl, .DontNeedMyCoinsText
	jr .print_ret
.dontHaveCoinCase
	ld hl, GameCornerOopsForgotCoinCaseText
.print_ret
	rst _PrintText
	rst TextScriptEnd

.WantToPlayText:
	text_far _GameCornerFishingGuruWantToPlayText
	text_end

.Received10CoinsText:
	text_far _GameCornerFishingGuruReceived10CoinsText
	sound_get_item_1
	text_end

.DontNeedMyCoinsText:
	text_far _GameCornerFishingGuruDontNeedMyCoinsText
	text_end

.WinsComeAndGoText:
	text_far _GameCornerFishingGuruWinsComeAndGoText
	text_end

GameCornerMiddleAgedWomanText:
	text_far _GameCornerMiddleAgedWomanText
	text_end

GameCornerGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_ERIKA
	jr nz, .afterBattle
	ld hl, GameCornerGymGuideChampInMakingText
	rst _PrintText
	jr .done
.afterBattle
	ld hl, CeladonGameCornerText_gymguide
	rst _PrintText
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	jr z, .gameCornerPrizes
	CheckEvent EVENT_GOT_CELADON_APEX_CHIPS
	jr nz, .gameCornerPrizes
.giveApexChips
	ld hl, GymGuideMoreApexChipText4
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedApexChipsText4
	rst _PrintText
	ld hl, CeladonGameCornerGymGuideApexChipGrassText
	rst _PrintText
	SetEvent EVENT_GOT_CELADON_APEX_CHIPS
.gameCornerPrizes
	ld hl, GameCornerGymGuideTheyOfferRarePokemonText
	rst _PrintText
	jr .done
.BagFull
	ld hl, ApexNoRoomText4
	rst _PrintText
.done
	rst TextScriptEnd

ReceivedApexChipsText4:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText4:
	text_far _PewterGymTM34NoRoomText
	text_end

GymGuideMoreApexChipText4:
	text_far _GymGuideMoreApexChipText
	text_end

CeladonGameCornerText_gymguide:
	text_far _GymGuideChampInMakingText
	text_far _CeladonGameCornerText_gymguide
	text_end

CeladonGameCornerGymGuideApexChipGrassText:
	text_far _CeladonGameCornerGymGuideApexChipGrassText
	text_end

GameCornerGymGuideChampInMakingText:
	text_far _GameCornerGymGuideChampInMakingText
	text_end

GameCornerGymGuideTheyOfferRarePokemonText:
	text_far _GameCornerGymGuideTheyOfferRarePokemonText
	text_end

GameCornerGamblerText:
	text_far _GameCornerGamblerText
	text_end

GameCornerClerk2Text:
	text_asm
	CheckEvent EVENT_GOT_20_COINS_2
	jr nz, .alreadyGotNpcCoins
	ld hl, .WantSomeCoinsText
	rst _PrintText
	CheckEvent EVENT_GOT_COIN_CASE ; PureRGBnote: CHANGED: coin case is an event instead of an item
	jr z, .dontHaveCoinCase
	call Has9990Coins
	jr nc, .coinCaseFull
	xor a
	ldh [hUnusedCoinsByte], a
	ldh [hCoins], a
	ld a, $20
	ldh [hCoins + 1], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	SetEvent EVENT_GOT_20_COINS_2
	ld hl, .Received20CoinsText
	jr .print_ret
.alreadyGotNpcCoins
	ld hl, .INeedMoreCoinsText
	jr .print_ret
.coinCaseFull
	ld hl, .YouHaveLotsOfCoinsText
	jr .print_ret
.dontHaveCoinCase
	ld hl, GameCornerOopsForgotCoinCaseText
.print_ret
	rst _PrintText
	rst TextScriptEnd

.WantSomeCoinsText:
	text_far _GameCornerClerk2WantSomeCoinsText
	text_end

.Received20CoinsText:
	text_far _GameCornerClerk2Received20CoinsText
	sound_get_item_1
	text_end

.YouHaveLotsOfCoinsText:
	text_far _GameCornerClerk2YouHaveLotsOfCoinsText
	text_end

.INeedMoreCoinsText:
	text_far _GameCornerClerk2INeedMoreCoinsText
	text_end

GameCornerGentlemanText:
	text_asm
	CheckEvent EVENT_GOT_20_COINS
	jr nz, .alreadyGotNpcCoins
	ld hl, .ThrowingMeOffText
	rst _PrintText
	CheckEvent EVENT_GOT_COIN_CASE ; PureRGBnote: CHANGED: coin case is an event instead of an item
	jr z, .dontHaveCoinCase
	call Has9990Coins
	jr z, .coinCaseFull
	xor a
	ldh [hUnusedCoinsByte], a
	ldh [hCoins], a
	ld a, $20
	ldh [hCoins + 1], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	SetEvent EVENT_GOT_20_COINS
	ld hl, .Received20CoinsText
	jr .print_ret
.alreadyGotNpcCoins
	ld hl, .CloselyWatchTheReelsText
	jr .print_ret
.coinCaseFull
	ld hl, .YouGotYourOwnCoinsText
	jr .print_ret
.dontHaveCoinCase
	ld hl, GameCornerOopsForgotCoinCaseText
.print_ret
	rst _PrintText
	rst TextScriptEnd

.ThrowingMeOffText:
	text_far _GameCornerGentlemanThrowingMeOffText
	text_end

.Received20CoinsText:
	text_far _GameCornerGentlemanReceived20CoinsText
	sound_get_item_1
	text_end

.YouGotYourOwnCoinsText:
	text_far _GameCornerGentlemanYouGotYourOwnCoinsText
	text_end

.CloselyWatchTheReelsText:
	text_far _GameCornerGentlemanCloselyWatchTheReelsText
	text_end

GameCornerRocketText:
	text_asm
	ld hl, .ImGuardingThisPosterText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .BattleEndText
	ld de, .BattleEndText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ld a, SCRIPT_GAMECORNER_ROCKET_BATTLE
	ld [wGameCornerCurScript], a
	rst TextScriptEnd

.ImGuardingThisPosterText:
	text_far _GameCornerRocketImGuardingThisPosterText
	text_end

.BattleEndText:
	text_far _GameCornerRocketBattleEndText
	text_end

GameCornerRocketAfterBattleText:
	text_far _GameCornerRocketAfterBattleText
	text_end

GameCornerPosterText:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .SwitchBehindPosterText
	rst _PrintText
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	call WaitForSoundToFinish
	SetEvent EVENT_FOUND_ROCKET_HIDEOUT
	ld a, $43
	ld [wNewTileBlockID], a
	lb bc, 2, 8
	predef ReplaceTileBlock
	rst TextScriptEnd

.SwitchBehindPosterText:
	text_far _GameCornerPosterSwitchBehindPosterText
	text_asm
	ld a, SFX_SWITCH
	rst _PlaySound
	call WaitForSoundToFinish
	rst TextScriptEnd

GameCornerOopsForgotCoinCaseText:
	text_far _GameCornerOopsForgotCoinCaseText
	text_end

GameCornerDrawCoinBox:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 11, 0
	lb bc, 5, 7
	call TextBoxBorderUpdateSprites
	hlcoord 12, 1
	lb bc, 4, 7
	call ClearScreenArea
	hlcoord 12, 2
	ld de, GameCornerMoneyText
	call PlaceString
	hlcoord 12, 3
	call .clearLine
	hlcoord 12, 3
	ld de, wPlayerMoney
	ld c, 3 | MONEY_SIGN | LEADING_ZEROES
	call PrintBCDNumber
	hlcoord 12, 4
	ld de, GameCornerCoinText
	call PlaceString
	hlcoord 12, 5
	call .clearLine
	hlcoord 15, 5
	ld de, wPlayerCoins
	ld c, 2 | LEADING_ZEROES
	call PrintBCDNumber
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret
.clearLine
	lb bc, 1, 7
	jp ClearScreenArea

GameCornerMoneyText:
	db "MONEY@"

GameCornerCoinText:
	db "COIN@"

Has9990Coins:
	ld a, $99
	ldh [hCoins], a
	ld a, $90
	ldh [hCoins + 1], a
	jp HasEnoughCoins

StartSlotMachine::
	ld a, [wSpritePlayerStateData1ImageIndex]
	and PLAYER_DIR_UP
	ret z
	ld a, [wHiddenEventFunctionArgument]
	cp SLOTS_OUTOFORDER
	ld b, TEXT_GAMECORNER_OUT_OF_ORDER
	jr z, .printText
	cp SLOTS_OUTTOLUNCH
	ld b, TEXT_GAMECORNER_OUT_TO_LUNCH
	jr z, .printText
	cp SLOTS_SOMEONESKEYS
	ld b, TEXT_GAMECORNER_SOMEONES_KEYS
	jr z, .printText
	CheckEvent EVENT_GOT_COIN_CASE ; PureRGBnote: CHANGED: coin case is an event instead of an item now.
	ld b, TEXT_GAMECORNER_NEED_COIN_CASE
	jr z, .printText
	ld hl, wPlayerCoins
	ld a, [hli]
	or [hl]
	ld b, TEXT_GAMECORNER_NO_COINS
	jr z, .printText
	ld a, [wLuckySlotHiddenEventIndex]
	ld b, a
	ld a, [wHiddenEventIndex]
	inc a
	cp b
	ld a, 253
	jr nz, .next
	ld a, 250
.next
	ld [wSlotMachineSevenAndBarModeChance], a
	ldh a, [hLoadedROMBank]
	ld [wSlotMachineSavedROMBank], a
	jpfar PromptUserToPlaySlots
.printText
	ld a, b
	ldh [hTextID], a
	jp DisplayTextID


GameCornerOutOfOrderText::
	text_far _GameCornerOutOfOrderText
	text_end

GameCornerOutToLunchText::
	text_far _GameCornerOutToLunchText
	text_end

GameCornerSomeonesKeysText::
	text_far _GameCornerSomeonesKeysText
	text_end

GameCornerCoinCaseText::
	text_far _GameCornerCoinCaseText
	text_end

GameCornerNoCoinsText::
	text_far _GameCornerNoCoinsText
	text_end

FoundHiddenCoinsText::
	text_far _FoundHiddenCoinsText
	sound_get_item_2
	text_end

DroppedHiddenCoinsText::
	text_far _FoundHiddenCoins2Text
	sound_get_item_2
	text_far _DroppedHiddenCoinsText
	text_end
