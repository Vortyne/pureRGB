; PureRGBnote: ADDED: secret house in cerulean
CeruleanRocketHouse1F_Script:
	call EnableAutoTextBoxDrawing
	jr CeruleanRocketHouse1F_AddStairs

CeruleanRocketHouse1F_TextPointers:
	def_text_pointers
; PureRGBnote: ADDED: Rocket who shows up in this building after getting the DIG tm from him. He goes downstairs after becoming champ.
	dba_const _CeruleanRocketHouse1FRocketText,  TEXT_CERULEANROCKETHOUSE1F_ROCKET
	dba_const CeruleanRocketHouse1FBookCaseText, TEXT_CERULEANROCKETHOUSE1F_BOOKCASE
	dba_const _RocketSNESText,                   TEXT_CERULEANROCKETHOUSE1F_SNES

; after becoming champ a stairway opens up in the house that wasn't present before, allowing you to descend.
CeruleanRocketHouse1F_AddStairs:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_BECAME_CHAMP
	ret z
	lb bc, 0, 1
	ld a, $08 ; stair block
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

CeruleanRocketHouse1FBookCaseText:
	text_far _CeruleanRocketHouse1FBookCaseText
	text_far _FlippedToARandomPage
	text_far _CeruleanRocketHouse1FBookCase2Text
	text_asm
	CheckEvent FLAG_HYPNO_FAMILY_LEARNSET
	jr nz, .done
	ld d, DEX_DROWZEE
	jpfar KeepReadingBookLearnset
.done
	rst TextScriptEnd
