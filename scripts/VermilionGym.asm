VermilionGym_Script:
	ld hl, wCurrentMapScriptFlags
	res BIT_CUR_MAP_LOADED_1, [hl]
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, VermilionGymSetDoorTile
	call EnableAutoTextBoxDrawing
	ld hl, VermilionGymTrainerHeaders
	ld de, VermilionGym_ScriptPointers
	ld a, [wVermilionGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVermilionGymCurScript], a
	ret

VermilionGymSetDoorTile:
	CheckEvent EVENT_2ND_LOCK_OPENED
	ld a, $5 ; clear floor tile ID
	jr nz, .replaceTile
	ld a, $24 ; double door tile ID
.replaceTile
	ld [wNewTileBlockID], a
	lb bc, 2, 2
	predef ReplaceTileBlock
	ld hl, wCurrentMapScriptFlags
	bit BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl]
	ret z
	jp GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here

VermilionGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_VERMILIONGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VERMILIONGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VERMILIONGYM_END_BATTLE
	dw_const VermilionGymLTSurgeAfterBattleScript,  SCRIPT_VERMILIONGYM_LT_SURGE_AFTER_BATTLE



VermilionGymResetScripts:
	call ResetMapScripts
	; a = 0 from ResetMapScripts
	ld [wVermilionGymCurScript], a
	ret

VermilionGymLTSurgeAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff ; did we lose?
	jr z, VermilionGymResetScripts
	call DisableDpad

VermilionGymLTSurgeReceiveTM24Script:
	ld d, VERMILIONGYM_LT_SURGE
	callfar MakeSpriteFacePlayer
	ld a, TEXT_VERMILIONGYM_LT_SURGE_THUNDER_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_LT_SURGE
	lb bc, TM_SURGE, 1
	call GiveItem
	jr nc, .bag_full
	ld a, TEXT_VERMILIONGYM_LT_SURGE_RECEIVED_TM24
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM24
	jr .gym_victory
.bag_full
	ld a, TEXT_VERMILIONGYM_LT_SURGE_TM24_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gym_victory
	ld hl, wObtainedBadges
	set BIT_THUNDERBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VERMILION_GYM_TRAINER_0, EVENT_BEAT_VERMILION_GYM_TRAINER_2

	ld a, VERMILIONGYM_LT_SURGE
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr VermilionGymResetScripts

VermilionGym_TextPointers:
	def_text_pointers
	dw_const VermilionGymLTSurgeText,                 TEXT_VERMILIONGYM_LT_SURGE
	dw_const VermilionGymGentlemanText,               TEXT_VERMILIONGYM_SOLDIER1
	dw_const VermilionGymSuperNerdText,               TEXT_VERMILIONGYM_ROCKER
	dw_const VermilionGymSailorText,                  TEXT_VERMILIONGYM_SOLDIER2
	dw_const VermilionGymGymGuideText,                TEXT_VERMILIONGYM_GYM_GUIDE
	dw_const VermilionGymGarbageNearSurgeText,        TEXT_VERMILIONGYM_GARBAGE_NEAR_SURGE
	dw_const VermilionGymBookshelfText,               TEXT_VERMILIONGYM_BOOKSHELF
	dw_const VermilionGymLTSurgeThunderBadgeInfoText, TEXT_VERMILIONGYM_LT_SURGE_THUNDER_BADGE_INFO
	dw_const VermilionGymLTSurgeReceivedTM24Text,     TEXT_VERMILIONGYM_LT_SURGE_RECEIVED_TM24
	dw_const VermilionGymLTSurgeTM24NoRoomText,       TEXT_VERMILIONGYM_LT_SURGE_TM24_NO_ROOM

VermilionGymTrainerHeaders:
	def_trainers 2
VermilionGymTrainerHeader0:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_0, 3, VermilionGymGentlemanBattleText, VermilionGymGentlemanEndBattleText, VermilionGymGentlemanAfterBattleText
VermilionGymTrainerHeader1:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_1, 2, VermilionGymSuperNerdBattleText, VermilionGymSuperNerdEndBattleText, VermilionGymSuperNerdAfterBattleText
VermilionGymTrainerHeader2:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_2, 3, VermilionGymSailorBattleText, VermilionGymSailorEndBattleText, VermilionGymSailorAfterBattleText
	db -1 ; end

VermilionGymLTSurgeText:
	text_asm
	CheckEvent EVENT_BEAT_LT_SURGE
	jr z, .before_beat
	CheckEventReuseA EVENT_GOT_TM24
	jr nz, .got_tm24_already
	call z, VermilionGymLTSurgeReceiveTM24Script
	call DisableWaitingAfterTextDisplay
	jr .text_script_end
.got_tm24_already
	ld hl, .PostBattleAdviceText
	rst _PrintText
	jr .text_script_end
.before_beat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, VermilionGymLTSurgeReceivedThunderBadgeText
	ld de, VermilionGymLTSurgeReceivedThunderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_VERMILIONGYM_LT_SURGE_AFTER_BATTLE
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
.text_script_end
	rst TextScriptEnd

.PreBattleText:
	text_far _VermilionGymLTSurgePreBattleText
	text_end

.PostBattleAdviceText:
	text_far _VermilionGymLTSurgePostBattleAdviceText
	text_end

VermilionGymLTSurgeThunderBadgeInfoText:
	text_far _VermilionGymLTSurgeThunderBadgeInfoText
	text_end

VermilionGymLTSurgeReceivedTM24Text:
	text_far _VermilionGymLTSurgeReceivedTM24Text
	sound_get_key_item
	text_far _TM24ExplanationText
	text_end

VermilionGymLTSurgeTM24NoRoomText:
	text_far _VermilionGymLTSurgeTM24NoRoomText
	text_end

VermilionGymLTSurgeReceivedThunderBadgeText:
	text_far _VermilionGymLTSurgeReceivedThunderBadgeText
	text_end

VermilionGymGentlemanText:
	text_asm
	ld hl, VermilionGymTrainerHeader0
VermilionGymTalkToTrainer:
	call TalkToTrainer
	rst TextScriptEnd

VermilionGymSuperNerdText:
	text_asm
	ld hl, VermilionGymTrainerHeader1
	jr VermilionGymTalkToTrainer

VermilionGymSailorText:
	text_asm
	ld hl, VermilionGymTrainerHeader2
	jr VermilionGymTalkToTrainer

VermilionGymGentlemanBattleText:
	text_far _VermilionGymGentlemanBattleText
	text_end

VermilionGymGentlemanEndBattleText:
	text_far _VermilionGymGentlemanEndBattleText
	text_end

VermilionGymGetTrainerText:
	call .getWhich
	ld b, 0
	add hl, bc
	rst _PrintText
	rst TextScriptEnd
.getWhich
	ld c, 0
	CheckEvent EVENT_BEAT_LT_SURGE
	ret nz
	CheckEvent EVENT_2ND_LOCK_OPENED
	ld c, 5
	ret nz
	ld c, 10
	ret

VermilionGymGentlemanAfterBattleText:
	text_asm
	ld hl, .text_entries
	jr VermilionGymGetTrainerText
.text_entries
.afterBeat
	text_far _VermilionGymGentlemanAfterBattleGymDefeatedText
	text_end
.afterLocks
	text_far _VermilionGymGentlemanAfterLocksText
	text_end
.beforeBeat
	text_far _VermilionGymGentlemanAfterBattleText
	text_end

VermilionGymSuperNerdAfterBattleText:
	text_asm
	ld hl, .text_entries
	jr VermilionGymGetTrainerText
.text_entries
.afterBeat
	text_far _VermilionGymSuperNerdAfterBattleGymDefeatedText
	text_end
.afterLocks
	text_far _VermilionGymSuperNerdAfterLocksText
	text_end
.beforeBeat
	text_far _VermilionGymSuperNerdAfterBattleText
	text_end

VermilionGymSailorAfterBattleText:
	text_asm
	ld hl, .text_entries
	jr VermilionGymGetTrainerText
.text_entries
.afterBeat
	text_far _VermilionGymSailorAfterBattleGymDefeatedText
	text_end
.afterLocks
	text_far _VermilionGymSailorAfterLocksText
	text_end
.beforeBeat
	text_far _VermilionGymSailorAfterBattleText
	text_end

VermilionGymSailorBattleText:
	text_far _VermilionGymSailorBattleText
	text_end

VermilionGymSailorEndBattleText:
	text_far _VermilionGymSailorEndBattleText
	text_end

VermilionGymSuperNerdBattleText:
	text_far _VermilionGymSuperNerdBattleText
	text_end

VermilionGymSuperNerdEndBattleText:
	text_far _VermilionGymSuperNerdEndBattleText
	text_end

VermilionGymGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_THUNDERBADGE, a
	ld hl, VermilionGymGuideChampInMakingText
	jr z, .printDone
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, VermilionGymGuidePostBattleText
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	CheckEvent EVENT_GOT_VERMILION_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText3
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, ApexNoRoomText3
	jr nc, .printDone
	ld hl, ReceivedApexChipsText3
	rst _PrintText
	ld hl, VermilionGymGuideApexChipElectricText
	rst _PrintText
	SetEvent EVENT_GOT_VERMILION_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText3
.printDone
	rst _PrintText
	rst TextScriptEnd

ReceivedApexChipsText3:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText3:
	text_far _PewterGymTM34NoRoomText
	text_end

GymGuideMoreApexChipText3:
	text_far _GymGuideMoreApexChipText
	text_end

AlreadyReceivedApexChipsText3:
	text_far _AlreadyReceivedApexChipsText
	text_end

VermilionGymGuideChampInMakingText:
	text_far _GymGuideChampInMakingText
	text_far _VermilionGymGymGuideChampInMakingText
	text_end

VermilionGymGuidePostBattleText:
	text_far _VermilionGymGymGuideBeatLTSurgeText
	text_end

VermilionGymGuideApexChipElectricText:
	text_far _VermilionGymGuideApexChipElectricText
	text_end

; PureRGBnote: ADDED: text entries for the garbage can and bookcase near surge for some flavour

VermilionGymGarbageNearSurgeText:
	text_far _VermilionGymGarbageNearSurgeText
	text_end

VermilionGymBookshelfText:
	text_far _VermilionGymBookshelfText
	text_end
