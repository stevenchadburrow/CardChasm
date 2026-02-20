
; sound sub-routines for Card Chasm NES, goes in last bank




; plays a sound effect on Pulse #1
sound_effect
	; store values
	PHA
	TXA
	PHA
	
	; use jump table
	LDA sound_effect_select
	ASL A
	TAX
	LDA sound_effect_table+0,X
	STA sound_effect_jump_low
	LDA sound_effect_table+1,X
	STA sound_effect_jump_high
	JMP (sound_effect_jump_low)
	
sound_effect_bong
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$A3 ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$00 ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$56 ; low timer frequency
	STA apu_pul1_timer
	LDA #$7B ; high timer frequency, length counter
	STA apu_pul1_len	

	JMP sound_effect_exit

sound_effect_pickup
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$AF ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$9A ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$D5 ; low timer frequency
	STA apu_pul1_timer
	LDA #$F8 ; high timer frequency, length counter
	STA apu_pul1_len

	JMP sound_effect_exit

sound_effect_laser
	; sound effects counter
	LDA #$2C
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$AF ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$94 ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA $AB ; low timer frequency
	STA apu_pul1_timer
	LDA #$F9 ; high timer frequency, length counter
	STA apu_pul1_len
	
	JMP sound_effect_exit

sound_effect_squeak
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$CF ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$9F ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$34 ; low timer frequency
	STA apu_pul1_timer
	LDA #$F8 ; high timer frequency, length counter
	STA apu_pul1_len

	JMP sound_effect_exit

sound_effect_error
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$CF ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$9F ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$F4 ; low timer frequency
	STA apu_pul1_timer
	LDA #$FB ; high timer frequency, length counter
	STA apu_pul1_len

	JMP sound_effect_exit

sound_effect_taps
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$E0 ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$9F ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$F4 ; low timer frequency
	STA apu_pul1_timer
	LDA #$F8 ; high timer frequency, length counter
	STA apu_pul1_len

	JMP sound_effect_exit

sound_effect_descend
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$E0 ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$97 ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$F4 ; low timer frequency
	STA apu_pul1_timer
	LDA #$79 ; high timer frequency, length counter
	STA apu_pul1_len

	JMP sound_effect_exit

sound_effect_bounce
	; sound effects counter
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect
	LDA #$E1 ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$00 ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$F4 ; low timer frequency
	STA apu_pul1_timer
	LDA #$FA ; high timer frequency, length counter
	STA apu_pul1_len

	JMP sound_effect_exit
	
; add more sound effects here

sound_effect_exit
	; restore values
	PLA
	TAX
	PLA
	RTS

; table of jump addresses
sound_effect_table
	.WORD sound_effect_bong ; selector bong
	.WORD sound_effect_pickup ; power-up pickup
	.WORD sound_effect_laser ; shooting laser
	.WORD sound_effect_squeak ; high pitched squeak
	.WORD sound_effect_error ; low pitched error
	.WORD sound_effect_taps ; repeated taps
	.WORD sound_effect_descend ; descending down
	.WORD sound_effect_bounce ; bounce noise






