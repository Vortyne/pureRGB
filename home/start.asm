_Start::
	cp BOOTUP_A_CGB
	ld a, TRUE
	jr z, .gbc
	dec a
.gbc
	ldh [hGBC], a ; shinpokerednote: gbcnote: need to indicate we're on GBC
	jp Init
