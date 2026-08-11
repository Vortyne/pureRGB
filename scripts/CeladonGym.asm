CeladonGym_Script:
	call CeladonGymCheckHideCutTrees
	ld hl, CeladonGymTrainerHeaders
	ld de, CeladonGym_ScriptPointers
	ld bc, wCeladonGymCurScript
	jp ExecuteCustomMapScriptInTable

; PureRGBnote: ADDED: code that keeps the cut trees cut down if we're in their alcove. Prevents getting softlocked if you delete cut.
CeladonGymCheckHideCutTrees:
	call WasMapJustLoaded
	ret z
	ld de, CeladonGymCutAlcove
	callfar FarArePlayerCoordsInRange
	jr c, .removeTreeBlockers
	; if the map is loaded outside of the alcove, reset the cut tree events
	ResetEvent EVENT_CUT_DOWN_CELADON_GYM_LEFT_TREE
	ResetEvent EVENT_CUT_DOWN_CELADON_GYM_BOTTOM_TREE
	ResetEvent EVENT_CUT_DOWN_CELADON_GYM_RIGHT_TREE
	ret
.removeTreeBlockers
	CheckEvent EVENT_CUT_DOWN_CELADON_GYM_LEFT_TREE
	jr z, .bottomTreeCheck
	lb de, 2, 1
	ld a, $35
	call .replaceTileBlock
.bottomTreeCheck
	CheckEvent EVENT_CUT_DOWN_CELADON_GYM_BOTTOM_TREE
	jr z, .rightTreeCheck
	lb de, 3, 2
	ld a, $35
	call .replaceTileBlock
.rightTreeCheck
	CheckEvent EVENT_CUT_DOWN_CELADON_GYM_RIGHT_TREE
	jr z, .done
	lb de, 2, 3
	ld a, $36
	call .replaceTileBlock
.done
	; doing the redraw at the end will improve performance if we need to replace multiple tree tileblocks.
	; since we're standing in the cut alcove to reach this code, all the trees are on screen and a redraw will be necessary
	jpfar RedrawMapView
.replaceTileBlock
	ld [wNewTileBlockID], a
	jpfar ReplaceTileBlockNoRedraw

CeladonGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_CELADONGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_CELADONGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_CELADONGYM_END_BATTLE
	dw_const CeladonGymErikaPostBattleScript,       SCRIPT_CELADONGYM_ERIKA_POST_BATTLE
	

CeladonGymResetScripts:
	call ResetMapScripts
	ld [wCeladonGymCurScript], a ; SCRIPT_CELADONGYM_DEFAULT
	ret

CeladonGymErikaPostBattleScript:
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	call GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here
	ld a, [wIsInBattle]
	cp $ff
	jr z, CeladonGymResetScripts
	call DisableDpad

CeladonGymReceiveTM21:
	ld d, CELADONGYM_ERIKA
	callfar MakeSpriteFacePlayer
	ld a, TEXT_CELADONGYM_RAINBOWBADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_ERIKA
	lb bc, TM_ERIKA, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_CELADONGYM_RECEIVED_TM21
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM21
	jr .gymVictory
.BagFull
	ld a, TEXT_CELADONGYM_TM21_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_RAINBOWBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CELADON_GYM_TRAINER_0, EVENT_BEAT_CELADON_GYM_TRAINER_6

	ld a, CELADONGYM_ERIKA
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr CeladonGymResetScripts

CeladonGym_TextPointers:
	def_text_pointers
	dba_const CeladonGymErikaText,            TEXT_CELADONGYM_ERIKA
	dba_const CeladonGymCooltrainerF1Text,    TEXT_CELADONGYM_COOLTRAINER_F1
	dba_const CeladonGymBeauty1Text,          TEXT_CELADONGYM_BEAUTY1
	dba_const CeladonGymCooltrainerF2Text,    TEXT_CELADONGYM_COOLTRAINER_F2
	dba_const CeladonGymBeauty2Text,          TEXT_CELADONGYM_BEAUTY2
	dba_const CeladonGymCooltrainerF3Text,    TEXT_CELADONGYM_COOLTRAINER_F3
	dba_const CeladonGymBeauty3Text,          TEXT_CELADONGYM_BEAUTY3
	dba_const CeladonGymCooltrainerF4Text,    TEXT_CELADONGYM_COOLTRAINER_F4
	dba_const CeladonGymRainbowBadgeInfoText, TEXT_CELADONGYM_RAINBOWBADGE_INFO
	dba_const CeladonGymReceivedTM21Text,     TEXT_CELADONGYM_RECEIVED_TM21
	dba_const CeladonGymTM21NoRoomText,       TEXT_CELADONGYM_TM21_NO_ROOM

CeladonGymTrainerHeaders:
	def_trainers 2
CeladonGymTrainerHeader0:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_0, 2, _CeladonGymBattleText2, _CeladonGymEndBattleText2, CeladonGymAfterBattleText2
CeladonGymTrainerHeader1:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_1, 2, _CeladonGymBattleText3, _CeladonGymEndBattleText3, _CeladonGymAfterBattleText3
CeladonGymTrainerHeader2:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_2, 4, _CeladonGymBattleText4, _CeladonGymEndBattleText4, _CeladonGymAfterBattleText4
CeladonGymTrainerHeader3:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_3, 4, _CeladonGymBattleText5, _CeladonGymEndBattleText5, _CeladonGymAfterBattleText5
CeladonGymTrainerHeader4:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_4, 2, _CeladonGymBattleText6, _CeladonGymEndBattleText6, _CeladonGymAfterBattleText6
CeladonGymTrainerHeader5:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_5, 2, _CeladonGymBattleText7, _CeladonGymEndBattleText7, _CeladonGymAfterBattleText7
CeladonGymTrainerHeader6:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_6, 3, _CeladonGymBattleText8, _CeladonGymEndBattleText8, _CeladonGymAfterBattleText8
	db -1 ; end

CeladonGymErikaText:
	text_asm
	CheckEvent EVENT_BEAT_ERIKA
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM21
	jr nz, .afterBeat
	call z, CeladonGymReceiveTM21
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld hl, .PostBattleAdviceText
	rst _PrintText
	jr .done
.beforeBeat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .ReceivedRainbowBadgeText
	ld de, .ReceivedRainbowBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $4
	ld [wGymLeaderNo], a
	ld a, SCRIPT_CELADONGYM_ERIKA_POST_BATTLE
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
.done
	rst TextScriptEnd

.PreBattleText:
	text_far_end _CeladonGymErikaPreBattleText

.ReceivedRainbowBadgeText:
	text_far_end _CeladonGymErikaReceivedRainbowBadgeText

.PostBattleAdviceText:
	text_far_end _CeladonGymErikaPostBattleAdviceText

CeladonGymRainbowBadgeInfoText:
	text_far_end _CeladonGymRainbowBadgeInfoText

CeladonGymReceivedTM21Text:
	text_far _GenericPlayerReceivedTextSFX1
	text_far_end _TM21ExplanationText

CeladonGymTM21NoRoomText:
	text_far_end _CeladonGymTM21NoRoomText

CeladonGymCooltrainerF1Text:
	script_trainer CeladonGymTrainerHeader0

CeladonGymBeauty1Text:
	script_trainer CeladonGymTrainerHeader1

CeladonGymCooltrainerF2Text:
	script_trainer CeladonGymTrainerHeader2

CeladonGymBeauty2Text:
	script_trainer CeladonGymTrainerHeader3

CeladonGymCooltrainerF3Text:
	script_trainer CeladonGymTrainerHeader4

CeladonGymBeauty3Text:
	script_trainer CeladonGymTrainerHeader5

CeladonGymCooltrainerF4Text:
	script_trainer CeladonGymTrainerHeader6

CeladonGymAfterBattleText2:
	text_asm
	CheckEvent EVENT_BEAT_ERIKA
	ld hl, .beforeBeat
	ret z
	ld hl, .afterBeat
	ret
.afterBeat
	text_far_end _CeladonGymAfterBattleText2GymDefeated
.beforeBeat
	text_far_end _CeladonGymAfterBattleText2
