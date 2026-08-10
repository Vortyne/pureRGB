_Route1Youngster1MartSampleText::
	text "Hi! I work at a"
	line "#MON MART."

	para "It's a convenient"
	line "shop, so please"
	cont "visit us in"
	cont "VIRIDIAN CITY."

	para "I know, I'll give"
	line "you a sample!"
	cont "Here you go!"
	prompt

_SilphCo2FSilphWorkerFReceivedTM50Text::
_Route1Youngster1GotPotionText::
	text_call _GenericPlayerGotTextEntry
	text "@"
	sound_get_item_1
	text_end

_GenericPlayerGotText::
	text
_GenericPlayerGotTextEntry::
	db "<PLAYER> got"
	line "@"
	text_ram_stringbuffer
	text "!"
	done

_Route1Youngster1AlsoGotPokeballsText::
	text "We also carry"
	line "# BALLs for"
	cont "catching #MON!"
	done

_Route1Youngster2Text::
	text "See those ledges"
	line "along the road?"

	para "It's a bit scary,"
	line "but you can jump"
	cont "from them."

	para "You can get back"
	line "to PALLET TOWN"
	cont "quicker that way."
	done

_Route1SignText::
	text "ROUTE 1"
	line "PALLET TOWN -"
	cont "VIRIDIAN CITY"
	done
