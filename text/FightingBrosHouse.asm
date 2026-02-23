_FightingBrosRocketText::
	text "Ow<...>"
	para "They roughed me"
	line "up for trying to"
	cont "block their door."
	para "Now I'm cleaning"
	line "up the mess<...>"
	prompt

_FightingBrosRocketText2::
	text "BRO: We'll sort"
	line "this <ROCKET> out!"
	para "He needs courtesy,"
	line "integrity,"
	cont "perseverance,"
	cont "self-control,"
	para "and indomitable"
	line "spirit!"
	para "Those are the five"
	line "tenets of the"
	cont "FIGHTING DOJO!"
	para "You're going there"
	line "tomorrow for some"
	cont "tough guidance!"
	para "Understand,"
	line "trainee?"
	prompt

_FightingBrosRocketText3::
	text "<ROCKET>: Yipes!"
	line "Y-yes sir!"
	done

_FightingBrosWelcomeText::
	text "We're the"
	line "FIGHTING BROS.!"
	para "Members of the"
	line "FIGHTING DOJO."
	prompt

_FightingBrosSabrinaText::
	text "SABRINA defeated"
	line "the DOJO<...>"
	para "she made us lose"
	line "<PK><MN> GYM status!"
	para "We're looking for"
	line "someone to beat"
	cont "her as revenge!"
	para "Get into SAFFRON"
	line "GYM and show her"
	cont "who's boss for us!"
	para "If you do, we'll"
	line "treat you as a"
	cont "brother!"
	done

_FightingBrosGotMarshBadge::
	text "The golden glare"
	line "of the MARSHBADGE"
	cont "is unmissable!"
	para "So you beat"
	line "SABRINA, brother!"
	para "The FIGHTING BROS."
	line "will reward you"
	cont "any way we can!"
	prompt

_FightingBrosRightBro::
	text "As the older"
	line "FIGHTING BRO,"
	para "I'm the calm,"
	line "collected one."
	para "I use reason"
	line "before violence,"
	cont "meditating daily."
	para "Do you know the"
	line "moves FIRE PUNCH,"
	cont "ICE PUNCH, and"
	cont "THUNDERPUNCH?"
	para "You may have seen"
	line "ALAKAZAM cannot"
	cont "learn them."
	para "Actually<...>"
	line "it can!"
	para "It's a genius"
	line "you know!"
	para "But it refuses to!"
	para "It sees the moves"
	line "as barbaric."
	para "I can convince"
	line "your ALAKAZAM to"
	cont "learn them-"
	para "through pure"
	line "logic!"
	para "But it isn't easy."
	para "So I'll only do"
	line "it once!"
	para "How about it?"
	done

_FightingBrosRightBroShort::
	text "So, how about it?"
	para "Shall I teach your"
	line "ALAKAZAM an"
	cont "elemental punch?"
	para "Remember, I'll"
	line "only do it once!"
	done

_FightingBrosRightBroWhich::
	text "Which punch move"
	line "should I teach?"
	done

_FightingBrosRightBroConvene::
	text "Perfect."
	line "@"
	text_ram_namebuffer
	text "!"
	para "Give me some time"
	line "to speak with"
	cont "@"
	text_ram_stringbuffer
	text "<CONT>to convince it!"
	prompt

_FightingBrosRightBroConvene2::
	text "It took a while,"
	para "but @"
	text_ram_stringbuffer
	text "<LINE>trusts your"
	cont "judgement!"
	para "It'll allow it."
	line "Here we go!"
	prompt

_FightingBrosRightBroEnd::
	text "You might have the"
	line "only ALAKAZAM in"
	cont "the whole world"
	cont "with that move!"
	para "Isn't that cool"
	line "to think of?"
	done

_FightingBrosRightBroAfter::
	text "ALAKAZAM!"
	para "Go forth and punch"
	line "the heavens!"
	done

_FightingBrosLeftBro::
	text "As the younger"
	line "FIGHTING BRO,"
	para "I'm the go-getter"
	line "and mood-maker!"
	para "I love learning"
	line "and teaching"
	cont "many techniques!"
.showMe
	para "Show me a #MON"
	line "and I'll tell you"
	cont "the moves I can"
	cont "teach it!"
	prompt

_FightingBrosLeftBroShort::
	text "Hey, brother!@"
	text_jump _FightingBrosLeftBro.showMe

_FightingBrosLeftBroAfterTeachText::
	text "Good choice!"
	line "That move rules!"
	done

_MoveTutorChooseMoveToLearnText::
	text "@"
	text_ram_namebuffer
	text "?"
	para "I can teach it"
	line "these moves."
	prompt

_MoveTutorCantTeach::
	text "@"
	text_ram_namebuffer
	text "?"
	line "Ah, sorry!"
	para "It can't learn any"
	line "of my moves!"
	prompt

_MoveTutorLearnMoveCost::
	text "Learning a move"
	line "costs ¥@"
	text_bcd hMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text "."
	prompt

_MoveTutorFreebie::
	text "This time only"
	line "it'll be free!"
	prompt

_MoveTutorNotEnoughCash::
	text "Whoops! You don't"
	line "have enough cash!"
	done

_FightingBrosHouseCatalogueText::
	text "FIGHTING BROS."
	line "sensei services!"
	para "Choose any move"
	line "from our catalog!"
	prompt

_FightingBrosHouseCatalogue2Text::
	text "Join the FIGHTING"
	line "BROS. family!"
	para "NEVER GIVE UP!"
	done

_FightingBrosRocketText4::
	text "I'm a humble"
	line "WHITEBELT at the"
	cont "FIGHTING DOJO!"
	para "I'm just starting"
	line "out now,"
	para "but it beats a"
	line "life of crime"
	cont "as a ROCKET!"
	para "FIGHTING BROS."
	line "NEVER GIVE UP!"
	done
