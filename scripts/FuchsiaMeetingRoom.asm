FuchsiaMeetingRoom_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaMeetingRoom_TextPointers:
	def_text_pointers
	dba_const _FuchsiaMeetingRoomSafariZoneWorker1, TEXT_FUCHSIAMEETINGROOM_SAFARI_ZONE_WORKER1
	dba_const _FuchsiaMeetingRoomSafariZoneWorker2, TEXT_FUCHSIAMEETINGROOM_SAFARI_ZONE_WORKER2
	dba_const _FuchsiaMeetingRoomSafariZoneWorker3, TEXT_FUCHSIAMEETINGROOM_SAFARI_ZONE_WORKER3
	dba_const FuchsiaMeetingRoomOaksAide,          TEXT_FUCHSIAMEETINGROOM_OAKS_AIDE
; PureRGBnote: ADDED: text entries for the poster and the papers on the desk in this room
	dba_const _FuchsiaMeetingRoomPoster,            TEXT_FUCHSIAMEETINGROOM_POSTER
	dba_const _FuchsiaMeetingRoomDeskPapers,        TEXT_FUCHSIAMEETINGROOM_DESK_PAPERS
	
FuchsiaMeetingRoomOaksAide:
	text_asm
	CheckEvent EVENT_UPGRADED_TOWN_MAP
	jr nz, .finished
	ld hl, .greet
	rst _PrintText
	CheckEvent EVENT_GOT_TOWN_MAP
	ld hl, .noTownMap
	jr z, .printDone
	ld hl, .howMany
	rst _PrintText
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 50
	ld hl, .notEnough
	jr c, .printDone
	SetEvent EVENT_UPGRADED_TOWN_MAP
	ld hl, .enough
	rst _PrintText
	ld a, SFX_SWITCH
	rst _PlaySound
	ld a, SFX_TRADE_MACHINE
	call PlaySoundWaitForCurrent
	ld c, 17
	rst DelayFrames
	call StopSFXChannels
	ld a, SFX_ARROW_TILES
	rst _PlaySound
	call WaitForSoundToFinish
	call DisplayTextPromptButton
	ld hl, .thereWeGo
	rst _PrintText
.finished
	ld hl, .goodLuck
.printDone
	rst _PrintText
	rst TextScriptEnd
.greet
	text_far_end _FuchsiaMeetingRoomOaksAideGreeting
.noTownMap
	text_far_end _FuchsiaMeetingRoomOaksAideNoTownmap
.howMany
	text_far_end _FuchsiaMeetingRoomOaksAideHowMany 
.notEnough
	text_far_end _FuchsiaMeetingRoomOaksAideNotEnough
.enough
	text_far_end _FuchsiaMeetingRoomOaksAideEnough
.goodLuck
	text_far_end _FuchsiaMeetingRoomOaksAideGoodLuck
.thereWeGo
	text_far_end _GenericThereWeGoText
