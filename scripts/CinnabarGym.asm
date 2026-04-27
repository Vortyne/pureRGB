CinnabarGym_Script:
	call CinnabarGymSetMapAndTiles
	call EnableAutoTextBoxDrawing
	ld hl, CinnabarGym_ScriptPointers
	ld a, [wCinnabarGymCurScript]
	jp CallFunctionInTable

CinnabarGymSetMapAndTiles:
	ld hl, wCurrentMapScriptFlags
	res BIT_CUR_MAP_LOADED_2, [hl]
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, UpdateCinnabarGymGateTileBlocks
	;ResetEvent EVENT_2A7
	ret

CinnabarGym_ScriptPointers:
	def_script_pointers
	dw_const CinnabarGymDefaultScript,          SCRIPT_CINNABARGYM_DEFAULT
	dw_const CinnabarGymGetOpponentTextScript,  SCRIPT_CINNABARGYM_GET_OPPONENT_TEXT
	dw_const CinnabarGymOpenGateScript,         SCRIPT_CINNABARGYM_OPEN_GATE
	dw_const CinnabarGymBlainePostBattleScript, SCRIPT_CINNABARGYM_BLAINE_POST_BATTLE

CinnabarGymDefaultScript:
	ld a, [wOpponentAfterWrongAnswer]
	and a
	ret z
	ldh [hSpriteIndex], a
	cp CINNABARGYM_SUPER_NERD2
	jr nz, .not_super_nerd3
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld de, MovementNpcToLeftAndUp
	jr .MoveSprite
.not_super_nerd3
	ld de, MovementNpcToLeft
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
.MoveSprite
	call MoveSprite
	ld a, SCRIPT_CINNABARGYM_GET_OPPONENT_TEXT
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ret

MovementNpcToLeftAndUp:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

MovementNpcToLeft:
	db NPC_MOVEMENT_LEFT
	db -1 ; end

CinnabarGymGetOpponentTextScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call EnableAllJoypad
	ld a, [wOpponentAfterWrongAnswer]
	ld [wTrainerHeaderFlagBit], a
	ldh [hTextID], a
	jp DisplayTextID

CinnabarGymFlagAction:
	predef_jump FlagActionPredef

CinnabarGymResetScripts:
	call ResetMapScripts
	; a = 0 after ResetMapScripts
	ld [wCinnabarGymCurScript], a ; SCRIPT_CINNABARGYM_DEFAULT
	ld [wOpponentAfterWrongAnswer], a
	ret

CinnabarGymOpenGateScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, CinnabarGymResetScripts
	ld a, [wTrainerHeaderFlagBit]
	ldh [hGymGateIndex], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call CinnabarGymFlagAction
	ld a, c
	and a
	jr nz, .no_sound
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	call WaitForSoundToFinish
.no_sound
	ld a, [wTrainerHeaderFlagBit]
	ldh [hGymGateIndex], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call CinnabarGymFlagAction
	ld a, [wTrainerHeaderFlagBit]
	sub $2
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	call CinnabarGymFlagAction
	call UpdateCinnabarGymGateTileBlocks
	jr CinnabarGymResetScripts

CinnabarGymBlainePostBattleScript:
	call UpdateCinnabarGymGateTileBlocks
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	call GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here after battle
	ld a, [wIsInBattle]
	cp $ff
	jr z, CinnabarGymResetScripts
	call DisableDpad
; fallthrough
CinnabarGymReceiveTM38:
	ld d, CINNABARGYM_BLAINE
	callfar MakeSpriteFacePlayer
	ld a, TEXT_CINNABARGYM_BLAINE_VOLCANO_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BLAINE
	lb bc, TM_BLAINE, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_CINNABARGYM_BLAINE_RECEIVED_TM38
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM38
	jr .gymVictory
.BagFull
	ld a, TEXT_CINNABARGYM_BLAINE_TM38_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_VOLCANOBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CINNABAR_GYM_TRAINER_0, EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	
	ld a, CINNABARGYM_BLAINE
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jp CinnabarGymResetScripts

CinnabarGym_TextPointers:
	def_text_pointers
	dw_const CinnabarGymBlaineText,                 TEXT_CINNABARGYM_BLAINE
	dw_const CinnabarGymSuperNerd1,                 TEXT_CINNABARGYM_SUPER_NERD1
	dw_const CinnabarGymBurglar1,                   TEXT_CINNABARGYM_BURGLAR1
	dw_const CinnabarGymSuperNerd2,                 TEXT_CINNABARGYM_SUPER_NERD2
	dw_const CinnabarGymBurglar2,                   TEXT_CINNABARGYM_BURGLAR2
	dw_const CinnabarGymFirefighter1,               TEXT_CINNERBARGYM_FIREFIGHTER1
	dw_const CinnabarGymBurglar3,                   TEXT_CINNABARGYM_BURGLAR3
	dw_const CinnabarGymFirefighter2,               TEXT_CINNERBARGYM_FIREFIGHTER2
	dw_const CinnabarGymGymGuideText,               TEXT_CINNABARGYM_GYM_GUIDE
	dw_const CinnabarGymBlaineVolcanoBadgeInfoText, TEXT_CINNABARGYM_BLAINE_VOLCANO_BADGE_INFO
	dw_const CinnabarGymBlaineReceivedTM38Text,     TEXT_CINNABARGYM_BLAINE_RECEIVED_TM38
	dw_const CinnabarGymBlaineTM38NoRoomText,       TEXT_CINNABARGYM_BLAINE_TM38_NO_ROOM

CinnabarGymStartBattleScript:
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld a, [wSpriteIndex]
	cp CINNABARGYM_BLAINE
	ld a, SCRIPT_CINNABARGYM_BLAINE_POST_BATTLE
	jr z, .blaine
	ld a, SCRIPT_CINNABARGYM_OPEN_GATE
.blaine
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	rst TextScriptEnd

CinnabarGymBlaineText:
	text_asm
	CheckEvent EVENT_BEAT_BLAINE
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM38
	jr nz, .afterBeat
	call z, CinnabarGymReceiveTM38
	call DisableWaitingAfterTextDisplay
	rst TextScriptEnd
.afterBeat
	ld d, MOLTRES
	callfar IsMonInParty
	jr nc, .noMoltres
	ld hl, .moltresText
	rst _PrintText
	lb hl, DEX_MOLTRES, BLAINE
	ld de, TextNothing
	ld bc, LearnsetFadeOutInBlaineStory
	predef_jump LearnsetTrainerScriptMain
.noMoltres
	ld hl, .PostBattleAdviceText
	rst _PrintText
	rst TextScriptEnd
.beforeBeat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, .ReceivedVolcanoBadgeText
	ld de, .ReceivedVolcanoBadgeText
	call SaveEndBattleTextPointers
	ld a, $7
	ld [wGymLeaderNo], a
	jp CinnabarGymStartBattleScript

.PreBattleText:
	text_far _CinnabarGymBlainePreBattleText
	text_end

.ReceivedVolcanoBadgeText:
	text_far _CinnabarGymBlaineReceivedVolcanoBadgeText
	sound_get_key_item ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	text_waitbutton
	text_end

.PostBattleAdviceText:
	text_far _CinnabarGymBlainePostBattleAdviceText
	text_end

.moltresText
	text_far _CinnabarGymBlaineMoltres
	text_end


CinnabarGymBlaineVolcanoBadgeInfoText:
	text_far _CinnabarGymBlaineVolcanoBadgeInfoText
	text_end

CinnabarGymBlaineReceivedTM38Text:
	text_far _CinnabarGymBlaineReceivedTM38Text
	sound_get_item_1
	text_far _CinnabarGymBlaineTM38ExplanationText
	text_end

CinnabarGymBlaineTM38NoRoomText:
	text_far _CinnabarGymBlaineTM38NoRoomText
	text_end

CinnabarGymSuperNerd1:
	text_asm
	ld hl, CinnabarGymSuperNerd1TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	; fall through
CinnabarGymDefaultTrainerTextScript:
	ldh a, [hTextID]
	ld [wTrainerHeaderFlagBit], a
	ld de, 5
	jr nz, .defeated
	push hl
	push de
	rst _PrintText
	pop de
	pop hl
	add hl, de
	; hl = .EndBattleText
	ld d, h
	ld e, l
	call SaveEndBattleTextPointers
	jp CinnabarGymStartBattleScript
.defeated
	add hl, de
	add hl, de ; hl = .AfterBattleText
	rst _PrintText
	rst TextScriptEnd

CinnabarGymBurglar1:
	text_asm
	ld hl, CinnabarGymBurglar1TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_1
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymSuperNerd2:
	text_asm
	ld hl, CinnabarGymSuperNerd2TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_2
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymBurglar2:
	text_asm
	ld hl, CinnabarGymBurglar2TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_3
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymFirefighter1:
	text_asm
	ld hl, CinnabarGymFirefighter1TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_4
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymBurglar3:
	text_asm
	ld hl, CinnabarGymBurglar3TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_5
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymFirefighter2:
	text_asm
	ld hl, CinnabarGymFirefighter2TextPointers
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	jr CinnabarGymDefaultTrainerTextScript

CinnabarGymSuperNerd1TextPointers:
.BattleText:
	text_far _CinnabarGymSuperNerd1BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymSuperNerd1EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymSuperNerd1AfterBattleText
	text_end

CinnabarGymBurglar1TextPointers:
.BattleText:
	text_far _CinnabarGymBurglar1BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymBurglar1EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymBurglar1AfterBattleText
	text_end

CinnabarGymSuperNerd2TextPointers:
.BattleText:
	text_far _CinnabarGymSuperNerd2BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymSuperNerd2EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymSuperNerd2AfterBattleText
	text_end

CinnabarGymBurglar2TextPointers:
.BattleText:
	text_far _CinnabarGymBurglar2BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymBurglar2EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymBurglar2AfterBattleText
	text_end

CinnabarGymFirefighter1TextPointers:
.BattleText:
	text_far _CinnabarGymFirefighter1BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymFirefighter1EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymFirefighter1AfterBattleText
	text_end

CinnabarGymBurglar3TextPointers:
.BattleText:
	text_far _CinnabarGymBurglar3BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymBurglar3EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymBurglar3AfterBattleText
	text_end

CinnabarGymFirefighter2TextPointers:
.BattleText:
	text_far _CinnabarGymFirefighter2BattleText
	text_end
.EndBattleText:
	text_far _CinnabarGymFirefighter2EndBattleText
	text_end
.AfterBattleText:
	text_far _CinnabarGymFirefighter2AfterBattleText
	text_end

CinnabarGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_BLAINE
	ld hl, ChampInMakingText
	jr nz, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, CinnabarGymGuidePostBattleText
	jr z, .printDone
	ld hl, CinnabarGymGuidePostBattleTextPrompt
	rst _PrintText
	CheckEvent EVENT_GOT_CINNABAR_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText7
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText7
	jr nc, .printDone
	ld hl, ReceivedApexChipsText7
	rst _PrintText
	ld hl, CinnabarGymGuideApexChipFireText
	rst _PrintText
	SetEvent EVENT_GOT_CINNABAR_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText7
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText7:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText7:
	text_far _PewterGymTM34NoRoomText
	text_end

GymGuideMoreApexChipText7:
	text_far _GymGuideMoreApexChipText
	text_end

AlreadyReceivedApexChipsText7:
	text_far _AlreadyReceivedApexChipsText
	text_end

CinnabarGymGuideApexChipFireText:
	text_far _CinnabarGymGuideApexChipFireText
	text_end

ChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far _CinnabarGymGymGuideChampInMakingText
	text_end

CinnabarGymGuidePostBattleText:
	text_far _CinnabarGymGymGuideBeatBlaineText
	text_end

CinnabarGymGuidePostBattleTextPrompt:
	text_far _CinnabarGymGymGuideBeatBlaineText
	text_promptbutton
	text_end