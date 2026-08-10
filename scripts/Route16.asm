Route16_Script:
	call Route16CheckHideCutTree
	ld hl, Route16TrainerHeaders
	ld de, Route16_ScriptPointers
	ld bc, wRoute16CurScript
	jp ExecuteCustomMapScriptInTable

; PureRGBnote: ADDED: code that keeps the cut tree cut down if we're in its alcove. Prevents getting softlocked if you delete cut.
Route16CheckHideCutTree:
	call WasMapJustLoaded
	jr nz, .mapLoadTree ; map wasn't just loaded
	bit BIT_CROSSED_MAP_CONNECTION, [hl] ; did we load the map from a save/warp/door/battle, etc?
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	jr nz, .checkMankey
	ret
.mapLoadTree
	ld de, Route16CutAlcove
	callfar FarArePlayerCoordsInRange
	call c, .removeTreeBlocker
.checkMankey
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	lb bc, SPRITESTATEDATA2_MAPY, ROUTE16_MANKEY
	call GetFromSpriteStateData2
	ld [hl], 2 + 4 ; move mankey into place
	ret
.removeTreeBlocker
	; if we're in the cut alcove, remove the tree
	lb bc, 4, 17
	ld a, $6E
	ld [wNewTileBlockID], a
	jp ReplaceTileBlock

Route16_ScriptPointers:
	def_script_pointers
	dw_const Route16DefaultScript,                  SCRIPT_ROUTE16_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE16_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE16_END_BATTLE
	dw_const Route16SnorlaxPostBattleScript,        SCRIPT_ROUTE16_SNORLAX_POST_BATTLE

Route16DefaultScript:
	CheckEventHL EVENT_BEAT_ROUTE16_SNORLAX
	jp nz, CheckFightingMapTrainers
	CheckEventReuseHL EVENT_FIGHT_ROUTE16_SNORLAX
	jp z, CheckFightingMapTrainers
	call SnorlaxWakesUpAnimation
	ld a, TEXT_ROUTE16_SNORLAX_WOKE_UP
	ldh [hTextID], a
	call DisplayTextID
	ld a, SNORLAX
	ld [wCurOpponent], a
	ld a, 40 ; PureRGBnote: CHANGED: raised snorlax's level to balance with party levels
	ld [wCurEnemyLevel], a
	ld a, ROUTE16_SNORLAX
	ldh [hSpriteIndex], a ; makes snorlax stay on screen during battle transition
	ld a, SCRIPT_ROUTE16_SNORLAX_POST_BATTLE
	ld [wRoute16CurScript], a
	ld [wCurMapScript], a
	ret

Route16SnorlaxPostBattleScript:
	ResetEvent EVENT_FIGHT_ROUTE16_SNORLAX
	ld a, [wIsInBattle]
	cp $ff
	jr z, .done
	ld hl, wCurrentMapScriptFlags
	res BIT_MAP_LOADED_AFTER_BATTLE, [hl] ; indicates we loaded the map after battle, since we went to a script need to reset here to prevent a double fade
	call UpdateSprites
	ld a, [wBattleFunctionalFlags]
	bit 1, a ; ran from battle
	jr nz, .goBackToSleep
	ld a, [wBattleResult]
	cp $2
	jr z, .caught_snorlax
.didntCatch
	ld a, TEXT_ROUTE16_SNORLAX_RETURNED_TO_MOUNTAINS
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
	ld d, ROUTE16_SNORLAX
	callfar FarSlideSpriteUp
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
	SetEvent EVENT_BEAT_ROUTE16_SNORLAX
	ld c, TOGGLE_ROUTE_16_SNORLAX
	jp HideObject
.done
	call ResetMapScripts
	ld [wRoute16CurScript], a ; SCRIPT_ROUTE16_DEFAULT
	ret
.goBackToSleep
	ld a, TEXT_ROUTE16_SNORLAX_WENT_BACK_TO_SLEEP
	call FadeInAndDisplayText
	jr .done

Route16_TextPointers:
	def_text_pointers
	dba_const Route16Biker1Text,                     TEXT_ROUTE16_BIKER1
	dba_const Route16Biker2Text,                     TEXT_ROUTE16_BIKER2
	dba_const Route16Biker3Text,                     TEXT_ROUTE16_BIKER3
	dba_const Route16Biker4Text,                     TEXT_ROUTE16_BIKER4
	dba_const Route16Biker5Text,                     TEXT_ROUTE16_BIKER5
	dba_const Route16Biker6Text,                     TEXT_ROUTE16_BIKER6
	dba_const SnorlaxText,                           TEXT_ROUTE16_SNORLAX
	dba_const Route16MankeyText,                     TEXT_ROUTE16_MANKEY
	dba_const _Route16CyclingRoadSignText,           TEXT_ROUTE16_CYCLING_ROAD_SIGN
	dba_const _Route16SignText,                      TEXT_ROUTE16_SIGN
	dba_const _Route12SnorlaxWokeUpText,             TEXT_ROUTE16_SNORLAX_WOKE_UP
	dba_const _Route12SnorlaxCalmedDownText,         TEXT_ROUTE16_SNORLAX_RETURNED_TO_MOUNTAINS
	dba_const _SnorlaxWentBackToSleepText,           TEXT_ROUTE16_SNORLAX_WENT_BACK_TO_SLEEP

Route16TrainerHeaders:
	def_trainers
Route16TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_16_TRAINER_0, 3, _Route16Biker1BattleText, _Route16Biker1EndBattleText, _Route16Biker1AfterBattleText
Route16TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_16_TRAINER_1, 2, _Route16Biker2BattleText, _Route16Biker2EndBattleText, _Route16Biker2AfterBattleText
Route16TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_16_TRAINER_2, 2, _Route16Biker3BattleText, _Route16Biker3EndBattleText, _Route16Biker3AfterBattleText
Route16TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_16_TRAINER_3, 2, _Route16biker4BattleText, _Route16Biker4EndBattleText, _Route16Biker4AfterBattleText
Route16TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_16_TRAINER_4, 2, _Route16Biker5BattleText, _Route16Biker5EndBattleText, _Route16Biker5AfterBattleText
Route16TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_16_TRAINER_5, 4, _Route16Biker6BattleText, _Route16Biker6EndBattleText, _Route16Biker6AfterBattleText
	db -1 ; end

Route16Biker1Text:
	script_trainer Route16TrainerHeader0

Route16Biker2Text:
	script_trainer Route16TrainerHeader1

Route16Biker3Text:
	script_trainer Route16TrainerHeader2

Route16Biker4Text:
	script_trainer Route16TrainerHeader3

Route16Biker5Text:
	script_trainer Route16TrainerHeader4

Route16Biker6Text:
	script_trainer Route16TrainerHeader5

Route16MankeyText:
	text_far _Route16MankeyText
	text_asm
	ld a, MANKEY
	call PlayCry
	call DisplayTextPromptButton
	ld hl, .glaring
	rst _PrintText
	rst TextScriptEnd
.glaring
	text_far_end _Route16MankeyText2

MankeyHiddenObject::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	ld a, TEXT_ROUTE16_MANKEY
.displayTextID
	ldh [hTextID], a
	jp DisplayTextID
