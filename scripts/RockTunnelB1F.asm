RockTunnelB1F_Script:
	call CheckUsedFlash
	ld hl, RockTunnel2TrainerHeaders
	ld de, RockTunnelB1F_ScriptPointers
	ld bc, wRockTunnelB1FCurScript
	jp ExecuteCustomMapScriptInTable

RockTunnelB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROCKTUNNELB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKTUNNELB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKTUNNELB1F_END_BATTLE

RockTunnelB1F_TextPointers:
	def_text_pointers
	dba_const RockTunnelB1FCooltrainerF1Text, TEXT_ROCKTUNNELB1F_COOLTRAINER_F1
	dba_const RockTunnelB1FHiker1Text,        TEXT_ROCKTUNNELB1F_HIKER1
	dba_const RockTunnelB1FSuperNerd1Text,    TEXT_ROCKTUNNELB1F_SUPER_NERD1
	dba_const RockTunnelB1FSuperNerd2Text,    TEXT_ROCKTUNNELB1F_SUPER_NERD2
	dba_const RockTunnelB1FHiker2Text,        TEXT_ROCKTUNNELB1F_HIKER2
	dba_const RockTunnelB1FCooltrainerF2Text, TEXT_ROCKTUNNELB1F_COOLTRAINER_F2
	dba_const RockTunnelB1FHiker3Text,        TEXT_ROCKTUNNELB1F_HIKER3
	dba_const RockTunnelB1FSuperNerd3Text,    TEXT_ROCKTUNNELB1F_SUPER_NERD3
;;;;;;;;;; PureRGBnote: ADDED: new item locations
	dba_const PickUpItemText,                 TEXT_ROCKTUNNELB1F_ITEM1
	dba_const PickUp3ItemText,                TEXT_ROCKTUNNELB1F_ITEM2
;;;;;;;;;;

RockTunnel2TrainerHeaders:
	def_trainers
RockTunnel2TrainerHeader0:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_0, 4, _RockTunnelB1FCooltrainerF1BattleText, _RockTunnelB1FCooltrainerF1EndBattleText, _RockTunnelB1FCooltrainerF1AfterBattleText
RockTunnel2TrainerHeader1:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_1, 3, _RockTunnelB1FHiker1BattleText, _RockTunnelB1FHiker1EndBattleText, _RockTunnelB1FHiker1AfterBattleText
RockTunnel2TrainerHeader2:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_2, 3, _RockTunnelB1FSuperNerd1BattleText, _RockTunnelB1FSuperNerd1EndBattleText, _RockTunnelB1FSuperNerd1AfterBattleText
RockTunnel2TrainerHeader3:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_3, 4, _RockTunnelB1FSuperNerd2BattleText, _RockTunnelB1FSuperNerd2EndBattleText, _RockTunnelB1FSuperNerd2AfterBattleText
RockTunnel2TrainerHeader4:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_4, 3, _RockTunnelB1FHiker2BattleText, _RockTunnelB1FHiker2EndBattleText, _RockTunnelB1FHiker2AfterBattleText
RockTunnel2TrainerHeader5:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_5, 4, _RockTunnelB1FCooltrainerF2BattleText, _RockTunnelB1FCooltrainerF2EndBattleText, _RockTunnelB1FCooltrainerF2AfterBattleText
RockTunnel2TrainerHeader6:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_6, 3, _RockTunnelB1FHiker3BattleText, _RockTunnelB1FHiker3EndBattleText, _RockTunnelB1FHiker3AfterBattleText
RockTunnel2TrainerHeader7:
	trainer EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_7, 3, _RockTunnelB1FSuperNerd3BattleText, _RockTunnelB1FSuperNerd3EndBattleText, _RockTunnelB1FSuperNerd3AfterBattleText
	db -1 ; end

RockTunnelB1FCooltrainerF1Text:
	script_trainer RockTunnel2TrainerHeader0

RockTunnelB1FHiker1Text:
	script_trainer RockTunnel2TrainerHeader1

RockTunnelB1FSuperNerd1Text:
	script_trainer RockTunnel2TrainerHeader2

RockTunnelB1FSuperNerd2Text:
	script_trainer RockTunnel2TrainerHeader3

RockTunnelB1FHiker2Text:
	script_trainer RockTunnel2TrainerHeader4

RockTunnelB1FCooltrainerF2Text:
	script_trainer RockTunnel2TrainerHeader5

RockTunnelB1FHiker3Text:
	script_trainer RockTunnel2TrainerHeader6

RockTunnelB1FSuperNerd3Text:
	script_trainer RockTunnel2TrainerHeader7
