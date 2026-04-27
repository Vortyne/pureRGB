; PureRGBnote: ADDED: secret house in cerulean
CeruleanRocketHouse1F_Script:
	call EnableAutoTextBoxDrawing
	jr CeruleanRocketHouse1F_AddStairs

CeruleanRocketHouse1F_TextPointers:
	def_text_pointers
; PureRGBnote: ADDED: Rocket who shows up in this building after getting the DIG tm from him. He goes downstairs after becoming champ.
	dw_const CeruleanRocketHouse1FRocketText,  TEXT_CERULEANROCKETHOUSE1F_ROCKET
	dw_const CeruleanRocketHouse1FBookCaseText, TEXT_CERULEANROCKETHOUSE1F_BOOKCASE
	dw_const CeruleanRocketHouse1FSnesText, TEXT_CERULEANROCKETHOUSE1F_SNES

; after becoming champ a stairway opens up in the house that wasn't present before, allowing you to descend.
CeruleanRocketHouse1F_AddStairs:
	call WasMapJustLoaded
	ret z
	CheckEvent EVENT_BECAME_CHAMP
	ret z
	lb bc, 0, 1
	ld a, $08 ; stair block
	ld [wNewTileBlockID], a
	predef_jump ReplaceTileBlock

CeruleanRocketHouse1FRocketText:
	text_far _CeruleanRocketHouse1FRocketText
	text_end

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

CeruleanRocketHouse1FSnesText::
	text_far _RocketSNESText
	text_end
