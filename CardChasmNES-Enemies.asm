
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
	.WORD portrait_data_0 ; portrait
	.BYTE $0F,$15,$20 ; colors
	.BYTE $04 ; weakness
	.BYTE $0A ; attack
	.BYTE $0A ; multiplier

	.WORD portrait_data_1 ; portrait
	.BYTE $0F,$13,$20 ; colors
	.BYTE $02 ; weakness
	.BYTE $08 ; attack
	.BYTE $0C ; multiplier

enemies_choice_data
	.BYTE $01,$01,$00,$01,$01,$01,$00,$01
	.BYTE $01,$00,$01,$01,$01,$00,$01,$01

enemies_name_data
	.BYTE _S,_T,_E,_F,_A,_N,_I,__
	.BYTE _J,_U,_D,_I,_T,_H,__,__

enemies_phrase_top_data
	.BYTE _S,_T,_A,_Y,__,_F,_A,_R
	.BYTE _U,_H,_H,_exclaim,__,_Y,_O,_U,__

enemies_phrase_bottom_data
	.BYTE _F,_R,_O,_M,__,_M,_E,_exclaim
	.BYTE _A,_R,_E,__,_U,_G,_L,_Y
	





