SaffronCity_Script:
	ResetEvent EVENT_SUPER_NERD_GOING_TO_CINNABAR ; PureRGBnote: ADDED: this will make it so the super nerd finishes reviving your fossil.
	call WasMapJustLoaded
	jr z, .notFirstLoad
	; if signature moves turned off, hide move mystic's house door on map load.
	CheckEvent FLAG_SIGNATURE_MOVES_TURNED_OFF
	jr z, .notFirstLoad
	xor a ; block 0
	ld [wNewTileBlockID], a
	lb bc, 1, 19
	call ReplaceTileBlock
.notFirstLoad
	jp EnableAutoTextBoxDrawing

SaffronCity_TextPointers:
	def_text_pointers
	dba_const _SaffronCityRocket1Text,                  TEXT_SAFFRONCITY_ROCKET1
	dba_const _SaffronCityRocket2Text,                  TEXT_SAFFRONCITY_ROCKET2
	dba_const _SaffronCityRocket3Text,                  TEXT_SAFFRONCITY_ROCKET3
	dba_const _SaffronCityRocket4Text,                  TEXT_SAFFRONCITY_ROCKET4
	dba_const _SaffronCityRocket5Text,                  TEXT_SAFFRONCITY_ROCKET5
	dba_const _SaffronCityRocket6Text,                  TEXT_SAFFRONCITY_ROCKET6
	dba_const _SaffronCityRocket7Text,                  TEXT_SAFFRONCITY_ROCKET7
	dba_const _SaffronCityScientistText,                TEXT_SAFFRONCITY_SCIENTIST
	dba_const _SaffronCitySilphWorkerMText,             TEXT_SAFFRONCITY_SILPH_WORKER_M
	dba_const _SaffronCitySilphWorkerFText,             TEXT_SAFFRONCITY_SILPH_WORKER_F
	dba_const SaffronCityGentlemanText,                TEXT_SAFFRONCITY_GENTLEMAN
	dba_const SaffronCityPidgeotText,                  TEXT_SAFFRONCITY_PIDGEOT
	dba_const _SaffronCityRockerText,                   TEXT_SAFFRONCITY_ROCKER
	dba_const _SaffronCityRocket8Text,                  TEXT_SAFFRONCITY_ROCKET8
	dba_const _SaffronCityRocket9Text,                  TEXT_SAFFRONCITY_ROCKET9
	dba_const _SaffronCitySignText,                     TEXT_SAFFRONCITY_SIGN
	dba_const _SaffronCityFightingDojoSignText,         TEXT_SAFFRONCITY_FIGHTING_DOJO_SIGN
	dba_const SaffronCityGymSignText,                  TEXT_SAFFRONCITY_GYM_SIGN
	dba_const MartSignText,                            TEXT_SAFFRONCITY_MART_SIGN
	dba_const _SaffronCityTrainerTips1Text,             TEXT_SAFFRONCITY_TRAINER_TIPS1
	dba_const _SaffronCityTrainerTips2Text,             TEXT_SAFFRONCITY_TRAINER_TIPS2
	dba_const _SaffronCitySilphCoSignText,              TEXT_SAFFRONCITY_SILPH_CO_SIGN
	dba_const PokeCenterSignText,                      TEXT_SAFFRONCITY_POKECENTER_SIGN
	dba_const _SaffronCityMrPsychicsHouseSignText,      TEXT_SAFFRONCITY_MR_PSYCHICS_HOUSE_SIGN
	dba_const _SaffronCitySilphCoLatestProductSignText, TEXT_SAFFRONCITY_SILPH_CO_LATEST_PRODUCT_SIGN
; PureRGBnote: ADDED: One of the buildings has its door barred, and will display this text when you interact with the door.
	dba_const _SaffronCityBusinessSpaceForLease,        TEXT_SAFFRONCITY_BUSINESS_SPACE_FOR_LEASE

SaffronCityGentlemanText:
	text_far _SaffronCityGentlemanText
	text_asm
.done
	ld c, DEX_PIDGEOT - 1
	callfar SetMonSeen
	rst TextScriptEnd

SaffronCityPidgeotText:
	text_far _SaffronCityPidgeotText
	text_asm
	ld a, PIDGEOT
	call PlayCry
	jr SaffronCityGentlemanText.done

SaffronCityGymSignText:
	text_asm
	ld c, SAFFRON_GYM
	ld de, SaffronGymOutsideSign
	jpfar GymOutsideSignTextScript
