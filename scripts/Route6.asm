; PureRGBnote: ADDED: new trainers on this route.

Route6_Script:
	call WasMapJustLoaded
	jr nz, .mapLoad
	bit BIT_CROSSED_MAP_CONNECTION, [hl]
	res BIT_CROSSED_MAP_CONNECTION, [hl]
	jr z, .notMapLoad
.mapLoad
	SetFlag FLAG_MAP_HAS_OVERWORLD_ANIMATION
.notMapLoad
	ld hl, Route6TrainerHeaders
	ld de, Route6_ScriptPointers
	ld bc, wRoute6CurScript
	jp ExecuteCustomMapScriptInTable

Route6_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE6_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE6_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE6_END_BATTLE

Route6_TextPointers:
	def_text_pointers
	dba_const Route6CooltrainerM1Text,        TEXT_ROUTE6_COOLTRAINER_M1
	dba_const Route6CooltrainerF1Text,        TEXT_ROUTE6_COOLTRAINER_F1
	dba_const Route6Youngster1Text,           TEXT_ROUTE6_YOUNGSTER1
	dba_const Route6CooltrainerM2Text,        TEXT_ROUTE6_COOLTRAINER_M2
	dba_const Route6CooltrainerF2Text,        TEXT_ROUTE6_COOLTRAINER_F2
	dba_const Route6Youngster2Text,           TEXT_ROUTE6_YOUNGSTER2
	dba_const Route6Text7,                    TEXT_ROUTE6_ROOKIE
	dba_const Route6Text8,                    TEXT_ROUTE6_BURGLAR
	dba_const _Route6ShadowText,              TEXT_ROUTE6_PSYDUCK_SHADOW
	dba_const PickUp3ItemText,                TEXT_ROUTE6_ITEM1 ; PureRGBnote: ADDED: new item on this route.
 ; PureRGBnote: ADDED: New trainer tips sign
	dba_const _Route6UndergroundPathSignText, TEXT_ROUTE6_UNDERGROUND_PATH_SIGN
	dba_const _Route6TrainerTipsText,         TEXT_ROUTE6_TRAINER_TIPS
	dba_const _Route6ShadowText,              TEXT_ROUTE6_SHADOW2

Route6TrainerHeaders:
	def_trainers
Route6TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_0, 0, _Route6CooltrainerM1BattleText, _Route6CooltrainerM1EndBattleText, _Route6CooltrainerAfterBattleText
Route6TrainerHeader1:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_1, 0, _Route6CooltrainerF1BattleText, _Route6CooltrainerF1EndBattleText, _Route6CooltrainerAfterBattleText
Route6TrainerHeader2:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_2, 4, _Route6Youngster1BattleText, _Route6Youngster1EndBattleText, Route6Youngster1AfterBattleText
Route6TrainerHeader3:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_3, 3, _Route6CooltrainerM2BattleText, _Route6CooltrainerM2EndBattleText, _Route6CooltrainerM2AfterBattleText
Route6TrainerHeader4:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_4, 3, _Route6CooltrainerF2BattleText, _Route6CooltrainerF2EndBattleText, _Route6CooltrainerF2AfterBattleText
Route6TrainerHeader5:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_5, 3, _Route6Youngster2BattleText, _Route6Youngster2EndBattleText, Route6Youngster2AfterBattleText
Route6TrainerHeader6:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_6, 2, _Route6BattleText7, _Route6EndBattleText7, _Route6AfterBattleText7
Route6TrainerHeader7:
	trainer EVENT_BEAT_ROUTE_6_TRAINER_7, 3, _Route6BattleText8, _Route6EndBattleText8, _Route6AfterBattleText8
	db -1 ; end

Route6CooltrainerM1Text:
	script_trainer Route6TrainerHeader0

Route6CooltrainerF1Text:
	script_trainer Route6TrainerHeader1

Route6Youngster1Text:
	script_trainer Route6TrainerHeader2

Route6CooltrainerM2Text:
	script_trainer Route6TrainerHeader3

Route6CooltrainerF2Text:
	script_trainer Route6TrainerHeader4

Route6Youngster2Text:
	script_trainer Route6TrainerHeader5

Route6Text7:
	script_trainer Route6TrainerHeader6

Route6Text8:
	script_trainer Route6TrainerHeader7

Route6Youngster1AfterBattleText:
	text_far _Route6Youngster1AfterBattleText
	text_asm
	lb hl, DEX_VENONAT, BUG_CATCHER
	ld de, Route6VenonatLearnsetText
	predef_jump LearnsetTrainerScript

Route6Youngster2AfterBattleText:
	text_far _Route6Youngster2AfterBattleText
	text_asm
	lb hl, DEX_BUTTERFREE, BUG_CATCHER
	ld de, Route6ButterfreeLearnsetText
	predef_jump LearnsetTrainerScript

PsyduckShadowFlicker::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_DRENCH_BALL
	ret nz
	ld a, ROUTE6_PSYDUCK_SHADOW
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA2_MAPX
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData2
	ld b, 26 + 4
	ld a, [wYCoord]
	cp 28
	jr nz, .noShadowSprite
	ld a, [wXCoord]
	cp 4
	jr nc, .noShadowSprite
	ld a, [hl]
	cp 26 + 4
	ld b, 2 + 4
	jr z, .noShadowSprite
	ld b, 26 + 4
.noShadowSprite
	ld [hl], b
	ret

PsyduckShadowDistance::
	CheckEvent FLAG_BALL_DESIGNER_TURNED_OFF
	ret nz
	CheckEvent EVENT_SNAPPED_CAMERA_PIC_DRENCH_BALL
	ret nz
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
.showShadowText
	ld a, TEXT_ROUTE6_SHADOW2
	ldh [hTextID], a
	jp DisplayTextID
