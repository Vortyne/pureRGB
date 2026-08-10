RocketHideoutB1F_Script:
	call RocketHideoutB1FDoorCallbackScript
	ld hl, RocketHideout1TrainerHeaders
	ld de, RocketHideoutB1F_ScriptPointers
	ld bc, wRocketHideoutB1FCurScript
	jp ExecuteCustomMapScriptInTable

RocketHideoutB1FDoorCallbackScript:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_ENTERED_ROCKET_HIDEOUT
	jr nz, .door_open
	CheckEventReuseA EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4
	jr nz, .play_sound_door_open
	ld a, $54 ; Door Block
	jr .set_door_block
.play_sound_door_open
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	SetEvent EVENT_ENTERED_ROCKET_HIDEOUT
.door_open
	ld a, $e ; Floor Block
.set_door_block
	ld [wNewTileBlockID], a
	lb bc, 8, 12
	jp ReplaceTileBlock

RocketHideoutB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROCKETHIDEOUTB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKETHIDEOUTB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKETHIDEOUTB1F_END_BATTLE

RocketHideoutB1F_TextPointers:
	def_text_pointers
	dba_const RocketHideoutB1FRocket1Text, TEXT_ROCKETHIDEOUTB1F_ROCKET1
	dba_const RocketHideoutB1FRocket2Text, TEXT_ROCKETHIDEOUTB1F_ROCKET2
	dba_const RocketHideoutB1FRocket3Text, TEXT_ROCKETHIDEOUTB1F_ROCKET3
	dba_const RocketHideoutB1FRocket4Text, TEXT_ROCKETHIDEOUTB1F_ROCKET4
	dba_const RocketHideoutB1FRocket5Text, TEXT_ROCKETHIDEOUTB1F_ROCKET5
	dba_const PickUp5ItemText,              TEXT_ROCKETHIDEOUTB1F_ITEM1
	dba_const PickUp3ItemText,              TEXT_ROCKETHIDEOUTB1F_ITEM2

RocketHideout1TrainerHeaders:
	def_trainers
RocketHideout1TrainerHeader0:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_0, 3, _RocketHideoutB1FRocket1BattleText, _RocketHideoutB1FRocket1EndBattleText, _RocketHideoutB1FRocket1AfterBattleText
RocketHideout1TrainerHeader1:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_1, 2, _RocketHideoutB1FRocket2BattleText, _RocketHideoutB1FRocket2EndBattleText, _RocketHideoutB1FRocket2AfterBattleText
RocketHideout1TrainerHeader2:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_2, 2, _RocketHideoutB1FRocket3BattleText, _RocketHideoutB1FRocket3EndBattleText, _RocketHideoutB1FRocket3AfterBattleText
RocketHideout1TrainerHeader3:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_3, 3, _RocketHideoutB1FRocket4BattleText, _RocketHideoutB1FRocket4EndBattleText, _RocketHideoutB1FRocket4AfterBattleText
RocketHideout1TrainerHeader4:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4, 3, _RocketHideoutB1FRocket5BattleText, RocketHideoutB1FRocket5EndBattleText, _RocketHideoutB1FRocket5AfterBattleText
	db -1 ; end

RocketHideoutB1FRocket1Text:
	script_trainer RocketHideout1TrainerHeader0

RocketHideoutB1FRocket2Text:
	script_trainer RocketHideout1TrainerHeader1

RocketHideoutB1FRocket3Text:
	script_trainer RocketHideout1TrainerHeader2

RocketHideoutB1FRocket4Text:
	script_trainer RocketHideout1TrainerHeader3

RocketHideoutB1FRocket5Text:
	script_trainer RocketHideout1TrainerHeader4

RocketHideoutB1FRocket5EndBattleText:
	text_far _RocketHideoutB1FRocket5EndBattleText
	text_asm
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4
	call DisplayTextPromptButton
	rst TextScriptEnd
