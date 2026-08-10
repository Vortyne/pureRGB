PokemonFanClub_Script:
	jp EnableAutoTextBoxDrawing

PokemonFanClub_TextPointers:
	def_text_pointers
	dba_const PokemonFanClubPikachuFanText,    TEXT_POKEMONFANCLUB_PIKACHU_FAN
	dba_const PokemonFanClubSeelFanText,       TEXT_POKEMONFANCLUB_SEEL_FAN
	dba_const PokemonFanClubPikachuText,       TEXT_POKEMONFANCLUB_PIKACHU
	dba_const PokemonFanClubSeelText,          TEXT_POKEMONFANCLUB_SEEL
	dba_const PokemonFanClubChairmanText,      TEXT_POKEMONFANCLUB_CHAIRMAN
	dba_const _PokemonFanClubReceptionistText, TEXT_POKEMONFANCLUB_RECEPTIONIST
	dba_const _PokemonFanClubSign1Text,        TEXT_POKEMONFANCLUB_SIGN_1
	dba_const _PokemonFanClubSign2Text,        TEXT_POKEMONFANCLUB_SIGN_2

PokemonFanClubPikachuFanText:
	text_asm
	ld c, DEX_PIKACHU - 1
	callfar SetMonSeen
	ld d, PIKACHU
	callfar IsMonInParty
	jr nc, .no
	ld hl, .yoursText
	rst _PrintText
	call AreLearnsetsEnabled
	jr z, .done
	CheckEvent FLAG_RAICHU_FAMILY_LEARNSET
	jr nz, .done
	ld de, FanName
	call CopyTrainerName
	lb hl, DEX_PIKACHU, $FF
	ld de, LearnsetCuteTalk
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain
.no
	CheckEvent EVENT_PIKACHU_FAN_BOAST
	jr nz, .mineisbetter
	ld hl, .NormalText
	rst _PrintText
	SetEvent EVENT_SEEL_FAN_BOAST
	jr .done
.mineisbetter
	ld hl, .BetterText
	rst _PrintText
	ResetEvent EVENT_PIKACHU_FAN_BOAST
.done
	rst TextScriptEnd

.NormalText:
	text_far_end _PokemonFanClubPikachuFanNormalText

.BetterText:
	text_far_end _PokemonFanClubPikachuFanBetterText

.yoursText:
	text_far_end _PokemonFanClubPikachuFanYoursText

FanName:
	db "SUPERFAN@"

PokemonFanClubSeelFanText:
	text_asm
	ld c, DEX_SEEL - 1
	callfar SetMonSeen
	ld d, SEEL
	callfar IsMonInParty
	jr nc, .no
	ld hl, .yoursText
	rst _PrintText
	call AreLearnsetsEnabled
	jr z, .done
	CheckEvent FLAG_DEWGONG_FAMILY_LEARNSET
	jr nz, .done
	ld de, FanName
	call CopyTrainerName
	lb hl, DEX_SEEL, $FF
	ld de, LearnsetBeautyTalk
	ld bc, LearnsetFadeOutInDetails
	predef_jump LearnsetTrainerScriptMain
.no
	CheckEvent EVENT_SEEL_FAN_BOAST
	jr nz, .mineisbetter
	ld hl, .NormalText
	rst _PrintText
	SetEvent EVENT_PIKACHU_FAN_BOAST
	jr .done
.mineisbetter
	ld hl, .BetterText
	rst _PrintText
	ResetEvent EVENT_SEEL_FAN_BOAST
.done
	rst TextScriptEnd

.NormalText:
	text_far_end _PokemonFanClubSeelFanNormalText

.BetterText:
	text_far_end _PokemonFanClubSeelFanBetterText

.yoursText:
	text_far_end _PokemonFanClubSeelFanYoursText

PokemonFanClubPikachuText:
	text_asm
	ld hl, .Text
	rst _PrintText
	ld a, PIKACHU
	call PlayCry
	ld c, DEX_PIKACHU - 1
	callfar SetMonSeen
	rst TextScriptEnd

.Text
	text_far_end _PokemonFanClubPikachuText

PokemonFanClubSeelText:
	text_asm
	ld hl, .Text
	rst _PrintText
	ld a, SEEL
	call PlayCry
	ld c, DEX_SEEL - 1
	callfar SetMonSeen
	rst TextScriptEnd

.Text:
	text_far_end _PokemonFanClubSeelText

PokemonFanClubChairmanText:
	text_asm
	CheckEvent EVENT_GOT_BIKE_VOUCHER
	jr nz, .gotBikeVoucherAlready
	ld hl, .IntroText
	rst _PrintText
	call .yesNoChoice
	jr nz, .printText
	; tell the story
	ld hl, .StoryText
	rst _PrintText
	lb bc, BIKE_VOUCHER, 1
	call GiveItem
	ld hl, .BagFullText
	jr nc, .printText
	ld hl, .BikeVoucherText
	rst _PrintText
	SetEvent EVENT_GOT_BIKE_VOUCHER
	rst TextScriptEnd
.gotBikeVoucherAlready
	CheckEvent FLAG_RAPIDASH_FAMILY_LEARNSET
	jr nz, .final
	call AreLearnsetsEnabled
	jr z, .final
	ld hl, .moreAboutRapidash
	rst _PrintText
	call .yesNoChoice
	jr nz, .printText
	ld c, DEX_RAPIDASH - 1
	callfar SetMonSeen
	ld hl, .longOne
	rst _PrintText
	ld de, ChairName
	call CopyTrainerName
	lb hl, DEX_RAPIDASH, $FF
	ld de, TextNothing
	ld bc, LearnsetFadeOutInStory
	predef_jump LearnsetTrainerScriptMain
.final
	ld hl, .FinalText
.printText
	rst _PrintText
.done
	rst TextScriptEnd
.yesNoChoice
	call YesNoChoice
	ld hl, .NoStoryText
	ret

.IntroText:
	text_far_end _PokemonFanClubChairmanIntroText

.StoryText:
	text_far_end _PokemonFanClubChairmanStoryText

.BikeVoucherText:
	text_far _PokemonFanClubReceivedBikeVoucherText
	sound_get_key_item
	text_far_end _PokemonFanClubExplainBikeVoucherText

.NoStoryText:
	text_far_end _PokemonFanClubNoStoryText

.FinalText:
	text_far_end _PokemonFanClubChairFinalText

.BagFullText:
	text_far_end _PokemonFanClubBagFullText

.moreAboutRapidash
	text_far_end _PokemonFanClubChairMoreText

.longOne
	text_far_end _PokemonFanClubChairLongOne

ChairName::
	db "CLUB CHAIR@"
