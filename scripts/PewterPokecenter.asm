PewterPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

PewterPokecenter_TextPointers:
	def_text_pointers
	dw_const PewterPokecenterNurseText,            TEXT_PEWTERPOKECENTER_NURSE
	dw_const PewterPokecenterGentlemanText,        TEXT_PEWTERPOKECENTER_GENTLEMAN
	dw_const PewterPokecenterJigglypuffText,       TEXT_PEWTERPOKECENTER_JIGGLYPUFF
	dw_const PewterPokecenterLinkReceptionistText, TEXT_PEWTERPOKECENTER_LINK_RECEPTIONIST
	dw_const PewterPokecenterBenchGuyText,         TEXT_PEWTERPOKECENTER_BENCH_GUY

PewterPokecenterNurseText:
	script_pokecenter_nurse

PewterPokecenterGentlemanText:
	text_far _PewterPokecenterGentlemanText
	text_end

PewterPokecenterJigglypuffText:
	text_asm
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .Text
	rst _PrintText

	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld c, 32
	rst _DelayFrames

	ld hl, .FacingDirections
	ld de, wJigglypuffFacingDirections
	ld bc, .FacingDirectionsEnd - .FacingDirections
	rst _CopyData

	ld a, [wSprite03StateData1ImageIndex]
	ld hl, wJigglypuffFacingDirections
.findMatchingFacingDirectionLoop
	cp [hl]
	inc hl
	jr nz, .findMatchingFacingDirectionLoop
	dec hl

	push hl
	ld c, BANK(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	pop hl

.spinMovementLoop
	ld a, [hl]
	ld [wSprite03StateData1ImageIndex], a
; rotate the array
	push hl
	ld hl, wJigglypuffFacingDirections
	ld de, wJigglypuffFacingDirections - 1
	ld bc, .FacingDirectionsEnd - .FacingDirections
	rst _CopyData
	ld a, [wJigglypuffFacingDirections - 1]
	ld [wJigglypuffFacingDirections + 3], a
	pop hl
	ld c, 24
	rst _DelayFrames
	ld a, [wChannelSoundIDs]
	ld b, a
	ld a, [wChannelSoundIDs + CHAN2]
	or b
	jr nz, .spinMovementLoop

	ld c, 48
	rst _DelayFrames
	call PlayDefaultMusic
	rst TextScriptEnd

.Text:
	text_far _PewterPokecenterJigglypuffText
	text_end

.FacingDirections:
	db $30 | SPRITE_FACING_DOWN
	db $30 | SPRITE_FACING_LEFT
	db $30 | SPRITE_FACING_UP
	db $30 | SPRITE_FACING_RIGHT
.FacingDirectionsEnd:

PewterPokecenterLinkReceptionistText:
	script_cable_club_receptionist

PewterPokecenterBenchGuyText:
	text_asm
	call AreLearnsetsEnabled
	jr z, .no
	CheckEvent FLAG_WIGGLYTUFF_FAMILY_LEARNSET
	jr nz, .no
	ld d, JIGGLYPUFF
	callfar IsMonInParty
	jr nc, .no
	ld hl, .oh
	rst _PrintText
	ld de, BenchGuyName
	call CopyTrainerName
	lb hl, DEX_JIGGLYPUFF, $FF
	ld de, PewterCityBenchGuyJigglyPuff2
	ld bc, LearnsetFadeOutInDream
	predef_jump LearnsetTrainerScriptMain
.no
	ld hl, .yawn
	rst _PrintText
	rst TextScriptEnd
.oh
	text_far _PewterPokecenterBenchGuyLearnsetText1
	text_end
.yawn
	text_far _PewterCityPokecenterGuyText
	text_end

BenchGuyName:
	db "BENCH GUY@"
	text_far _PewterCityPokecenterGuyText
	text_end
