BackupAudioWram::
	CheckEvent FLAG_RESUME_MUSIC
	ret z
	; prevents multiple calls to this from repeatedly backing up data before battle, because trainer encounters need to back it up before
	; the trainer music plays, while other encounters need to before the battle music starts.
	CheckEvent EVENT_ALREADY_BACKED_UP_MUSIC_BEFORE_BATTLE
	ret nz
	ld a, [wAudioFadeOutControl]
	and a
	ret nz ; don't back up when fading out audio
	ld a, 1
	ld [wMuteAudioAndPauseMusic], a
	; copy custom ball names from sram to temporary wram space
	ld hl, wAudioWRAMStart
	ld de, sAudioRamBackup
	call AudioWramSramAction
	ld a, [wAudioROMBank]
	ld [wPausedAudioBank], a
	ld a, [wLastMusicSoundID]
	ld [wPausedAudioSoundID], a
	SetEvent EVENT_PAUSED_MUSIC_BEFORE_BATTLE
	SetEvent EVENT_ALREADY_BACKED_UP_MUSIC_BEFORE_BATTLE
	xor a
	ld [wMuteAudioAndPauseMusic], a
	ret

; check if we should restore from sram to resume music
; requirements:
; - EVENT_PAUSED_MUSIC_BEFORE_BATTLE set
; - wPausedAudioSoundID which was backed up before battle matches the music that we want to play after battle
; - wPausedAudioBank which was backed up before battle matches the bank of the music that we want to play after battle
; - input d = audio ID intended to be played
RestoreAudioWram::
	CheckAndResetEvent EVENT_PAUSED_MUSIC_BEFORE_BATTLE
	ret z
	CheckEvent FLAG_RESUME_MUSIC
	ret z
	ld a, [wPausedAudioSoundID]
	cp d ; d = audio ID intended to be played
	jr nz, .noRemap ; if the paused music was not the intended to be played music, don't unpause and restart with the new music
	ld a, [wAudioSavedROMBank]
	; a = new song's bank
	ld b, a
	ld a, [wPausedAudioBank]
	cp b
	jr nz, .noRemap ; if the paused music's bank was not the same as the intended music's bank, play the intended music instead of unpausing
	ld hl, sAudioRamBackup
	ld de, wAudioWRAMStart
	call AudioWramSramAction
	jr ResetPausedAudioData
.noRemap
	xor a
	ret

ResetPausedAudioData::
	ResetEvent EVENT_PAUSED_MUSIC_BEFORE_BATTLE
	xor a
	ld [wMuteAudioAndPauseMusic], a
	ld [wPausedAudioBank], a
	ld [wPausedAudioSoundID], a
	inc a ; a = nz
	ret

AudioWramSramAction::
	ld a, SRAM_ENABLE
  	ld [MBC1SRamEnable], a
  	ld a, $1
  	ld [MBC1SRamBankingMode], a
  	xor a
	ld [MBC1SRamBank], a
	ld bc, wAudioWRAMEnd - wAudioWRAMStart
	rst _CopyData
   	xor a
  	ld [MBC1SRamBankingMode], a
  	ld [MBC1SRamEnable], a
  	ret
