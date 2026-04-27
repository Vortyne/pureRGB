MACRO add_tx_pre
\1_id::
	dw \1
ENDM

; the only ones that should be text predefs are ones that can appear in multiple maps

TextPredefs::
	add_tx_pre CardKeySuccessText                   ; 01
	add_tx_pre CardKeyFailText                      ; 02
	add_tx_pre GymStatueTextScript                  ; 0C
	add_tx_pre BookcaseText                         ; 0E
	add_tx_pre PorygonPCScreenText                  ; 1D
	add_tx_pre PokemonCenterPCText                  ; 1F
	add_tx_pre JustAMomentText                      ; 22
	add_tx_pre FoundHiddenItemText                  ; 24
	add_tx_pre CardKeyDoneText                      ; 25
	add_tx_pre IndigoPlateauStatues                 ; 3A
	add_tx_pre TownMapText                          ; 3F
	add_tx_pre ElevatorText                         ; 41
	add_tx_pre PokemonStuffText                     ; 42
