
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
