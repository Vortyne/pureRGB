_CeruleanBallDesignerSwitchBallMenuStart::
	text "Change a #MON's"
	line "#BALL?"
	done

_CeruleanBallDesignerCustomizeBallMenuStart::
	text "Edit custom"
	line "#BALLs?"
	done

_NoBallsToSwitch::
	text "No BALLs"
	line "available in bag!"
	done

_CurrentlyInABall::
	text "Currently in:"
	line "@"
	text_ram_namebuffer
	text_end

_AlreadyInThatBall::
	text "It's already in"
	line "that type of BALL."
	done

_NoRoomForBall::
	text "No room for the"
	line "previous #BALL!"
	done

_ChangedBallText1::
	text "Put @"
	text_ram_namebuffer
	text ""
	line "into a pristine"
	cont "@"
	text_ram_stringbuffer
	text "!"
	done

_ChangedBallText2::
	text "Put the old"
	line "@"
	text_ram_namebuffer
	text " into"
	cont "your bag."
	done

_ChangeIntoWarning::
	text "If you put it"
	line "in a @"
	text_ram_stringbuffer
	text ","
	para "you can't get the"
	line "@"
	text_ram_stringbuffer
	text " back."
	para "Due to a powerful"
	line "catch mechanism,"
	para "@"
	text_ram_stringbuffer
	text "s can't"
	line "be reused!"
	para "Change anyway?"
	done

_ChangeOutOfWarning::
	text "Taking it out of"
	line "a @"
	text_ram_namebuffer
	text ""
	cont "will destroy the"
	cont "@"
	text_ram_namebuffer
	text "."
	para "Its powerful catch"
	line "mechanism can"
	cont "only work once!"
	para "Change anyway?"
	done

_CeruleanBallDesignerBlankPokeballText::
	text "It's a blank white"
	line "# BALL!"
	para "It's ready for a"
	line "cool design!"
	done

_CeruleanBallDesignerCameraText::
	text "It's an instant"
	line "film CAMERA!"
	para "It prints out a"
	line "photo right after"
	cont "taking it!"
	done

_CeruleanBallDesignerCamera2Text::
	text "Time to take some"
	line "inspiring photos!"
	prompt

_CeruleanBallDesignerDarkRoomSignText::
	text "DARKROOM"
	para "Keep door closed!"
	para "Photos are"
	line "developing."
	done

_CeruleanBallDesignerBallDisplayText::
	text "A solid silver"
	line "# BALL is on"
	cont "display!"
	para "The engraving"
	line "reads:"
	para "THANKS FOR YOUR"
	line "EXCELLENT WORK!"
	para "-SILPH CO."
	done

_CeruleanBallDesignerPhotosText::
	text "A bunch of photos"
	line "are developing!"
	para "Shouldn't touch!"
	done

_CeruleanBallDesignerSinkText::
	text "Sinks for chemical"
	line "photo baths,"
	cont "and an enlarger!"
	done

_CeruleanBallDesignerPosterText::
	text "A poster"
	line "advertisement."
	para "MISTY's wearing"
	line "a red lifeguard"
	cont "outfit, blowing"
	cont "a whistle."
	para "She's holding a new"
	line "GREAT BALL up to"
	cont "the viewer."
	para "“You won't need"
	line "saving-"
	para "when you've got"
	line "a GREAT BALL!”"
	para "-SILPH CO."
	done

_CeruleanBallDesignerDesignerGreeting::
	text "I'm a # BALL"
	line "DESIGNER!"
	para "SILPH CO. creates"
	line "capture tech, I"
	cont "design the look!"
	para "Check out my"
	line "latest design-"
	para "In all its blue"
	line "glory!"
	prompt

_CeruleanBallDesignerDesignerSecondTime::
	text "I'm brainstorming"
	line "new ideas on this"
	cont "notepad."
	para "# BALL design"
	line "ideas!"
	para "Agh, I can't think"
	line "of anything good!"
	para "Hmm<...>"
	para "Maybe you could"
	line "help."
	para "Want to become my"
	line "assistant?"
	done

_CeruleanBallDesignerDesignerBecameAssistant::
	text "Hooray! I've got"
	line "an assistant now!"
	para "Ready to start?<PARA>@"
	text_end

_CeruleanBallDesignerGoGetCamera::
	text "Go to my DARKROOM"
	line "over there and"
	cont "grab the CAMERA."

	para "Take some photos"
	line "with it, find me"
	cont "some inspiration!"
	done

_CeruleanBallDesignerDesignerGotCamera::
	text "Got my new CAMERA?"
	para "Good!"
	para "I wrote down some"
	line "concepts that may"
	cont "inspire me on"
	cont "that clipboard!"
	para "Take a look!"
	done

_CeruleanBallDesignerDesignerWaitingForPhotos::
	text "Got any new"
	line "photos?"
	para "No?"
	para "By the way,"
	para "You can switch"
	line "your #MON's"
	cont "# BALLs at my"
	cont "work bench!"
	para "Try it out!"
	done

_CeruleanBallDesignerNewPhoto::
	text "Oh? You have a"
	line "new photo?!"
	para "Ah, so exciting!"
	line "Show me! Show me!"
	prompt

_CeruleanBallDesignerWait::
	text "!!!"
	line "Wait a sec<...>"
	prompt

_CeruleanBallDesignerEureka::
	text "EUREKA!!!"
	prompt

_CeruleanBallDesignerDesigned::
	text "With your photo's"
	line "inspiration,"
	para "I designed the"
	line "@"
	text_ram_stringbuffer
	text "!"
	done

_CeruleanBallDesignerDesigned2::
	text "<PARA>You can put your"
	line "#MON in it at"
	cont "my workbench,"
	para "or customize it"
	line "with my tools!"
	para "Thanks again,"
	line "my assistant!"
	done

_BallDesignerPokemonBreederReaction::
	text "#MON and humans"
	line "living together"
	cont "off of this green"
	cont "earth!"
	para "Our planet is like"
	line "one big tree!"
	prompt

_BallDesignerPsyduckReaction::
	text "Its beautiful soul"
	line "is reflected in"
	cont "rippling water!"
	prompt

_BallDesignerFlareonReaction::
	text "A ball of blazing"
	line "fluff!"
	prompt

_BallDesignerJigglypuffReaction::
	text "OH. MY. GOSH!"
	para "That is soooo"
	line "cute!"
	prompt

_BallDesignerJolteonReaction::
	text "Shocking!"
	para "It's lookin' real"
	line "sharp!"
	prompt

_BallDesignerPorygonReaction::
	text "Whoa!"
	para "Is it surfing"
	line "the virtual web?"
	prompt

_BallDesignerFossilReaction::
	text "These ancient"
	line "stones:"
	para "gardens of bone!"
	prompt

_BallDesignerArticunoReaction::
	text "Brrr! You must"
	line "have froze while"
	cont "taking that pic!"
	prompt

_BallDesignerAbraReaction::
	text "I wonder what"
	line "it's seeing in"
	cont "its dreams?"
	prompt

_BallDesignerPidgeotReaction::
	text "Wow! So dynamic!"
	para "It's soaring on"
	line "the wind!"
	prompt

_BallDesignerGrimerReaction::
	text "It's somehow cute"
	line "while also being"
	cont "toxic sludge!"
	prompt

_BallDesignerGastlyReaction::
	text "What a spooky"
	line "piece that is!"
	prompt

_BallDesignerScytherReaction::
	text "It's slicing right"
	line "through a field!"
	prompt

_BallDesignerLassReaction::
	text "Look at her"
	line "beautiful smile!"
	para "What an angel!"
	prompt

_BallDesignerMankeyReaction::
	text "It looks so angry"
	line "it could explode!"
	prompt

_BallDesignerGamblerReaction::
	text "A picture of dice?"
	para "That's pretty"
	line "random! Hehe."
	prompt

_BallDesignerPokemonBreederHint::
	text "A man in a straw"
	line "hat tending a"
	cont "green field."
	prompt

_BallDesignerPsyduckHint::
	text "A #MON living"
	line "in a pond near"
	cont "a port city."
	prompt

_BallDesignerFlareonHint::
	text "A fiery #MON"
	line "living in a rocky"
	cont "eastern ROUTE."
	prompt

_BallDesignerJigglypuffHint::
	text "A cute round"
	line "singing #MON"
	cont "living south of"
	cont "the gray city."
	prompt

_BallDesignerJolteonHint::
	text "An electric"
	line "#MON living on"
	cont "the outskirts of"
	cont "a big city."
	prompt

_BallDesignerPorygonHint::
	text "A virtual #MON"
	line "cruising through"
	cont "cyberspace."
	prompt

_BallDesignerFossilHint::
	text "Stone cold proof"
	line "of prehistoric"
	cont "#MON!"
	prompt

_BallDesignerArticunoHint::
	text "A super-rare"
	line "#MON in an"
	cont "icy area!"
	prompt

_BallDesignerAbraHint::
	text "A sleepy little"
	line "#MON living in"
	cont "a northern ROUTE."
	prompt

_BallDesignerPidgeotHint::
	text "A stunning bird"
	line "#MON in a"
	cont "ROUTE with many"
	cont "fences."
	prompt

_BallDesignerGrimerHint::
	text "A #MON living"
	line "secretly below an"
	cont "underground path!"
	prompt

_BallDesignerGastlyHint::
	text "A little girl who"
	line "is in touch with"
	cont "the supernatural!"
	prompt

_BallDesignerScytherHint::
	text "A fast #MON"
	line "zooming through a"
	cont "ROUTE with lots"
	cont "of tall grass."
	prompt

_BallDesignerLassHint::
	text "A skirt-wearing"
	line "girly girl who"
	cont "loves CLEFAIRY."
	prompt

_BallDesignerMankeyHint::
	text "An angry looking"
	line "ball of fluff"
	cont "living near the"
	cont "path for BIKERs!"
	prompt

_BallDesignerGamblerHint::
	text "A lucky man who"
	line "embraces random"
	cont "chaos in battle!"
	prompt

_CeruleanBallDesignerThanksForHelp::
	text "You helped me"
	line "design so many"
	cont "new # BALLs!"
	para "Now customize"
	line "some of your own!"
	para "Head to my bench"
	line "and get busy!"
	para "Good job,"
	line "assistant!"
	done

_CeruleanBallDesignerBenchCustomizeNoPermission::
	text "A bunch of tools"
	line "and doodads for"
	cont "designing new"
	cont "# BALLs!"
	para "I don't have"
	line "permission to use"
	cont "these yet."
	done

_NeedWorkBenchInfo::
	text "Need info on using"
	line "the workbench?"
	prompt

_WorkbenchInfoBasic::
	text "Custom # BALLs"
	line "are special."
	para "They have unique"
	line "animations when"
	cont "sending out your"
	cont "#MON!"
	para "But these custom"
	line "BALLs don't have"
	cont "catch mechanisms!"
	para "You cannot catch"
	line "wild #MON with"
	cont "them."
	prompt

_WorkbenchInfoChangingBalls::
	text "You can change the"
	line "# BALLs your"
	cont "#MON are in."
	para "For item BALLs,"
	line "you will need one"
	cont "in your bag to"
	cont "switch a #MON"
	cont "into it."
	para "But custom BALLs"
	line "are unlimited!"
	para "By switching a"
	line "#MON to a"
	cont "custom BALL,"
	para "you can get back"
	line "your item BALL!"
	para "Save your money"
	line "and reuse item"
	cont "BALLs to catch"
	cont "more #MON!"
	prompt 

_WorkbenchInfoCustomizingBalls::
	text "You can modify"
	line "custom BALLs that"
	cont "you've unlocked."
	para "You can change"
	line "their audiovisual"
	cont "effects!"
	para "As the DESIGNER"
	line "makes new BALLs,"
	cont "you will unlock"
	cont "more options."
	prompt

_CeruleanBallDesignerBookshelfText::
	text "A reel-to-reel"
	line "audio system!"
	para "Lots of tapes"
	line "on the shelf too!"
	para "Classical, jazz,"
	line "big band<...>"
	done

_CeruleanBallDesignerCannotChangeTile::
	text "You cannot change"
	line "tile of this poof"
	cont "animation."
	para "OG Poof + Explode"
	line "animations use"
	cont "static graphics."
	prompt

_CeruleanBallDesignerCannotChangeColor::
	text "Cannot edit color"
	line "on this system."
	prompt

_BallDesignerInfoText::
	text "If ON, in CERULEAN"
	line "CITY a new house"
	cont "will contain the"
	cont "BALL DESIGNER."
	para "You can work"
	line "with the DESIGNER"
	cont "to create new"
	cont "# BALLs."
	para "Customize BALLs"
	line "with unlockable"
	cont "audiovisual"
	cont "effects!"
	prompt

_BallDesignerCameraBack::
	text "By the way,"
	para "Can I have my"
	line "CAMERA back?"
	done

_BallDesignerCameraBackPC::
	text "It's in your PC!"
	line "Retrieve it first."
	done

_BallDesignerCameraBorrowAgain::
	text "Thanks!"
	para "Feel free to"
	line "borrow it again"
	cont "from my DARKROOM!"
	done
