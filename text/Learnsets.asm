_LearnsetCuteTalk::
	text "I could talk"
	line "about my cute"
	cont "@"
	text_ram wNameBuffer
	text " all"
	cont "day!"
	prompt

_LearnsetBeautyTalk::
	text "Do you even"
	line "recognize the"
	cont "absolute serene"
	cont "beauty of a @"
	text_ram_cont wNameBuffer
	text "?"
	prompt

_LearnsetLove::
	text "Oh I just want"
	line "to tell every-"
	cont "one about @"
	text_ram_cont wNameBuffer
	text "!"
	para "I love it!"
	prompt

_LearnsetRude::
	text "Hey!"
	para "It's rude to beat"
	line "a girl and not"
	cont "walk her back to"
	cont "a #MON CENTER."
	para "My poor @"
	text_ram_line wNameBuffer
	text "!"
	prompt

_LearnsetKnowAlotAbout::
	text "I know a lot"
	line "about @"
	text_ram wNameBuffer
	text "."
	para "I'll share some"
	line "of my secrets!"
	prompt

_LearnsetKnowEverythingAbout::
	text "I know everything"
	line "about @"
	text_ram wNameBuffer
	text "!"
	para "Time to hear"
	line "from an expert!"
	prompt

_LearnsetKnowMoreThanYou::
	text "I know more than"
	line "you when it comes"
	cont "to @"
	text_ram wNameBuffer
	text "."
	para "I'll prove it!"
	prompt

_LearnsetBoring::
	text "You're boring."
	para "You'd never train"
	line "a cool #MON"
	cont "like @"
	text_ram wNameBuffer
	text "."
	para "You just wouldn't"
	line "get it!"
	prompt

_LearnsetAppreciator::
	text "It's time for"
	line "you to join<...>"
	para "<...>"
	para "<...>"
	para "The @"
	text_ram wNameBuffer
	text_start
	line "APPRECIATOR CLUB!"
	prompt

_LearnsetMastering::
	text "I've spent years"
	line "mastering the art"
	cont "of training this"
	cont "@"
	text_ram wNameBuffer
	text "."
	para "Listen well!"
	prompt

_LearnsetCool::
	text "The coolness level"
	line "of @"
	text_ram wNameBuffer
	text " is"
	cont "off the charts!"
	para "Listen up bro!"
	prompt

_LearnsetTough::
	text "You'll never find"
	line "a #MON tougher"
	cont "than @"
	text_ram wNameBuffer
	text "!"
	para "You should train"
	line "one!"
	prompt

_LearnsetMystery::
	text "Are you also"
	line "interested in the"
	cont "mysterious nature"
	cont "of @"
	text_ram wNameBuffer
	text "?"
	prompt

_WhileGoingBackToPkmnCenter::
	text "The @"
	text_ram wTrainerName
	text_start
	line "taught you about"
	cont "@"
	text_ram wNameBuffer
	text " while"
	cont "on a trip to the"
	cont "#MON CENTER."
	prompt

_StartedTalkingAboutDetails::
	text "The @"
	text_ram wTrainerName
	text_start
	line "started talking"
	cont "about @"
	text_ram wNameBuffer
	text_start
	cont "in great detail."
	prompt

_ToldAThrillingStory::
	text "The @"
	text_ram wTrainerName
	text_start
	line "told a riveting"
	cont "story about @"
	text_ram_cont wNameBuffer
	text "."
	prompt

_ShowedCoolMoves::
	text "The @"
	text_ram wTrainerName
	text_start
	line "showed off a few"
	cont "of @"
	text_ram wNameBuffer
	text "'s"
	cont "best abilities."
	prompt

_ReadAlotAboutPkmn::
	text "You read a lot"
	line "about @"
	text_ram wNameBuffer
	text "."
	para "Wow, this is"
	line "so @"
	text_asm
	call Random
	and %111
	ld hl, .astonishing
	jr z, .printDone
.loop
	push af
.loopToNextEntry
	ld a, [hli]
	cp "<PROMPT>"
	jr nz, .loopToNextEntry
	pop af
	dec a
	jr nz, .loop
.printDone
	call TextCommandProcessor
	rst TextScriptEnd
.astonishing
	text "astonishing!"
	prompt
.fascinating
	text "fascinating!"
	prompt
.tantalizing
	text "tantalizing!"
	prompt
.engrossing
	text "engrossing!"
	prompt
.enthralling
	text "enthralling!"
	prompt
.interesting
	text "interesting!"
	prompt
.intriguing
	text "intriguing!"
	prompt
.enlightening
	text "enlightening!"
	prompt

_KeepReadingText::
	text "Keep reading?"
	done

_CheckDexToSeeIt::
	text "Check your #DEX"
	line "to read it!"
	done

_WhileGoingHeadingToShipInfirmary::
	text "The @"
	text_ram wTrainerName
	text_start
	line "taught you about"
	cont "@"
	text_ram wNameBuffer
	text " while"
	cont "heading to the"
	cont "ship infirmary."
	prompt

_LearnsetFondMemories::
	text "The @"
	text_ram wTrainerName
	text_start
	line "recounted fond"
	cont "memories made"
	cont "with @"
	text_ram wNameBuffer
	text "."
	prompt


_PlayedAroundWith::
	text "<PLAYER> and the"
	line "@"
	text_ram wTrainerName
	text " played"
	cont "around with"
	cont "@"
	text_ram wNameBuffer
	text " a bit."
	prompt

_LearnsetDream::
	text "The @"
	text_ram wTrainerName
	text_start
	line "described the"
	cont "strange dream"
	cont "they had about"
	cont "@"
	text_ram wNameBuffer
	text "."
	prompt

_BlaineStory::
	text "@"
	text_ram wTrainerName
	text " told"
	line "his epic story"
	cont "about being saved"
	cont "by @"
	text_ram wNameBuffer
	text "."
	prompt

_LearnsetNaturalHabitatText::
	text "<PLAYER> observed"
	line "@"
	text_ram wNameBuffer
	text " in its"
	cont "natural habitat."
	prompt

