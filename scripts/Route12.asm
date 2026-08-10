; PureRGBnote: ADDED: new trainers on this route.

Route12_Script:
	call Route12CheckHideCutTree
	ld hl, Route12TrainerHeaders
	ld de, Route12_ScriptPointers
	ld bc, wRoute12CurScript
	jp ExecuteCustomMapScriptInTable

; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
Route12CheckHideCutTree:
	call WasMapJustLoaded
	ret z ; map wasn't just loaded
	ld de, Route12CutAlcove1
	callfar FarArePlayerCoordsInRange
	lb bc, 44, 3
	ld a, $4C
	call c, .removeTreeBlocker
	ld de, Route12CutAlcove2
	callfar FarArePlayerCoordsInRange
	lb bc, 49, 4
	ld a, $6C
	call c, .removeTreeBlocker
	ret
.removeTreeBlocker
	; if we're in the cut alcove, remove the tree
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

Route12_ScriptPointers:
	def_script_pointers
	dw_const Route12DefaultScript,                  SCRIPT_ROUTE12_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE12_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE12_END_BATTLE
	dw_const Route12SnorlaxPostBattleScript,        SCRIPT_ROUTE12_SNORLAX_POST_BATTLE

Route12DefaultScript:
	CheckEventHL EVENT_BEAT_ROUTE12_SNORLAX
	jp nz, CheckFightingMapTrainers
	CheckEventReuseHL EVENT_FIGHT_ROUTE12_SNORLAX
	jp z, CheckFightingMapTrainers
	call SnorlaxWakesUpAnimation
	ld a, TEXT_ROUTE12_SNORLAX_WOKE_UP
	ldh [hTextID], a
	call DisplayTextID
	ld a, SNORLAX
	ld [wCurOpponent], a
	ld a, 40 ; PureRGBnote: CHANGED: raised snorlax's level to balance with party levels
	ld [wCurEnemyLevel], a
	ld a, ROUTE12_SNORLAX
	ldh [hSpriteIndex], a ; makes snorlax stay on screen during battle transition
	ld a, SCRIPT_ROUTE12_SNORLAX_POST_BATTLE
	ld [wRoute12CurScript], a
	ld [wCurMapScript], a
	ret

; PureRGBnote: ADDED: There's a new animation when snorlax wakes up.
SnorlaxWakesUpAnimation::
	; show an exclamation bubble when snorlax wakes up for effect
	call PauseMusic
	ld a, [wAudioROMBank]
	push af
	ld a, BANK(ExclamationBubbleSFX)
	ld [wAudioROMBank], a
	ld de, ExclamationBubbleSFX
	call PlayNewSoundChannel5
	ld a, EXCLAMATION_BUBBLE
	call Route12PrepareEmotionBubble
	call WaitForSoundToFinish
	pop af
	ld [wAudioROMBank], a
	ld a, SNORLAX
	call PlayCry
	; make snorlax move around a bit
	ld b, 12
.loop
	push bc
	srl b
	ld de, PartyMonSprites2 tile 10
	lb bc, BANK(PartyMonSprites2), 2
	jr nc, .replaceSprite
	ld de, SnorlaxSprite
	lb bc, BANK(SnorlaxSprite), 2
.replaceSprite
	ld hl, vNPCSprites tile $7C
	call CopyVideoData
	pop bc
	rst _DelayFrame
	rst _DelayFrame
	dec b
	jr nz, .loop
	ret
	
Route12SnorlaxPostBattleScript:
	ResetEvent EVENT_FIGHT_ROUTE12_SNORLAX
	ld a, [wIsInBattle]
	cp $ff
	jr z, .done
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl] ; indicates we loaded the map after battle, since we went to a script need to reset here to prevent a double fade
	ld a, [wBattleFunctionalFlags]
	bit 1, a ; ran from battle
	jr nz, .goBackToSleep
	ld a, [wBattleResult]
	cp $2 ; caught pokemon (or ran away)
	jr z, .caught_snorlax
.didntCatch
	ld a, TEXT_ROUTE12_SNORLAX_CALMED_DOWN
	call FadeInAndDisplayText
	ld d, SFX_RUN
	ld hl, .snorlaxruns
	call PlayBattleSFXWhenNotInBattle
	call .hide_snorlax
	jr .done
.snorlaxruns
	ld a, 0
.loop
	push af
	ld d, ROUTE12_SNORLAX
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_DOWN
	jr z, .moveDown
	callfar FarSlideSpriteUp
	jr .doneSlide
.moveDown
	callfar FarSlideSpriteDown
.doneSlide
	pop af
	call ReplaceSnorlaxSprite
	inc a
	cp 5
	jr nz, .loop
	ret
.caught_snorlax
	call .hide_snorlax
	call GBFadeInFromWhite
	jr .done
.hide_snorlax
	SetEvent EVENT_BEAT_ROUTE12_SNORLAX
	ld c, TOGGLE_ROUTE_12_SNORLAX
	jp HideObject
.done
	call ResetMapScripts
	ld [wRoute12CurScript], a
	ret
.goBackToSleep
	ld a, TEXT_ROUTE12_SNORLAX_WENT_BACK_TO_SLEEP
	call FadeInAndDisplayText
	jr .done

FadeInAndDisplayText:
	ldh [hTextID], a
	call GBFadeInFromWhite
	jp DisplayTextID

ReplaceSnorlaxSprite:
	ld d, 0
	ld e, a
	push af
	and %11 ; only first 2 bits so it loops
	ld hl, SnorlaxRollingSprites
	add hl, de
	add hl, de
	hl_deref
	pop af
	push af
	and %11 ; only first 2 bits so it loops
	cp 3
	lb bc, BANK(SnorlaxSprite), 4
	jr z, .load
	lb bc, BANK(SnorlaxRollingSprite), 4
.load
	ld d, h
	ld e, l
	ld hl, vNPCSprites tile $7C
	call CopyVideoData
	pop af
	ret

SnorlaxRollingSprites:
	dw SnorlaxRollingSprite
	dw SnorlaxRollingSprite tile 4
	dw SnorlaxRollingSprite tile 8
	dw SnorlaxSprite



Route12_TextPointers:
	def_text_pointers
	dba_const SnorlaxText,                   TEXT_ROUTE12_SNORLAX
	dba_const Route12Fisher1Text,            TEXT_ROUTE12_FISHER1
	dba_const Route12Fisher2Text,            TEXT_ROUTE12_FISHER2
	dba_const Route12CooltrainerMText,       TEXT_ROUTE12_COOLTRAINER_M
	dba_const Route12SuperNerdText,          TEXT_ROUTE12_ROCKER
	dba_const Route12Fisher3Text,            TEXT_ROUTE12_FISHER3
	dba_const Route12Fisher4Text,            TEXT_ROUTE12_FISHER4
	dba_const Route12Fisher5Text,            TEXT_ROUTE12_FISHER5
	dba_const Route12Text9,                  TEXT_ROUTE12_TAMER
	dba_const Route12Text10,                 TEXT_ROUTE12_SUPER_NERD
	dba_const Route12GamblerText,            TEXT_ROUTE12_GAMBLER
	dba_const PickUpItemText,                TEXT_ROUTE12_ITEM1
	dba_const PickUpItemText,                TEXT_ROUTE12_ITEM2
	dba_const PickUpItemText,                TEXT_ROUTE12_ITEM3 ; PureRGBnote: ADDED: new item in this location
	dba_const _Route12SignText,              TEXT_ROUTE12_SIGN
	dba_const _Route12SportFishingSignText,  TEXT_ROUTE12_SPORT_FISHING_SIGN
	dba_const Route12SnorlaxWokeUpText,      TEXT_ROUTE12_SNORLAX_WOKE_UP
	dba_const _Route12SnorlaxCalmedDownText, TEXT_ROUTE12_SNORLAX_CALMED_DOWN
	dba_const _SnorlaxWentBackToSleepText,   TEXT_ROUTE12_SNORLAX_WENT_BACK_TO_SLEEP

Route12TrainerHeaders:
	def_trainers 2
Route12TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_0, 4, _Route12Fisher1BattleText, _Route12Fisher1EndBattleText, Route12Fisher1AfterBattleText
Route12TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_1, 4, _Route12Fisher2BattleText, _Route12Fisher2EndBattleText, Route12Fisher2AfterBattleText
Route12TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_2, 4, _Route12CooltrainerMBattleText, _Route12CooltrainerMEndBattleText, _Route12CooltrainerMAfterBattleText
Route12TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_3, 4, _Route12SuperNerdBattleText, _Route12SuperNerdEndBattleText, _Route12SuperNerdAfterBattleText
Route12TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_4, 4, _Route12Fisher3BattleText, _Route12Fisher3EndBattleText, Route12Fisher3AfterBattleText
Route12TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_5, 4, _Route12Fisher4BattleText, _Route12Fisher4EndBattleText, _Route12Fisher4AfterBattleText
Route12TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_6, 1, _Route12Fisher5BattleText, _Route12Fisher5EndBattleText, _Route12Fisher5AfterBattleText
Route12TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_7, 4, _Route12BattleText8, _Route12EndBattleText8, Route12AfterBattleText8
Route12TrainerHeader8:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_8, 3, _Route12BattleText9, _Route12EndBattleText9, _Route12AfterBattleText9
Route12TrainerHeader9:
	trainer EVENT_BEAT_ROUTE_12_TRAINER_9, 0, _Route12MetronomeGamblerText, _Route12MetronomeGamblerEndBattleText, DoRet
	db -1 ; end

SnorlaxText:: ; PureRGBnote: CHANGED: now also used by route 16's snorlax
	text_asm
	call SnorlaxSnoring
	ld hl, .sleeping
	rst _PrintText
	rst TextScriptEnd
.sleeping
	text_far_end _Route12SnorlaxText

; PureRGBnote: ADDED: when you talk to sleeping snorlax, there's a little snoring animation.
SnorlaxSnoring::
	call .sound
	call PauseMusic
	ld c, 10
	rst DelayFrames
.sound
	ld d, SFX_BATTLE_21
	lb bc, $10, $12
	ld hl, .showEmotionBubble
	jp PlayBattleSFXWhenNotInBattleWithMods
.showEmotionBubble
	ld a, SLEEPING_BUBBLE
	jp Route12PrepareEmotionBubble

Route12PrepareEmotionBubble:
  	ld [wWhichEmotionBubble], a
  	ld a, [wCurMap]
  	cp ROUTE_12
	ld a, ROUTE12_SNORLAX
  	jr z, .load
  	ld a, ROUTE16_SNORLAX
.load
	ld [wEmotionBubbleSpriteIndex], a
	jpfar EmotionBubble

Route12SnorlaxWokeUpText: ; PureRGBnote: CHANGED: now also used by route 16's snorlax
	text_asm
	ld hl, .wokeUp
	rst _PrintText
	callfar PlayDefaultTrainerMusic
	rst TextScriptEnd
.wokeUp
	text_far_end _Route12SnorlaxWokeUpText

Route12Fisher1Text:
	script_trainer Route12TrainerHeader0

Route12Fisher2Text:
	script_trainer Route12TrainerHeader1

Route12CooltrainerMText:
	script_trainer Route12TrainerHeader2

Route12SuperNerdText:
	script_trainer Route12TrainerHeader3

Route12Fisher3Text:
	script_trainer Route12TrainerHeader4

Route12Fisher4Text:
	script_trainer Route12TrainerHeader5

Route12Fisher5Text:
	script_trainer Route12TrainerHeader6

Route12Text9:
	script_trainer Route12TrainerHeader7

Route12Text10:
	script_trainer Route12TrainerHeader8

Route12Fisher1AfterBattleText:
	text_far _Route12Fisher1AfterBattleText
	text_asm
	lb hl, DEX_GOLDEEN, FISHER
	ld de, LearnsetGoldeen
	predef_jump LearnsetTrainerScript

Route12Fisher2AfterBattleText:
	text_far _Route12Fisher2AfterBattleText
	text_asm
	lb hl, DEX_TENTACOOL, FISHER
	ld de, TentacoolLearnset
	predef_jump LearnsetTrainerScript

Route12Fisher3AfterBattleText:
	text_far _Route12Fisher3AfterBattleText
	text_asm
	lb hl, DEX_SEADRA, FISHER
	ld de, SeadraLearnset
	predef_jump LearnsetTrainerScript

Route12AfterBattleText8:
	text_far _Route12AfterBattleText8
	text_asm
	lb hl, DEX_SHELLDER, TAMER
	ld de, ShellderLearnset
	predef_jump LearnsetTrainerScript

Route12GamblerText:
	text_asm
	CheckEvent EVENT_BEAT_ROUTE_12_TRAINER_9
	jr nz, .metronomeTeach
	ld hl, Route12TrainerHeader9
	call TalkToTrainer
	rst TextScriptEnd
.metronomeTeach
	ld hl, .teach
	rst _PrintText
	call YesNoChoice
	ld hl, .ohWell
	jr nz, .printDone
	ld a, METRONOME
	ld [wMoveNum], a
	callfar SingleMoveTutorScript
	ld a, d
	and a
	ld hl, .ohWell
	jr z, .printDone
	dec a
	ld hl, .chaos
	jr z, .printDone
	ld hl, .ditto
.printDone
	rst _PrintText
	rst TextScriptEnd
.teach
	text_far_end _Route12MetronomeGamblerMetronomeTeachText
.chaos
	text_far_end _Route12MetronomeGamblerMetronomeTeach2Text
.ohWell
	text_far_end _NoTrade1Text
.ditto
	text_far_end _Route12MetronomeGamblerNoDitto

Route12GamblerBattleText:
	text_far_end _Route12MetronomeGamblerText

Route12GamblerEndBattleText:
	text_far_end _Route12MetronomeGamblerEndBattleText
