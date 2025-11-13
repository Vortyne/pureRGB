PokemonFanClub_Script:
	jp EnableAutoTextBoxDrawing

PokemonFanClub_TextPointers:
	def_text_pointers
	dw_const PokemonFanClubPikachuFanText,   TEXT_POKEMONFANCLUB_PIKACHU_FAN
	dw_const PokemonFanClubSeelFanText,      TEXT_POKEMONFANCLUB_SEEL_FAN
	dw_const PokemonFanClubPikachuText,      TEXT_POKEMONFANCLUB_PIKACHU
	dw_const PokemonFanClubSeelText,         TEXT_POKEMONFANCLUB_SEEL
	dw_const PokemonFanClubChairmanText,     TEXT_POKEMONFANCLUB_CHAIRMAN
	dw_const PokemonFanClubReceptionistText, TEXT_POKEMONFANCLUB_RECEPTIONIST
	dw_const PokemonFanClubSign1Text,        TEXT_POKEMONFANCLUB_SIGN_1
	dw_const PokemonFanClubSign2Text,        TEXT_POKEMONFANCLUB_SIGN_2

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
	text_far _PokemonFanClubPikachuFanNormalText
	text_end

.BetterText:
	text_far _PokemonFanClubPikachuFanBetterText
	text_end

.yoursText:
	text_far _PokemonFanClubPikachuFanYoursText
	text_end

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
	lb hl, DEX_SEEL, $FF ; TODO: fix
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
	text_far _PokemonFanClubSeelFanNormalText
	text_end

.BetterText:
	text_far _PokemonFanClubSeelFanBetterText
	text_end

.yoursText:
	text_far _PokemonFanClubSeelFanYoursText
	text_end

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
	text_far _PokemonFanClubPikachuText
	text_end

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
	text_far _PokemonFanClubSeelText
	text_end

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
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .NoStoryText
	ret

.IntroText:
	text_far _PokemonFanClubChairmanIntroText
	text_end

.StoryText:
	text_far _PokemonFanClubChairmanStoryText
	text_end

.BikeVoucherText:
	text_far _PokemonFanClubReceivedBikeVoucherText
	sound_get_key_item
	text_far _PokemonFanClubExplainBikeVoucherText
	text_end

.NoStoryText:
	text_far _PokemonFanClubNoStoryText
	text_end

.FinalText:
	text_far _PokemonFanClubChairFinalText
	text_end

.BagFullText:
	text_far _PokemonFanClubBagFullText
	text_end

.moreAboutRapidash
	text_far _PokemonFanClubChairMoreText
	text_end

.longOne
	text_far _PokemonFanClubChairLongOne
	text_end

ChairName::
	db "CLUB CHAIR@"

PokemonFanClubReceptionistText:
	text_far _PokemonFanClubReceptionistText
	text_end

PokemonFanClubSign1Text:
	text_far _PokemonFanClubSign1Text
	text_end

PokemonFanClubSign2Text:
	text_far _PokemonFanClubSign2Text
	text_end
