
; enemy sub-routine for Card Chasm NES, goes in last bank

; run once before drawing
enemies_setup
	; find font location
	LDA #$C0
	STA grab_low
	LDA #>font_data_0
	CLC
	ADC #$03
	STA grab_high
	
	; find pattern table location
	LDA ppu_status
	LDA #$01
	STA ppu_addr
	LDA #$40
	STA ppu_addr
	
	; from font
	LDY #$04
@loop1
	LDX #$10
@loop2
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @loop2
	LDX #$10
	LDA #$00
@loop3
	STA ppu_data
	DEX
	BNE @loop3
	DEY
	BNE @loop1

	RTS


; draw enemy sprites
enemies_draw
	; draw player sprite
	LDY #$80
	LDA #$88
	STA oam_page+0,Y
	LDA #$1A
	STA oam_page+1,Y
	LDA #$00
	STA oam_page+2,Y
	LDA #$20
	STA oam_page+3,Y

	; draw enemy sprites 15 places ahead
	LDX enemies_position
	INX
	TXA
	CLC
	ADC #$0F
	STA math_slot_0
@loop
	CPX enemies_max
	BEQ @regular
	BCS @blank
@regular
	TXA
	SEC
	SBC enemies_position
	ASL A
	ASL A
	CLC
	ADC #$80
	TAY ; location in oam_page
	SEC
	SBC #$80
	ASL A
	STA math_slot_1
	LDA #$88
	SEC
	SBC math_slot_1	
	STA oam_page+0,Y
	LDA enemies_page,X
	CMP #$02
	BCC @lesser
	LDA #$02
@lesser
	ASL A
	CLC
	ADC #$14
	STA oam_page+1,Y
	LDA #$00
	STA oam_page+2,Y
	LDA #$20
	STA oam_page+3,Y
	INX
	CPX math_slot_0
	BNE @loop
	RTS

@blank
	; reached the end of the tunnel
	TXA
	SEC
	SBC enemies_position
	ASL A
	ASL A
	CLC
	ADC #$80
	TAY ; location in oam_page
	LDA #$EF
	STA oam_page+0,Y
	INX
	CPX math_slot_0
	BNE @blank
	RTS


; loads enemy phrase
enemies_phrase_load
	; top phrase
	LDX #$00
	LDY #$10
@loop1
	LDA battle_phrase_top,X
	STA string_array,Y
	INX
	INY
	CPX #$08
	BNE @loop1

	; bottom phrase
	LDX #$00
	LDY #$18
@loop2
	LDA battle_phrase_bottom,X
	STA string_array,Y
	INX
	INY
	CPX #$08
	BNE @loop2

	RTS

; just shown during double damage
enemies_phrase_double
	LDY #$00
@loop
	LDA enemies_phrase_double_data,Y
	STA string_array+16,Y
	INY
	CPY #$10
	BNE @loop
	RTS

enemies_phrase_double_data
	.BYTE __,_D,_O,_U,_B,_L,_E,__
	.BYTE __,_D,_A,_M,_A,_G,_E,__

; clears enemy phrase
enemies_phrase_clear
	; top phrase
	LDX #$00
	LDY #$10
	LDA #$30 ; space
@loop1
	STA string_array,Y
	INX
	INY
	CPX #$08
	BNE @loop1

	; bottom phrase
	LDX #$00
	LDY #$18
	LDA #$30 ; space
@loop2
	STA string_array,Y
	INX
	INY
	CPX #$08
	BNE @loop2

	RTS

; data to fill in portrait and battle information
; 8 bytes per enemy in each criteria
enemies_battle_data
	.WORD reward_data_0 ; portrait
	.BYTE $00,$10,$20 ; colors
	.BYTE $00 ; weakness
	.BYTE $00 ; attack
	.BYTE $40 ; multiplier

	.WORD portrait_data_0 ; portrait
	.BYTE $0F,$15,$20 ; colors
	.BYTE $02 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_1 ; portrait
	.BYTE $0F,$13,$20 ; colors
	.BYTE $03 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_2 ; portrait
	.BYTE $0F,$11,$20 ; colors
	.BYTE $04 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_3 ; portrait
	.BYTE $0F,$18,$20 ; colors
	.BYTE $05 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_4 ; portrait
	.BYTE $0F,$15,$20 ; colors
	.BYTE $02 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_0 ; portrait
	.BYTE $0F,$15,$20 ; colors
	.BYTE $02 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_0 ; portrait
	.BYTE $0F,$15,$20 ; colors
	.BYTE $02 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier


enemies_choice_data
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $01,$01,$00,$02,$01,$01,$00,$02
	.BYTE $01,$00,$02,$01,$01,$00,$02,$01
	.BYTE $00,$02,$01,$01,$00,$02,$01,$01
	.BYTE $01,$01,$02,$00,$01,$01,$02,$00
	.BYTE $01,$01,$00,$02,$01,$01,$00,$02
	.BYTE $01,$01,$00,$02,$01,$01,$00,$02
	.BYTE $01,$01,$00,$02,$01,$01,$00,$02

enemies_name_data
	.BYTE __,_R,_E,_W,_A,_R,_D,__
	.BYTE _S,_T,_E,_F,_A,_N,_I,__
	.BYTE _M,_I,_C,_H,_A,_E,_L,__
	.BYTE _N,_I,_C,_O,_L,_I,_N,_A
	.BYTE _W,_I,_L,_H,_E,_L,_M,__
	.BYTE _J,_E,_S,_S,_I,_C,_A,__
	.BYTE _S,_T,_E,_F,_A,_N,_I,__
	.BYTE _S,_T,_E,_F,_A,_N,_I,__

enemies_phrase_top_data
	.BYTE __,__,__,__,__,__,__,__
	.BYTE _Y,_O,_U,__,_M,_A,_K,_E
	.BYTE _T,_U,_R,_N,__,_A,_N,_D
	.BYTE _P,_R,_E,_P,_A,_R,_E,__
	.BYTE _T,_H,_E,__,_P,_A,_T,_H
	.BYTE _D,_O,_D,_G,_E,__,__,__
	.BYTE _Y,_O,_U,__,_M,_A,_K,_E
	.BYTE _Y,_O,_U,__,_M,_A,_K,_E

enemies_phrase_bottom_data
	.BYTE __,__,__,__,__,__,__,__
	.BYTE _M,_E,__,_A,_N,_G,_R,_Y
	.BYTE _L,_E,_A,_V,_E,_exclaim,__,__
	.BYTE _Y,_O,_U,_R,_S,_E,_L,_F
	.BYTE _E,_N,_D,_S,__,_N,_O,_W
	.BYTE _T,_H,_I,_S,_exclaim,__,__,__
	.BYTE _M,_E,__,_A,_N,_G,_R,_Y
	.BYTE _M,_E,__,_A,_N,_G,_R,_Y
	




