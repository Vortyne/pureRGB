; PureRGBnote: ADDED: this code was modified to make it so you can speed up pokemon center dialog by holding B before talking to the nurse. 
;                     the ability to do this is unlocked by donating to the nurse at rock tunnel pokecenter.

DisplayPokemonCenterDialogue_::
	CheckEvent EVENT_NURSE_TEXT_LOOP_BLOCKER
	jr z, .normalText
	ld c, 14 ; number of frames for the nurse to bow (faster than usual)
	call .nurseBows
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp UpdateSprites
.normalText
	call SaveScreenTilesToBuffer1 ; save screen
	ldh a, [hJoyHeld]
	bit B_PAD_B, a
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
	SetEvent EVENT_NURSE_TEXT_LOOP_BLOCKER
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
	ld c, $14 ; length of nurse bowing in frames
	call .nurseBows
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
	ld bc, TEXT_FAR_TABLE_ENTRY_SIZE
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
.nurseBows
	ld a, $14
	ld [wSprite01StateData1ImageIndex], a ; make the nurse bow
	rst DelayFrames
	ret

PokemonCenterWelcomeText:
	text_far_end _PokemonCenterWelcomeText

ShallWeHealYourPokemonText:
	text_pause
	text_far_end _ShallWeHealYourPokemonText

NeedYourPokemonText:
	text_far_end _NeedYourPokemonText

PokemonCenterFastWelcomeText:
	text_far_end _PokemonCenterFastWelcomeText

PokemonFightingFitText:
	text_far_end _PokemonFightingFitText

PokemonCenterFarewellTextDelay:
	text_pause
PokemonCenterFarewellText:
	text_far_end _PokemonCenterFarewellText

PokemonCenterChampText:
	text_far_end _PokemonCenterChampText

PokemonCenterFastChampText:
	text_far_end _PokemonCenterFastChampText

; keep the below 8 text references together in the same format
PokemonCenterChampFarewells:
PokemonCenterFarewellChamp1Text:
	text_far_end _PokemonCenterFarewellChamp1Text
PokemonCenterFarewellChamp2Text:
	text_far_end _PokemonCenterFarewellChamp2Text
PokemonCenterFarewellChamp3Text:
	text_far_end _PokemonCenterFarewellChamp3Text
PokemonCenterFarewellChamp4Text:
	text_far_end _PokemonCenterFarewellChamp4Text
PokemonCenterFarewellChamp5Text:
	text_far_end _PokemonCenterFarewellChamp5Text
PokemonCenterFarewellChamp6Text:
	text_far_end _PokemonCenterFarewellChamp6Text
PokemonCenterFarewellChamp7Text:
	text_far_end _PokemonCenterFarewellChamp7Text
PokemonCenterFarewellChamp8Text:
	text_far_end _PokemonCenterFarewellChamp8Text
