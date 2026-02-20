
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

	; sound effect - bounce
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

	; sound effect - clock
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
	LDA #$14
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect - stomp
	LDA #$CF ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$9F ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA #$34 ; low timer frequency
	STA apu_pul1_timer
	LDA #$78 ; high timer frequency, length counter
	STA apu_pul1_len
	
	JMP sound_effect_exit

sound_effect_squeak
	; sound effects counter
	LDA #$2C
	STA sound_effect_timer

	; turn on pulse1 channel
	LDA #$0F
	STA apu_status

	; sound effect 2 - death
	LDA #$AF ; half duty, envelope, full volume
	STA apu_pul1_ctrl
	LDA #$94 ; sweep, period, direction, shift
	STA apu_pul1_sweep
	LDA $AB ; low timer frequency
	STA apu_pul1_timer
	LDA #$F9 ; high timer frequency, length counter
	STA apu_pul1_len

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






