MACRO add_predef
\1Predef::
	IF _NARG == 1
		dba \1
	ELSE
		dbw \2, \1
	ENDC
ENDM

PredefPointers::
; bank and address of certain subroutines are stored in home bank for easy switching with the predef subroutine
; all registers get preserved by a predef call, but it takes a lot of cycles to perform compared to other methods of bank switching
; should only use for functions that are used a bunch of times and need multiple arguments, in places where cycles don't matter very much
	add_predef ArePlayerCoordsInRangePredef
	add_predef CopyDownscaledMonTiles
	add_predef HealParty
	add_predef MoveAnimation
	add_predef LearnsetTrainerScript
	add_predef LearnsetTrainerScriptMain
	add_predef AddBCDPredef
	add_predef SubBCDPredef
	add_predef MakePokemonAppearInOverworld
	add_predef CopyMenuSpritesVideoDataFar
	add_predef LoadTilesetHeader
	add_predef LearnMoveFromLevelUp
	add_predef LearnMove
	add_predef GetQuantityOfItemInBag
	add_predef GetIndexOfItemInBag
	add_predef UpdateHPBar
	add_predef HPBarLength ; used once
	add_predef CopyTileIDsFromList
	add_predef WriteMonMoves
	add_predef MakePokemonDisappearInOverworld
	add_predef SaveScreenTileAreaToBuffer3
	add_predef LoadScreenTileAreaFromBuffer3
	add_predef SetAttackAnimPal
	add_predef AskName
	add_predef DoInGameTradeDialogue
	add_predef BGLayerScrollingUpdate
	add_predef FarLoadTownMapEntry
	add_predef LoadMovePPs
	;;;
