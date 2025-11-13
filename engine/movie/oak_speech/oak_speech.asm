PrepareOakSpeech:
	ld a, [wLetterPrintingDelayFlags]
	push af
;;;;;;;;;; PureRGBnote: ADDED: Preserve all options settings when starting a new game
	call BackupOptionsSettings
	ld hl, wPlayerName
	ld bc, wBoxDataEnd - wPlayerName
	xor a
	call FillMemory
	ld hl, wSpriteDataStart
	ld bc, wSpriteDataEnd - wSpriteDataStart
	xor a
	call FillMemory
	call RestoreOptionsSettings
;;;;;;;;;
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, [wOptionsInitialized]
	and a
	call z, InitOptions
	; These debug names are used for StartNewGameDebug.
	; TestBattle uses the debug names from DebugMenu.
	; A variant of this process is performed in PrepareTitleScreen.
	ld hl, DebugNewGamePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, DebugNewGameRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	rst _CopyData
	; PureRGBnote: ADDED: make sure the new game has the internal save file version stored so the save updater doesn't get triggered
	ld hl, wGameInternalVersion
	ld [hl], CURRENT_INTERNAL_VERSION
	ret

; PureRGBnote: CHANGED: this subroutine was modified to make debug mode (wStatusFlags6 bit 1 = non-zero) skip through it quickly to start debugging faster
OakSpeech:
	callfar GBCSetCPU1xSpeed ; shinpokerednote: ADDED: GBC double speed cpu mode messes up oak speech, stay at 1x speed
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
IF DEF(_DEBUG)
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	jr nz, .skipMusic
ENDC
	ld a, BANK(Music_Routes2)
	ld c, a
	ld a, MUSIC_ROUTES2
	call PlayMusic
.skipMusic
	call ClearScreen
	call LoadTextBoxTilePatterns
	call PrepareOakSpeech
	predef InitPlayerData
	call RunDefaultPaletteCommand	; shinpokerednote: gbcnote: reinitialize the default palette in case the pointers got cleared
	ld hl, wNumBoxItems
	ld a, ITEM_INITIAL_PC_ITEM
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call PrepareForSpecialWarp
	xor a
	ldh [hTileAnimations], a
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	jp nz, .skipSpeech
	ld de, ProfOakPic
	lb bc, BANK(ProfOakPic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, OakSpeechText1
	rst _PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld a, NIDORINO
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetMonHeader
	hlcoord 6, 4
	call LoadFlippedFrontSpriteByMonIndex
	call MovePicLeft
	ld hl, OakSpeechText2
	rst _PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
	call IntroDisplayPicCenteredOrUpperRight
	call MovePicLeft
	ld hl, IntroducePlayerText
	rst _PrintText
	call ChoosePlayerName
	call GBFadeOutToWhite
	call ClearScreen
	ld de, Rival1Pic
	lb bc, BANK(Rival1Pic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, IntroduceRivalText
	rst _PrintText
	call ChooseRivalName
;.skipSpeech
	call GBFadeOutToWhite
	call ClearScreen
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
	call IntroDisplayPicCenteredOrUpperRight
	call GBFadeInFromWhite
	ld a, [wStatusFlags3]
	and a ; ???
	jr nz, .next
	ld hl, OakSpeechText3
	rst _PrintText
.next
	ldh a, [hLoadedROMBank]
	push af
	ld a, SFX_SHRINK
	rst _PlaySound
	pop af
	call SetCurBank
	ld c, 4
	rst _DelayFrames
	ld de, RedSprite
	ld hl, vSprites
	lb bc, BANK(RedSprite), $0C
	call CopyVideoData
	ld de, ShrinkPic1
	lb bc, BANK(ShrinkPic1), $00
	call IntroDisplayPicCenteredOrUpperRight
	ld c, 4
	rst _DelayFrames
	ld de, ShrinkPic2
	lb bc, BANK(ShrinkPic2), $00
	call IntroDisplayPicCenteredOrUpperRight
	call ResetPlayerSpriteData
.skipSpeech
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(Music_PalletTown)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, 10
	ld [wAudioFadeOutControl], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	rst _PlaySound
	pop af
	call SetCurBank
IF DEF(_DEBUG)
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	jr nz, .skipDelay
ENDC
	ld c, 20
	rst _DelayFrames
	hlcoord 6, 5
	lb bc, 7, 7
	call ClearScreenArea
	call LoadTextBoxTilePatterns
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld c, 50
	rst _DelayFrames
	call GBFadeOutToWhite
.skipDelay
	jp ClearScreen
OakSpeechText1:
	text_far _OakSpeechText1
	text_end
OakSpeechText2:
	text_far _OakSpeechText2A
	; BUG: The cry played does not match the sprite displayed. PureRGBnote: FIXED: Plays nidorino's cry now.
	text_asm
	ld a, NIDORINO
	call PlayCry
	call DisplayTextPromptButton
	ld hl, .2b
	rst _PrintText
	rst TextScriptEnd
.2b
	text_far _OakSpeechText2B
	text_end
IntroducePlayerText:
	text_far _IntroducePlayerText
	text_end
IntroduceRivalText:
	text_far _IntroduceRivalText
	text_end
OakSpeechText3:
	text_far _OakSpeechText3
	text_end

FadeInIntroPic:
	ld hl, IntroFadePalettes
	ld b, 6
.next
	ld a, [hli]
	ldh [rBGP], a
	call UpdateGBCPal_BGP ; shinpokerednote: gbcnote: gbc color code from yellow 
	ld c, 10
	rst _DelayFrames
	dec b
	jr nz, .next
	ret

IntroFadePalettes:
	dc 1, 1, 1, 0
	dc 2, 2, 2, 0
	dc 3, 3, 3, 0
	dc 3, 3, 2, 0
	dc 3, 3, 1, 0
	dc 3, 2, 1, 0

MovePicLeft:
	ld a, 119
	ldh [rWX], a
	rst _DelayFrame

	ld a, %11100100
	ldh [rBGP], a
	call UpdateGBCPal_BGP ; shinpokerednote: gbcnote: gbc color code from yellow 
.next
	rst _DelayFrame
	ldh a, [rWX]
	sub 8
	cp $FF
	ret z
	ldh [rWX], a
	jr .next

DisplayPicCenteredOrUpperRight:
	call GetPredefRegisters
IntroDisplayPicCenteredOrUpperRight:
; b = bank
; de = address of compressed pic
; c: 0 = centred, non-zero = upper-right
	push bc
	ld a, b
	call UncompressSpriteFromDE
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, $310
	rst _CopyData
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a, c
	and a
	hlcoord 15, 1
	jr nz, .next
	hlcoord 6, 4
.next
	xor a
	ldh [hStartTileID], a
	predef_jump CopyUncompressedPicToTilemap

BackupOptionsSettings:
	ld de, wBuffer
	ld hl, BackupList
	jr DoOptionsBackup

RestoreOptionsSettings:
	ld de, wBuffer
	ld hl, BackupList
	call DoOptionsRestore
	ld hl, wStatusFlags6
	res BIT_ALWAYS_ON_BIKE, [hl]
	ret

DoOptionsBackup:
	ld b, [hl]
	inc hl
.loopBackup
	push hl
	hl_deref
	ld a, [hl]
	ld [de], a
	pop hl
	inc hl
	inc hl
	inc de
	dec b
	jr nz, .loopBackup
	ret

DoOptionsRestore:
	ld b, [hl]
	inc hl
.loopBackup
	push hl
	hl_deref
	ld a, [de]
	ld [hl], a
	pop hl
	inc hl
	inc hl
	inc de
	dec b
	jr nz, .loopBackup
	ret

BackupList:
	db 11
	dw wOptions2
	dw wSpriteOptions
	dw wSpriteOptions2
	dw wSpriteOptions3
	dw wSpriteOptions4
	dw wOptions3
	dw wOptions
	dw wWorldOptions
	dw wSpriteOptions5
	dw wOptions4
	dw wStatusFlags6

CopyOptionsFromSRAM::
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, 1
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamBank], a
	; by checking if a name has been saved we can know if a save file was created
	callfar CheckSaveFileExists
	jr nc, .doneLoad
	ld hl, SRAMCopyList
	ld de, BackupList+1
	ld b, [hl]
	inc hl
.loop
	push hl
	push de
	; deref de
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld d, a
	ld e, c
	hl_deref
	ld a, [hl]
	ld [de], a
	pop de
	pop hl
	inc hl
	inc hl
	inc de
	inc de
	dec b
	jr nz, .loop
.doneLoad
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

SRAMCopyList:
	db 10
	dw sOptions2
	dw sSpriteOptions
	dw sSpriteOptions2
	dw sSpriteOptions3
	dw sSpriteOptions4
	dw sOptions3
	dw sOptions
	dw sWorldOptions
	dw sSpriteOptions5
	dw sOptions4
