IndigoPlateauLobby_Script:
	lb de, 7, 7
	call SetSpecificBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	call Serial_TryEstablishingExternallyClockedConnection
	call CheckArenaAssistantWalking
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	ret z
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	; Reset Elite Four events if the player started challenging them before
	ld hl, wElite4Flags
	bit BIT_STARTED_ELITE_4, [hl]
	res BIT_STARTED_ELITE_4, [hl]
	ret z
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, EVENT_LANCES_ROOM_LOCK_DOOR
	ret

IndigoPlateauLobby_TextPointers:
	def_text_pointers
	dba_const GenericPokecenterNurseText,            TEXT_INDIGOPLATEAULOBBY_NURSE
	dba_const IndigoPlateauLobbyGymGuideText,         TEXT_INDIGOPLATEAULOBBY_GYM_GUIDE
	dba_const _IndigoPlateauLobbyCooltrainerFText,     TEXT_INDIGOPLATEAULOBBY_COOLTRAINER_F
	dba_const IndigoPlateauLobbyClerkText,            TEXT_INDIGOPLATEAULOBBY_CLERK
	dba_const IndigoPlateauLobbyLinkReceptionistText, TEXT_INDIGOPLATEAULOBBY_LINK_RECEPTIONIST
	dba_const IndigoGymGuideSonText,                  TEXT_INDIGOPLATEAULOBBY_TM_KID
	dba_const IndigoPlateauArenaAssistantText,        TEXT_INDIGOPLATEAULOBBY_ARENA_ASSISTANT

IndigoPlateauLobbyGymGuideText: ; PureRGBnote: ADDED: gym guide sells you apex chips (and a couple items) after becoming champ
	text_asm
	CheckEvent EVENT_BECAME_CHAMP
	jr nz, .afterChamp
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, IndigoPlateauLobbyGymGuideText2
	jr z, .donePrompt
	ld hl, IndigoPlateauLobbyGymGuideText2
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, IndigoPlateauApexChipsAfterChamp
	rst _PrintText
	rst TextScriptEnd
.afterChamp
	CheckEvent EVENT_TALKED_GYM_GUIDE_AFTER_CHAMP
	jr nz, .quickGreet
	SetEvent EVENT_TALKED_GYM_GUIDE_AFTER_CHAMP
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, IndigoPlateauGymGuideChampGreeting
	jr z, .donePrompt
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, IndigoPlateauGymGuideChampApexChips
	rst _PrintText
	jr .sellChips
.quickGreet
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	ld hl, IndigoPlateauGymGuideChampAfterGreet
	jr z, .donePrompt
	rst _PrintText
	call DisplayTextPromptButton
.sellChips
	ld hl, IndigoGymGuideShop
	call DisplayPokemartNoGreeting
	rst TextScriptEnd
.donePrompt
	rst _PrintText
	rst TextScriptEnd

IndigoGymGuideSonText:  ; PureRGBnote: ADDED: new NPC who will sell TMs - sells all 50 TMs after becoming champ.
	text_asm
	CheckEvent EVENT_BECAME_CHAMP
	jr nz, .afterChamp
	ld hl, IndigoPlateauGymGuideSonText
	rst _PrintText
	CheckEvent EVENT_MET_GYM_GUIDE_SON
	call nz, .noIntroduce
	call .checkIntroduce
	jr .shop1
.checkIntroduce
	CheckEvent EVENT_MET_GYM_GUIDE_SON
	ret nz
	ld hl, IndigoPlateauGymGuideSonIntro
	rst _PrintText
	ret
.noIntroduce
	ld hl, IndigoPlateauGymGuideSonShopStart
	rst _PrintText
	ret
.moreTMs
	CheckEvent EVENT_TALKED_GYM_GUIDE_SON_AFTER_CHAMP
	ret nz
	ld hl, IndigoPlateauGymGuideSonMoreTMs
	rst _PrintText
	ret
.afterChamp
	ld hl, IndigoPlateauGymGuideSonChampText
	rst _PrintText
	call .checkIntroduce
	CheckEvent EVENT_TALKED_GYM_GUIDE_SON_AFTER_CHAMP
	call nz, .noIntroduce 
	CheckEvent EVENT_MET_GYM_GUIDE_SON
	call nz, .moreTMs 
	SetEvent EVENT_TALKED_GYM_GUIDE_SON_AFTER_CHAMP
.shop2
	ld hl, IndigoGymGuideSonShop2
	jr .done
.shop1
	ld hl, IndigoGymGuideSonShop1
.done
	push hl
	call DisableTextDelay
	pop hl
	call DisplayPokemartNoGreeting
	call EnableTextDelay
	SetEvent EVENT_MET_GYM_GUIDE_SON
	rst TextScriptEnd

IndigoPlateauLobbyGymGuideText2:
	text_far _GymGuideChampInMakingText
	text_far_end _IndigoPlateauLobbyGymGuideText

IndigoPlateauApexChipsAfterChamp:
	text_far_end _IndigoPlateauApexChipsAfterChamp

IndigoPlateauGymGuideChampGreeting:
	text_far_end _IndigoPlateauGymGuideChampGreeting

IndigoPlateauGymGuideChampApexChips:
	text_far_end _IndigoPlateauGymGuideChampApexChips

IndigoPlateauGymGuideChampAfterGreet:
	text_far_end _IndigoPlateauGymGuideChampAfterGreet

IndigoPlateauLobbyLinkReceptionistText:
IF DEF(_DEBUG)
	text_asm ;DEBUGMODE
	SetEvent EVENT_BECAME_CHAMP
	rst TextScriptEnd
ELSE
	script_cable_club_receptionist
ENDC

IndigoPlateauGymGuideSonText:
	text_far _GymGuideChampInMakingText
	text_far_end _IndigoPlateauGymGuideSonText

IndigoPlateauGymGuideSonChampText:
	text_far_end _IndigoPlateauGymGuideSonChampText

IndigoPlateauGymGuideSonIntro:
	text_far_end _IndigoPlateauGymGuideSonIntro

IndigoPlateauGymGuideSonShopStart:
	text_far_end _IndigoPlateauGymGuideSonShopStart

IndigoPlateauGymGuideSonMoreTMs:
	text_far_end _IndigoPlateauGymGuideSonMoreTMs

INCLUDE "data/items/marts/indigo_plateau.asm"

; PureRGBnote: ADDED: new NPC arena assistant who will let you enter the champ arena after becoming champ 
IndigoPlateauArenaAssistantText:
	text_asm
	CheckEvent EVENT_BECAME_CHAMP
	ld hl, .onlyEliteFourAllowed
	jr z, .printDone
.becameChamp
	SetEvent EVENT_ARENA_ASSISTANT_WALKING
	; walks into door and leaves
	ld de, AssistantWalksUp
	ld a, INDIGOPLATEAULOBBY_ARENA_ASSISTANT
	ldh [hSpriteIndex], a
	call MoveSpriteButAllowAOrBPress
	ld hl, .champAttained
.printDone
	rst _PrintText
	rst TextScriptEnd
.onlyEliteFourAllowed
	text_far_end _IndigoPlateauArenaAssistantOnlyEliteFourAllowed
.champAttained
	text_far_end _IndigoPlateauArenaAssistantChampAttained

AssistantWalksUp:
	db NPC_MOVEMENT_UP
	db -1

CheckArenaAssistantWalking:
	CheckEvent EVENT_ARENA_ASSISTANT_WALKING
	ret z
	call DisableAllJoypad
	call IsNPCAutoMoving
	ret nz
	ResetEvent EVENT_ARENA_ASSISTANT_WALKING
	call EnableAllJoypad
	ld a, SFX_GO_OUTSIDE
	rst _PlaySound
	ld c, TOGGLE_INDIGO_PLATEAU_LOBBY_CHAMP_ARENA_ASSISTANT
	jp HideExtraObject

