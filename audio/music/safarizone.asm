Music_SafariZone::
	channel_count 4
	channel 1, Music_SafariZone_Ch1
	channel 2, Music_SafariZone_Ch2
	channel 3, Music_SafariZone_Ch3
	channel 4, Music_SafariZone_Ch4


Music_SafariZone_Ch1::
	tempo 132
	volume 7, 7
	vibrato 6, 3, 4
	toggle_perfect_pitch
	duty_cycle 2
	note_type 12, 9, 2
	octave 3
	pitch_slide 1, 4, A_
	note C_, 1
	pitch_slide 1, 4, A_
	note G_, 1
	pitch_slide 1, 4, A_
	note C_, 1
	pitch_slide 1, 4, A_
	note G_, 1
	rest 12
	tempo 150
	duty_cycle 3
	sound_call Music_SafariZone_branch_bc5f
	note_type 12, 10, 4
	note F#, 4
	sound_call Music_SafariZone_branch_bc5f
	note_type 12, 10, 4
	note F#, 2

	tempo 75
.songStart
	note_type 12, 10, 4
	sound_call SafariZonePhrase1

	volume_envelope 8, 7
	rest 4
	octave 3
	note F_, 8
	note C_, 4
	note F_, 8
	rest 12
	note G_, 8
	note E_, 4
	note G_, 8
	rest 8

	sound_call SafariZonePhrase3

	volume_envelope 8, 7
	rest 4
	octave 4
	note C_, 8
	rest 4
	note C_, 8
	rest 12
	octave 3
	note G_, 8
	rest 4
	note B_, 8
	rest 8


	sound_call SafariZonePhrase1

	volume_envelope 8, 7
	rest 4
	octave 3
	note F_, 8
	note C_, 4
	note F_, 8
	rest 12
	note G_, 8
	note E_, 4
	note G_, 8
	rest 8

	sound_call SafariZonePhrase3

	volume_envelope 8, 7
	rest 4
	octave 4
	note C_, 8
	rest 4
	note C_, 8
	rest 12
	octave 3
	note G_, 8
	rest 4
	note B_, 8
	rest 8

	sound_call .ch1JamSession

	duty_cycle 2
	volume_envelope 9, -7
	sound_call SafariZonePhrase3x
	volume_envelope 3, 7
	octave 5
	note G_, 2
	note E_, 2
.twinklies1
	note C_, 2
	note E_, 2
	note G_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note E_, 2
	sound_loop 2, .twinklies1
	octave 8
.descendtwinkle
	note C_, 2
	dec_octave 
	note B_, 2 
	note G_, 2 
	note E_, 2
	sound_loop 3, .descendtwinkle
	note C_, 2
	dec_octave 
	note B_, 2
	duty_cycle 2
	volume_envelope 9, -7
	sound_call SafariZonePhrase3x

	duty_cycle 3
	volume_envelope 12, 7
	sound_call SafariZonePhrase4x


.endReprise
	sound_call SafariZonePhrase1
	sound_call SafariZonePhrase2
	sound_call SafariZonePhrase3
	sound_call SafariZonePhrase4
	sound_loop 2, .endReprise
	sound_call .ch1JamSession
.endRests
	rest 16
	sound_loop 4, .endRests
	sound_loop 0, .songStart

.ch1JamSession
	octave 3
	note C_, 2
	note D_, 2

.jamSessionCh1Part1:
	octave 3
	note C_, 2
	rest 2
	note C_, 4
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note E_, 2
	octave 3
	note D_, 2
	rest 2
	note D_, 4
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note E_, 2
	octave 3
	note E_, 2
	rest 2
	note E_, 4
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note E_, 2
	octave 3
	note D_, 2
	rest 2
	note D_, 4
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note E_, 2
	sound_loop 3, .jamSessionCh1Part1

	octave 3
	note C_, 2
	rest 2
	note C_, 4
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note E_, 2
	octave 3
	note D_, 2
	rest 2
	note D_, 4
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note E_, 2

	octave 3
	note C_, 2
	dec_octave
	note B_, 2
	inc_octave
	note C_, 2
	note E_, 2
	note G_, 2
	note F#, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 8
	rest 4
	sound_ret

SafariZonePhrase1::
	volume_envelope 10, 7
	octave 4
	note C_, 2
	note D_, 2
	note D#, 1
	note E_, 7
	note D_, 4
	note F_, 8
	note E_, 4
	note D_, 4
	note F_, 4
	note D#, 1
	note E_, 7
	note C_, 4
	octave 3
	note G_, 8
	rest 8
	sound_ret

SafariZonePhrase2::
	volume_envelope 10, 7
	octave 3
	note G_, 2
	note G#, 2
	note A_, 8
	octave 4
	note C_, 4
	note C#, 1
	note D_, 7
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note D_, 4
	note C_, 8
	octave 3
	note G_, 4
	octave 4
	note G_, 8
	rest 8
	sound_ret

SafariZonePhrase3:
	volume_envelope 10, 7
SafariZonePhrase3x:
	octave 4
	note A_, 2
	note B_, 2
	octave 5
	note C_, 8
	rest 4
	octave 4
	note B_, 1
	octave 5
	note C_, 7
	octave 4
	note B_, 4
	note A_, 4
	octave 5
	note C_, 4
	octave 4
	note A#, 1
	note B_, 7
	note G_, 4
	note C_, 8
	rest 8
	sound_ret

SafariZonePhrase4::
	volume_envelope 10, 7
SafariZonePhrase4x::
	octave 4
	note C_, 2
	note D_, 2
	note E_, 10
	rest 2
	note E_, 1
	note F_, 7
	note E_, 4
	note D_, 4
	note F_, 4
	note D#, 1
	note E_, 7
	note F_, 2
	note E_, 2
	note D_, 8
	rest 8
	sound_ret


Music_SafariZone_branch_bc5f::
	note_type 12, 10, 2
	octave 3
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C_, 4
	sound_ret


Music_SafariZone_Ch2::
	duty_cycle 2
	vibrato 8, 2, 5
	note_type 12, 10, 2
	octave 4
	note G_, 1
	note D_, 1
	note G_, 1
	note D_, 1
	rest 12
	duty_cycle 3
	sound_call Music_SafariZone_branch_bc89
	note_type 12, 11, 5
	note A_, 4
	sound_call Music_SafariZone_branch_bc89
	note_type 12, 11, 5
	note B_, 2
.songStart
	note_type 12, 11, 5
	volume_envelope 8, 7
	rest 4
	octave 3
	note G_, 8
	note C_, 4
	note G_, 8
	rest 12
	note G_, 8
	note E_, 4
	note G_, 8
	rest 8
	sound_call SafariZonePhrase2
	volume_envelope 8, 7
	rest 4
	octave 4
	note A_, 8
	rest 4
	note A_, 8
	rest 12
	note G_, 8
	rest 4
	note E_, 8
	rest 8
	sound_call SafariZonePhrase4
	volume_envelope 8, 7
	rest 4
	octave 3
	note G_, 8
	note C_, 4
	note G_, 8
	rest 12
	note G_, 8
	note E_, 4
	note G_, 8
	rest 8
	sound_call SafariZonePhrase2
	volume_envelope 8, 7
	rest 4
	octave 4
	note A_, 8
	rest 4
	note A_, 8
	rest 12
	note G_, 8
	rest 4
	note E_, 8
	rest 8
	sound_call SafariZonePhrase4

	sound_call .ch2JamSession
	sound_call .twinklage
	volume_envelope 9, -7
	sound_call SafariZonePhrase4x
	duty_cycle 2
	volume_envelope 5, 7
	note G_, 2 
	note E_, 2
	sound_call .twinklage
	duty_cycle 3
	volume_envelope 10, 7
	octave 4
	note E_, 2
	note F_, 2
	note F#, 1
	note G_, 7
	rest 4
	note A_, 8
	note G_, 4
	note F_, 4
	note A_, 4
	note G_, 8
	note F#, 1
	note G_, 3
	note G_, 8
	rest 8

	sound_call .phrase1Harmony
	volume_envelope 12, 7
	octave 5
	note C_, 2
	dec_octave
	note B_, 2
	note G_, 2
	note E_, 2
	note C_, 2
	note E_, 2
	sound_call .phrase2Harmony
	volume_envelope 12, 7
	octave 4
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	note E_, 2
	sound_call .phrase3Harmony
	volume_envelope 12, 7
	octave 6
	note C_, 2
	dec_octave
	note C_, 1
	rest 1
	note C_, 2
	inc_octave
	note C_, 2
	dec_octave
	note C_, 1
	rest 1
	note C_, 2
	sound_call .phrase4Harmony
	volume_envelope 12, 7
	octave 4
	note B_, 2
	note G_, 2
	note D_, 2
	note B_, 2
	note G_, 2
	note D_, 2
	sound_call .phrase1Harmony
	volume_envelope 12, 7
	octave 4
	note C_, 1
	rest 1
	note E_, 2
	note G_, 2
	note C_, 1
	rest 1
	note E_, 2
	note G_, 2
	sound_call .phrase2Harmony
	volume_envelope 12, 7
	octave 5
	note C_, 1
	dec_octave
	note B_, 1
	note E_, 1
	note G_, 1
	rest 2
	note C_, 1
	dec_octave
	note B_, 1
	note E_, 1
	note G_, 1
	rest 2
	sound_call .phrase3Harmony
	volume_envelope 12, 7
	octave 3
.scaleup
	note C_, 1
	note E_, 1
	note G_, 1
	inc_octave
	sound_loop 4, .scaleup
	sound_call .phrase4Harmony
	volume_envelope 12, 7
	octave 7
.scaledown
	note D_, 1
	dec_octave
	note B_, 1
	note G_, 1
	sound_loop 4, .scaledown
	volume_envelope 10, 7

	sound_call .ch2JamSession

	rest 12
.endRests
	rest 16
	sound_loop 3, .endRests
	sound_loop 0, .songStart

.twinklage
	duty_cycle 2
	volume_envelope 5, 7
.twinklies1
	octave 5
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note B_, 2
	note G_, 2
	note E_, 2
	sound_loop 3, .twinklies1
	octave 5
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note B_, 2
	sound_ret

.phrase1Harmony
	volume_envelope 10, 7
	octave 3
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 8
	dec_octave
	note B_, 4
	inc_octave
	note D_, 8
	note C_, 4
	dec_octave
	note B_, 4
	inc_octave
	note D_, 4
	dec_octave
	note B_, 1
	inc_octave
	note C_, 7
	dec_octave
	note A_, 4
	note C_, 4
	sound_ret

.phrase2Harmony
	volume_envelope 10, 7
	octave 3
	note D_, 2
	note E_, 2
	note F_, 8
	note A_, 4
	note A#, 1
	note B_, 7
	note A_, 4
	note G_, 4
	note B_, 4
	note G_, 8
	note E_, 4
	inc_octave
	note E_, 4
	sound_ret

.phrase3Harmony
	volume_envelope 10, 7
	octave 4
	note F_, 2
	note G_, 2
	note A_, 8
	rest 4
	note G#, 1
	note A_, 7
	note G_, 4
	note F_, 4
	note A_, 4
	note F#, 1
	note G_, 7
	note E_, 4
	dec_octave
	note G_, 4
	sound_ret

.phrase4Harmony
	volume_envelope 10, 7
	octave 3
	note A_, 2
	note B_, 2
	inc_octave
	note C_, 10
	rest 2
	note C#, 1
	note D_, 7
	note C_, 4
	dec_octave
	note B_, 4
	inc_octave
	note D_, 4
	dec_octave
	note B_, 1
	inc_octave
	note C_, 7
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 4
	sound_ret

.ch2JamSession
	rest 4
.jamSessionCh2Part1:
	octave 2
	note C_, 2
	rest 2
	note C_, 4
	octave 3
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	octave 2
	note D_, 2
	rest 2
	note D_, 4
	octave 3
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	octave 2
	note E_, 2
	rest 2
	note E_, 4
	octave 3
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	octave 2
	note D_, 2
	rest 2
	note D_, 4
	octave 3
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	sound_loop 2, .jamSessionCh2Part1

	octave 3
	note E_, 2
	rest 2
	note E_, 4
	octave 5
	note E_, 2
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 2
	octave 3
	note F_, 2
	rest 2
	note F_, 4
	octave 5
	note E_, 2
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 2
	octave 3
	note G_, 2
	rest 2
	note G_, 4
	octave 5
	note E_, 2
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 2
	octave 3
	note F_, 2
	rest 2
	note F_, 4
	octave 5
	note E_, 2
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 2

	octave 3
	note E_, 2
	rest 2
	note E_, 4
	octave 5
	note E_, 2
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 2
	octave 3
	note F_, 2
	rest 2
	note F_, 4
	octave 5
	note E_, 2
	note D_, 2
	note C_, 2
	dec_octave
	note G_, 2

	octave 4
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 8
	rest 8
	sound_ret


Music_SafariZone_branch_bc89::
	note_type 12, 11, 2
	octave 3
	note G_, 4
	note D_, 4
	note G_, 4
	note D_, 4
	note G_, 4
	note D_, 4
	note G_, 4
	sound_ret


Music_SafariZone_Ch3::
	note_type 12, 1, 0
	rest 16

Music_SafariZone_branch_bc97::
	sound_call Music_SafariZone_branch_bca5
	octave 4
	note A_, 4
	sound_call Music_SafariZone_branch_bca5
	octave 4
	note B_, 2
.songStart
	channel_volume 3
	vibrato 9, 2, 8
	fade_wave 0
	rest 4
	sound_call Ch3Branch1
	sound_call Ch3Branch1

	sound_call .ch3JamSession

	channel_volume 2
	fade_wave 0
	vibrato 18, 2, 5
	rest 4
	note F_, 16
	note F_, 16
	note E_, 16
	note E_, 16
	note D_, 16
	note D_, 16
	note G_, 16
	note G_, 16
	note F_, 16
	note F_, 16
	note E_, 16
	note E_, 12

	channel_volume 3
	fade_wave 11
	octave 2
	note C_, 2
	note D_, 2
	note E_, 10
	rest 2
	note F_, 8
	note E_, 4
	note D_, 4
	note F_, 4
	dec_octave
	note G_, 4
	octave 3
	note F#, 1
	note G_, 3
	note F#, 1
	note G_, 3
	note F#, 1
	note G_, 3
	note F#, 1
	note G_, 1
	note D_, 2
	note F_, 2
	note G_, 2
	note D_, 2
	note F_, 2
	note F_, 2
	note G_, 2

.repriseBass
	channel_volume 2
	; reprise
	sound_call .ch3RepriseRiff1
	sound_call .ch3RepriseRiff1Coolness
	sound_call .ch3RepriseRiff1
	inc_octave
	sound_call .ch3RepriseRiff1Coolness
	octave 2
	note F_, 2
	rest 2
	note F_, 4
	inc_octave
	note E_, 1
	note F_, 3
	dec_octave
	note F_, 2
	note G_, 4
	inc_octave
	note G_, 4
	dec_octave
	note G_, 2
	inc_octave
	note F#, 1
	note G_, 1
	note D_, 2
	note F_, 2
	note G_, 2
	octave 2
	note C_, 2
	rest 2
	note C_, 4
	note B_, 1
	inc_octave
	note C_, 3
	dec_octave
	note C_, 1
	rest 1
	note C_, 1
	rest 1
	inc_octave
	note B_, 1
	inc_octave
	note C_, 1
	dec_octave
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note B_, 1
	inc_octave
	note C_, 1
	dec_octave
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note A_, 2
	note B_, 2

	dec_octave
	note A_, 2
	rest 2
	note A_, 4
	inc_octave
	note E_, 1
	note F_, 3
	dec_octave
	note A_, 1
	rest 1
	note A_, 4
	note A_, 4
	note A_, 2
	inc_octave
	note E_, 1
	note F_, 3
	dec_octave
	note A_, 2
	inc_octave
	note F_, 2

	dec_octave
	note G_, 2
	rest 2
	note G_, 4
	inc_octave
	note D_, 1
	note E_, 3
	dec_octave
	note G_, 1
	rest 1
	note G_, 4
	note G_, 4
	note G_, 2
	inc_octave
	note D_, 1
	note E_, 3
	dec_octave
	note G_, 2
	inc_octave
	note E_, 2

	dec_octave
	note F#, 2
	rest 2
	note F#, 4
	inc_octave
	note D_, 1
	note E_, 3
	dec_octave
	note F#, 1
	rest 1
	note F#, 4
	note F#, 4
	note F#, 2
	inc_octave
	note D_, 1
	note E_, 3
	dec_octave
	note F#, 2
	inc_octave
	note F#, 2

	note F#, 1
	note G_, 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 2
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note F#, 2
	note G_, 2
	inc_octave
	note F#, 1
	note G_, 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 2
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note F#, 2
	note G_, 2
	sound_loop 2, .repriseBass
	sound_call .ch3JamSession
	;;;;;
	rest 4
	fade_wave 14
	octave 2
	note B_, 1
	inc_octave
	note C_, 1
	rest 2
	note D_, 4
	note C_, 2
	rest 2
	note D_, 4
	dec_octave
	note B_, 1
	inc_octave
	note C_, 1
	note D_, 4
	note C_, 2
	rest 2
	note G_, 1
	note A_, 5

	octave 2
	note B_, 1
	inc_octave
	note C_, 1
	dec_octave
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note B_, 1
	inc_octave
	note C_, 1
	dec_octave
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note A#, 2
	inc_octave
	note C_, 2
	dec_octave
	note B_, 1
	inc_octave
	note C_, 3

	rest 8

	sound_loop 0, .songStart

.ch3RepriseRiff1
	octave 2
	note C_, 2
	rest 2
	note C_, 4
	note B_, 1
	inc_octave
	note C_, 3
	dec_octave
	note C_, 2
	note C_, 4
	note C_, 4
	note C_, 2
	sound_ret
.ch3RepriseRiff1Coolness
	note B_, 1
	inc_octave
	note C_, 1
	dec_octave
	note G_, 2
	note A#, 2
	inc_octave
	note C_, 2
	sound_ret
.ch3JamSession
	channel_volume 3
	fade_wave 11
.jamSessionCh3Part1
	octave 2
	note C_, 2
	rest 2
	note C_, 4
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	rest 2
	dec_octave
	note C_, 2
	rest 2
	note C_, 4
	inc_octave
	note C_, 2
	dec_octave
	note B_, 2
	inc_octave
	note C_, 2
	sound_loop 4, .jamSessionCh3Part1

	octave 2
	note C_, 2
	rest 2
	note C_, 4
	note E_, 2
	note G_, 2
	inc_octave
	note D_, 2
	note E_, 2
	rest 2
	dec_octave
	note C_, 2
	rest 2
	note C_, 4
	inc_octave
	note E_, 2
	note D_, 2
	note E_, 2

	octave 2
	note D_, 2
	rest 2
	note D_, 4
	note E_, 2
	note G_, 2
	inc_octave
	note E_, 2
	note F_, 2
	rest 2
	dec_octave
	note D_, 2
	rest 2
	note D_, 4
	inc_octave
	note F_, 2
	note E_, 2
	note F_, 2

	octave 2
	note E_, 2
	rest 2
	note E_, 4
	note E_, 2
	note B_, 2
	inc_octave
	note E_, 2
	note G_, 2
	rest 2
	dec_octave
	note E_, 2
	rest 2
	note E_, 4
	inc_octave
	note G_, 2
	note F_, 2
	note G_, 2

	octave 2
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note B_, 2
	inc_octave
	note C_, 2
	note B_, 2
	inc_octave
	note C_, 8
	rest 4
	sound_ret

Ch3Branch1:
	octave 4
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note C_, 2
	note C_, 2
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note G_, 4
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note C_, 2
	note C_, 2
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note G_, 4
	;;;;
	octave 3
	note A_, 2
	rest 2
	note A_, 6
	rest 2
	note A_, 2
	note A_, 2
	note B_, 2
	rest 2
	note B_, 6
	rest 2
	note B_, 4
	octave 4
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note C_, 2
	note C_, 2
	octave 3
	note G_, 2
	rest 2
	note G_, 6
	rest 2
	note F_, 2
	note E_, 2

	octave 3
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note C_, 2
	note C_, 2
	note C_, 2
	rest 2
	note C_, 6
	rest 2

	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	note C_, 2
	note C_, 2
	octave 3
	note C_, 2
	rest 2
	note C_, 6
	rest 2
	octave 5
	note C_, 2
	octave 4
	note B_, 2


	note E_, 2
	rest 2
	note E_, 6
	rest 2
	note E_, 2
	note E_, 2
	note F_, 2
	rest 2
	note F_, 6
	rest 2
	note F_, 2
	note F#, 2
	note G_, 2
	rest 2
	note G_, 6
	rest 2
	note G_, 2
	note G_, 2
	note G_, 2
	rest 2
	note G_, 6
	rest 2
	note F_, 2
	note E_, 2
	sound_ret


Music_SafariZone_branch_bca5::
	octave 3
.loop
	note A_, 2
	rest 2
	inc_octave
	note D_, 2
	rest 2
	dec_octave
	sound_loop 3, .loop
	note A_, 2
	rest 2
	sound_ret

Music_SafariZone_Ch4:
	toggle_noise 0
	drum_speed 6
.startRests
	rest 16
	sound_loop 9, .startRests
	rest 12
.songStart
.firstLoop:
	sound_call .Beat1
	rest 8
	sound_call .Beat1
	rest 8
	sound_call .Beat1
	rest 8
	sound_call .Beat1
	drum_note 19, 2
	drum_note 19, 2 
	drum_note 18, 2
	drum_note 18, 2
	sound_call .Beat1
	rest 8
	sound_call .Beat1
	rest 8
	sound_call .Beat1
	rest 8
	sound_call .Beat1
	drum_note 17, 2
	drum_note 17, 2
	drum_note 18, 2
	drum_note 18, 2
	sound_loop 2, .firstLoop

	rest 8
	toggle_noise 6
	sound_call .jamSessionCh4
.Beat3
	rest 8
	drum_note_short 5, 8
	rest 16
	rest 16
	rest 16
	rest 8
	drum_note_short 6, 8
	rest 16
	rest 16
	rest 16
	sound_loop 3, .Beat3

	drum_note_short 7, 4
	drum_note_short 7, 4
	drum_note_short 5, 8
	rest 16
	drum_note_short 5, 16
	drum_note_short 6, 4
	drum_note_short 5, 4
	drum_note_short 6, 4
	drum_note_short 6, 4
	drum_note_short 5, 4
	drum_note_short 1, 4
	drum_note_short 1, 4
	drum_note_short 7, 8
	drum_note_short 1, 4
	drum_note_short 1, 4
	drum_note_short 7, 8
	drum_note_short 1, 4
	drum_note_short 1, 4
	drum_note_short 7, 4
	drum_note_short 1, 4
	drum_note_short 7, 4
	drum_note_short 1, 4
	drum_note_short 7, 4
	drum_note_short 1, 4
	drum_note_short 7, 4

.Beat4
	drum_note_short 1, 8
	drum_note_short 1, 8
	drum_note_short 7, 8
	drum_note_short 1, 4
	drum_note_short 1, 8
	drum_note_short 1, 8
	drum_note_short 1, 4
	drum_note_short 7, 8
	drum_note_short 1, 4
	drum_note_short 1, 4
	sound_loop 16, .Beat4

	sound_call .jamSessionCh4


.endRests
	rest 16
	sound_loop 7, .endRests

	toggle_noise 0
	rest 8
	drum_note 14, 8
	
	sound_loop 0, .songStart

	
.Beat1:
	drum_note 19, 2
	drum_note 19, 2
	drum_note 18, 2
	drum_note 18, 2
	drum_note 17, 8
	drum_note 17, 8
	rest 8
	drum_note 18, 4
	drum_note 18, 4
	drum_note 17, 8
	drum_note 17, 8
	sound_ret

.jamSessionCh4
.Beat2:
	drum_note_short 1, 8
	drum_note_short 1, 8
	drum_note_short 7, 4
	drum_note_short 1, 8
	drum_note_short 7, 4
	sound_loop 14, .Beat2
	drum_note_short 7, 4
	drum_note_short 1, 4
	drum_note_short 1, 4
	drum_note_short 7, 4
	drum_note_short 1, 4
	drum_note_short 1, 4
	drum_note_short 7, 2
	drum_note_short 7, 2
	drum_note_short 1, 2
	drum_note_short 1, 2
	drum_note_short 5, 8

	rest 8
	rest 8
	sound_ret
