SSAnne2FRooms_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wYCoord
	ld a, [hli]
	cp 6
	jr nc, .continue
	ld a, [hl] ; x coord
	cp 4
	call c, DisableAutoTextBoxDrawing ; need to disable auto text box drawing in the snorlax guy's room for the snorlax display to work properly.
.continue
	ld hl, SSAnne9TrainerHeaders
	ld de, SSAnne2FRooms_ScriptPointers
	ld bc, wSSAnne2FRoomsCurScript
	jp ExecuteCustomMapScriptInTableOnly

SSAnne2FRooms_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSANNE2FROOMS_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSANNE2FROOMS_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSANNE2FROOMS_END_BATTLE

SSAnne2FRooms_TextPointers:
	def_text_pointers
	dba_const SSAnne2FRoomsGentleman1Text,   TEXT_SSANNE2FROOMS_GENTLEMAN1
	dba_const SSAnne2FRoomsFisherText,       TEXT_SSANNE2FROOMS_FISHER
	dba_const SSAnne2FRoomsGentleman2Text,   TEXT_SSANNE2FROOMS_GENTLEMAN2
	dba_const SSAnne2FRoomsCooltrainerFText, TEXT_SSANNE2FROOMS_COOLTRAINER_F
	dba_const SSAnne2FRoomsGentleman3Text,   TEXT_SSANNE2FROOMS_GENTLEMAN3
	dba_const PickUp2ItemText,               TEXT_SSANNE2FROOMS_ITEM1
	dba_const _SSAnne2FRoomsGentleman4Text,   TEXT_SSANNE2FROOMS_GENTLEMAN4
	dba_const _SSAnne2FRoomsGrampsText,       TEXT_SSANNE2FROOMS_GRAMPS
	dba_const PickUpItemText,                TEXT_SSANNE2FROOMS_ITEM2
	dba_const _SSAnne2FRoomsGentleman5Text,   TEXT_SSANNE2FROOMS_GENTLEMAN5
	dba_const _SSAnne2FRoomsLittleBoyText,    TEXT_SSANNE2FROOMS_LITTLE_BOY
	dba_const _SSAnne2FRoomsBrunetteGirlText, TEXT_SSANNE2FROOMS_BRUNETTE_GIRL
	dba_const _SSAnne2FRoomsBeautyText,       TEXT_SSANNE2FROOMS_BEAUTY

SSAnne9TrainerHeaders:
	def_trainers
SSAnne9TrainerHeader0:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_0, 2, _SSAnne2FRoomsGentleman1BattleText, _SSAnne2FRoomsGentleman1EndBattleText, _SSAnne2FRoomsGentleman1AfterBattleText
SSAnne9TrainerHeader1:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_1, 3, _SSAnne2FRoomsFisherBattleText, _SSAnne2FRoomsFisherEndBattleText, _SSAnne2FRoomsFisherAfterBattleText
SSAnne9TrainerHeader2:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_2, 3, _SSAnne2FRoomsGentleman2BattleText, _SSAnne2FRoomsGentleman2EndBattleText, _SSAnne2FRoomsGentleman2AfterBattleText
SSAnne9TrainerHeader3:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_3, 2, _SSAnne2FRoomsCooltrainerFBattleText, _SSAnne2FRoomsCooltrainerFEndBattleText, _SSAnne2FRoomsCooltrainerFAfterBattleText
	db -1 ; end

SSAnne2FRoomsGentleman1Text:
	script_trainer SSAnne9TrainerHeader0

SSAnne2FRoomsFisherText:
	script_trainer SSAnne9TrainerHeader1

SSAnne2FRoomsGentleman2Text:
	script_trainer SSAnne9TrainerHeader2

SSAnne2FRoomsCooltrainerFText:
	script_trainer SSAnne9TrainerHeader3

SSAnne2FRoomsGentleman3Text:
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, .Text
	rst _PrintText
	call LoadScreenTilesFromBuffer1
	ld a, SNORLAX
	call DisplayPokedex
	rst TextScriptEnd

.Text:
	text_far_end _SSAnne2FRoomsGentleman3Text
