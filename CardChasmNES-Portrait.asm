
; portrait sub-routines for Card Chasm NES, goes in last bank


; draws a portrait (auto setup included)
portrait_draw
	; decide where to go
	LDA portrait_progress
	BNE @sub1
	RTS
@sub1
	CMP #$01
	BNE @sub2
	INC portrait_progress ; do nothing
	RTS
@sub2	
	CMP #$12
	BCS @sub3
	JMP portrait_draw_pattern
@sub3
	CMP #$12
	BNE @sub4
	JMP portrait_draw_palette
@sub4
	CMP #$13
	BNE @sub5
	JMP portrait_draw_attribute
@sub5
	CMP #$14
	BNE @sub6
	JMP portrait_draw_name
@sub6
	LDA #$00 ; stop drawing portrait
	STA portrait_progress
	RTS

portrait_draw_pattern
	; fill in pattern table #1
	LDA portrait_progress
	SEC
	SBC #$02
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA grab_low
	LDA portrait_progress
	SEC
	SBC #$02
	LSR A
	LSR A
	CLC
	ADC portrait_address
	STA grab_high
	LDA ppu_status
	LDA portrait_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$10
	STA math_slot_0
	LDA portrait_progress
	SEC
	SBC #$02
	LSR A
	LSR A
	CLC
	ADC math_slot_0
	STA ppu_addr
	LDA portrait_progress
	SEC
	SBC #$02
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA ppu_addr
	LDX #$40
@patt_loop
	JSR grab_func
	AND portrait_filter
	STA ppu_data
	INC grab_low
	BNE @patt_increment
	INC grab_high
@patt_increment
	DEX
	BNE @patt_loop

	INC portrait_progress
	RTS

portrait_draw_palette
	; fill palette for portrait
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA portrait_palette
	ASL A
	ASL A
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA portrait_color1
	STA ppu_data
	LDA portrait_color2
	STA ppu_data
	LDA portrait_color3
	STA ppu_data

	INC portrait_progress
	RTS

portrait_draw_attribute
	; fill in attribute table
	LDA #$23
	STA math_slot_0
	LDA portrait_x
	LSR A
	LSR A
	CLC
	ADC #$C0
	STA math_slot_1
	LDA portrait_y
	ASL A
	CLC
	ADC math_slot_1
	STA math_slot_1
	LDX #$02
@attr_loop
	LDA ppu_status
	LDA math_slot_0
	STA ppu_addr
	LDA math_slot_1
	STA ppu_addr
	LDY portrait_palette
	LDA portrait_draw_data,Y
	STA ppu_data
	STA ppu_data
	LDA math_slot_1
	CLC
	ADC #$08
	STA math_slot_1
	DEX
	BNE @attr_loop

	INC portrait_progress
	RTS

portrait_draw_name
	; fill in name table
	LDA portrait_y
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$20
	STA math_slot_0
	LDA portrait_x
	STA math_slot_1
	LDA portrait_y
	AND #$07
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC math_slot_1
	STA math_slot_1
	LDX portrait_location
	LDY #$08
@name_loop
	LDA ppu_status
	LDA math_slot_0
	STA ppu_addr
	LDA math_slot_1
	STA ppu_addr
	STX ppu_data
	INX
	STX ppu_data
	INX
	STX ppu_data
	INX
	STX ppu_data
	INX
	STX ppu_data
	INX
	STX ppu_data
	INX
	STX ppu_data
	INX
	STX ppu_data
	INX
	LDA math_slot_1
	CLC
	ADC #$20
	STA math_slot_1
	BCC @name_check
	INC math_slot_0
@name_check
	DEY
	BNE @name_loop

	INC portrait_progress
	RTS

portrait_draw_data
	.BYTE $00,$55,$AA,$FF
