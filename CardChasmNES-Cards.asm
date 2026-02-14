
; interface sub-routines for Card Chasm NES, goes in last bank


; run once before drawing
card_setup
; setup card font on top of name table #0
; numbers on top
card_setup_numbers_top
	LDA #$00
	STA grab_low
	LDA #>font_data_0
	STA grab_high
	LDA ppu_status
	LDA card_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$00
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDY #$0A
@card_loop1
	LDX #$10
@card_loop2
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @card_loop2
	LDX #$08
@card_loop3
	LDA #$FF
	STA ppu_data
	DEX
	BNE @card_loop3
	LDX #$08
@card_loop4
	LDA #$00
	STA ppu_data
	DEX
	BNE @card_loop4
	DEY
	BNE @card_loop1

; numbers on bottom
card_setup_numbers_bottom
	LDA #$00
	STA grab_low
	LDA #>font_data_0
	STA grab_high
	LDA ppu_status
	LDA card_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$02
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDY #$0A
@card_loop1
	LDX #$08
@card_loop2
	LDA #$FF
	STA ppu_data
	DEX
	BNE @card_loop2
	LDX #$08
@card_loop3
	LDA #$00
	STA ppu_data
	DEX
	BNE @card_loop3
	LDX #$10
@card_loop4
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @card_loop4
	DEY
	BNE @card_loop1

; symbols on top
card_setup_symbols_top
	LDA #$10
	STA grab_low
	LDA #>font_data_0
	CLC
	ADC #$03
	STA grab_high
	LDA ppu_status
	LDA card_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$04
	STA ppu_addr
	LDA #$40
	STA ppu_addr
	LDY #$06
@card_loop1
	LDX #$10
@card_loop2
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @card_loop2
	LDX #$08
@card_loop3
	LDA #$FF
	STA ppu_data
	DEX
	BNE @card_loop3
	LDX #$08
@card_loop4
	LDA #$00
	STA ppu_data
	DEX
	BNE @card_loop4
	DEY
	BNE @card_loop1

; symbols on bottom
card_setup_symbols_bottom
	LDA #$70
	STA grab_low
	LDA #>font_data_0
	CLC
	ADC #$03
	STA grab_high
	LDA ppu_status
	LDA card_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$05
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDY #$01
@card_loop1
	LDX #$08
@card_loop2
	LDA #$FF
	STA ppu_data
	DEX
	BNE @card_loop2
	LDX #$08
@card_loop3
	LDA #$00
	STA ppu_data
	DEX
	BNE @card_loop3
	LDX #$10
@card_loop4
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @card_loop4
	DEY
	BNE @card_loop1

	; last tile blank
	LDY #$02
@card_blank0
	LDX #$08
	LDA #$FF
@card_blank1
	STA ppu_data
	DEX
	BNE @card_blank1
	LDX #$08
	LDA #$00
@card_blank2
	STA ppu_data
	DEX
	BNE @card_blank2
	DEY
	BNE @card_blank0

; corners (on top)
card_setup_corners_top
	LDA #$80
	STA grab_low
	LDA #>font_data_0
	CLC
	ADC #$03
	STA grab_high
	LDA ppu_status
	LDA card_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$04
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDX #$20
@card_loop1
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @card_loop1

; corners (on bottom)
card_setup_corners_bottom
	LDA #$A0
	STA grab_low
	LDA #>font_data_0
	CLC
	ADC #$03
	STA grab_high
	LDA ppu_status
	LDA card_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$04
	STA ppu_addr
	LDA #$20
	STA ppu_addr
	LDX #$20
@card_loop1
	JSR grab_func
	STA ppu_data
	INC grab_low
	DEX
	BNE @card_loop1
	
	RTS

; draw one card in sprites
card_draw
	; adjust palette
	LDA card_palette
	ASL A
	ASL A
	TAX
	LDA #$0F ; transparent
	STA card_palette_array,X
	INX
	LDA card_color1
	STA card_palette_array,X
	INX
	LDA card_color2
	STA card_palette_array,X
	INX
	LDA card_color3
	STA card_palette_array,X
	INX

	LDA battle_enemy_health
	BNE @battle	

@move
	; adjust oam
	LDX card_address ; location in oam
	LDA card_y ; y-value
	STA oam_page+0,X
	STA oam_page+4,X
	STA oam_page+8,X
	CLC
	ADC #$10
	STA oam_page+12,X
	STA oam_page+16,X
	STA oam_page+20,X
	LDA card_location
	CLC
	ADC #$40
	STA oam_page+1,X
	LDA card_top_symbol
	ASL A
	CLC
	ADC #$40
	STA oam_page+5,X
	LDA card_top_number
	ASL A
	CLC
	ADC #$00
	STA oam_page+9,X
	LDA card_bottom_number
	ASL A
	CLC
	ADC #$20	
	STA oam_page+13,X
	LDA card_bottom_symbol
	ASL A
	CLC
	ADC #$40
	STA oam_page+17,X
	LDA card_location
	CLC
	ADC #$42
	STA oam_page+21,X
	LDA card_palette
	STA oam_page+2,X
	STA oam_page+6,X
	STA oam_page+10,X
	STA oam_page+14,X
	STA oam_page+18,X
	STA oam_page+22,X
	LDA card_x
	STA oam_page+3,X
	STA oam_page+15,X
	CLC
	ADC #$08
	STA oam_page+7,X
	STA oam_page+19,X
	CLC
	ADC #$08
	STA oam_page+11,X
	STA oam_page+23,X

	RTS

@battle
	; adjust oam
	LDX card_address ; location in oam
	LDA card_y ; y-value
	STA oam_page+0,X
	STA oam_page+4,X
	STA oam_page+8,X
	CLC
	ADC #$10
	STA oam_page+12,X
	STA oam_page+16,X
	STA oam_page+20,X
	LDA card_location
	CLC
	ADC #$40
	STA oam_page+1,X
	LDA card_top_symbol
	ASL A
	CLC
	ADC #$40
	STA oam_page+5,X
	LDA card_top_number
	ASL A
	CLC
	ADC #$00
	STA oam_page+9,X
	LDA card_bottom_number
	ASL A
	CLC
	ADC #$20	
	STA oam_page+13,X
	LDA card_bottom_symbol
	ASL A
	CLC
	ADC #$40
	STA oam_page+17,X
	LDA card_location
	CLC
	ADC #$42
	STA oam_page+21,X
	LDA card_palette
	STA oam_page+6,X
	STA oam_page+10,X
	STA oam_page+14,X
	STA oam_page+18,X
	ORA #$40
	STA oam_page+2,X
	STA oam_page+22,X
	LDA card_x
	STA oam_page+11,X
	STA oam_page+23,X
	CLC
	ADC #$08
	STA oam_page+7,X
	STA oam_page+19,X
	CLC
	ADC #$08
	STA oam_page+3,X
	STA oam_page+15,X

	RTS


; runs 'card_draw' from deck information
card_show
	LDY #$00
@loop
	LDX card_hand_array,Y
	LDA card_show_data,Y
	STA card_address ; $18 of oam space each
	CPX #$FF
	BEQ @blank
	LDA #$D8
	STA card_x
	TYA
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA math_slot_0
	TYA
	ASL A
	ASL A
	ASL A
	CLC
	ADC math_slot_0
	CLC
	ADC #$10
	CPY selector_position
	BCC @height
	CLC
	ADC card_shift_timer
@height
	STA card_y

	STY card_palette
	LDA card_deck_color,X
	STA card_color1
	CLC
	ADC #$10
	STA card_color2
	LDA #$20
	STA card_color3
	LDA card_deck_number,X
	STA card_top_number
	LDA card_deck_symbol,X
	STA card_top_symbol
	LDA card_deck_movement,X
	STA card_bottom_number
	LDA #$08
	STA card_bottom_symbol
@ready
	TXA
	PHA
	JSR card_draw
	PLA
	TAX
@increment
	INY
	CPY #$04
	BNE @loop
	RTS
@blank
	LDA #$EF
	STA card_y
	BNE @ready
	
card_show_data
	.BYTE $20,$38,$50,$68


; select card to move
card_shift
	LDA card_shift_timer
	BEQ @exit
	CMP #$FF
	BEQ @shift

	; decrement timer value		
	LDA card_shift_timer
	SEC
	SBC #$02
	STA card_shift_timer
	JMP @exit

@shift
	; change timer value
	LDA #$28 ; time to shift
	STA card_shift_timer

	; shift all cards up
	LDX selector_position
	LDY selector_position
	INY
@loop
	LDA card_hand_array,Y
	STA card_hand_array,X
	INX
	INY
	CPX #$04
	BNE @loop
	
	; last card now empty
	LDA #$FF
	STA card_hand_array+3

	; get 3 more cards when near empty
	LDA card_hand_array+1
	CMP #$FF
	BNE @exit
	
	; get cards from deck here
	JSR card_transfer

@exit
	RTS


; transfer 3 cards from library to hand
card_transfer
	LDA card_deck_position
	CMP #$28 ; 40 cards in deck
	BCC @skip
	JSR card_shuffle
@skip
	LDX card_deck_position
	LDA card_deck_array+0,X
	STA card_hand_array+1
	LDA card_deck_array+1,X
	STA card_hand_array+2
	LDA card_deck_array+2,X
	STA card_hand_array+3
	LDA card_deck_position
	CLC
	ADC #$03
	STA card_deck_position
	RTS 


; shuffle cards back into deck
card_shuffle
	; swap card around
	LDX #$00
	JSR rand_func
	TAY
	LDA random_value_data,Y
	TAY
@loop
	INY
	LDA random_value_data,Y
	CMP #$28 ; 40 cards in deck
	BCS @loop
	STY math_slot_0
	TAY
	LDA card_deck_array,X
	STA math_slot_1
	LDA card_deck_array,Y
	STA card_deck_array,X
	LDA math_slot_1
	STA card_deck_array,Y
	LDY math_slot_0
	INX
	CPX #$28
	BNE @loop
	
	; starting position
	LDA #$01
	STA card_deck_position
	RTS


; load deck from PRG-RAM
card_deck_load
	; transfer cards to deck
	LDX #$00
	LDY #$00
@loop
	LDA #$00 ; type (unused)
	STA card_deck_type,X
	LDA save_deck,Y
	AND #$0F
	STA card_deck_number,X
	LDA save_deck,Y
	INY
	LSR A
	LSR A
	LSR A
	LSR A
	STA math_slot_0
	CLC
	ADC #$02
	STA card_deck_symbol,X
	TYA
	PHA
	LDY math_slot_0
	LDA card_color_data,Y
	STA card_deck_color,X
	PLA
	TAY
	LDA save_deck,Y
	INY
	AND #$0F
	STA card_deck_movement,X
	INX
	CPX #$28 ; 40 cards in deck
	BNE @loop
	RTS

; load sideboard from PRG-RAM
card_side_load
	; transfer cards to sideboard
	LDX #$00
	LDY #$00
@loop
	LDA save_side,Y
	AND #$0F
	STA card_side_number,X
	LDA save_side,Y
	INY
	LSR A
	LSR A
	LSR A
	LSR A
	STA math_slot_0
	CLC
	ADC #$02
	STA card_side_symbol,X
	TYA
	PHA
	LDY math_slot_0
	LDA card_color_data,Y
	STA card_side_color,X
	PLA
	TAY
	LDA save_side,Y
	INY
	AND #$0F
	STA card_side_movement,X
	INX
	CPX #$40 ; 64 cards in sideboard
	BNE @loop
	RTS

card_color_data
	; colors associated with each card symbol
	.BYTE $1A,$16,$28,$22,$13,$25

; save deck to PRG-RAM
card_deck_save
	; transfer cards for deck
	LDX #$00
	LDY #$00
@loop
	LDA card_deck_number,X
	AND #$0F
	STA math_slot_0
	LDA card_deck_symbol,X
	AND #$0F
	ASL A
	ASL A
	ASL A
	ASL A
	ORA math_slot_0	
	STA save_deck,Y
	INY	
	LDA card_deck_movement,X
	AND #$0F
	STA save_deck,Y
	INY
	INX
	CPX #$28 ; 40 cards in deck
	BNE @loop
	RTS

; save sideboard to PRG-RAM
card_side_save
	; transfer cards for sideboard
	LDX #$00
	LDY #$00
@loop
	LDA card_side_number,X
	BEQ @zero
	LDA card_side_movement,X
	BEQ @zero
	LDA card_side_number,X
	AND #$0F
	STA math_slot_0
	LDA card_side_symbol,X
	AND #$0F
	ASL A
	ASL A
	ASL A
	ASL A
	ORA math_slot_0	
	STA save_side,Y
	INY	
	LDA card_side_movement,X
	AND #$0F
	STA save_side,Y
	INY
	INX
	CPX #$40 ; 64 cards in sideboard
	BNE @loop
@zero
	LDA #$00
	STA save_side,Y
	INY
	STA save_side,Y
	INY
	INX
	CPX #$40 ; 64 cards in sideboard
	BNE @loop
	RTS


