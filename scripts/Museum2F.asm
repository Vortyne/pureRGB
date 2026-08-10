; PureRGBnote: ADDED: new NPC who will give you LOST WALLET after beating them in a battle.

Museum2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Museum2FTrainerHeaders
	ld de, Museum2F_ScriptPointers
	jp ExecuteCurMapScriptInTable

Museum2F_TextPointers:
	def_text_pointers
	dba_const Museum2FWalletKid1,           TEXT_MUSEUM2F_WALLET_KID
	dba_const _Museum2FYoungsterText,        TEXT_MUSEUM2F_YOUNGSTER
	dba_const _Museum2FGrampsText,           TEXT_MUSEUM2F_GRAMPS
	dba_const _Museum2FScientistText,        TEXT_MUSEUM2F_SCIENTIST
	dba_const _Museum2FBrunetteGirlText,     TEXT_MUSEUM2F_BRUNETTE_GIRL
	dba_const _Museum2FHikerText,            TEXT_MUSEUM2F_HIKER
	dba_const _Museum2FSpaceShuttleSignText, TEXT_MUSEUM2F_SPACE_SHUTTLE_SIGN
	dba_const _Museum2FMoonStoneSignText,    TEXT_MUSEUM2F_MOON_STONE_SIGN
	dba_const _Museum2FWalletKidWalletGive,  TEXT_MUSEUM2F_WALLET_KID_WALLET_GIVE
	dba_const ReceivedLostWallet,           TEXT_MUSEUM2F_RECEIVED_LOST_WALLET
	dba_const WalletKidNoRoomText,          TEXT_MUSEUM2F_WALLET_KID_NO_ROOM

Museum2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_MUSEUM2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_MUSEUM2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_MUSEUM2F_END_BATTLE
	dw_const WalletKidPostBattle,                   SCRIPT_MUSEUM2F_WALLET_KID_POST_BATTLE

Museum2FTrainerHeaders:
	def_trainers
WalletKidTrainerHeader:
	trainer EVENT_BEAT_WALLET_KID, 0, Museum2FWalletKidBattle, Museum2FWalletKidEndBattle, Museum2FWalletKidEndBattle
	db -1 ; end

Museum2FWalletKid1:
	text_asm
	CheckEvent EVENT_MET_POCKET_ABRA_LADY
	ld hl, Museum2FWalletKid1Intro
	jr z, .printDone
.battle
	CheckEvent EVENT_BEAT_WALLET_KID
	jp nz, .giveWallet
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, WalletKidTrainerHeader
	call TalkToTrainer
	ld a, SCRIPT_MUSEUM2F_WALLET_KID_POST_BATTLE
	ld [wCurMapScript], a 
	rst TextScriptEnd
.giveWallet
	CheckEvent EVENT_GOT_LOST_WALLET
	ld hl, Museum2FWalletKidEnd
	jr nz, .printDone
	call GiveWallet
	jp TextScriptEndNoButtonPress
.printDone
	rst _PrintText
	rst TextScriptEnd

ResetScripts:
	xor a
	ld [wCurMapScript], a
	ret

WalletKidPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, ResetScripts
GiveWallet:
	ld d, MUSEUM2F_WALLET_KID
	callfar MakeSpriteFacePlayer
	SetEvent EVENT_BEAT_WALLET_KID
	ld a, TEXT_MUSEUM2F_WALLET_KID_WALLET_GIVE
	ldh [hTextID], a
	call DisplayTextID
	lb bc, LOST_WALLET, 1
	call GiveItem
	ld a, TEXT_MUSEUM2F_WALLET_KID_NO_ROOM
	jr nc, .done ; bag full
	SetEvent EVENT_GOT_LOST_WALLET
	ld a, TEXT_MUSEUM2F_RECEIVED_LOST_WALLET
.done
	ldh [hTextID], a
	call DisplayTextID
	jr ResetScripts

Museum2FWalletKid1Intro:
	text_far_end _Museum2FWalletKid1

Museum2FWalletKidEnd:
	text_far_end _Museum2FWalletKidEnd

Museum2FWalletKidBattle:
	text_far_end _Museum2FWalletKidBattle 

Museum2FWalletKidEndBattle:
	text_far_end _Museum2FWalletKidBattleAfter 

WalletKidNoRoomText:
	text_far_end _PewterGymTM34NoRoomText

ReceivedLostWallet:
	text_far _Museum2FReceivedLostWalletText
	sound_get_key_item
	text_end