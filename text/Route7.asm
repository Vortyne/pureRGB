_Route7UndergroundPathSignText::
	text "UNDERGROUND PATH"
	line "CELADON CITY -"
	cont "LAVENDER TOWN"
	done

_Route7BattleText1::
	text "I'm the oldest"
	line "gambler alive!"
	done

_Route7EndBattleText1::
	text "You"
	line "don't believe me?"
	prompt

_Route7AfterBattleText1::
	text "Don't listen to@"
	text_call _Route7OtherGuyText
	para "I was a GAMBLER"
	line "when he was in"
	cont "diapers!"
	done

_Route7OtherGuyText:
	db "<LINE>what the other"
	cont "guy says to you."
	done

_Route7BattleText2::
	text "I invented"
	line "gambling when I"
	cont "was young!"
	done

_Route7EndBattleText2::
	text "Listen"
	line "to me!"
	prompt

_Route7AfterBattleText2::
	text "Don't believe@"
	text_call _Route7OtherGuyText
	para "CELADON CITY"
	line "wouldn't be the"
	cont "same without my"
	cont "gambling!"
	para "I lost more money"
	line "than anyone else!"
	done	
