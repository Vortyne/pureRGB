; rst vectors
; PureRGBnote: CHANGED: use these rst vectors. 
; By using "rst (rst vector)" instead of "call (16-bit address)" we can reduce the size of calls to frequently used functions.

SECTION "rst0", ROM0[$0000]
_Bankswitch::
	jp Bankswitch

; PureRGBnote: MOVED: 5 extra bytes of space left here, may as well move something here that puts the space to some use
MartSignText::
	text_far_end _MartSignText

GenericPokecenterNurseText::
	script_pokecenter_nurse

SECTION "rst8", ROM0[$0008]
_Predef::
	jp Predef

; PureRGBnote: MOVED: 5 extra bytes of space left here, may as well move something here that puts the space to some use
PokemartGreetingText::
	text_far_end _PokemartGreetingText

GenericLinkReceptionistText::
	script_cable_club_receptionist

SECTION "rst10", ROM0[$0010]
_DelayFrame::
	jp DelayFrame
	
IghtText::        db "i", "ght@"

SECTION "rst18", ROM0[$0018]
DelayFrames::
; wait c frames
	rst _DelayFrame
	dec c
	jr nz, DelayFrames
	ret

; PureRGBnote: MOVED: 3 extra bytes of space left here, may as well move something here that puts the space to some use
TMCharText::      db "TM@"

SECTION "rst20", ROM0[$0020]
_CopyData::
	jp CopyData

WithText::        db "w", "ith@"

SECTION "rst28", ROM0[$0028]
_PrintText::
	jp PrintText

; PureRGBnote: MOVED: 5 extra bytes of space left here, may as well move something here that puts the space to some use	
PlayerBlackedOutText::
	text_far_end _PlayerBlackedOutText

EndSound::
	sound_ret

SECTION "rst30", ROM0[$0030]
_PlaySound::
	jp PlaySound

LikeText::        db "l", "ike@"

SECTION "rst38", ROM0[$0038]
; PureRGBnote: MOVED: We save a lot of space by moving TextScriptEnd here and using rst TextScriptEnd to jump to it instead
TextScriptEnd:: 
	pop hl ; turn the rst call into a jp by popping off the return address
TextScriptEndNoPop::
	ld hl, TextScriptEndingText
DoRet::
	ret

; PureRGBnote: MOVED: 3 extra bytes of space left here, may as well move something here that puts the space to some use
PlacePKMNText::   db "<PK><MN>@"

; Game Boy hardware interrupts

SECTION "vblank", ROM0[$0040]
	jp VBlank

HaveText::        db "h", "ave@"

SECTION "lcd", ROM0[$0048]
; this interrupt is disabled on init, so this is a free 8 bytes to use unless we turn it on
; PureRGBnote: MOVED: 8 extra bytes of space left here, may as well move something here that puts the space to some use	
BoulderText::
	text_asm
	callfar CheckStrengthUsage
	rst TextScriptEnd

SECTION "timer", ROM0[$0050]
	jp Timer
; PureRGBnote: MOVED: 5 extra bytes of space left here, may as well move something here that puts the space to some use	
PlacePOKeText::   db "POKé@"

SECTION "serial", ROM0[$0058]
	jp Serial
; PureRGBnote: MOVED: 5 extra bytes of space left here, may as well move something here that puts the space to some use	
PlaceMonText::    db "#","MON@" ; have to separate to avoid using the combined macro

SECTION "joypad", ROM0[$0060]
	reti


SECTION "Header", ROM0[$0100]

Start::
; Nintendo requires all Game Boy ROMs to begin with a nop ($00) and a jp ($C3)
; to the starting address.
	nop
	jp _Start

; The Game Boy cartridge header data is patched over by rgbfix.
; This makes sure it doesn't get used for anything else.

	ds $0150 - @

ENDSECTION
