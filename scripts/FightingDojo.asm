FightingDojo_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	CheckEvent EVENT_GENERIC_NPC_WALKING_FLAG
	jr nz, .MasterWalking
	call WasMapJustLoaded
	jr z, .noMapLoadScript
	CheckEvent EVENT_OPENED_DOJO_INTERIOR
	jr z, .noMapLoadScript2
	call FightingDojoLoadBetaDojoTiles
	call c, FightingDojoReplaceScrolls
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	jr nz, .afterBattle
.noMapLoadScript
	CheckEvent EVENT_IN_FIGHTING_DOJO_EXPERT_CLUB_BATTLE_LOOP
	jr nz, .startBattleCheck
	ld a, [wXCoord]
	cp 12
	ret nc
.noMapLoadScript2
	ld hl, FightingDojoTrainerHeaders
	ld de, FightingDojo_ScriptPointers
	ld bc, wFightingDojoCurScript
	jp ExecuteCustomMapScriptInTable
.MasterWalking
	call IsNPCAutoMoving
	ret nz
	ResetEvent EVENT_GENERIC_NPC_WALKING_FLAG
	call EnableAllJoypad
	ld a, TEXT_FIGHTINGDOJO_KARATE_MASTER_POST_BALL
	ldh [hTextID], a
	jp DisplayTextID
.startBattleCheck
	lb de, 17, 4
	call IsPlayerAtCoords ; battle position
	ret nz
	jp StartFightingDojoExpertClubBattle
.afterBattle
	call ResetFitnessBattleState
	jr z, .reset ; lost battle
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	call GBFadeInFromWhite
	ld a, TEXT_FIGHTINGDOJO_EXPERT_CLUB_AFTER_BATTLE
	ldh [hTextID], a
	jp DisplayTextID
.reset
	ResetEvent EVENT_IN_FIGHTING_DOJO_EXPERT_CLUB_BATTLE_LOOP
	ret

FightingDojo_ScriptPointers:
	def_script_pointers
	dw_const FightingDojoDefaultScript,                SCRIPT_FIGHTINGDOJO_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,    SCRIPT_FIGHTINGDOJO_START_BATTLE
	dw_const EndTrainerBattle,                         SCRIPT_FIGHTINGDOJO_END_BATTLE
	dw_const FightingDojoKarateMasterPostBattleScript, SCRIPT_FIGHTINGDOJO_KARATE_MASTER_POST_BATTLE

FightingDojoDefaultScript:
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	ret nz
	call CheckFightingMapTrainers
	ld a, [wTrainerHeaderFlagBit]
	and a
	ret nz
	CheckEvent EVENT_BEAT_KARATE_MASTER
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld [wSavedCoordIndex], a
	lb de, 4, 3
	call IsPlayerAtCoords
	ret nz
	ld a, 1
	ld [wSavedCoordIndex], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, FIGHTINGDOJO_KARATE_MASTER
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_FIGHTINGDOJO_KARATE_MASTER
	ldh [hTextID], a
	jp DisplayTextID

FightingDojoResetScripts:
	call ResetMapScripts
	ld [wFightingDojoCurScript], a ; SCRIPT_FIGHTINGDOJO_DEFAULT
	ret

FightingDojoKarateMasterPostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, FightingDojoResetScripts
	ld a, [wSavedCoordIndex]
	and a ; nz if the player was at (4, 3), left of the Karate Master
	jr z, .already_facing
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
.already_facing
	call DisableDpad
	SetEventRange EVENT_BEAT_KARATE_MASTER, EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	ld d, FIGHTINGDOJO_KARATE_MASTER
	callfar MakeSpriteFacePlayer
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	call GBFadeInFromWhite
	ld a, TEXT_FIGHTINGDOJO_KARATE_MASTER_I_WILL_GIVE_YOU_A_POKEMON
	ldh [hTextID], a
	call DisplayTextID
	jr FightingDojoResetScripts

FightingDojo_TextPointers:
	def_text_pointers
	dba_const FightingDojoKarateMasterText,                          TEXT_FIGHTINGDOJO_KARATE_MASTER
	dba_const FightingDojoBlackbelt1Text,                            TEXT_FIGHTINGDOJO_BLACKBELT1
	dba_const FightingDojoBlackbelt2Text,                            TEXT_FIGHTINGDOJO_BLACKBELT2
	dba_const FightingDojoBlackbelt3Text,                            TEXT_FIGHTINGDOJO_BLACKBELT3
	dba_const FightingDojoBlackbelt4Text,                            TEXT_FIGHTINGDOJO_BLACKBELT4
	dba_const _FightingDojoSparringGuysLeftText,                     TEXT_FIGHTINGDOJO_SPARRING_GUYS_LEFT
	dba_const FightingDojoOpponentBlackbeltText,                     TEXT_FIGHTINGDOJO_SPARRING_GUYS_RIGHT
	dba_const FightingDojoSparringmonsNidokingText,                  TEXT_FIGHTINGDOJO_SPARRING_MONS_NIDOKING
	dba_const FightingDojoSparringmonsMachampText,                   TEXT_FIGHTINGDOJO_SPARRING_MONS_MACHAMP
	dba_const FightingDojoExpertBattleClerkText,                     TEXT_FIGHTINGDOJO_EXPERT_BATTLE_CLERK
	dba_const FightingDojoOpponentFistFighterText,                   TEXT_FIGHTINGDOJO_OPPONENT_FIST_FIGHTER
	dba_const FightingDojoOpponentTamerText,                         TEXT_FIGHTINGDOJO_OPPONENT_TAMER
	dba_const FightingDojoOpponentCooltrainerFText,                  TEXT_FIGHTINGDOJO_OPPONENT_COOLTRAINER_F
	dba_const FightingDojoHitmonleePokeBallText,                     TEXT_FIGHTINGDOJO_HITMONLEE_POKE_BALL
	dba_const FightingDojoHitmonchanPokeBallText,                    TEXT_FIGHTINGDOJO_HITMONCHAN_POKE_BALL
	dba_const _FightingDojoText,                                     TEXT_FIGHTINGDOJO_STATUE1
	dba_const _FightingDojoText,                                     TEXT_FIGHTINGDOJO_STATUE2
	dba_const _EnemiesOnEverySideText,                               TEXT_FIGHTINGDOJO_ENEMIES_SCROLL
	dba_const FightingDojoHitmonleeScrollText,                       TEXT_FIGHTINGDOJO_HITMONLEE_SCROLL
	dba_const FightingDojoHitmonchanScrollText,                      TEXT_FIGHTINGDOJO_HITMONCHAN_SCROLL
	dba_const _WhatGoesAroundComesAroundText,                        TEXT_FIGHTINGDOJO_GOES_AROUND_SCROLL
	dba_const FightingDojoHitmonleeScrollText,                       TEXT_FIGHTINGDOJO_HITMONLEE_SCROLL2
	dba_const FightingDojoHitmonchanScrollText,                      TEXT_FIGHTINGDOJO_HITMONCHAN_SCROLL2
	dba_const _FightingDojoExpertRulesSign,                          TEXT_FIGHTINGDOJO_EXPERT_RULES
	dba_const _FightingDojoBuddhaStatueText,                         TEXT_FIGHTINGDOJO_STATUE3
	dba_const _FightingDojoBuddhaStatueText,                         TEXT_FIGHTINGDOJO_STATUE4
	dba_const FightingDojoKarateMasterText.IWillGiveYouAPokemonText, TEXT_FIGHTINGDOJO_KARATE_MASTER_I_WILL_GIVE_YOU_A_POKEMON
	dba_const FightingDojoKarateMasterPostBallText,   				 TEXT_FIGHTINGDOJO_KARATE_MASTER_POST_BALL
	dba_const FightingDojoExpectClubAfterBattleText,                 TEXT_FIGHTINGDOJO_EXPERT_CLUB_AFTER_BATTLE

FightingDojoTrainerHeaders:
	def_trainers 2
FightingDojoTrainerHeader0:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_0, 4, _FightingDojoBlackbelt1BattleText, _FightingDojoBlackbelt1EndBattleText, _FightingDojoBlackbelt1AfterBattleText
FightingDojoTrainerHeader1:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_1, 4, _FightingDojoBlackbelt2BattleText, _FightingDojoBlackbelt2EndBattleText, FightingDojoBlackbelt2AfterBattleText
FightingDojoTrainerHeader2:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_2, 3, _FightingDojoBlackbelt3BattleText, _FightingDojoBlackbelt3EndBattleText, FightingDojoBlackbelt3AfterBattleText
FightingDojoTrainerHeader3:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_3, 3, _FightingDojoBlackbelt4BattleText, _FightingDojoBlackbelt4EndBattleText, _FightingDojoBlackbelt4AfterBattleText
	db -1 ; end

FightingDojoKarateMasterText:
	text_asm
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	jr nz, .beatEveryone
	CheckEventReuseA EVENT_BEAT_KARATE_MASTER
	ld hl, .IWillGiveYouAPokemonText
	jr nz, .printDone
	CheckBothEventsSet EVENT_BEAT_FIGHTING_DOJO_TRAINER_0, EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	jr nz, .defeatOthersFirst
	CheckBothEventsSet EVENT_BEAT_FIGHTING_DOJO_TRAINER_2, EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	jr nz, .defeatOthersFirst
	ld hl, .Text
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .DefeatedText
	ld de, .DefeatedText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_FIGHTINGDOJO_KARATE_MASTER_POST_BATTLE
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	rst TextScriptEnd
.defeatOthersFirst
	ld hl, .defeatOthers
	rst _PrintText
	ld a, [wYCoord]
	cp 3
	jr nz, .noDownWalk
	ld a, PAD_DOWN
	ld hl, wSimulatedJoypadStatesEnd
	ld [hli], a
	ld [hl], -1
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
.noDownWalk
	rst TextScriptEnd
.stay
	ld hl, .StayAndTrainWithUsText
.printDone
	rst _PrintText
	rst TextScriptEnd
.beatEveryone
	CheckEvent FLAG_CATCHUP_CLUBS_TURNED_OFF
	jr nz, .stay
	ld a, [wObtainedBadges]
	bit BIT_SOULBADGE, a
	ld hl, KarateMasterGoFightKogaText
	jr z, .printDone
	CheckAndSetEvent EVENT_OPENED_DOJO_INTERIOR
	jr nz, .stay
	ld hl, .gotSoulBadge
	rst _PrintText
	ld a, FIGHTINGDOJO_KARATE_MASTER
	call SetSpriteFacingUp
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld hl, .openUp
	rst _PrintText
	ld c, 40
	rst DelayFrames
	call FightingDojoReplaceScrolls
	ld a, SFX_FLY
	rst _PlaySound
	ld c, 12
	rst DelayFrames
	ld a, SFX_TELEPORT_ENTER_2
	rst _PlaySound
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	rst TextScriptEnd

.Text:
	text_far_end _FightingDojoKarateMasterText

.DefeatedText:
	text_far_end _FightingDojoKarateMasterDefeatedText

.IWillGiveYouAPokemonText:
	text_far_end _FightingDojoKarateMasterIWillGiveYouAPokemonText

.StayAndTrainWithUsText:
	text_far_end _FightingDojoKarateMasterStayAndTrainWithUsText

.defeatOthers
	text_far_end _FightingDojoKarateMasterOthersText

.gotSoulBadge
	text_far_end _FightingDojoMasterGotBadge

.openUp
	text_far_end _FightingDojoMasterOpenUp

FightingDojoBlackbelt1Text:
	script_trainer FightingDojoTrainerHeader0

FightingDojoBlackbelt2Text:
	script_trainer FightingDojoTrainerHeader1

FightingDojoBlackbelt3Text:
	script_trainer FightingDojoTrainerHeader2

FightingDojoBlackbelt4Text:
	script_trainer FightingDojoTrainerHeader3

FightingDojoBlackbelt2AfterBattleText:
	text_far _FightingDojoBlackbelt2AfterBattleText
	text_asm
	lb hl, DEX_MACHOKE, BLACKBELT
	ld de, MachokeLearnsetText2
	predef_jump LearnsetTrainerScript

FightingDojoBlackbelt3AfterBattleText:
	text_far _FightingDojoBlackbelt3AfterBattleText
	text_asm
	lb hl, DEX_PRIMEAPE, BLACKBELT
	ld de, PrimeapeLearnsetText
	predef_jump LearnsetTrainerScript

FightingDojoHitmonleePokeBallText:
	text_asm
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, .GetMon
	ld hl, FightingDojoBetterNotGetGreedyText
	rst _PrintText
	jr .done
.GetMon
	ld a, HITMONLEE
	call DisplayPokedex
	ld hl, .Text
	rst _PrintText
	call YesNoChoice
	jr nz, .done
	ld a, [wCurPartySpecies]
	ld b, a
	ld c, 30
	ld a, BALL_DATA_ULTRA << 3
	call GivePokemonCommon
	jr nc, .done

	; once Poké Ball is taken, hide sprite
	ld c, TOGGLE_FIGHTING_DOJO_GIFT_1
	call HideObject
	SetEvents EVENT_GOT_HITMONLEE, EVENT_DEFEATED_FIGHTING_DOJO
	SetEvent EVENT_GENERIC_NPC_WALKING_FLAG
	ld a, FIGHTINGDOJO_KARATE_MASTER
	ldh [hSpriteIndex], a
	ld de, GenericMoveUp
	call MoveSpriteButAllowAOrBPress
.done
	rst TextScriptEnd

.Text:
	text_far_end _FightingDojoHitmonleePokeBallText

FightingDojoHitmonchanPokeBallText:
	text_asm
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, .GetMon
	ld hl, FightingDojoBetterNotGetGreedyText
	rst _PrintText
	jr .done
.GetMon
	ld a, HITMONCHAN
	call DisplayPokedex
	ld hl, .Text
	rst _PrintText
	call YesNoChoice
	jr nz, .done
	ld a, [wCurPartySpecies]
	ld b, a
	ld c, 30
	ld a, BALL_DATA_ULTRA << 3
	call GivePokemonCommon
	jr nc, .done
	SetEvents EVENT_GOT_HITMONCHAN, EVENT_DEFEATED_FIGHTING_DOJO

	; once Poké Ball is taken, hide sprite
	ld c, TOGGLE_FIGHTING_DOJO_GIFT_2
	call HideObject
	SetEvent EVENT_GENERIC_NPC_WALKING_FLAG
	ld a, FIGHTINGDOJO_KARATE_MASTER
	ldh [hSpriteIndex], a
	ld de, .movement
	call MoveSpriteButAllowAOrBPress
.done
	rst TextScriptEnd

.Text:
	text_far_end _FightingDojoHitmonchanPokeBallText
.movement
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1

FightingDojoBetterNotGetGreedyText:
	text_far_end _FightingDojoBetterNotGetGreedyText

FightingDojoHitmonleeScrollText::
	text_far _FightingDojoHitmonleeScrollText
	text_asm
	CheckEvent FLAG_HITMONLEE_LEARNSET
	jr nz, .done
	ld d, DEX_HITMONLEE
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

FightingDojoHitmonchanScrollText::
	text_far _FightingDojoHitmonchanScrollText
	text_asm
	CheckEvent FLAG_HITMONCHAN_LEARNSET
	jr nz, .done
	ld d, DEX_HITMONCHAN
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd

FightingDojoKarateMasterPostBallText::
	text_asm
	ld c, TOGGLE_FIGHTING_DOJO_GIFT_1
	call HideObject
	ld c, TOGGLE_FIGHTING_DOJO_GIFT_2
	call HideObject
	ld c, 30
	rst DelayFrames
	ld a, [wXCoord]
	cp 4
	ld a, PLAYER_DIR_RIGHT
	ld hl, SetSpriteFacingLeft
	jr z, .masterIsRight
	ld a, PLAYER_DIR_LEFT
	ld hl, SetSpriteFacingRight
.masterIsRight
	ld [wPlayerMovingDirection], a
	ld a, FIGHTINGDOJO_KARATE_MASTER
	call hl_caller
	ld hl, .goodChoice
	rst _PrintText
	CheckEvent FLAG_CATCHUP_CLUBS_TURNED_OFF
	jr nz, .done
	call DisplayTextPromptButton
	ld hl, .justATest
	rst _PrintText
	ld hl, KarateMasterGoFightKogaText
	rst _PrintText
.done
	rst TextScriptEnd
.goodChoice
	text_far_end _FightingDojoMasterGoodChoice
.justATest
	text_far_end _FightingDojoMasterJustATest

KarateMasterGoFightKogaText:
	text_far_end _FightingDojoMasterJustATest2

FightingDojoReplaceScrolls:
	CheckEvent FLAG_CATCHUP_CLUBS_TURNED_OFF
	ret nz
	lb bc, 0, 2
	ld a, $05
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

FightingDojoLoadBetaDojoTiles::
	ld a, [wXCoord]
	cp 12
	ret c
	ld hl, vTileset tile $2C
	lb bc, BANK(DojoBetaTiles), 4
	ld de, DojoBetaTiles
	call CopyVideoDataHBlank
	ld hl, vTileset tile $55
	lb bc, BANK(DojoBetaTiles), 11
	ld de, DojoBetaTiles tile 4
	call CopyVideoDataHBlank
	ld hl, vTileset tile $30
	lb bc, BANK(House_GFX), 1
	ld de, House_GFX tile 5
	call CopyVideoDataHBlank
	ld hl, vTileset tile $31
	lb bc, BANK(House_GFX), 1
	ld de, House_GFX tile $15
	call CopyVideoDataHBlank
	and a
	ret

FightingDojoExpertBattleClerkText:
	text_far _FightingDojoExpertClubClerkText
	text_asm
	CheckAndSetEvent EVENT_MET_FIGHTING_DOJO_CLERK
	jr nz, .met
	ld hl, .intro
	rst _PrintText
	call DisplayTextPromptButton
.met
	ld hl, .start
	rst _PrintText
	lb de, 45, 33 ; max opponent level, min opponent level
	call FitnessClubIntroScript
	jr nc, .done
.startBattle
	ld hl, wSimulatedJoypadStatesEnd
	ld [hl], PAD_UP
	inc hl
	ld [hl], PAD_LEFT
	inc hl
	ld c, 3
	ld a, [wYCoord]
	cp 5
	ld b, PAD_LEFT
	jr z, .next
	cp 6
	ld a, PAD_UP
	ld b, a
	jr z, .next
	ld [hli], a
	ld [hli], a
	inc c
	inc c
	ld b, PAD_LEFT
.next
	ld [hl], b
	inc hl
	ld [hl], -1
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStatesOnlyAOrBPress
	SetEvent EVENT_IN_FIGHTING_DOJO_EXPERT_CLUB_BATTLE_LOOP
.done
	rst TextScriptEnd

.intro
	text_far_end _FightingDojoExpertClubClerkIntroText
.start
	text_far_end _FightingDojoExpertClubClerkBattleText

StartFightingDojoExpertClubBattle:
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld c, 30
	rst DelayFrames
	call HideFightingDojoExpertClubSprites ; hide previous opponents if applicable
	ld hl, AvailableFightingDojoExpertClubTrainers
	lb de, 3, 0 ; coord delta with respect to the player for opponent to show up at
	jp StartFitnessClubBattle

AvailableFightingDojoExpertClubTrainers:
	db OPP_BLACKBELT, TEXT_FIGHTINGDOJO_SPARRING_GUYS_RIGHT
	db OPP_FIST_FIGHTER, TEXT_FIGHTINGDOJO_OPPONENT_FIST_FIGHTER
	db OPP_TAMER, TEXT_FIGHTINGDOJO_OPPONENT_TAMER
	db OPP_COOLTRAINER_F, TEXT_FIGHTINGDOJO_OPPONENT_COOLTRAINER_F
	ASSERT FIGHTINGDOJO_SPARRING_GUYS_RIGHT == TEXT_FIGHTINGDOJO_SPARRING_GUYS_RIGHT
	ASSERT FIGHTINGDOJO_OPPONENT_FIST_FIGHTER == TEXT_FIGHTINGDOJO_OPPONENT_FIST_FIGHTER
	ASSERT FIGHTINGDOJO_OPPONENT_TAMER == TEXT_FIGHTINGDOJO_OPPONENT_TAMER
	ASSERT FIGHTINGDOJO_OPPONENT_COOLTRAINER_F == TEXT_FIGHTINGDOJO_OPPONENT_COOLTRAINER_F

HideFightingDojoExpertClubSprites:
	ld a, [wFitnessClubChallenger]
	cp FIGHTINGDOJO_SPARRING_GUYS_RIGHT
	ld c, a
	lb de, 30, 14
	jr nz, .notSparringGuy
	lb de, -1, 6
	jpfar FarMoveSpriteInRelationToPlayer
.notSparringGuy
	jpfar FarMoveSpriteOffScreen

FightingDojoExpectClubAfterBattleText:
	text_asm
	lb de, 45, 33
	call FitnessClubAfterBattleText
	jr c, .done
	ld hl, HideFightingDojoExpertClubSprites
	call FitnessClubHideOpponents
	ResetEvent EVENT_IN_FIGHTING_DOJO_EXPERT_CLUB_BATTLE_LOOP
.done
	rst TextScriptEnd

FightingDojoOpponentBlackbeltText:
	text_asm
	ld a, [wYCoord]
	cp 4
	ld hl, .normalText
	jr nz, .printDone
	ld hl, .intro1
	jp GetRandomClubOpponentText
.printDone
	rst _PrintText
	rst TextScriptEnd
.intro1
	text_far_end _FightingDojoOpponentBlackbeltIntro1
.intro2
	text_far_end _FightingDojoOpponentBlackbeltIntro2
.intro3
	text_far_end _FightingDojoOpponentBlackbeltIntro3
.intro4
	text_far_end _FightingDojoOpponentBlackbeltIntro4
.normalText
	text_far_end _FightingDojoSparringGuysRightText

FightingDojoSparringmonsNidokingText:
	text_far _FightingDojoSparringmonsNidokingText
	text_asm
	ld a, NIDOKING
.playCry
	call PlayCry
	ld c, DEX_NIDOKING - 1
	callfar SetMonSeen
	ld c, DEX_MACHAMP - 1
	callfar SetMonSeen
	call DisplayTextPromptButton
	ld hl, .grappling
	rst _PrintText
	rst TextScriptEnd
.grappling
	text_far_end _FightingDojoSparringmonsText

FightingDojoSparringmonsMachampText:
	text_far _FightingDojoSparringmonsMachampText
	text_asm
	ld a, MACHAMP
	jr FightingDojoSparringmonsNidokingText.playCry


FightingDojoOpponentFistFighterText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far_end _FightingDojoOpponentFistFighterIntro1
.intro2
	text_far_end _FightingDojoOpponentFistFighterIntro2
.intro3
	text_far_end _FightingDojoOpponentFistFighterIntro3
.intro4
	text_far_end _FightingDojoOpponentFistFighterIntro4

FightingDojoOpponentTamerText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far_end _FightingDojoOpponentTamerIntro1
.intro2
	text_far_end _FightingDojoOpponentTamerIntro2
.intro3
	text_far_end _FightingDojoOpponentTamerIntro3
.intro4
	text_far_end _FightingDojoOpponentTamerIntro4

FightingDojoOpponentCooltrainerFText:
	text_asm
	ld hl, .intro1
	jp GetRandomClubOpponentText
.intro1
	text_far_end _FightingDojoOpponentCooltrainerFIntro1
.intro2
	text_far_end _FightingDojoOpponentCooltrainerFIntro2
.intro3
	text_far_end _FightingDojoOpponentCooltrainerFIntro3
.intro4
	text_far_end _FightingDojoOpponentCooltrainerFIntro4
