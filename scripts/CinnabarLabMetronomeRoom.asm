CinnabarLabMetronomeRoom_Script:
	jp EnableAutoTextBoxDrawing

CinnabarLabMetronomeRoom_TextPointers:
	def_text_pointers
	dba_const CinnabarLabMetronomeRoomScientist1Text,  TEXT_CINNABARLABMETRONOMEROOM_SCIENTIST1
	dba_const _CinnabarLabMetronomeRoomScientist2Text, TEXT_CINNABARLABMETRONOMEROOM_SCIENTIST2
	dba_const CinnabarLabMetronomeRoomScientist3Text,  TEXT_CINNABARLABMETRONOMEROOM_SCIENTIST3
	dba_const _CinnabarLabMetronomeRoomPCText,         TEXT_CINNABARLABMETRONOMEROOM_PC_KEYBOARD
	dba_const _CinnabarLabMetronomeRoomPCText,         TEXT_CINNABARLABMETRONOMEROOM_PC_MONITOR
	dba_const _CinnabarLabMetronomeRoomAmberPipeText,  TEXT_CINNABARLABMETRONOMEROOM_AMBER_PIPE

CinnabarLabMetronomeRoomScientist1Text:
	text_asm
	CheckEvent EVENT_GOT_TM35
	jr nz, .got_item
	ld hl, .Text
	rst _PrintText
	lb bc, TM_CINNABAR_LAB_CENTER_ROOM, 1
	call GiveItem
	ld hl, .TM35NoRoomText
	jr nc, .printDone
	SetEvent EVENT_GOT_TM35
	ld hl, .ReceivedTM35Text
.printDone
	rst _PrintText
	rst TextScriptEnd
.got_item
	ld hl, .TM35ExplanationText
	rst _PrintText
	ld c, DEX_KINGLER - 1
	callfar SetMonSeen
	lb hl, DEX_KINGLER, SCIENTIST
	ld de, LearnsetKinglerGuy
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain

.Text:
	text_far_end _CinnabarLabMetronomeRoomScientist1Text

.ReceivedTM35Text:
	text_far_end _GenericPlayerReceivedTextSFX1

.TM35ExplanationText:
	text_far_end _CinnabarLabMetronomeRoomScientist1TM35ExplanationText

.TM35NoRoomText:
	text_far_end _CinnabarLabMetronomeRoomScientist1TM35NoRoomText

CinnabarLabMetronomeRoomScientist3Text:
	text_asm
	callfar DoesPlayerHaveLegendaryBird
	jr c, .hasLegendaryBird
	CheckEvent EVENT_SHOWED_RESEARCHER_LADY_LEGENDARY_BIRD
	ld hl, .default
	jr z, .printDone
	ld hl, .shownBirdBefore
.printDone
	rst _PrintText
	rst TextScriptEnd
.hasLegendaryBird
	SetEvent EVENT_SHOWED_RESEARCHER_LADY_LEGENDARY_BIRD
	ld de, ResearcherLadyName
	call CopyTrainerName
	ld a, [wPokedexNum]
	ld h, a
	ld l, $FF
	ld de, TextNothing
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain
.default
	text_far_end _CinnabarLabMetronomeRoomScientist3Text
.shownBirdBefore
	text_far_end _CinnabarLabMetronomeRoomScientist3Text2

ResearcherLadyName:
	db "RESEARCHER@"
