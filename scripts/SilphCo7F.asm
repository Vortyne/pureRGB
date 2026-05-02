; PureRGBnote: ADDED: card key will be consumed if all card key doors were opened in the game.

SilphCo7F_Script:
	call SilphCo7FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo7TrainerHeaders
	ld de, SilphCo7F_ScriptPointers
	ld a, [wSilphCo7FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo7FCurScript], a
	ret

SilphCo7FGateCallbackScript::
	call WasMapJustLoaded
	ret z
	callfar SilphCo7FCardKeyMapLoad
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	ret z
	jp GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here

SilphCo7F_ScriptPointers:
	def_script_pointers
	dw_const SilphCo7FDefaultScript,                SCRIPT_SILPHCO7F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO7F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO7F_END_BATTLE
	dw_const SilphCo7FRivalStartBattleScript,       SCRIPT_SILPHCO7F_RIVAL_START_BATTLE
	dw_const SilphCo7FRivalAfterBattleScript,       SCRIPT_SILPHCO7F_RIVAL_AFTER_BATTLE
	dw_const SilphCo7FRivalExitScript,              SCRIPT_SILPHCO7F_RIVAL_EXIT

SilphCo7FDefaultScript:
	CheckEvent EVENT_BEAT_SILPH_CO_RIVAL
	jp nz, CheckFightingMapTrainers
	ld hl, .RivalEncounterCoordinates
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	xor a
	ldh [hJoyHeld], a
	call DisableDpad
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	rst _PlaySound
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, TEXT_SILPHCO7F_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	ld a, SILPHCO7F_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, .RivalMovementUp
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	cp 1 ; index of second, lower entry in .RivalEncounterCoordinates
	jr z, .full_rival_movement
	inc de
.full_rival_movement
	ld a, SILPHCO7F_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_SILPHCO7F_RIVAL_START_BATTLE
	jr SilphCo7FSetCurScript

.RivalEncounterCoordinates:
	dbmapcoord  3,  2
	dbmapcoord  3,  3
	db -1 ; end

.RivalMovementUp:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

SilphCo7FRivalStartBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	; reset rival's sprite behaviour bytes otherwise he can look around weirdly after battle for a moment
	ld hl, wMapSpriteData + ((SILPHCO7F_RIVAL - 1) * 2)
	ld [hl], UP
	call EnableAllJoypad
	ld a, TEXT_SILPHCO7F_RIVAL_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo7FRivalDefeatedText
	ld de, SilphCo7FRivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL2
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	call StarterToPartyID
	add 6 ; third set of rival parties for RIVAL2
	ld [wTrainerNo], a
	ld a, SCRIPT_SILPHCO7F_RIVAL_AFTER_BATTLE
	jr SilphCo7FSetCurScript

SilphCo7FSetDefaultScript:
	call EnableAllJoypad

SilphCo7FSetCurScript:
	ld [wSilphCo7FCurScript], a
	ld [wCurMapScript], a
	ret

SilphCo7FRivalAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, SilphCo7FSetDefaultScript
	call DisableDpad
	SetEvent EVENT_BEAT_SILPH_CO_RIVAL
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld d, SILPHCO7F_RIVAL
	callfar MakeSpriteFacePlayer
	ld a, TEXT_SILPHCO7F_RIVAL_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	rst _PlaySound
	farcall Music_RivalAlternateStart
	ld de, .RivalWalkAroundPlayerMovement
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in SilphCo7FDefaultScript.RivalEncounterCoordinates
	jr nz, .walk_around_player
	ld de, .RivalExitRightMovement
.walk_around_player
	ld a, SILPHCO7F_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_SILPHCO7F_RIVAL_EXIT
	jr SilphCo7FSetCurScript

.RivalExitRightMovement:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

.RivalWalkAroundPlayerMovement:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SilphCo7FRivalExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	; PureRGBnote: ADDED: make rival teleport away
	ld a, SILPHCO7F_RIVAL
	call SetSpriteFacingDown
	call UpdateSpritesAndDelay3
	ld a, SFX_TELEPORT_EXIT_1
	rst _PlaySound
	call DisableSpriteUpdates
.loopTeleportAway
	ld hl, wShadowOAMSprite08YCoord
	ld b, 0
	ld d, [hl]
	inc hl
	; we will move up 3 pixels per frame, but the sprite hits pixel 0 (off top of screen), we will end the animation
	dec d
	jr z, .lastLoop
	dec d
	jr z, .lastLoop
	dec d
	jr z, .lastLoop
.next
	ld e, [hl]
	ld c, 8
	push bc
	callfar LoadSpecificOAMSpriteCoords
	pop bc
	dec b
	inc b
	jr nz, .done
	rst _DelayFrame
	jr .loopTeleportAway
.lastLoop
	inc b
	jr .next
.done
	call EnableSpriteUpdates
	ld c, TOGGLE_SILPH_CO_7F_RIVAL
	call HideObject
	call PlayDefaultMusic
	jp SilphCo7FSetDefaultScript

SilphCo7F_TextPointers:
	def_text_pointers
	dw_const SilphCo7FSilphWorkerM1Text,      TEXT_SILPHCO7F_SILPH_WORKER_M1
	dw_const SilphCo7FSilphWorkerM2Text,      TEXT_SILPHCO7F_SILPH_WORKER_M2
	dw_const SilphCo7FSilphWorkerM3Text,      TEXT_SILPHCO7F_SILPH_WORKER_M3
	dw_const SilphCo7FSilphWorkerM4Text,      TEXT_SILPHCO7F_SILPH_WORKER_M4
	dw_const SilphCo7FRocket1Text,            TEXT_SILPHCO7F_ROCKET1
	dw_const SilphCo7FScientistText,          TEXT_SILPHCO7F_SCIENTIST
	dw_const SilphCo7FRocket2Text,            TEXT_SILPHCO7F_ROCKET2
	dw_const SilphCo7FRocket3Text,            TEXT_SILPHCO7F_ROCKET3
	dw_const SilphCo7FRivalText,              TEXT_SILPHCO7F_RIVAL
	dw_const PickUpItemText,                  TEXT_SILPHCO7F_ITEM1
	dw_const PickUpItemText,                  TEXT_SILPHCO7F_ITEM2
	dw_const SilphCo7FRivalWaitedHereText,    TEXT_SILPHCO7F_RIVAL_WAITED_HERE
	dw_const SilphCo7FRivalDefeatedText,      TEXT_SILPHCO7F_RIVAL_DEFEATED
	dw_const SilphCo7FRivalGoodLuckToYouText, TEXT_SILPHCO7F_RIVAL_GOOD_LUCK_TO_YOU

SilphCo7TrainerHeaders:
	def_trainers 5
SilphCo7TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_0, 2, SilphCo7FRocket1BattleText, SilphCo7FRocket1EndBattleText, SilphCo7FRocket1AfterBattleText
SilphCo7TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_1, 3, SilphCo7FScientistBattleText, SilphCo7FScientistEndBattleText, SilphCo7FScientistAfterBattleText
SilphCo7TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_2, 3, SilphCo7FRocket2BattleText, SilphCo7FRocket2EndBattleText, SilphCo7FRocket2AfterBattleText
SilphCo7TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_3, 4, SilphCo7FRocket3BattleText, SilphCo7FRocket3EndBattleText, SilphCo7FRocket3AfterBattleText
	db -1 ; end

; PureRGBnote: ADDED: the guy who gives you lapras will give you something else if you already received lapras from him in celadon earlier in game.
SilphCo7FSilphWorkerM1Text:
; lapras guy
	text_asm
	ld c, TOGGLE_LAPRAS_GUY_CELADON
	call HideObject
	CheckEventHL EVENT_GOT_LAPRAS_EARLY
	jr nz, .gotLaprasAlready
	ld a, [wStatusFlags4]
	bit BIT_GOT_SILPH_CO_LAPRAS_OR_ITEM, a ; got lapras?
	jr z, .give_lapras
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .savedsilph
.noItemToGive	
	ld hl, .IsOurPresidentOkText
	rst _PrintText
	jr .done
.give_lapras
	ld hl, .HaveThisPokemonText
	rst _PrintText
	lb bc, LAPRAS, 40 ; PureRGBnote: CHANGED: lapras level increased to keep up with party level
	ld a, BALL_DATA_GREAT << 3
	call GivePokemonCommon
	jr nc, .done
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
	ld hl, .LaprasDescriptionText
	rst _PrintText
	ld hl, wStatusFlags4
	set BIT_GOT_SILPH_CO_LAPRAS_OR_ITEM, [hl]
	jr .done
.savedsilph
	ld hl, .SavedText
	rst _PrintText
.done
	rst TextScriptEnd
.gotLaprasAlready
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .savedsilph
	ld a, [wStatusFlags4]
	bit BIT_GOT_SILPH_CO_LAPRAS_OR_ITEM, a ; got his item already?
	jr nz, .noItemToGive
	ld hl, .LaprasGuyAlreadyText
	rst _PrintText
	; give ra
	lb bc, ITEM_GOT_LAPRAS_SILPH_CO_7F_REWARD_NEW, 1
	call GiveItem
	jr nc, .noRoom
	ld hl, .LaprasGuyReceivedItemText
	rst _PrintText
	ld hl, .LaprasGuyGoodLuckText
	rst _PrintText
	ld hl, wStatusFlags4
	set BIT_GOT_SILPH_CO_LAPRAS_OR_ITEM, [hl]
	jr .done
.noRoom
	ld hl, .LaprasGuyNoBagRoomText
	rst _PrintText
	jr .done

.HaveThisPokemonText
	text_far _SilphCo7FSilphWorkerM1HaveThisPokemonText
	text_end

.LaprasDescriptionText
	text_far _SilphCo7FSilphWorkerM1LaprasDescriptionText
	text_end

.IsOurPresidentOkText
	text_far _SilphCo7FSilphWorkerM1IsOurPresidentOkText
	text_end

.SavedText
	text_far _SilphCo7FSilphWorkerM1SavedText
	text_end

.LaprasGuyAlreadyText
	text_far _LaprasGuySilphCoAlreadyText
	text_end

.LaprasGuyReceivedItemText
	text_far _LastTwoGurusReceivedItemText
	sound_get_item_1
	text_end

.LaprasGuyGoodLuckText
	text_far _GenericGoodLuckText
	text_end

.LaprasGuyNoBagRoomText
	text_far _GenericNoRoomText
	text_end

SilphCo7FSilphWorkerM2Text:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .AfterTheMasterBallText
	rst _PrintText
	jr .done
.saved_silph
	ld hl, .CancelledTheMasterBallText
	rst _PrintText
.done
	rst TextScriptEnd

.AfterTheMasterBallText
	text_far _SilphCo7FSilphWorkerM2AfterTheMasterBallText
	text_end

.CancelledTheMasterBallText
	text_far _SilphCo7FSilphWorkerM2CancelledMasterBallText
	text_end

SilphCo7FSilphWorkerM3Text:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .ItWouldBeBadText
	rst _PrintText
	jr .done
.saved_silph
	ld hl, .YouChasedOffTeamRocketText
	rst _PrintText
.done
	rst TextScriptEnd

.ItWouldBeBadText
	text_far _SilphCo7FSilphWorkerM3ItWouldBeBadText
	text_end

.YouChasedOffTeamRocketText
	text_far _SilphCo7FSilphWorkerM3YouChasedOffTeamRocketText
	text_end

SilphCo7FSilphWorkerM4Text:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .ItsReallyDangerousHereText
	rst _PrintText
	jr .done
.saved_silph
	ld hl, .SafeAtLastText
	rst _PrintText
.done
	rst TextScriptEnd

.ItsReallyDangerousHereText
	text_far _SilphCo7FSilphWorkerM4ItsReallyDangerousHereText
	text_end

.SafeAtLastText
	text_far _SilphCo7FSilphWorkerM4SafeAtLastText
	text_end

SilphCo7FRocket1Text:
	text_asm
	ld hl, SilphCo7TrainerHeader0
SilphCo7FTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

SilphCo7FScientistText:
	text_asm
	ld hl, SilphCo7TrainerHeader1
	jr SilphCo7FTalkToTrainer

SilphCo7FRocket2Text:
	text_asm
	ld hl, SilphCo7TrainerHeader2
	jr SilphCo7FTalkToTrainer

SilphCo7FRocket3Text:
	text_asm
	ld hl, SilphCo7TrainerHeader3
	jr SilphCo7FTalkToTrainer
	
SilphCo7FRocket1BattleText:
	text_far _SilphCo7FRocket1BattleText
	text_end

SilphCo7FRocket1EndBattleText:
	text_far _SilphCo7FRocket1EndBattleText
	text_end

SilphCo7FRocket1AfterBattleText:
	text_far _SilphCo7FRocket1AfterBattleText
	text_end

SilphCo7FScientistBattleText:
	text_far _SilphCo7FScientistBattleText
	text_end

SilphCo7FScientistEndBattleText:
	text_far _SilphCo7FScientistEndBattleText
	text_end

SilphCo7FScientistAfterBattleText:
	text_far _SilphCo7FScientistAfterBattleText
	text_end

SilphCo7FRocket2BattleText:
	text_far _SilphCo7FRocket2BattleText
	text_end

SilphCo7FRocket2EndBattleText:
	text_far _SilphCo7FRocket2EndBattleText
	text_end

SilphCo7FRocket2AfterBattleText:
	text_far _SilphCo7FRocket2AfterBattleText
	text_end

SilphCo7FRocket3BattleText:
	text_far _SilphCo7FRocket3BattleText
	text_end

SilphCo7FRocket3EndBattleText:
	text_far _SilphCo7FRocket3EndBattleText
	text_end

SilphCo7FRocket3AfterBattleText:
	text_far _SilphCo7FRocket3AfterBattleText
	text_end

SilphCo7FRivalText:
	text_asm
	ld hl, .Text
	rst _PrintText
	rst TextScriptEnd

.Text:
	text_far _SilphCo7FRivalText
	text_end

SilphCo7FRivalWaitedHereText:
	text_far _SilphCo7FRivalWaitedHereText
	text_end

SilphCo7FRivalDefeatedText:
	text_far _SilphCo7FRivalDefeatedText
	text_end

SilphCo7FRivalVictoryText:
	text_far _SilphCo7FRivalVictoryText
	text_end

SilphCo7FRivalGoodLuckToYouText:
	text_far _SilphCo7FRivalGoodLuckToYouText
	text_end
