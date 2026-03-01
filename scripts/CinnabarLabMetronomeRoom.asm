CinnabarLabMetronomeRoom_Script:
	jp EnableAutoTextBoxDrawing

CinnabarLabMetronomeRoom_TextPointers:
	def_text_pointers
	dw_const CinnabarLabMetronomeRoomScientist1Text, TEXT_CINNABARLABMETRONOMEROOM_SCIENTIST1
	dw_const CinnabarLabMetronomeRoomScientist2Text, TEXT_CINNABARLABMETRONOMEROOM_SCIENTIST2
	dw_const CinnabarLabMetronomeRoomScientist3Text, TEXT_CINNABARLABMETRONOMEROOM_SCIENTIST3
	dw_const CinnabarLabMetronomeRoomPCText,         TEXT_CINNABARLABMETRONOMEROOM_PC_KEYBOARD
	dw_const CinnabarLabMetronomeRoomPCText,         TEXT_CINNABARLABMETRONOMEROOM_PC_MONITOR
	dw_const CinnabarLabMetronomeRoomAmberPipeText,  TEXT_CINNABARLABMETRONOMEROOM_AMBER_PIPE

CinnabarLabMetronomeRoomScientist1Text:
	text_asm
	CheckEvent EVENT_GOT_TM35
	jr nz, .got_item
	ld hl, .Text
	rst _PrintText
	lb bc, TM_CINNABAR_LAB_CENTER_ROOM, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .ReceivedTM35Text
	rst _PrintText
	SetEvent EVENT_GOT_TM35
	rst TextScriptEnd
.bag_full
	ld hl, .TM35NoRoomText
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
.done
	rst TextScriptEnd

.Text:
	text_far _CinnabarLabMetronomeRoomScientist1Text
	text_end

.ReceivedTM35Text:
	text_far _CinnabarLabMetronomeRoomScientist1ReceivedTM35Text
	sound_get_item_1
	text_end

.TM35ExplanationText:
	text_far _CinnabarLabMetronomeRoomScientist1TM35ExplanationText
	text_end

.TM35NoRoomText:
	text_far _CinnabarLabMetronomeRoomScientist1TM35NoRoomText
	text_end

CinnabarLabMetronomeRoomScientist2Text:
	text_far _CinnabarLabMetronomeRoomScientist2Text
	text_end

CinnabarLabMetronomeRoomPCText:
	text_far _CinnabarLabMetronomeRoomPCText
	text_end

CinnabarLabMetronomeRoomAmberPipeText:
	text_far _CinnabarLabMetronomeRoomAmberPipeText
	text_end

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
	text_far _CinnabarLabMetronomeRoomScientist3Text
	text_end
.shownBirdBefore
	text_far _CinnabarLabMetronomeRoomScientist3Text2
	text_end

ResearcherLadyName:
	db "RESEARCHER@"
