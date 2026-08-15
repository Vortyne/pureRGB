; PureRGBnote: ADDED: code related to having food at home with mom was added. You have to phone her from celadon mart to have food.
RedsHouse1F_Script:
	call SetOnlyLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	jp EnableAutoTextBoxDrawing

RedsHouse1F_TextPointers:
	def_text_pointers
	dba_const RedsHouse1FMomText, TEXT_REDSHOUSE1F_MOM
	dba_const RedsHouse1FDadText, TEXT_REDSHOUSE1F_DAD
	dba_const RedsHouse1FTVText,  TEXT_REDSHOUSE1F_TV

RedsHouse1FMomText:
	text_asm
	CheckEvent EVENT_MET_DAD
	jr nz, .dadAround
	CheckEvent EVENT_CALLED_DAD_WAITING
	jr nz, .not_here
.dadAround
	ld b, 0
	CheckEvent EVENT_CALLED_MOM_RICE_BALLS
	jr nz, .foodReady
	inc b
	CheckEvent EVENT_CALLED_MOM_JELLY_DONUTS
	jr nz, .foodReady
	inc b
	CheckEvent EVENT_CALLED_MOM_BRISKET
	jr nz, .foodReady
	inc b
	CheckEvent EVENT_CALLED_MOM_LASAGNA
	jr nz, .foodReady
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jr nz, .heal
	ld hl, .WakeUpText
	rst _PrintText
	rst TextScriptEnd
.heal
	call MomHealPokemon
	rst TextScriptEnd
.not_here
	ResetEvent EVENT_CALLED_DAD_WAITING
	ld hl, MomDadNotHereText
	rst _PrintText
	rst TextScriptEnd
.foodReady
	push bc
	call SaveScreenTilesToBuffer2
	; start the text
	ld hl, MomFoodReadyText
	rst _PrintText
	; load some food tiles on the table
	ld hl, vChars2 tile 5
	ld de, FoodTiles
	lb bc, BANK(FoodTiles), 1
	call CopyVideoData
	ld hl, vChars2 tile $28
	ld de, FoodTiles tile 1
	lb bc, BANK(FoodTiles), 1
	call CopyVideoData
	; reusing some tiles from the ss anne tileset
	ld hl, vChars2 tile $37
	ld de, Ship_GFX tile $50
	lb bc, BANK(Ship_GFX), 2
	call CopyVideoData
	ld a, SFX_NOISE_INSTRUMENT02
	rst _PlaySound
	ld a, SFX_59
	call PlaySoundWaitForCurrent
	ld hl, MomFoodBonAppetit
	rst _PrintText

	call GBFadeOutToWhite
	ld c, 60
	rst DelayFrames
	call ClearScreen
	ld hl, TextScriptEndingText
	rst _PrintText ; seemingly the only way of preventing sprites from flickering on the screen during the next printText
	call GBPalNormal
	pop bc
	ld a, b
	and a
	ld hl, MomFoodRiceBallsText
	jr z, .printText
	dec a
	ld hl, MomFoodJellyDonutsText
	jr z, .printText
	dec a
	ld hl, MomFoodBrisketText
	jr z, .printText
	ld hl, MomFoodLasagnaText
.printText
	rst _PrintText
	CheckEvent EVENT_MET_DAD
	jr z, .noDad
	ld hl, DadChowedDownText
	rst _PrintText
	ld a, SFX_PUSH_BOULDER
	rst _PlaySound
	call WaitForSoundToFinish
.noDad
	call RandomPartyPokemon
	ld a, d
	push af
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, MomFoodPokemonJoinsText
	rst _PrintText
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1
	pop af
	call AddNTimes
	call WaitForSoundToFinish
	ld a, [hl] ; species
	call PlayCry
	call WaitForSoundToFinish
	ld hl, MomFoodPokemonChowedDownText
	rst _PrintText
	ld a, SFX_FLY
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld hl, MomFoodPokemonShowText
	rst _PrintText
	call ClearScreen
	call MomHealPokemonImmediate
	call GBPalWhiteOut
	call LoadScreenTilesFromBuffer2

	; remove food tiles on the table
	ld hl, vChars2 tile 5
	ld de, RedsHouse1_GFX tile 5
	lb bc, BANK(RedsHouse1_GFX), 1
	call CopyVideoDataHBlank
	ld hl, vChars2 tile $28
	ld de, RedsHouse1_GFX tile $28
	lb bc, BANK(RedsHouse1_GFX), 1
	call CopyVideoDataHBlank
	ld hl, vChars2 tile $37
	ld de, RedsHouse1_GFX tile $37
	lb bc, BANK(RedsHouse1_GFX), 2
	call CopyVideoDataHBlank

	call UpdateSprites
	call GBFadeInFromWhite
	ld hl, MomFoodDone
	rst _PrintText
	ResetEventRange EVENT_CALLED_MOM_RICE_BALLS, EVENT_CALLED_MOM_LASAGNA
	rst TextScriptEnd

.WakeUpText:
	text_far_end _RedsHouse1FMomWakeUpText

MomDadNotHereText:
	text_far_end _MomDadNotHereText

MomFoodReadyText:
	text_far_end _MomFoodReadyText

MomFoodBonAppetit:
	text_far_end _MomFoodBonAppetit

MomFoodRiceBallsText:
	text_far_end _MomFoodRiceBallsText

MomFoodJellyDonutsText:
	text_far_end _MomFoodJellyDonutsText

MomFoodBrisketText:
	text_asm
	CheckEvent EVENT_MET_DAD
	ld hl, MomFoodBrisketText1
	jr z, .noDad
	ld hl, DadFoodBrisketText
.noDad
	rst _PrintText
	ld hl, MomFoodBrisketText2
	rst _PrintText
	rst TextScriptEnd

MomFoodBrisketText1:
	text_far_end _MomFoodBrisketText

DadFoodBrisketText:
	text_far_end _DadFoodBrisketText

MomFoodBrisketText2:
	text_far_end _MomFoodBrisketText2	

MomFoodLasagnaText:
	text_far_end _MomFoodLasagnaText

DadChowedDownText:
	text_far_end _DadChowedDownText

MomFoodPokemonJoinsText:
	text_far_end _MomFoodPokemonJoinsText

MomFoodPokemonChowedDownText:
	text_far_end _MomFoodPokemonChowedDownText

MomFoodPokemonShowText:
	text_far_end _MomFoodPokemonShowText

MomFoodDone:
	text_far_end _MomFoodDone

MomHealPokemon:
	ld hl, RedsHouse1FMomYouShouldRestText
	rst _PrintText
	call HealFade
	ld hl, RedsHouse1FMomLookingGreatText
	jp PrintText

HealFade:
	call GBFadeOutToWhite
	call ReloadMapData
	call MomHealPokemonImmediate
	jp GBFadeInFromWhite

MomHealPokemonImmediate::
	call StopAllMusic
	predef HealParty
	call HealPokemonSound
;;;;;;;;;; PureRGBnote: ADDED: if you have OG+ music turned on, a beta healing theme will play at your house.
	ld a, [wOptions2]
	bit BIT_MUSIC, a
	jr z, WaitForHealingSoundToFinish
	; if OG+ music, remap to a different SFX
	ld de, Music_RestPallet_Ch1
	ld hl, wChannelCommandPointers
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld de, Music_RestPallet_Ch2
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld de, Music_RestPallet_Ch3
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, BANK(Music_RestPallet)
	ld [wSpecialMusicBank], a
	call WaitForHealingSoundToFinish
	jp PlayDefaultMusic
;;;;;;;;;;

HealPokemonSound:
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	rst _PlaySound
	ret
WaitForHealingSoundToFinish:
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	rst _PlaySound
	ret

FarHeal::
	ld a, BANK(Music_PkmnHealed)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	call StopAllMusic
	predef HealParty
	call HealPokemonSound
	call WaitForHealingSoundToFinish
	jp PlayDefaultMusic

RedsHouse1FMomYouShouldRestText:
	text_far_end _RedsHouse1FMomYouShouldRestText
RedsHouse1FMomLookingGreatText:
	text_far_end _RedsHouse1FMomLookingGreatText

RedsHouse1FTVText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, .WrongSideText
	jr nz, .got_text
	ld hl, .StandByMeMovieText
.got_text
	rst _PrintText
	rst TextScriptEnd

.StandByMeMovieText:
	text_far_end _RedsHouse1FTVStandByMeMovieText

.WrongSideText:
	text_far_end _RedsHouse1FTVWrongSideText

RedsHouse1FDadText:
	text_asm
	ld hl, DadHealText1
	rst _PrintText
	call HealFade
	ld hl, DadHealText2
	rst _PrintText
	rst TextScriptEnd

DadHealText1:
	text_far_end _DadHealText1

DadHealText2:
	text_far_end _DadHealText2

RandomPartyPokemon::
	; store a party pokemon's nickname to use later in the text
	ld a, [wPartyCount]
	cp 6 ; if they player has less than 6 pokemon just use the first pokemon
	ld d, 0
	ret nz
.random ; otherwise randomize it between any of the 6
	call Random
	and %111
	cp 6
	jr nc, .random
	ld d, a
	ret
