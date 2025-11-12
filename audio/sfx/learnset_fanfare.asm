SFX_Learnset_Fanfare_Ch5::
	execute_music
	speed 1
	volume 7, 7
	vibrato 28, 3, 3
	duty_cycle 1
	toggle_perfect_pitch
	note_type 1, 11, 1
SFX_Learnset_Fanfare::
	octave 2
	note B_, 3
	rest 4
	inc_octave
	note D_, 4
	rest 4
	dec_octave
	note B_, 3
	rest 4
	inc_octave
	note F#, 4
	rest 4
	dec_octave
	note B_, 3
	rest 4
	inc_octave
	inc_octave
	note_type 1, 15, 1
	note D_, 4
	rest 4
	note E_, 3
	rest 12
	sound_ret

SFX_Learnset_Fanfare_Ch6:: 
	transpose 1, 5
	sound_call SFX_Learnset_Fanfare_Ch5
	transpose 0, 0
	sound_ret

SFX_Learnset_Fanfare_part2::
	duty_cycle 2
	pitch_sweep 4, 4
	square_note 15, 15, 0, 1264
	pitch_sweep 1, 7
	square_note 15, 15, 2, 1616
	pitch_sweep 0, 8
	sound_ret
