FuchsiaMeetingRoom_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaMeetingRoom_TextPointers:
	def_text_pointers
	dw_const FuchsiaMeetingRoomSafariZoneWorker1, TEXT_FUCHSIAMEETINGROOM_SAFARI_ZONE_WORKER1
	dw_const FuchsiaMeetingRoomSafariZoneWorker2, TEXT_FUCHSIAMEETINGROOM_SAFARI_ZONE_WORKER2
	dw_const FuchsiaMeetingRoomSafariZoneWorker3, TEXT_FUCHSIAMEETINGROOM_SAFARI_ZONE_WORKER3
	dw_const FuchsiaMeetingRoomOaksAide,          TEXT_FUCHSIAMEETINGROOM_OAKS_AIDE
	dw_const FuchsiaMeetingRoomPoster,            TEXT_FUCHSIAMEETINGROOM_POSTER
	dw_const FuchsiaMeetingRoomDeskPapers,        TEXT_FUCHSIAMEETINGROOM_DESK_PAPERS

FuchsiaMeetingRoomSafariZoneWorker1:
	text_far _FuchsiaMeetingRoomSafariZoneWorker1
	text_end

FuchsiaMeetingRoomSafariZoneWorker2:
	text_far _FuchsiaMeetingRoomSafariZoneWorker2
	text_end

FuchsiaMeetingRoomSafariZoneWorker3:
	text_far _FuchsiaMeetingRoomSafariZoneWorker3
	text_end

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
	rst _DelayFrames
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
	text_far _FuchsiaMeetingRoomOaksAideGreeting
	text_end
.noTownMap
	text_far _FuchsiaMeetingRoomOaksAideNoTownmap
	text_end
.howMany
	text_far _FuchsiaMeetingRoomOaksAideHowMany
	text_end 
.notEnough
	text_far _FuchsiaMeetingRoomOaksAideNotEnough
	text_end
.enough
	text_far _FuchsiaMeetingRoomOaksAideEnough
	text_end
.goodLuck
	text_far _FuchsiaMeetingRoomOaksAideGoodLuck
	text_end
.thereWeGo
	text_far _GenericThereWeGoText
	text_end


; PureRGBnote: ADDED: text entries for the poster and the papers on the desk in this room

FuchsiaMeetingRoomPoster:
	text_far _FuchsiaMeetingRoomPoster
	text_end

FuchsiaMeetingRoomDeskPapers:
	text_far _FuchsiaMeetingRoomDeskPapers
	text_end