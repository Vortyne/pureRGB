; PureRGBnote: CHANGED: The predef text functionality was moved out of home and simplified.
GetPredefText::
	ld a, [wTextPredefID]
	ld hl, TextPredefs
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld d, [hl] ; bank of text into d
	inc hl
	hl_deref ; pointer to text into hl
	ret

MACRO add_tx_pre
\1_id::
	dba \1
ENDM

; the only ones that should be text predefs are ones that can appear in multiple maps

TextPredefs::
	add_tx_pre CardKeySuccessText    
	add_tx_pre CardKeyFailText       
	add_tx_pre GymStatueTextScript   
	add_tx_pre BookcaseText          
	add_tx_pre PorygonPCScreenText   
	add_tx_pre PokemonCenterPCText
	add_tx_pre JustAMomentText       
	add_tx_pre FoundHiddenItemText   
	add_tx_pre CardKeyDoneText       
	add_tx_pre IndigoPlateauStatues  
	add_tx_pre TownMapText           
	add_tx_pre ElevatorText          
	add_tx_pre PokemonStuffText      
