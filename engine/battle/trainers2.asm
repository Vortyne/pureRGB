; PureRGBnote: MOVED: this function was slightly modified and moved outside of home bank for more space in the home bank.

GetTrainerInformation:: 
	callfar GetTrainerName
	ld a, [wLinkState]
	and a
	jr nz, .linkBattle
	ld a, [wTrainerClass]
	dec a
	ld hl, TrainerPicAndMoneyPointers 
	ld bc, $5
	call AddNTimes
	ld de, wTrainerPicPointer
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wTrainerBaseMoney
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret
.linkBattle
	ld hl, wTrainerPicPointer
	ld de, RedPicFront
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

INCLUDE "data/trainers/pic_pointers_money.asm"
