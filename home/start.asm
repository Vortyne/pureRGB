_Start::
	cp CGB
	ld a, 1
	jr z, .gbc
	dec a
.gbc
	ldh [hGBC], a ; shinpokerednote: gbcnote: need to indicate we're on GBC
	jp Init
