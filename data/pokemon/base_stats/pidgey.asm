	db DEX_PIDGEY ; pokedex id

	db  40,  45,  40,  66,  65
	;   hp  atk  def  spd  spc

	db NORMAL, FLYING ; type
	db 255 ; catch rate
	db 55 ; base exp

	INCBIN "gfx/pokemon/front/pidgey.pic", 0, 1 ; sprite dimensions
	dw PidgeyPicFront, PidgeyPicBackSW

	db TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm \
	RAZOR_WIND,\ ; ROOST
	PIN_MISSILE,\
	TOXIC,\
	BODY_SLAM,\
	SLASH,\
	DOUBLE_EDGE,\
	BARRIER,\
	RAZOR_LEAF,\
	DRAGON_RAGE,\
	KINESIS,\ ; FIREWALL
	SWORDS_DANCE,\
	REFLECT,\
	BIDE,\
	AGILITY,\
	BARRAGE,\
	SLAM,\ ; FILTHY SLAM
	MEDITATE,\
	SKY_ATTACK,\
	LIGHT_SCREEN,\
	GLARE,\
	SUBSTITUTE,\
	CUT,\
	FLY
	; end


	db BANK(PidgeyPicFront)
	db 0
	db BANK(PidgeyPicBack)
	db BANK(PidgeyPicBackSW)

	dw 0, PidgeyPicBack

