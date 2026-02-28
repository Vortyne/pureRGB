CeladonMoveTutorMoves::
	dbw SELFDESTRUCT, SelfdestructLearnset
	dbw EXPLOSION,    ExplosionLearnset
	dbw TRI_ATTACK,   TriAttackLearnset
	dbw DREAM_EATER,  DreamEaterLearnset
	dbw PAY_DAY,      PayDayLearnset
	dbw REST,         -1
	dbw TELEPORT,     TeleportLearnset
	dbw SOFTBOILED,   SoftboiledLearnset
	db -1

SaffronMoveTutorMoves::
	dbw MEGA_PUNCH, MegaPunchLearnset
	dbw MEGA_KICK,  MegaKickLearnset
	dbw WHIRLWIND,  WhirlwindLearnset
	dbw SKULL_BASH, SkullBashLearnset
	dbw SWIFT,      SwiftLearnset
	dbw EGG_BOMB,   EggBombLearnset
	dbw RAGE,       -1
	dbw SCREECH,    ScreechLearnset
	db -1

; input de = which move tutor move list will be used
; output d = result
; d = 0 = cancelled teaching move or already knows move
; d = 1 = taught move successfully
; d = 2 = no moves teachable
MoveTutorScript::
	push de
	call ClearTextBox
	call SaveScreenTilesToBuffer2
	; first, choose the pokemon to see what moves can be tutored
	callfar GenericShowPartyMenuSelection
	jr nc, .partyMenuSelected
	; party menu selection cancelled
	pop de
	ld d, 0
	ret
.partyMenuSelected
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Species
	ld bc, wPartyMon2Species - wPartyMon1Species
	call AddNTimes
	ld a, [hl] ; a = selected pokemon's species
	ld b, a ; b = selected pokemon's index (species)
	ld [wPokedexNum], a
	predef IndexToPokedex
	ld a, [wPokedexNum]
	ld c, a ; c = selected pokemon's dex number
	pop hl ; pop which list should be used into hl from de
	; then show a list of available moves for that pokemon
	; - check which moves it can learn, store them in wTutorMoveList
	ld de, wTutorMoveList
.loopCheckMovesCanbeLearned
	ld a, [hli]
	cp -1
	jr z, .doneCheckingMoveList
	cp SOFTBOILED
	jr z, .onlyPokemonList
	cp RAGE
	jr z, .onlyDittoCant
	cp REST
	jr z, .onlyDittoCant
	push bc
	push hl
	push de
	hl_deref
	; hl = flag array for all pokemon for the given move, check current pokemon's dex ID against this array
	ld b, FLAG_TEST
	; c = pokemon's dex number, aka which bit to check in flag array
	call FlagAction ; calling FlagAction relies on this code being within Bank 3. Otherwise we need to copy the learnset data to wram and do FlagActionPredef.
	pop de
	pop hl
	ld a, c
	and a
	pop bc
	jr .continue
.onlyDittoCant
	ld a, b
	cp DITTO
.continue
	jr nz, .canLearn
	jr .next
.onlyPokemonList
	push hl
	push bc
	push de
	hl_deref
	ld a, b ; b = selected pokemon's species
	call IsInSingleByteArray ; is it in the array of pokemon who can learn this move
	pop de
	pop bc
	pop hl
	jr nc, .next
.canLearn
	dec hl
	ld a, [hli]
	ld [de], a
	inc de
.next
	inc hl
	inc hl
	jr .loopCheckMovesCanbeLearned
.doneCheckingMoveList
	ld a, $FF
	ld [de], a ; finish off learnable move list with the terminator
	; get the pokemon's species name string to display in text
	ld a, b ; b = species of given pokemon
	ld [wNamedObjectIndex], a
	call GetMonName
	; check if we have any moves available to teach, if not first byte of wTutorMoveList is $FF
	ld a, [wTutorMoveList]
	cp $FF
	jr nz, .movesAvailableToTeach
	; no moves to teach
	ld hl, .noTeachableMoves
	rst _PrintText
	ld d, 2
	ret
.movesAvailableToTeach
	; "(Species)? I can teach it these moves."
	ld hl, .chooseMove
	rst _PrintText
	; - draw move choice textbox
	; find out how big vertically we should make the textbox based on how many moves there are in wTutorMoveList
	ld b, -1
	ld hl, wTutorMoveList
.loopCount
	ld a, [hli]
	inc b
	cp $FF
	jr nz, .loopCount
.doneCount
	dec b
	ld a, b
	ld [wMaxMenuItem], a ; which item in the list is the last one
	ld a, 10
	sub b
	ld [wTopMenuItemY], a ; y coord of the first menu item
	inc b ; b = height of the textbox
	hlcoord 5, 0 ; starting top left coords of the textbox
	; adjust vertical position of the textbox based on how many options there are
	ld de, SCREEN_WIDTH
	dec a
.loop
	add hl, de
	dec a
	jr nz, .loop
	ld c, 13 ; c = width of textbox
	push hl
	push de
	call TextBoxBorderUpdateSprites
	; - write each move name that can be learned onto the textbox
	call DisableTextDelay
	pop de
	; now put the x/y hlcoords at the start of where we will write move names onto the textbox
	pop hl
	; move down 1 y coord
	add hl, de
	; move to the right 2 x coords
	inc hl
	inc hl
	; now place the names
	ld de, wTutorMoveList
.loopPlaceNames
	ld a, [de]
	inc de
	cp $FF
	jr z, .donePlacingNames
	ld [wNamedObjectIndex], a
	push hl
	push de
	call GetMoveName
	call PlaceString
	pop de
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	jr .loopPlaceNames
.donePlacingNames
	call EnableTextDelay
	; choose move from move list with handlemenuinput
	ld a, 6
	ld [wTopMenuItemX], a ; 
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	inc a
	ld [wMenuWrappingEnabled], a
	ldh [hJoy7], a ; allow holding down the menu navigation buttons
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld hl, hUILayoutFlags
	set BIT_DOUBLE_SPACED_MENU, [hl]
	push hl
	call HandleMenuInput
	pop hl
	res BIT_DOUBLE_SPACED_MENU, [hl]
	xor a
	ldh [hJoy7], a
	ldh a, [hJoy5]
	bit BIT_B_BUTTON, a
	ld d, 0
	ret nz
	; grab the chosen move from the list
	ld a, [wCurrentMenuItem]
	ld hl, wTutorMoveList
	ld d, 0
	ld e, a
	add hl, de
	ld d, [hl]
	; teach the chosen move
	callfar FarLearnArbitraryMove
	push de
	call LoadScreenTilesFromBuffer2
	call UpdateSprites
	pop de
	ret
.noTeachableMoves
	text_far _MoveTutorCantTeach
	text_end
.chooseMove
	text_far _MoveTutorChooseMoveToLearnText
	text_end

; input b = whether player needs to pay for the tutor, 0 = no, 1 = yes
; hMoney = the cost
; de = which move list to use
PaidMoveTutorScript::
	ld a, c
	and a
	push bc
	push de
	jr z, .freebie1
	; check if player has enough money if applicable
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, .itCosts
	rst _PrintText
	ld de, wPlayerMoney
	ld hl, hMoney
	ld c, 3 ; length of money in bytes
	call StringCmp
	ld hl, .notEnough
	jr nc, .continue
	rst _PrintText
	pop de
	pop bc
	ld d, 0
	ret
.freebie1
	ld hl, .noCost
	rst _PrintText
.continue
	pop de
	call MoveTutorScript
	pop bc
	ld a, d
	cp 1
	jr z, .success
	push de
	ld hl, .ohwell
	rst _PrintText
	pop de
	ret
.success
	; remove money if applicable
	ld a, c
	and a
	ret z
	push de
	call Delay3
	call SubtractAmountPaidFromMoney
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	pop de
	ret
.notEnough
	text_far _MoveTutorNotEnoughCash
	text_end
.itCosts
	text_far _MoveTutorLearnMoveCost
	text_end
.noCost
	text_far _MoveTutorFreebie
	text_end
.ohwell
	text_far _NoTrade1Text
	text_end

; show a window listing the moves a given move tutor can teach
; input 
; hMoney = cost of learning a move
; de = which list of moves (max 8 moves)
ShowMoveTutorMoveList::
	push de
	ld hl, .info
	rst _PrintText
	; draw the textbox
	hlcoord 6, 3
	lb bc, 8, 12
	call TextBoxBorderUpdateSprites
	call DisableTextDelay
	pop de
	hlcoord 7, 4
.loopPlaceMoveNames
	ld a, [de]
	cp $FF
	jr z, .done
	inc de
	inc de
	inc de
	push de
	ld [wNamedObjectIndex], a
	call GetMoveName
	call PlaceString
	pop de
	ld bc, SCREEN_WIDTH
	add hl, bc
	jr .loopPlaceMoveNames
.done
	call EnableTextDelay
	call Delay3
	jp WaitForTextScrollButtonPress
.info
	text_far _MoveTutorInfoText
	text_end

; script for move tutors that teach one move
; [wMoveNum] = which move will be taught
; at the moment all pokemon will be able to learn the move except for ditto (may change if needed later)
; output:
; d = 0 = cancelled teaching or already knew move
; d = 1 = successfully taught move
; d = 2 = ditto was selected
SingleMoveTutorScript::
	call ClearTextBox
	callfar GenericShowPartyMenuSelection
	ld d, 0
	ret c
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Species
	ld bc, wPartyMon2Species - wPartyMon1Species
	call AddNTimes
	ld a, [hl]
	cp DITTO
	ld d, 2
	ret z
	ld a, [wMoveNum]
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyToStringBuffer
	xor a
	ld [wLetterPrintingDelayFlags], a
	predef LearnMove
	push bc
	call LoadScreenTilesFromBuffer2
	pop bc
	ld d, b
	ret

INCLUDE "data/pokemon/tutor_moves/tutor_moves.asm"
