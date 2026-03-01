Route16FlyHouse_Script:
	jp EnableAutoTextBoxDrawing

Route16FlyHouse_TextPointers:
	def_text_pointers
	dw_const Route16FlyHouseBrunetteGirlText, TEXT_ROUTE16FLYHOUSE_BRUNETTE_GIRL
	dw_const Route16FlyHouseFearowText,       TEXT_ROUTE16FLYHOUSE_FEAROW

Route16FlyHouseBrunetteGirlText:
	text_asm
	CheckEvent EVENT_GOT_HM02
	ld hl, .HM02ExplanationText
	jr nz, .got_item
	ld hl, .Text
	rst _PrintText
	lb bc, HM_FLY, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_HM02
	ld hl, .ReceivedHM02Text
	jr .got_item
.bag_full
	ld hl, .HM02NoRoomText
.got_item
	rst _PrintText
	rst TextScriptEnd

.Text:
	text_far _Route16FlyHouseBrunetteGirlText
	text_end

.ReceivedHM02Text:
	text_far _Route16FlyHouseBrunetteGirlReceivedHM02Text
	sound_get_key_item
	text_end

.HM02ExplanationText:
	text_far _Route16FlyHouseBrunetteGirlHM02ExplanationText
	text_end

.HM02NoRoomText:
	text_far _Route16FlyHouseBrunetteGirlHM02NoRoomText
	text_end

Route16FlyHouseFearowText:
	text_far _Route16FlyHouseFearowText
	text_asm
	ld a, FEAROW
	call PlayCry
	call WaitForSoundToFinish
	call DisplayTextPromptButton
	ld a, ROUTE16FLYHOUSE_BRUNETTE_GIRL
	call SetSpriteFacingDown
	ld de, .famousGirlName
	call CopyTrainerName
	ld hl, .polly
	rst _PrintText
	ld c, DEX_FEAROW - 1
	callfar SetMonSeen
	lb hl, DEX_FEAROW, $FF
	ld de, TextNothing
	ld bc, LearnsetFadeOutInStory
	predef_jump LearnsetTrainerScriptMain
.polly:
	text_far _Route16FlyHouseFearow2Text
	text_end
.famousGirlName
	db "FAMOUS GIRL@"