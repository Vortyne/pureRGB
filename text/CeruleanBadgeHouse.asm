_CeruleanBadgeHouseMiddleAgedManText::
	text "#MON BADGEs"
	line "are owned only by"
	cont "skilled trainers."

	para "I see you have"
	line "at least one."

	para "Those BADGEs have"
	line "amazing secrets!"
	prompt

_CeruleanBadgeHouseNowThenText::
	text "Now then<...>"
	done

_CeruleanBadgeHouseMiddleAgedManWhichBadgeText::
	text "<PARA>Which of the 8"
	line "BADGEs should I"
	cont "describe?"
	done

_CeruleanBadgeHouseAnyMoreText::
	text "<PARA>Need info on"
	line "any other BADGEs?"
	done

_CeruleanBadgeHouseMiddleAgedManVisitAnyTimeText::
	text "Come visit me any"
	line "time you wish."
	done

_CeruleanBadgeHouseBoulderBadgeText::
	text "The ATTACK@"
	text_jump _CeruleanBadgeHouseIncreasesALittleBit

_CeruleanBadgeHouseCascadeBadgeText::
	text_call _CeruleanBadgeHouseUpToLevel
	text "@"
	text_jump _CeruleanBadgeHouseAlsoLetsYouUseHM

_CeruleanBadgeHouseThunderBadgeText::
	text "The SPEED@"
	text_jump _CeruleanBadgeHouseIncreasesALittleBit

_CeruleanBadgeHouseRainbowBadgeText::
	text_call _CeruleanBadgeHouseUpToLevel
	text "@"
	text_jump _CeruleanBadgeHouseAlsoLetsYouUseHM

_CeruleanBadgeHouseSoulBadgeText::
	text "The DEFENSE@"
	text_jump _CeruleanBadgeHouseIncreasesALittleBit

_CeruleanBadgeHouseMarshBadgeText::
	text_call _CeruleanBadgeHouseUpToLevel
	prompt

_CeruleanBadgeHouseVolcanoBadgeText::
	text "Your #MON's"
	line "SPECIAL abilities"
	cont "increase a bit."
	prompt

_CeruleanBadgeHouseEarthBadgeText::
	text "All #MON will"
	line "obey you!"
	prompt

_CeruleanBadgeHouseUpToLevel::
	db "#MON up to L@"
	text_decimal w2CharStringBuffer, 1, 2
	text "<LINE>will obey you."

	para "Any higher, they"
	line "become unruly!"
	done

_CeruleanBadgeHouseIncreasesALittleBit::
	text "of all"
	line "#MON increases"
	cont "a little bit."
_CeruleanBadgeHouseAlsoLetsYouUseHM::
	para "Also lets you use"
	line "@"
	text_ram wNameBuffer
	text " outside"
	cont "of battle."
	prompt

_GarbageCrumpledUpPaper::
	text "What's in the"
	line "garbage bin?"
	para "A crumpled up"
	line "sheet of paper."
	para "What's on it?@"
	text_end

_CeruleanBadgeHouseGarbageText::
	text "<PARA>Ohoho."
	para "Some drawings"
	line "of BADGEs."
	para "Is he a designer?"
	done

_CeruleanBadgeHouseLeftPaperText::
	text "If you have a"
	line "MOVEDEX, you can"
	cont "record learnsets"
	cont "for #MON in"
	cont "your #DEX!"
	para "Read books or"
	line "talk to experts"
	cont "on #MON to"
	cont "register their"
	cont "learnsets!"
	done

_CeruleanBadgeHouseCenterLeftPaperText::
	text "When you register"
	line "a learnset for a"
	cont "specific #MON,"
	para "you will auto-"
	line "register the"
	cont "learnsets of its"
	cont "whole evolution"
	cont "family too!"
	done

_CeruleanBadgeHouseCenterRightPaperText::
	text "Learnset data will"
	line "only show names"
	cont "of moves you've"
	cont "seen used before."
	para "If you haven't seen"
	line "the move,"
	para "you can at least"
	line "see what level"
	cont "the #MON will"
	cont "learn a new move!"
	done

_CeruleanBadgeHouseRightPaperText::
	text "If you train your"
	line "#MON to a high"
	cont "enough level,"
	para "you'll master"
	line "using it!"
	para "This will unlock"
	line "its learnset!"
	para "If you don't"
	line "already have it."
	done
