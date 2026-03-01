; PureRGBnote: ADDED: this code was modified to make it so you can speed up pokemon center dialog by holding B before talking to the nurse. 
;                     the ability to do this is unlocked by donating to the nurse at rock tunnel pokecenter.

DisplayPokemonCenterDialogue_::
	call SaveScreenTilesToBuffer1 ; save screen
	ldh a, [hJoyHeld]
	bit BIT_B_BUTTON, a
	jr z, .notFastWelcome ; NEW: if you're holding b when you start talking to the nurse, it'll skip right to healing.
.fastWelcome
	CheckEvent EVENT_DONATED_TO_POKECENTER_CHARITY ; must donate to pokecenter charity at rock tunnel pokecenter to be able to do this
	jr z, .normalWelcome
	ld a, 1
	ld [wUnusedC000], a
	CheckEvent EVENT_BECAME_CHAMP
	ld hl, PokemonCenterFastChampText
	jr nz, .fastPrint
	ld hl, PokemonCenterFastWelcomeText
.fastPrint
	rst _PrintText
	jr .skipToHeal
.notFastWelcome
	CheckEvent EVENT_BECAME_CHAMP
	jr z, .normalWelcome
	ld hl, PokemonCenterChampText
	rst _PrintText
	jr .skipToHeal
.normalWelcome
	ld hl, PokemonCenterWelcomeText
	rst _PrintText
	ld hl, wStatusFlags4
	bit BIT_USED_POKECENTER, [hl]
	set BIT_UNKNOWN_4_1, [hl]
	set BIT_USED_POKECENTER, [hl]
	jr nz, .skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	rst _PrintText
.skipShallWeHealYourPokemon
	call YesNoChoicePokeCenter ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declinedHealing ; if the player chose No
	; call SetLastBlackoutMap ; PureRGBnote: FIXED: set last blackout map on entering a pokemon center instead of when healing
	call LoadScreenTilesFromBuffer1 ; restore screen
	ld hl, NeedYourPokemonText
	rst _PrintText
.skipToHeal
	ld a, $18
	ld [wSprite01StateData1ImageIndex], a ; make the nurse turn to face the machine
	call Delay3
	predef HealParty
	farcall AnimateHealingMachine ; do the healing machine animation
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	rst _PlaySound
	CheckEvent EVENT_BECAME_CHAMP
	jr nz, .skipFightingFit
	ld a, [wUnusedC000]
	and a
	jr nz, .skipFightingFit ; NEW: if you're holding b when you start talking to the nurse, it'll skip right to healing.
	ld hl, PokemonFightingFitText
	rst _PrintText
.skipFightingFit
	ld a, $14
	ld [wSprite01StateData1ImageIndex], a ; make the nurse bow
	ld c, a
	rst _DelayFrames
	CheckEvent EVENT_BECAME_CHAMP
	jr z, .notChamp
	callfar RandomPartyPokemon
	ld a, d
	ld hl, wPartyMon1Nick
	ld bc, NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	call CopyToStringBuffer
	call Random
	and %111
	ld hl, PokemonCenterChampFarewells
	ld bc, 5
	call AddNTimes
	jr .printDone
.notChamp
	ld hl, PokemonCenterFarewellTextDelay
	jr .printDone
.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
	ld hl, PokemonCenterFarewellText
.printDone
	rst _PrintText
	xor a
	ld [wUnusedC000], a
	jp UpdateSprites

PokemonCenterWelcomeText:
	text_far _PokemonCenterWelcomeText
	text_end

ShallWeHealYourPokemonText:
	text_pause
	text_far _ShallWeHealYourPokemonText
	text_end

NeedYourPokemonText:
	text_far _NeedYourPokemonText
	text_end

PokemonCenterFastWelcomeText:
	text_far _PokemonCenterFastWelcomeText
	text_end

PokemonFightingFitText:
	text_far _PokemonFightingFitText
	text_end

PokemonCenterFarewellTextDelay:
	text_pause
PokemonCenterFarewellText:
	text_far _PokemonCenterFarewellText
	text_end

PokemonCenterChampText:
	text_far _PokemonCenterChampText
	text_end

PokemonCenterFastChampText:
	text_far _PokemonCenterFastChampText
	text_end

; keep the below 8 text references together in the same format
PokemonCenterChampFarewells:
PokemonCenterFarewellChamp1Text:
	text_far _PokemonCenterFarewellChamp1Text
	text_end
PokemonCenterFarewellChamp2Text:
	text_far _PokemonCenterFarewellChamp2Text
	text_end
PokemonCenterFarewellChamp3Text:
	text_far _PokemonCenterFarewellChamp3Text
	text_end
PokemonCenterFarewellChamp4Text:
	text_far _PokemonCenterFarewellChamp4Text
	text_end
PokemonCenterFarewellChamp5Text:
	text_far _PokemonCenterFarewellChamp5Text
	text_end
PokemonCenterFarewellChamp6Text:
	text_far _PokemonCenterFarewellChamp6Text
	text_end
PokemonCenterFarewellChamp7Text:
	text_far _PokemonCenterFarewellChamp7Text
	text_end
PokemonCenterFarewellChamp8Text:
	text_far _PokemonCenterFarewellChamp8Text
	text_end
