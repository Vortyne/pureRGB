LearnsetTrainerScript::
	call GetPredefRegisters
	ld bc, LearnsetFadeOutInPkmnCenter
	jr LearnsetTrainerScriptDefault

LearnsetTrainerScriptMain:
	call GetPredefRegisters
LearnsetTrainerScriptDefault:
	push bc
	push de
	ld a, h
	ld [wNamedObjectIndex], a
	ld a, l
	ld [wTrainerClass], a
	callfar IsPokemonLearnsetUnlockedDirect
	jr nz, .noFurtherText
	call AreLearnsetsEnabled
	jr z, .noFurtherText
	callfar SetPokemonLearnsetUnlocked
	callfar PokedexToIndex
	ld a, [wNamedObjectIndex]
	push af
	ld a, [wTrainerClass]
	cp $FF
	jr z, .skipGetTrainerName
	callfar GetTrainerName_
.skipGetTrainerName
	pop af
	ld [wNamedObjectIndex], a
	call GetMonName
	call DisplayTextPromptButton
	pop hl ; de into hl
	rst _PrintText
	pop hl ; bc into hl
	jp hl
.noFurtherText
	pop de
	pop bc
	rst TextScriptEnd

LearnsetNaturalHabitat::
	ld hl, LearnsetNaturalHabitatText
	jr LearnsetFadeOutIn

LearnsetMukFade::
	ld hl, MukLearnset2
	jr LearnsetFadeOutIn
	
LearnsetFadeOutInStory::
	ld hl, ToldAThrillingStory
	jr LearnsetFadeOutIn

LearnsetFadeOutInPkmnCenter::
	ld hl, WhileGoingBackToPkmnCenter
	call LearnsetFadeOutIn
	predef HealParty
	rst TextScriptEnd

LearnsetFadeOutInfirmary::
	ld hl, WhileGoingHeadingToShipInfirmary
	jr LearnsetFadeOutIn

LearnsetShowedCoolMoves::
	ld hl, ShowedCoolMoves
	jr LearnsetFadeOutIn

LearnsetPlayedAroundWith::
	ld hl, PlayedAroundWith
	jr LearnsetFadeOutIn

LearnsetRecountedFondMemories::
	ld hl, LearnsetFondMemories
	jr LearnsetFadeOutIn

LearnsetFadeOutInDream::
	ld hl, LearnsetDream
	jr LearnsetFadeOutIn

LearnsetFadeOutInBlaineStory::
	ld hl, BlaineStory
	jr LearnsetFadeOutIn
	
LearnsetFadeOutInDetails::
	ld hl, StartedTalkingAboutDetails
LearnsetFadeOutIn::
	push hl
	call ClearTextBox
	call SaveScreenTilesToBuffer2
	call HalfVolume
	call GBFadeOutToWhite
	call ClearScreen
	ld hl, TextScriptEndingText
	rst _PrintText ; prevents sprite flickering when printing the next text
	call GBPalNormal
	pop hl
	rst _PrintText
	call LoadScreenTilesFromBuffer2
	call GBFadeInFromWhite
LearnsetUnlockedScript::
	ld hl, LearnsetUnlockedText2
	rst _PrintText
	call MaxVolume
	call PlayLearnsetSound
	CheckAndSetEvent EVENT_SAW_LEARNSET_UNLOCK_TEXT_ONCE
	jr nz, .saw
	call DisplayTextPromptButton
	ld hl, CheckDexToSeeIt
	rst _PrintText
.saw
	rst TextScriptEnd

LearnsetFadeOutInReadAlot::
	ld hl, ReadAlotAboutPkmn
	jr LearnsetFadeOutIn

KeepReadingBookLearnset::
	call AreLearnsetsEnabled
	jr z, .done
	push de
	ld c, d
	dec c
	call SetMonSeen
	call DisplayTextPromptButton
	ld hl, KeepReadingText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	pop de
	jr z, .yes
	ld hl, TextForgetIt178
	rst _PrintText
.done
	rst TextScriptEnd
.yes
	; fall through
KeepReadingBookLearnsetDirect::
	ld a, d
	ld [wNamedObjectIndex], a
	callfar SetPokemonLearnsetUnlocked
	callfar PokedexToIndex
	call GetMonName
	jr LearnsetFadeOutInReadAlot

PlayLearnsetSoundMain:
	ld a, SFX_GET_ITEM_1
	rst _PlaySound
	ld de, SFX_Learnset_Fanfare_Ch5
	ld hl, wChannelCommandPointers + CHAN5 * 2
	call RemapSoundChannel
	inc hl
	ld de, SFX_Learnset_Fanfare_Ch6
	call RemapSoundChannel
	inc hl
	ld de, StopSFXSound
	call RemapSoundChannel
	inc hl
	ld de, StopSFXSound
	call RemapSoundChannel
	call WaitForSoundToFinish
	ld de, SFX_Learnset_Fanfare_part2
	call PlayNewSoundChannel5
	jp WaitForSoundToFinish

PlayLearnsetSound:
	ld hl, PlayLearnsetSoundMain
PlaySoundOnAudio3Engine:
	; TODO: make generic in home bank?
	ld a, 1
	ld [wMuteAudioAndPauseMusic], a
	ld a, [wAudioROMBank]
	push af
	ld a, BANK("Audio Engine 3")
	ld [wAudioROMBank], a
	call hl_caller
	pop af
	ld [wAudioROMBank], a
	xor a
	ld [wMuteAudioAndPauseMusic], a
	ret

; input c = pokemon dex ID - 1
SetMonSeen::
	ld hl, wPokedexSeen
	ld b, FLAG_SET
	predef_jump FlagActionPredef

WhileGoingBackToPkmnCenter::
	text_far _WhileGoingBackToPkmnCenter
	text_end

StartedTalkingAboutDetails::
	text_far _StartedTalkingAboutDetails
	text_end

LearnsetUnlockedText2::
	text_far _LearnsetUnlockedText
	text_end

LearnsetKnowAlotAbout::
	text_far _LearnsetKnowAlotAbout
	text_end

LearnsetKnowEverythingAbout::
	text_far _LearnsetKnowEverythingAbout
	text_end

LearnsetKnowMoreThanYou::
	text_far _LearnsetKnowMoreThanYou
	text_end

LearnsetAppreciator::
	text_far _LearnsetAppreciator
	text_end

LearnsetCuteTalk::
	text_far _LearnsetCuteTalk
	text_end

LearnsetCool::
	text_far _LearnsetCool
	text_end

LearnsetLove::
	text_far _LearnsetLove
	text_end

LearnsetRude::
	text_far _LearnsetRude
	text_end

LearnsetTough::
	text_far _LearnsetTough
	text_end

LearnsetBoring::
	text_far _LearnsetBoring
	text_end

LearnsetDream::
	text_far _LearnsetDream
	text_end

LearnsetBeautyTalk::
	text_far _LearnsetBeautyTalk
	text_end

ReadAlotAboutPkmn::
	text_far _ReadAlotAboutPkmn
	text_end

KeepReadingText::
	text_far _KeepReadingText
	text_end

Route2AfterBattle1Learnset::
	text_far _Route2AfterBattle1Learnset
	text_end

Route2AfterBattle3Learnset::
	text_far _Route2AfterBattle3Learnset
	text_far _LearnsetCuteTalk
	text_end

TextNothing::
	text_far _TextNothing
	text_end

CheckDexToSeeIt::
	text_far _CheckDexToSeeIt
	text_end

TextForgetIt178::
	text_far _GenericForgetItText
	text_end

Route5CharmeleonLearnset::
	text_far _Route5CharmeleonLearnset
	text_end

Route6ButterfreeLearnsetText::
	text_far _Route6ButterfreeLearnsetText
	text_far _LearnsetKnowMoreThanYou
	text_end

Route6VenonatLearnsetText::
	text_far _Route6VenonatLearnsetText
	text_end

Route3RattataLearnsetText::
	text_far _Route3Youngster2AfterBattleText3Yes2
	text_end

MtMoonB2fRocket4AfterBattleLearnsetText::
	text_far _MtMoonB2fRocket4AfterBattleLearnsetText
	text_far _LearnsetKnowEverythingAbout
	text_end

MtMoonPokecenterMagikarpSalesmanArentYouGladText::
	text_far _MtMoonPokecenterMagikarpSalesmanArentYouGladText
	text_end

Route3CooltrainerF3AfterBattleText2::
	text_far _Route3CooltrainerF3AfterBattleText2
	text_far _LearnsetRude
	text_end

PewterCityBenchGuyJigglyPuff2::
	text_far _PewterPokecenterBenchGuyLearnsetText2
	text_end

Route18AerodactylLearnsetText::
	text_far _Route18AerodactylLearnsetText
	text_far _LearnsetTough
	text_end

Route5SquirtleLearnset::
	text_far _Route5SquirtleLearnset
	text_end

LearnsetKrabbyKid::
	text_far _LearnsetKrabbyKid
	text_end

LearnsetKinglerGuy::
	text_far _CinnabarLabKinglerLearnset
	text_end

ToldAThrillingStory::
	text_far _ToldAThrillingStory
	text_end

VermilionPidgeyHouseYoungsterLearnset::
	text_far _VermilionPidgeyHouseYoungsterLearnset
	text_end

LearnsetGrowlithe::
	text_far _GrowlitheLearnset
	text_far _LearnsetMastering
	text_end

WhileGoingHeadingToShipInfirmary::
	text_far _WhileGoingHeadingToShipInfirmary
	text_end

ShowedCoolMoves::
	text_far _ShowedCoolMoves
	text_end

PlayedAroundWith::
	text_far _PlayedAroundWith
	text_end

LearnsetFondMemories::
	text_far _LearnsetFondMemories
	text_end

PokemonTower1FGirl2Text::
	text_far _PokemonTower1FGirl2Text
	text_end

LearnsetVulpixLuckyNumber::
	text_far _LearnsetVulpixLuckyNumber
	text_end

LearnsetBellsprout::
	text_far _LearnsetBellsprout
	text_end

LearnsetMagneton::
	text_far _LearnsetMagneton
	text_far _LearnsetKnowEverythingAbout
	text_end

LearnsetStaryu::
	text_far _LearnsetStaryu
	text_far _LearnsetMystery
	text_end

LearnsetGloom::
	text_far _LearnsetGloom
	text_far _LearnsetLove
	text_end

LearnsetSandslash::
	text_far _LearnsetSandslash
	text_end

GeodudeLearnset::
	text_far _GeodudeLearnset
	text_end

RhyhornLearnset::
	text_far _RhyhornLearnset
	text_end

GastlyLearnset::
	text_far _ViridianCityFisherGastlyLearnset
	text_end

LavenderCuboneLearnset::
	text_far _LavenderCuboneLearnset
	text_end

ArbokLearnset::
	text_far _ArbokLearnset
	text_end

TentacoolLearnset::
	text_far _LearnsetTentacool
	text_end

SeadraLearnset::
	text_far _SeadraLearnset
	text_far _LearnsetMystery
	text_end

ShellderLearnset::
	text_far _ShellderLearnset
	text_far _LearnsetKnowAlotAbout
	text_end

LearnsetGoldeen::
	text_far _LearnsetGoldeen
	text_far _LearnsetBeautyTalk
	text_end

LearnsetNidorina::
	text_far _NidorinaLearnset
	text_end

MukLearnset::
	text_far _MukLearnset
	text_end

MukLearnset2::
	text_far _MukLearnset2
	text_end

ClefableLearnset::
	text_far _ClefableLearnset
	text_far _LearnsetLove
	text_end

MeowthLearnset::
	text_far _LearnsetMeowth
	text_end

FearowLearnset::
	text_far _FearowLearnset
	text_end

KoffingLearnsetText::
	text_far _KoffingLearnsetText
	text_end

PoliwrathLearnsetText::
	text_far _PoliwrathLearnsetText
	text_asm
	jpfar PoliwrathAnimation

ElectabuzzLearnsetText::
	text_far _ElectabuzzLearnsetText
	text_far _LearnsetKnowMoreThanYou
	text_end

MankeyLearnsetText::
	text_far _MankeyLearnsetText
	text_far _LearnsetCuteTalk
	text_end

MachokeLearnsetText2::
	text_far _MachokeLearnsetText2
	text_far _LearnsetMastering
	text_end 

PrimeapeLearnsetText::
	text_far _PrimeapeLearnsetText
	text_far _LearnsetTough
	text_end 

TaurosLearnsetText::
	text_far _TaurosLearnsetText
	text_end

BlaineStory::
	text_far _BlaineStory
	text_end

ChanseyLearnsetText::
	text_far _CopycatsHouse1FChanseyText2
	text_end

DoduoLearnsetText::
	text_far _DoduoLearnsetText
	text_end

LearnsetNaturalHabitatText::
	text_far _LearnsetNaturalHabitatText
	text_end

LearnsetElectrode::
	text_far _LearnsetElectrode
	text_far _LearnsetCool
	text_end
