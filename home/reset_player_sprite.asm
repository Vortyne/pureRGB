ResetPlayerSpriteData::
	ld hl, wSpriteStateData1
	call ResetPlayerSpriteData_ClearSpriteData
	ld hl, wSpriteStateData2
	call ResetPlayerSpriteData_ClearSpriteData
	ld a, $1
	ld [wSpritePlayerStateData1PictureID], a
	ld [wSpritePlayerStateData2ImageBaseOffset], a
	ld hl, wSpritePlayerStateData1YPixels
	; PureRGBnote: OPTIMIZED
	ld a, $3c
	ld [hli], a ; set Y screen pos
	;ld [hl], $3c     
	;inc hl
	inc hl
	ld [hl], $40     ; set X screen pos
	ret

; overwrites sprite data with zeroes
ResetPlayerSpriteData_ClearSpriteData::
	ld bc, SPRITESTATEDATA1_LENGTH
	ASSERT SPRITESTATEDATA2_LENGTH == SPRITESTATEDATA1_LENGTH
	xor a
	jp FillMemory
