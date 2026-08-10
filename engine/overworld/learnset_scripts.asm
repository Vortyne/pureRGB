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
	callfar GetTrainerName
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
	call GBPalWhiteOut
	call LoadScreenTilesFromBuffer2
	call Delay3
	call UpdateSprites
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
	call PauseMusic
	ld a, [wAudioROMBank]
	push af
	ld a, BANK("Audio Engine 3")
	ld [wAudioROMBank], a
	call hl_caller
	pop af
	ld [wAudioROMBank], a
	jp ResumeMusic

; input c = pokemon dex ID - 1
SetMonSeen::
	ld hl, wPokedexSeen
	ld b, FLAG_SET
	jp FlagAction

WhileGoingBackToPkmnCenter::
	text_far_end _WhileGoingBackToPkmnCenter

StartedTalkingAboutDetails::
	text_far_end _StartedTalkingAboutDetails

LearnsetUnlockedText2::
	text_far_end _LearnsetUnlockedText

LearnsetKnowAlotAbout::
	text_far_end _LearnsetKnowAlotAbout

LearnsetKnowEverythingAbout::
	text_far_end _LearnsetKnowEverythingAbout

LearnsetKnowMoreThanYou::
	text_far_end _LearnsetKnowMoreThanYou

LearnsetAppreciator::
	text_far_end _LearnsetAppreciator

LearnsetCuteTalk::
	text_far_end _LearnsetCuteTalk

LearnsetCool::
	text_far_end _LearnsetCool

LearnsetLove::
	text_far_end _LearnsetLove

LearnsetRude::
	text_far_end _LearnsetRude

LearnsetTough::
	text_far_end _LearnsetTough

LearnsetBoring::
	text_far_end _LearnsetBoring

LearnsetDream::
	text_far_end _LearnsetDream

LearnsetBeautyTalk::
	text_far_end _LearnsetBeautyTalk

ReadAlotAboutPkmn::
	text_far_end _ReadAlotAboutPkmn

KeepReadingText::
	text_far_end _KeepReadingText

Route2AfterBattle1Learnset::
	text_far_end _Route2AfterBattle1Learnset

Route2AfterBattle3Learnset::
	text_far _Route2AfterBattle3Learnset
	text_far_end _LearnsetCuteTalk

TextNothing::
	text_far_end _TextNothing

CheckDexToSeeIt::
	text_far_end _CheckDexToSeeIt

TextForgetIt178::
	text_far_end _GenericForgetItText

Route5CharmeleonLearnset::
	text_far_end _Route5CharmeleonLearnset

Route6ButterfreeLearnsetText::
	text_far _Route6ButterfreeLearnsetText
	text_far_end _LearnsetKnowMoreThanYou

Route6VenonatLearnsetText::
	text_far_end _Route6VenonatLearnsetText

Route3RattataLearnsetText::
	text_far_end _Route3Youngster2AfterBattleText3Yes2

MtMoonB2fRocket4AfterBattleLearnsetText::
	text_far _MtMoonB2fRocket4AfterBattleLearnsetText
	text_far_end _LearnsetKnowEverythingAbout

MtMoonPokecenterMagikarpSalesmanArentYouGladText::
	text_far_end _MtMoonPokecenterMagikarpSalesmanArentYouGladText

Route3CooltrainerF3AfterBattleText2::
	text_far _Route3CooltrainerF3AfterBattleText2
	text_far_end _LearnsetRude

PewterCityBenchGuyJigglyPuff2::
	text_far_end _PewterPokecenterBenchGuyLearnsetText2

Route18AerodactylLearnsetText::
	text_far _Route18AerodactylLearnsetText
	text_far_end _LearnsetTough

Route5SquirtleLearnset::
	text_far_end _Route5SquirtleLearnset

LearnsetKrabbyKid::
	text_far_end _LearnsetKrabbyKid

LearnsetKinglerGuy::
	text_far_end _CinnabarLabKinglerLearnset

ToldAThrillingStory::
	text_far_end _ToldAThrillingStory

VermilionPidgeyHouseYoungsterLearnset::
	text_far_end _VermilionPidgeyHouseYoungsterLearnset

LearnsetGrowlithe::
	text_far _GrowlitheLearnset
	text_far_end _LearnsetMastering

WhileGoingHeadingToShipInfirmary::
	text_far_end _WhileGoingHeadingToShipInfirmary

ShowedCoolMoves::
	text_far_end _ShowedCoolMoves

PlayedAroundWith::
	text_far_end _PlayedAroundWith

LearnsetFondMemories::
	text_far_end _LearnsetFondMemories

PokemonTower1FGirl2Text::
	text_far_end _PokemonTower1FGirl2Text

LearnsetVulpixLuckyNumber::
	text_far_end _LearnsetVulpixLuckyNumber

LearnsetBellsprout::
	text_far_end _LearnsetBellsprout

LearnsetMagneton::
	text_far _LearnsetMagneton
	text_far_end _LearnsetKnowEverythingAbout

LearnsetStaryu::
	text_far _LearnsetStaryu
	text_far_end _LearnsetMystery

LearnsetGloom::
	text_far _LearnsetGloom
	text_far_end _LearnsetLove

LearnsetSandslash::
	text_far_end _LearnsetSandslash

GeodudeLearnset::
	text_far_end _GeodudeLearnset

RhyhornLearnset::
	text_far_end _RhyhornLearnset

GastlyLearnset::
	text_far_end _ViridianCityFisherGastlyLearnset

LavenderCuboneLearnset::
	text_far_end _LavenderCuboneLearnset

ArbokLearnset::
	text_far_end _ArbokLearnset

TentacoolLearnset::
	text_far_end _LearnsetTentacool

SeadraLearnset::
	text_far _SeadraLearnset
	text_far_end _LearnsetMystery

ShellderLearnset::
	text_far _ShellderLearnset
	text_far_end _LearnsetKnowAlotAbout

LearnsetGoldeen::
	text_far _LearnsetGoldeen
	text_far_end _LearnsetBeautyTalk

LearnsetNidorina::
	text_far_end _NidorinaLearnset

MukLearnset::
	text_far_end _MukLearnset

MukLearnset2::
	text_far_end _MukLearnset2

ClefableLearnset::
	text_far _ClefableLearnset
	text_far_end _LearnsetLove

MeowthLearnset::
	text_far_end _LearnsetMeowth

FearowLearnset::
	text_far_end _FearowLearnset

KoffingLearnsetText::
	text_far_end _KoffingLearnsetText

PoliwrathLearnsetText::
	text_far _PoliwrathLearnsetText
	text_asm
	jpfar PoliwrathAnimation

ElectabuzzLearnsetText::
	text_far _ElectabuzzLearnsetText
	text_far_end _LearnsetKnowMoreThanYou

MankeyLearnsetText::
	text_far _MankeyLearnsetText
	text_far_end _LearnsetCuteTalk

MachokeLearnsetText2::
	text_far _MachokeLearnsetText2
	text_far_end _LearnsetMastering 

PrimeapeLearnsetText::
	text_far _PrimeapeLearnsetText
	text_far_end _LearnsetTough 

TaurosLearnsetText::
	text_far_end _TaurosLearnsetText

BlaineStory::
	text_far_end _BlaineStory

ChanseyLearnsetText::
	text_far_end _CopycatsHouse1FChanseyText2

DoduoLearnsetText::
	text_far_end _DoduoLearnsetText

LearnsetNaturalHabitatText::
	text_far_end _LearnsetNaturalHabitatText

LearnsetElectrode::
	text_far _LearnsetElectrode
	text_far_end _LearnsetCool
