Route15Gate2F_Script:
	jp DisableAutoTextBoxDrawing

Route15Gate2F_TextPointers:
	def_text_pointers
	dba_const Route15Gate2FOaksAideText,   TEXT_ROUTE15GATE2F_OAKS_AIDE
	dba_const Route15Gate2FBinocularsText, TEXT_ROUTE15GATE2F_BINOCULARS
	dba_const Route15GateLeftBinocularsText, TEXT_ROUTE15GATE2F_BINOCULARS_ARTICUNO

; PureRGBnote: CHANGED: oak's aide here will give you the BOOSTER CHIP instead of EXP.ALL, and it requires 80 pokemon caught to obtain.
; Once you install it, you must talk to him to get it removed. This removes the need for it taking up an item slot when in use.
Route15Gate2FOaksAideText:
	text_asm
	CheckEvent EVENT_GOT_BOOSTER_CHIP
	jr nz, .got_item
	ld a, 80
	ldh [hOaksAideRequirement], a
	ld a, BOOSTER_CHIP
	ldh [hOaksAideRewardItem], a
	ld [wNamedObjectIndex], a
	call GetItemName
	ld hl, wNameBuffer
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	rst _CopyData
	callfar OaksAideScript
	ldh a, [hOaksAideResult]
	cp OAKS_AIDE_GOT_ITEM
	jr nz, .done
	SetEvent EVENT_GOT_BOOSTER_CHIP
.got_item
	CheckEvent EVENT_BOOSTER_CHIP_ACTIVE
	ld hl, BoosterChipText
	jr z, .printDone
	ld hl, Route15GateUpstairsRemoveBoosterText
	rst _PrintText
	call YesNoChoice
	ld hl, Route15GateUpstairsNoUninstallText
	jr nz, .printDone
	lb bc, BOOSTER_CHIP, 1
	call GiveItem
	ld hl, Route15GateUpstairsNoRoomText
	jr nc, .printDone
	ResetEvent EVENT_BOOSTER_CHIP_ACTIVE
	call RemoveBoosterChipSounds
	ld hl, Route15GateUpstairsDoneText
.printDone
	rst _PrintText
.done
	rst TextScriptEnd

RemoveBoosterChipSounds:
	ld b, 5
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
.loop
	ld a, SFX_NOISE_INSTRUMENT16
	rst _PlaySound
	ld c, 10
	rst DelayFrames
	dec b
	jr nz, .loop
	ld a, SFX_NOISE_INSTRUMENT03
	rst _PlaySound
	ld c, 10
	rst DelayFrames
	ld a, SFX_WITHDRAW_DEPOSIT
	rst _PlaySound
	ld c, 30
	jp PlayDefaultMusic
	

BoosterChipText:
	text_far_end _Route15Gate2FOaksAideBoosterChipText

;;;;;;;; PureRGBnote: FIXED: Articuno cry is played within the DisplayMonFrontSpriteInBox code now
Route15GateLeftBinocularsText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr nz, .done
	call SaveScreenTilesToBuffer1
	ld hl, .text
	rst _PrintText
	call LoadScreenTilesFromBuffer1
	ld a, ARTICUNO
	ld [wCurPartySpecies], a
	callfar DisplayMonFrontSpriteInBox
.done
	jp TextScriptEndNoButtonPress
;;;;;;;;
.text::
	text_far _GenericLookedIntoTheBinocularsText
	text_far_end _Route15UpstairsBinocularsText


Route15Gate2FBinocularsText:
	text_asm
	ld hl, .Text
	jp GateUpstairsScript_PrintIfFacingUp

.Text:
	text_far _GenericLookedIntoTheBinocularsText
	text_far_end _Route15Gate2FBinocularsText

Route15GateUpstairsNoRoomText:
	text_far_end _PewterGymTM34NoRoomText

Route15GateUpstairsRemoveBoosterText:
	text_far_end _Route15GateUpstairsRemoveBoosterText

Route15GateUpstairsNoUninstallText:
	text_far_end _FossilGuyDenied

Route15GateUpstairsDoneText:
	text_far_end _Route15GateUpstairsDoneText
