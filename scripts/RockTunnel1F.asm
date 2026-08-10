RockTunnel1F_Script:
	call CheckUsedFlash
	ld hl, RockTunnel1TrainerHeaders
	ld de, RockTunnel1F_ScriptPointers
	ld bc, wRockTunnel1FCurScript
	jp ExecuteCustomMapScriptInTable

CheckUsedFlash::
	CheckAndResetEvent EVENT_USED_FLASH_FROM_PARTY_MENU
	ret z
	ld a, 4 ; fade out music first
	call StopMusic
	; have to switch sound bank to the battle one to play the flash sound effect
	ld a, BANK(Music_TrainerBattle)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, $ff
	ld [wTempoModifier], a
	ld a, $09
	ld [wFrequencyModifier], a
	ld a, SFX_NOT_VERY_EFFECTIVE
	rst _PlaySound
	call GBPalWhiteOut
	call WaitForSoundToFinish
	xor a
	ld [wMapPalOffset], a ; undo darkness
	call GBFadeInFromWhite
	jp PlayDefaultMusic


RockTunnel1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROCKTUNNEL1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKTUNNEL1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKTUNNEL1F_END_BATTLE

RockTunnel1F_TextPointers:
	def_text_pointers
	dba_const RockTunnel1FHiker1Text,        TEXT_ROCKTUNNEL1F_HIKER1
	dba_const RockTunnel1FHiker2Text,        TEXT_ROCKTUNNEL1F_HIKER2
	dba_const RockTunnel1FHiker3Text,        TEXT_ROCKTUNNEL1F_HIKER3
	dba_const RockTunnel1FSuperNerdText,     TEXT_ROCKTUNNEL1F_SUPER_NERD
	dba_const RockTunnel1FCooltrainerF1Text, TEXT_ROCKTUNNEL1F_COOLTRAINER_F1
	dba_const RockTunnel1FCooltrainerF2Text, TEXT_ROCKTUNNEL1F_COOLTRAINER_F2
	dba_const RockTunnel1FCooltrainerF3Text, TEXT_ROCKTUNNEL1F_COOLTRAINER_F3
	dba_const PickUp5ItemText,               TEXT_ROCKTUNNEL1F_ITEM1 ; PureRGBnote: ADDED: new item location
	dba_const _RockTunnel1FSignText,         TEXT_ROCKTUNNEL1F_SIGN

RockTunnel1TrainerHeaders:
	def_trainers
RockTunnel1TrainerHeader0:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_0, 4, _RockTunnel1FHiker1BattleText, _RockTunnel1FHiker1EndBattleText, _RockTunnel1FHiker1AfterBattleText
RockTunnel1TrainerHeader1:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_1, 4, _RockTunnel1FHiker2BattleText, _RockTunnel1FHiker2EndBattleText, _RockTunnel1FHiker2AfterBattleText
RockTunnel1TrainerHeader2:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_2, 3, _RockTunnel1FHiker3BattleText, _RockTunnel1FHiker3EndBattleText, _RockTunnel1FHiker3AfterBattleText
RockTunnel1TrainerHeader3:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_3, 3, _RockTunnel1FSuperNerdBattleText, _RockTunnel1FSuperNerdEndBattleText, _RockTunnel1FSuperNerdAfterBattleText
RockTunnel1TrainerHeader4:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_4, 4, _RockTunnel1FCooltrainerF1BattleText, _RockTunnel1FCooltrainerF1EndBattleText, _RockTunnel1FCooltrainerF1AfterBattleText
RockTunnel1TrainerHeader5:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_5, 4, _RockTunnel1FCooltrainerF2BattleText, _RockTunnel1FCooltrainerF2EndBattleText, _RockTunnel1FCooltrainerF2AfterBattleText
RockTunnel1TrainerHeader6:
	trainer EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_6, 4, _RockTunnel1FCooltrainerF3BattleText, _RockTunnel1FCooltrainerF3EndBattleText, _RockTunnel1FCooltrainerF3AfterBattleText
	db -1 ; end

RockTunnel1FHiker1Text:
	script_trainer RockTunnel1TrainerHeader0

RockTunnel1FHiker2Text:
	script_trainer RockTunnel1TrainerHeader1

RockTunnel1FHiker3Text:
	script_trainer RockTunnel1TrainerHeader2

RockTunnel1FSuperNerdText:
	script_trainer RockTunnel1TrainerHeader3

RockTunnel1FCooltrainerF1Text:
	script_trainer RockTunnel1TrainerHeader4

RockTunnel1FCooltrainerF2Text:
	script_trainer RockTunnel1TrainerHeader5

RockTunnel1FCooltrainerF3Text:
	script_trainer RockTunnel1TrainerHeader6
