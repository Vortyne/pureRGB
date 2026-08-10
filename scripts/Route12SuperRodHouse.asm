; PureRGBnote: CHANGED: since Old rod is obtained in cerulean and good rod in vermilion now, this fishing guru will give either
; the SUPER ROD or the FISHING GUIDE depending on which of the last two gurus you talked to first.
Route12SuperRodHouse_Script:
	jp EnableAutoTextBoxDrawing

Route12SuperRodHouse_TextPointers:
	def_text_pointers
	dba_const Route12SuperRodHouseFishingGuruText, TEXT_ROUTE12SUPERRODHOUSE_FISHING_GURU
	dba_const Route12FishingGuide,                 TEXT_ROUTE12SUPERRODHOUSE_FISHING_GUIDE

Route12SuperRodHouseFishingGuruText:
	text_asm
	CheckEvent EVENT_GOT_ROUTE12_FISHING_GURU_ITEM
	jr nz, .printEndText
	ld hl, Route12GuruIntro
	rst _PrintText
	callfar LastTwoGurusScript
	rst TextScriptEnd
.printEndText
	ld a, [wOptions2] ; PureRGBnote: ADDED: this NPC will talk about how super rod can catch alternate palette pokemon, but only if the feature is enabled.
	bit BIT_ALT_PKMN_PALETTES, a ; do we have alt palettes enabled
	ld hl, Route12GuruEnd
	jr z, .printDone
	rst _PrintText
	call DisplayTextPromptButton
	ld hl, Route12GuruColorInfo
.printDone
	rst _PrintText
	rst TextScriptEnd

Route12GuruIntro:
	text_far_end _Route12GuruIntro

Route12GuruEnd:
	text_far_end _Route12GuruEnd

Route12GuruColorInfo:
	text_far_end _Route12GuruColor

Route12FishingGuide:
	text_asm
	callfar LastTwoGurusFishingGuideBookText
	rst TextScriptEnd
