
Music_JigglypuffSong_Ch1::
	tempo 144
	duty_cycle_pattern 2, 2, 1, 1
	sound_call Music_JigglypuffSong_Ch1_Common
	note E_, 10
	sound_ret 
	
Music_JigglypuffSong_Ch1_Common::	
	vibrato 8, 2, 4
	volume 7, 7
	duty_cycle 2
	toggle_perfect_pitch
	note_type 13, 6, 7
	octave 4
	note E_, 8
	note_type 12, 6, 7
	note B_, 2
	note G#, 6
	note F#, 8
	note G#, 2
	note A_, 6
	note G#, 8
	note F#, 4
	note G#, 4
	sound_ret

Music_JigglypuffSong_Ch1_Alternate::
	tempo 60
	sound_call Music_JigglypuffSong_Ch1_Common
	note E_, 15
	note E_, 8
	note B_, 2
	note G#, 6
	note F#, 8
	note G#, 2
	note A_, 6
	note G#, 15
	sound_ret

Music_JigglypuffSong_Ch2_Alternate::
	sound_call Music_JigglypuffSong_Ch2_Common
	note E_, 15
	note E_, 8
	note B_, 2
	note G#, 6
	note F#, 8
	note G#, 2
	note A_, 6
	note G#, 15
	sound_ret

Music_JigglypuffSong_Ch2::
	duty_cycle_pattern 0, 0, 2, 2
	sound_call Music_JigglypuffSong_Ch2_Common
	note E_, 10
	sound_ret

Music_JigglypuffSong_Ch2_Common::
	duty_cycle 2
	vibrato 5, 1, 5
	note_type 12, 10, 7
	octave 4
	note E_, 8
	note B_, 2
	note G#, 6
	note F#, 8
	note G#, 2
	note A_, 6
	note G#, 8
	note F#, 4
	note G#, 4
	sound_ret
