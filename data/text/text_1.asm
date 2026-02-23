_CardKeySuccessText1::
	text "Bingo!@"
	text_end

_CardKeySuccessText2::
	text_start
	line "The CARD KEY"
	cont "opened the door!"
	done

_CardKeyFailText::
	text "Darn! It needs a"
	line "CARD KEY!"
	done

_CardKeyDoneText::
	text "All the CARD KEY"
	line "doors have been"
	cont "opened!"
	
	para "Don't need this"
	line "CARD KEY anymore."

	para "<PLAYER> left it"
	line "in the card slot!"
	done

_TrainerNameText::
	text_ram_namebuffer
	text ": @"
	text_end

_NoNibbleText::
	text "Not even a nibble!"
	prompt

_NothingHereText::
	text "Looks like there's"
	line "nothing here."
	prompt

_ItsABiteText::
	text "Oh!"
	line "It's a bite!"
	prompt

_ExclamationText::
	text "!"
	done

;_GroundRoseText:: ; unused
;	text "Ground rose up"
;	line "somewhere!"
;	done

_BoulderText::
	text "This requires"
	line "STRENGTH to move!"
	done

_StrengthActive::
	text "This boulder"
	line "can be moved!"
	done

_MartSignText::
	text "All your item"
	line "needs fulfilled!"
	cont "#MON MART"
	done

_PokeCenterSignText::
	text "Heal Your #MON!"
	line "#MON CENTER"
	done

_FoundItemText::
	text "<PLAYER> found"
	line "@"
	text_ram_stringbuffer
	text "!@"
	text_end

_FoundMultipleItemText::
	text "<PLAYER> found"
	line "@"
	text_ram_stringbuffer
	text " ×@"
	text_ram wTempStore1
	text "!@"
	text_end

_NoMoreRoomForItemText::
	text "No more room for"
	line "items!"
	done

_OaksAideHiText::
	text "Hi! Remember me?"
	line "I'm PROF.OAK's"
	cont "AIDE!"

	para "If you caught @"
	text_decimal hOaksAideRequirement, 1, 3
	text_start
	line "kinds of #MON,"
	cont "I'm supposed to"
	cont "give you this"
	cont "@"
	text_ram wOaksAideRewardItemName
	text "!"

	para "So, <PLAYER>! Have"
	line "you caught at"
	cont "least @"
	text_decimal hOaksAideRequirement, 1, 3
	text " kinds of"
	cont "#MON?"
	done

_OaksAideUhOhText::
	text "Let's see<...>"
	line "Uh-oh! You have"
	cont "caught only @"
	text_decimal hOaksAideNumMonsOwned, 1, 3
	text_start
	cont "kinds of #MON!"

	para "You need @"
	text_decimal hOaksAideRequirement, 1, 3
	text " kinds"
	line "if you want the"
	cont "@"
	text_ram wOaksAideRewardItemName
	text "."
	done

_OaksAideComeBackText::
	text "Oh. I see."

	para "When you get @"
	text_decimal hOaksAideRequirement, 1, 3
	text_start
	line "kinds, come back"
	cont "for @"
	text_ram wOaksAideRewardItemName
	text "."
	done

_OaksAideHereYouGoText::
	text "Great! You have"
	line "caught @"
	text_decimal hOaksAideNumMonsOwned, 1, 3
	text " kinds"
	cont "of #MON!"
	cont "Congratulations!"

	para "Here you go!"
	prompt

_OaksAideGotItemText::
	text "<PLAYER> got the"
	line "@"
	text_ram wOaksAideRewardItemName
	text "!@"
	text_end

_OaksAideNoRoomText::
	text "Oh! I see you"
	line "don't have any"
	cont "room for the"
	cont "@"
	text_ram wOaksAideRewardItemName
	text "."
	done

_ConversionEnteredAttackModeText::
	text "<USER>"
	line "converted to"
	cont "ATTACK mode!"
	prompt

_ConversionEnteredDefenseModeText::
	text "<USER>"
	line "converted to"
	cont "DEFENSE mode!"
	prompt

_ConversionAlreadyDefenseModeText::
	text "<USER> is"
	line "already in"
	cont "DEFENSE mode."
	prompt

_FuchsiaMeetingRoomOaksAideGreeting::
	text "Hey <PLAYER>!"
	line "How's it going?"
	para "I'm one of PROF."
	line "OAK's AIDEs!"
	para "If you've caught 50"
	line "or more #MON,"
	para "I'll upgrade"
	line "your TOWN MAP!"
	prompt

_FuchsiaMeetingRoomOaksAideHowMany::
	text "How many #MON"
	line "have you caught?"
	prompt

_FuchsiaMeetingRoomOaksAideNotEnough::
	text "@"
	text_decimal wNumSetBits, 1, 3
	text "? Not enough"
	line "yet! Come on!"
	para "I believe in you,"
	line "you can do it!"
	done

_FuchsiaMeetingRoomOaksAideEnough::
	text "@"
	text_decimal wNumSetBits, 1, 3
	text "? Fantastic!"
	line "MAP upgrade time!"
	para "A new function"
	line "will be added."
	para "It'll have wild"
	line "#MON data for"
	cont "each area!"
	para "Just press A on an"
	line "area to check."
	para "Alright let's see"
	line "your MAP<...>"
	done


_FuchsiaMeetingRoomOaksAideNoTownmap::
	text "What?!"
	para "You don't have a"
	line "TOWN MAP?"
	para "Head back to"
	line "PALLET TOWN and"
	cont "ask around!"
	para "I'm sure someone'll"
	line "give you a MAP!"
	done

_FuchsiaMeetingRoomOaksAideGoodLuck::
	text "Good luck on"
	line "your journey!"
	para "I'm rooting for"
	line "you, <PLAYER>!"
	done

_GenericThereWeGoText::
	text "There we go!"
	prompt