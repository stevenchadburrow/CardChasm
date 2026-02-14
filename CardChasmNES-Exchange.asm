
; exchange sub-routines for Card Chasm NES

exchange_setup
	; setup card sprites
	LDA #$00
	STA card_location
	JSR card_setup

	LDA #$0F
	STA background_color

	; draw font to pattern table
	LDA #$80
	STA string_location
	LDA #$00
	STA string_palette
	LDA background_color
	STA string_color1
	LDA #$10
	STA string_color2
	LDA #$20
	STA string_color3
	JSR string_setup

	; vertical alignment
	LDA #$04
	STA ppu_ctrl

	; draw font to name table
	LDA ppu_status
	LDA #$21
	STA ppu_addr
	LDA #$04
	STA ppu_addr
	LDA #$8D ; 'D'
	STA ppu_data
	LDA #$8E ; 'E'
	STA ppu_data
	LDA #$8C ; 'C'
	STA ppu_data
	LDA #$94 ; 'K'
	STA ppu_data
	LDA ppu_status
	LDA #$21
	STA ppu_addr
	LDA #$1B
	STA ppu_addr
	LDA #$9C ; 'S'
	STA ppu_data
	LDA #$92 ; 'I'
	STA ppu_data
	LDA #$8D ; 'D'
	STA ppu_data
	LDA #$8E ; 'E'
	STA ppu_data

	; horizontal alignment
	LDA #$00
	STA ppu_ctrl

	; draw arrow to pattern table #1
	LDA ppu_status
	LDA #$1C
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDA #>exchange_arrow_data
	STA grab_high
	LDA #<exchange_arrow_data
	STA grab_low
	LDX #$00
@pattern
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @increment
	INC grab_high
@increment
	INX
	CPX #$40
	BNE @pattern

	; draw arrow to name table
	LDA ppu_status
	LDA #$21
	STA ppu_addr
	LDA #$CE
	STA ppu_addr
	LDA #$C0
	STA ppu_data
	LDA #$C1
	STA ppu_data
	LDA #$C2
	STA ppu_data
	LDA #$C3
	STA ppu_data

	; selector sprite to pattern table
	LDA ppu_status
	LDA #$0F
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDA #<exchange_selector_data
	STA grab_low
	LDA #>exchange_selector_data
	STA grab_high	
	LDX #$00
@select1
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @select2
	INC grab_high
@select2
	INX
	CPX #$20
	BNE @select1

	; selector sprite oam setup
	LDX #$04
	LDA #$6B
	STA oam_page+0,X
	LDA #$FC
	STA oam_page+1,X
	LDA #$01
	STA oam_page+2,X
	LDA #$2C
	STA oam_page+3,X

	LDA #$00
	STA title_position
	STA title_timer
	STA exchange_position+0
	STA exchange_position+1

	RTS

exchange_selector_data
	.BYTE $80,$C0,$60,$30,$98,$CC,$66,$33,$80,$C0,$E0,$F0,$78,$3C,$1E,$0F
	.BYTE $33,$66,$CC,$98,$30,$60,$C0,$80,$0F,$1E,$3C,$78,$F0,$E0,$C0,$80

exchange_arrow_data
	.BYTE $19,$33,$66,$FF,$FF,$66,$33,$19,$1E,$3C,$78,$FF,$FF,$78,$3C,$1E
	.BYTE $80,$03,$00,$FF,$FF,$00,$03,$80,$00,$00,$0F,$FF,$FF,$0F,$00,$00
	.BYTE $01,$C0,$00,$FF,$FF,$00,$C0,$01,$00,$00,$F0,$FF,$FF,$F0,$00,$00
	.BYTE $98,$CC,$66,$FF,$FF,$66,$CC,$98,$78,$3C,$1E,$FF,$FF,$1E,$3C,$78

exchange_card_left
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

exchange_card_right
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

exchange_draw

	; enable rendering
	LDA #$18
	STA ppu_mask
	LDA #$B0 ; background on nametable #1
	STA ppu_ctrl

	; clear v-blank flag
	LDA #$00
	STA vblank_ready

exchange_draw_loop
	; wait for v-blank flag
	LDA vblank_ready
	BEQ exchange_draw_loop

	; clear v-blank flag
	LDA #$00
	STA vblank_ready

	; disable rendering
	LDA #$00
	STA ppu_mask

	; change card palettes
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA #$14
	STA ppu_addr
	LDX exchange_position+0
	LDA #$0F
	STA ppu_data	
	LDA card_deck_color,X
	STA ppu_data
	CLC
	ADC #$10
	STA ppu_data
	LDA #$20
	STA ppu_data
	LDX exchange_position+1
	LDA #$0F
	STA ppu_data	
	LDA card_deck_color,X ; TEMPORARY!
	STA ppu_data
	CLC
	ADC #$10
	STA ppu_data
	LDA #$20
	STA ppu_data

	; background on nametable #1
	LDA #$B0
	STA ppu_ctrl

	; adjust scroll position
	LDA ppu_status
	LDA #$00
	STA ppu_scroll
	LDA #$00
	STA ppu_scroll

	; trigger oam dma
	LDA #$02
	STA oam_dma

	; enable rendering
	LDA #$18
	STA ppu_mask

	; helps randomize
	JSR rand_func

	; check buttons
	JSR buttons
	LDX title_position
	LDA buttons_value
	AND #$40 ; B
	BEQ @button1
	LDA buttons_wait
	BNE @button1
	JMP exchange_draw_exit
@button1
	LDA buttons_value
	BNE @button2
	STA buttons_wait
@button2
	LDA buttons_wait
	BNE @button4
	LDA buttons_value
	AND #$08 ; up
	BEQ @button3
	LDA exchange_position,X
	BEQ @button3
	SEC
	SBC #$01
	STA exchange_position,X
	LDA #$01
	STA buttons_wait
@button3
	LDA buttons_value
	AND #$04 ; down
	BEQ @button4
	LDA exchange_position,X
	CPX #$00
	BEQ @button_check1
	CMP #$7F ; one less than max
	BEQ @button4
	BNE @button_check2
@button_check1
	CMP #$27 ; one less than max
	BEQ @button4
@button_check2
	CLC
	ADC #$01
	STA exchange_position,X
	LDA #$01
	STA buttons_wait
@button4
	LDA buttons_value
	AND #$02 ; left
	BEQ @button5
	LDA #$00
	STA title_position
@button5
	LDA buttons_value
	AND #$01 ; right
	BEQ @button6
	LDA #$01
	STA title_position
@button6

	; increment timer for animation purposes
	INC title_timer
	
	; draw left cards
	LDA exchange_position+0
	SEC
	SBC #$02
	TAX
	LDY #$00
@left_loop
	TYA
	ASL A
	ASL A
	ASL A
	STA math_slot_0
	ASL A
	CLC
	ADC math_slot_0
	CLC
	ADC #$08 ; add address plus 8
	STA card_address
	CPX #$28 ; 40 card max
	BCC @left_skip
	TXA
	PHA
	LDX card_address
	LDA #$FE
	STA oam_page+0,X
	STA oam_page+4,X
	STA oam_page+8,X
	STA oam_page+12,X
	STA oam_page+16,X
	STA oam_page+20,X
	PLA
	TAX
	JMP @left_increment
@left_skip
	SEC
	SBC #$00 ; remove address
	CLC
	ADC math_slot_0
	CLC
	ADC math_slot_0
	CLC
	ADC #$0A
	STA card_y
	LDA #$40
	STA card_x
	LDA exchange_palette_data,Y
	STA card_palette
	LDA card_deck_number,X
	STA card_top_number
	LDA card_deck_symbol,X
	STA card_top_symbol
	LDA card_deck_movement,X
	STA card_bottom_number
	LDA #$08
	STA card_bottom_symbol
	TXA
	PHA
	JSR exchange_card_left
	PLA
	TAX
@left_increment
	INX
	INY
	CPY #$05
	BNE @left_loop

	; draw right cards
	LDA exchange_position+1
	SEC
	SBC #$02
	TAX
	LDY #$00
@right_loop
	TYA
	ASL A
	ASL A
	ASL A
	STA math_slot_0
	ASL A
	CLC
	ADC math_slot_0
	CLC
	ADC #$88 ; add address plus 8
	STA card_address
	CPX #$80 ; 128 card max
	BCC @right_skip
	TXA
	PHA
	LDX card_address
	LDA #$FE
	STA oam_page+0,X
	STA oam_page+4,X
	STA oam_page+8,X
	STA oam_page+12,X
	STA oam_page+16,X
	STA oam_page+20,X
	PLA
	TAX
	JMP @right_increment
@right_skip
	SEC
	SBC #$80 ; remove address
	CLC
	ADC math_slot_0
	CLC
	ADC math_slot_0
	CLC
	ADC #$0A
	STA card_y
	LDA #$A8
	STA card_x
	LDA exchange_palette_data,Y
	ASL A
	STA card_palette
	LDA card_deck_number,X ; TEMPORARY!
	STA card_top_number
	LDA card_deck_symbol,X ; TEMPORARY!
	STA card_top_symbol
	LDA card_deck_movement,X ; TEMPORARY!
	STA card_bottom_number
	LDA #$08
	STA card_bottom_symbol
	TXA
	PHA
	JSR exchange_card_right
	PLA
	TAX
@right_increment
	INX
	INY
	CPY #$05
	BNE @right_loop

	; selector sprite oam setup
	LDX #$04
	LDA title_position
	BNE @selector1
	LDA #$6B
	STA oam_page+0,X
	LDA #$FC
	STA oam_page+1,X
	LDA #$00
	STA oam_page+2,X
	LDA title_timer
	AND #$1C
	LSR A
	LSR A
	CLC
	ADC #$2C
	STA oam_page+3,X
	BNE @selector2
@selector1
	LDA #$6B
	STA oam_page+0,X
	LDA #$FC
	STA oam_page+1,X
	LDA #$40
	STA oam_page+2,X
	LDA title_timer
	AND #$1C
	LSR A
	LSR A
	STA math_slot_0
	LDA #$CC
	SEC
	SBC math_slot_0
	STA oam_page+3,X
@selector2

	JMP exchange_draw_loop

exchange_draw_exit
	RTS

exchange_palette_data
	.BYTE $00,$00,$01,$00,$00



