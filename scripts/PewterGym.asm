PewterGym_Script:
	call EnableAutoTextBoxDrawing
	; Check if the gym guide should call the player over after beating brock when the player is leaving
	CheckEvent EVENT_GYM_GUIDE_CALLED_PLAYER_OVER
	jr nz, .skipCallOverCheck
	CheckEvent EVENT_BEAT_BROCK
	jr z, .skipCallOverCheck
	ld a, [wYCoord]
	cp 11
	jr c, .skipCallOverCheck
	push af
	SetEvent EVENT_GYM_GUIDE_CALLED_PLAYER_OVER 
	pop af
	ld a, TEXT_PEWTERGYM_GYM_GUIDE_CALL_OVER
	jp z, PewterGymDisplayTextID
	; if the player warps out after beating brock with the pocket abra, then the gym guide won't call them over
	; if they re-enter the gym later
.skipCallOverCheck
	ld hl, PewterGymTrainerHeaders
	ld de, PewterGym_ScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

PewterGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_PEWTERGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_PEWTERGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_PEWTERGYM_END_BATTLE
	dw_const PewterGymBrockPostBattle,              SCRIPT_PEWTERGYM_BROCK_POST_BATTLE

PewterGymResetScripts:
	call ResetMapScripts
	ld [wPewterGymCurScript], a ; SCRIPT_PEWTERGYM_DEFAULT
	ret

PewterGymBrockPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, PewterGymResetScripts
	call DisableDpad
; fallthrough
PewterGymScriptReceiveTM34:
	ld d, PEWTERGYM_BROCK
	callfar MakeSpriteFacePlayer
	ld a, TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	call PewterGymDisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb bc, TM_BROCK, 1
	call GiveItem
	ld a, TEXT_PEWTERGYM_TM34_NO_ROOM
	jr nc, .BagFull
	SetEvent EVENT_GOT_TM34
	ld a, TEXT_PEWTERGYM_RECEIVED_TM34
.BagFull
	call PewterGymDisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_BOULDERBADGE, [hl]

	ld c, TOGGLE_GYM_GUY
	call HideObject
	ld c, TOGGLE_ROUTE_22_RIVAL_1
	call HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0
	ld a, PEWTERGYM_BROCK
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	jr PewterGymResetScripts

PewterGymDisplayTextID:
	ldh [hTextID], a
	jp DisplayTextID

PewterGym_TextPointers:
	def_text_pointers
	dw_const PewterGymBrockText,             TEXT_PEWTERGYM_BROCK
	dw_const PewterGymCooltrainerMText,      TEXT_PEWTERGYM_COOLTRAINER_M
	dw_const PewterGymGuideText,             TEXT_PEWTERGYM_GYM_GUIDE
	dw_const PewterGymBrockWaitTakeThisText, TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	dw_const PewterGymReceivedTM34Text,      TEXT_PEWTERGYM_RECEIVED_TM34
	dw_const PewterGymTM34NoRoomText,        TEXT_PEWTERGYM_TM34_NO_ROOM
	dw_const PewterGymGuideCallOverText,     TEXT_PEWTERGYM_GYM_GUIDE_CALL_OVER

PewterGymTrainerHeaders:
	def_trainers 2
PewterGymTrainerHeader0:
	trainer EVENT_BEAT_PEWTER_GYM_TRAINER_0, 5, PewterGymCooltrainerMBattleText, PewterGymCooltrainerMEndBattleText, PewterGymCooltrainerMAfterBattleText
	db -1 ; end

PewterGymBrockText:
	text_asm
	CheckEvent EVENT_BEAT_BROCK
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .afterBeat
	call z, PewterGymScriptReceiveTM34
	call DisableWaitingAfterTextDisplay
	rst TextScriptEnd
.afterBeat
	ld hl, .PostBattleAdviceText
	rst _PrintText
	rst TextScriptEnd
.beforeBeat
	ld hl, .PreBattleText
	rst _PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PewterGymBrockReceivedBoulderBadgeText
	ld de, PewterGymBrockReceivedBoulderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_PEWTERGYM_BROCK_POST_BATTLE
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	rst TextScriptEnd

.PreBattleText:
	text_far _PewterGymBrockPreBattleText
	text_end

.PostBattleAdviceText:
	text_far _PewterGymBrockPostBattleAdviceText
	text_end

PewterGymBrockWaitTakeThisText:
	text_far _PewterGymBrockWaitTakeThisText
	text_end

PewterGymReceivedTM34Text:
	text_far _PewterGymReceivedTM34Text
	sound_get_item_1
	text_far _TM34ExplanationText
	text_end

PewterGymTM34NoRoomText:
	text_far _PewterGymTM34NoRoomText
	text_end

PewterGymBrockReceivedBoulderBadgeText:
	text_far _PewterGymBrockReceivedBoulderBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_far _PewterGymBrockBoulderBadgeInfoText ; Text to tell that the flash technique can be used
	text_end

PewterGymCooltrainerMText:
	text_asm
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

PewterGymCooltrainerMBattleText:
	text_far _PewterGymCooltrainerMBattleText
	text_end

PewterGymCooltrainerMEndBattleText:
	text_far _PewterGymCooltrainerMEndBattleText
	text_end

PewterGymCooltrainerMAfterBattleText:
	text_far _PewterGymCooltrainerMAfterBattleText
	text_end

PewterGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_BOULDERBADGE, a
	jr nz, .afterBeat
	ld hl, PewterGymGuidePreAdviceText
	rst _PrintText
	call YesNoChoice
	ld hl, PewterGymGuideBeginAdviceText
	jr nz, .gotYesNoChoice
	ld hl, PewterGymGuideFreeServiceText
.gotYesNoChoice
	rst _PrintText
	ld hl, PewterGymGuideAdviceText
	jr .printDone
.afterBeat
	ld hl, PewterGymGuidePostBattleText
	rst _PrintText
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, PewterGymGuideApexChipText
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	ld hl, PewterGymTM34NoRoomText
	jr nc, .printDone
	ld hl, ReceivedApexChipsTextPewter
	rst _PrintText
	SetEvent EVENT_GOT_PEWTER_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText
.printDone
	rst _PrintText
	rst TextScriptEnd

PewterGymGuidePreAdviceText:
	text_far _PewterGymGuidePreAdviceText
	text_end

PewterGymGuideBeginAdviceText:
	text_far _PewterGymGuideBeginAdviceText
	text_end

PewterGymGuideAdviceText:
	text_far _PewterGymGuideAdviceText
	text_end

PewterGymGuideFreeServiceText:
	text_far _PewterGymGuideFreeServiceText
	text_end

PewterGymGuidePostBattleText:
	text_far _PewterGymGuidePostBattleText
	text_end

PewterGymGuideApexChipText:
	text_far _PewterGymGuideApexChipText
	text_end

ReceivedApexChipsTextPewter:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_far _ApexChipExplanationText
	text_end

AlreadyReceivedApexChipsText:
	text_far _AlreadyReceivedApexChipsText
	text_end

PewterGymGuideCallOverText:
	text_asm
	ld a, PEWTERGYM_GYM_GUIDE
	call SetSpriteFacingLeft
	ld hl, .text
	rst _PrintText
	rst TextScriptEnd
.text
	text_far _PewterGymGuideCallOverText
	text_end
