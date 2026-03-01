; PureRGBnote: ADDED: sound effect from gold/silver/crystal, used for the master ball visual effect in those games, but in PureRGB it's used in the
; THE MAW battle for when Cubone gets powered up.
SFX_Sparkle_Ch5::
SFX_Sparkle_Ch6::
	execute_music
	duty_cycle 1
	note_type 2, 14, 1
	octave 6
	note B_, 2
	octave 7
	note D_, 2
	octave 6
	note B_, 2
	note G_, 2
	note B_, 2
	note A#, 2
SparkleShort:
	note A_, 2
	note A#, 2
	note A_, 2
	volume_envelope 12, 1
	note G#, 2
	note G_, 2
	note F#, 2
	volume_envelope 9, 1
	note F_, 2
	note E_, 2
	note D#, 2
	volume_envelope 6, 1
	note D_, 2
	note C#, 2
	note C_, 2
	sound_ret

SFX_SparkleShort_Ch5::
SFX_SparkleShort_Ch6::
	execute_music
	duty_cycle 1
	note_type 2, 14, 1
	octave 6
	sound_call SparkleShort
	sound_ret

SFX_Short_Ball_Poof_Ch5::
	duty_cycle 2
	pitch_sweep 1, 6
	square_note 5, 15, 2, 1300
	pitch_sweep 0, 8
	sound_ret

SFX_Short_Ball_Poof_Ch8::
	noise_note 5, 10, 2, 34
	sound_ret

SFX_Psychic_Ball_Poof_Ch5::
	sound_call SFX_Short_Ball_Poof_Ch5
	duty_cycle 2
	pitch_sweep 15, 7
	square_note 8, 10, 4, 1981
	square_note 8, 10, 4, 1982
	square_note 8, 10, 4, 1983
	square_note 8, 10, 4, 1984
	square_note 8, 10, 4, 1985
	pitch_sweep 0, 8
	square_note 1, 0,  0, 0
	sound_ret

SFX_Psychic_Ball_Poof_Ch6::
	square_note 5, 0,  0, 0
	duty_cycle 2
	square_note 8, 10, 4, 1904
	square_note 8, 10, 4, 1889
	square_note 8, 10, 4, 1890
	square_note 8, 10, 4, 1891
	square_note 8, 10, 4, 1892
	square_note 1, 0,  0, 0
	sound_ret


SFX_Psychic_Ball_Poof_Ch8::
	sound_call SFX_Short_Ball_Poof_Ch8
	noise_note 15, 3, -7, 20
	noise_note 8, 10, -7, 19
	noise_note 8, 10, 2, 16
	sound_ret

SFX_Electric_Whirl_Poof_Ch5::
	sound_call SFX_Short_Ball_Poof_Ch5
	duty_cycle 2
	square_note 15, 3, -7, 1984
.loop1:
	square_note 15, 13, -7, 1984
	sound_loop 2, .loop1
	square_note 15, 13, 1, 1984
	sound_ret

SFX_Electric_Whirl_Poof_Ch6::
	square_note 5, 0,  0, 0
	duty_cycle_pattern 2, 3, 0, 3
	square_note 15, 2, -7, 1992
.loop1:
	square_note 15, 12, -7, 1991
	sound_loop 2, .loop1
	square_note 15, 12, 1, 1992
	sound_ret

SFX_Electric_Whirl_Poof_Ch8::
	sound_call SFX_Short_Ball_Poof_Ch8
.loop
	noise_note 3, 9, 7, 18
	noise_note 3, 10, 1, 17
	sound_loop 5, .loop
	sound_ret

SFX_Hearts_Poof_Ch5::
	sound_call SFX_Short_Ball_Poof_Ch5
SFX_LovelyKiss_Ch5::
	duty_cycle 2
	pitch_sweep 1, 5
	square_note 10, 15, 0, 1264
	square_note 10, 15, 0, 1326
	square_note 10, 15, 0, 1264
	pitch_sweep 0, 8
	sound_ret


SFX_Poison_Whirl_Poof_Ch5::
	duty_cycle_pattern 0, 3, 2, 1
	square_note 4, 15, 4, 1536
	square_note 3, 12, 4, 1280
	square_note 5, 11, 5, 1536
	square_note 13, 14, 2, 1728
	sound_loop 2, SFX_Poison_Whirl_Poof_Ch5
	square_note 8, 13, 1, 1536
	sound_ret

SFX_Poison_Whirl_Poof_Ch6::
	duty_cycle_pattern 2, 0, 3, 1
	square_note 5, 14, 4, 1504
	square_note 4, 11, 4, 1248
	square_note 6, 10, 5, 1512
	square_note 14, 13, 1, 1696
	sound_loop 2, SFX_Poison_Whirl_Poof_Ch6
	sound_ret

SFX_Poison_Whirl_Poof_Ch8::
	noise_note 5, 12, 3, 51
	noise_note 3, 9, 2, 67
	noise_note 10, 11, 5, 51
	noise_note 15, 12, 3, 50
	sound_loop 1, SFX_Poison_Whirl_Poof_Ch8
	sound_ret

SFX_Battle_Water_Poof_Ch5::
	duty_cycle 2
	sound_call SFX_Short_Ball_Poof_Ch5
	duty_cycle 1
	pitch_sweep 9, 7
	square_note 15, 15, 2, 1774
	pitch_sweep 0, 8
	sound_ret

SFX_Battle_Water_Poof_Ch8::
	sound_call SFX_Short_Ball_Poof_Ch8
	noise_note 15, 3, -7, 34
	noise_note 15, 15, 2, 34
	sound_ret

SFX_Battle_Lightning_Strike_Poof_Ch5::
	duty_cycle_pattern 3, 2, 3, 1
	square_note 7, 15, -7, 1016
	square_note 12, 15, -7, 1024
	square_note 12, 15, 3, 1024
	sound_ret

SFX_Battle_Lightning_Strike_Poof_Ch6::
	duty_cycle_pattern 2, 3, 1, 0
	square_note 7, 14, -7, 960
	square_note 12, 14, -7, 960
	square_note 12, 14, 3, 960
	sound_ret

SFX_Battle_Lightning_Strike_Poof_Ch8::
	noise_note 4, 15, -7, 81
	noise_note 8, 15, -7, 84
	noise_note 15, 15, -7, 85
	noise_note 5, 15, 3, 86
	sound_ret



SFX_Sparkle_Poof_Ch5::
	sound_call SFX_Short_Ball_Poof_Ch5
.main
	execute_music
	duty_cycle 1
	note_type 2, 14, 1
	octave 6
	note A_, 2
	note A#, 2
	volume_envelope 12, 1
	note G_, 2
	note G#, 2
	volume_envelope 9, 1
	note E_, 2
	note F_, 2
	volume_envelope 6, 1
	note C#, 2
	note D_, 2
	sound_ret

SFX_Sparkle_Poof_Ch6::
	square_note 5, 0,  0, 0
	sound_call SFX_Sparkle_Poof_Ch5.main
	sound_ret

SFX_Wind_Poof_Ch8::
	sound_call SFX_Short_Ball_Poof_Ch8
	noise_note 8, 4, -7, 71
	noise_note 4, 12, 4, 54
	noise_note 6, 15, 2, 55
	noise_note 15, 15, 2, 54
	sound_ret

SFX_Ice_Poof_Ch5::
	sound_call SFX_Short_Ball_Poof_Ch5
	duty_cycle 3
	square_note 3, 14, 1, 1792
	square_note 2, 14, 1, 1920
	square_note 10, 15, 1, 1999
	square_note 1, 0, 1, 1984
	sound_loop 3, SFX_Ice_Poof_Ch5
	sound_ret

SFX_Camera_Shutter::
	square_note 4, 15, 1, 68
	square_note 2, 14, 4, 11
	square_note 2, 14, 4, 10
	square_note 4, 14, 4, 11
	square_note 2, 14, 4, 12
	square_note 4, 14, 1, 5
	sound_ret
