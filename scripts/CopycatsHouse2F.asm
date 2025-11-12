CopycatsHouse2F_Script:
	jp EnableAutoTextBoxDrawing

CopycatsHouse2F_TextPointers:
	def_text_pointers
	dw_const CopycatsHouse2FCopycatText,      TEXT_COPYCATSHOUSE2F_COPYCAT
	dw_const CopycatsHouse2FDoduoText,        TEXT_COPYCATSHOUSE2F_DODUO
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_MONSTER
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_BIRD
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_FAIRY
	dw_const CopycatsHouse2FSNESText,         TEXT_COPYCATSHOUSE2F_SNES
	dw_const CopycatsHouse2FPCText,           TEXT_COPYCATSHOUSE2F_PC

CopycatsHouse2FCopycatText:
	text_asm
	CheckEvent EVENT_GOT_TM31
	jr nz, .got_item
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .DoYouLikePokemonText
	rst _PrintText
	ld b, POKE_DOLL
	call IsItemInBag
	jr z, .done
	ld hl, .TM31PreReceiveText
	rst _PrintText
	lb bc, TM_SAFFRON_CITY_COPYCAT_POKEDOLL_REWARD, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .ReceivedTM31Text
	rst _PrintText
	ld a, POKE_DOLL
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	SetEvent EVENT_GOT_TM31
	jr .done
.bag_full
	ld hl, .TM31NoRoomText
	rst _PrintText
	jr .done
.got_item
	ld hl, .TM31Explanation2Text
	rst _PrintText
.done
	rst TextScriptEnd

.DoYouLikePokemonText:
	text_far _CopycatsHouse2FCopycatDoYouLikePokemonText
	text_end

.TM31PreReceiveText:
	text_far _CopycatsHouse2FCopycatTM31PreReceiveText
	text_end

.ReceivedTM31Text:
	text_far _CopycatsHouse2FCopycatReceivedTM31Text
	sound_get_item_1
.TM31Explanation1Text:
	text_far _CopycatsHouse2FCopycatTM31Explanation1Text
	text_waitbutton
	text_end

.TM31Explanation2Text:
	text_far _CopycatsHouse2FCopycatTM31Explanation2Text
	text_end

.TM31NoRoomText:
	text_far _CopycatsHouse2FCopycatTM31NoRoomText
	text_waitbutton
	text_end

CopycatsHouse2FDoduoText:
	text_far _CopycatsHouse2FDoduoText
	text_asm
	ld a, DODUO
	call PlayCry
	ld c, DEX_DODUO - 1
	callfar SetMonSeen
	call DisplayTextPromptButton
	ld hl, .mirrorMirror
	rst _PrintText
	CheckEvent FLAG_DODRIO_FAMILY_LEARNSET
	jr nz, .done
	ld a, COPYCATSHOUSE2F_COPYCAT
	call SetSpriteFacingDown
	ld de, CopycatName
	call CopyTrainerName
	lb hl, DEX_DODUO, $FF
	ld de, DoduoLearnsetText
	ld bc, LearnsetPlayedAroundWith
	predef_jump LearnsetTrainerScriptMain
.done
	rst TextScriptEnd
.mirrorMirror
	text_far _CopycatsHouse2FDoduoText2
	text_end

CopycatName:
	db "COPYCAT@"


CopycatsHouse2FRareDollText:
	text_far _CopycatsHouse2FRareDollText
	text_end

CopycatsHouse2FSNESText:
	text_far _CopycatsHouse2FSNESText
	text_end

CopycatsHouse2FPCText:
	text_far _CopycatsHouse2FPCMySecretsText
	text_end
