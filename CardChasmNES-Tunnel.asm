
; tunnel sub-routines for Card Chasm NES, goes in last bank

; run once before drawing
tunnel_setup
	; setup tunnel tiles
	LDA #$00
	STA grab_low
	LDA #>tunnel_data_0
	STA grab_high
	LDA ppu_status
	LDA tunnel_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$10
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDY #$04
	LDX #$00
@tunnel_loop
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @tunnel_check
	INC grab_high
@tunnel_check
	INX
	BNE @tunnel_loop
	DEY
	BNE @tunnel_loop
	
	; setup tunnel palettes
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA tunnel_ceiling_palette
	ASL A
	ASL A
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA tunnel_ceiling_color1
	STA ppu_data
	LDA tunnel_ceiling_color2
	STA ppu_data
	LDA tunnel_ceiling_color3
	STA ppu_data

	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA tunnel_floor_palette
	ASL A
	ASL A
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA tunnel_floor_color1
	STA ppu_data
	LDA tunnel_floor_color2
	STA ppu_data
	LDA tunnel_floor_color3
	STA ppu_data

	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA tunnel_hud_palette
	ASL A
	ASL A
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA tunnel_hud_color1
	STA ppu_data
	LDA tunnel_hud_color2
	STA ppu_data
	LDA tunnel_hud_color3
	STA ppu_data

	RTS

; draws tunnel to one name table
tunnel_draw
	LDA #$00
	STA grab_low
	LDA #>tunnel_draw_name_data
	STA grab_high

	LDA ppu_status
	LDA tunnel_table
	STA ppu_addr
	LDA #$00
	STA ppu_addr

	LDA tunnel_top
	BNE tunnel_draw_closed
	JMP tunnel_draw_open	

; does have a ceiling
tunnel_draw_closed
	LDX #$80
@loop1
	JSR grab_func
	CLC
	ADC tunnel_location
	STA ppu_data
	INC grab_low
	DEX
	BNE @loop1
	
	LDY #$06
@loop2
	LDX #$40
@loop3
	JSR grab_func
	CMP #$FF
	BEQ @skip1
	CLC
	ADC tunnel_location
@skip1
	STA ppu_data
	INC grab_low
	DEX
	BNE @loop3
	LDA grab_low
	SEC
	SBC #$40
	STA grab_low
	DEY
	BNE @loop2
	LDA grab_low
	CLC
	ADC #$40
	STA grab_low

	LDX #$00
@loop4
	JSR grab_func
	CLC
	ADC tunnel_location
	STA ppu_data
	INC grab_low
	BNE @skip2
	INC grab_high
@skip2
	INX
	BNE @loop4
	
	LDX #$80
	LDA #$FF
@loop5
	STA ppu_data
	DEX
	BNE @loop5

	LDA tunnel_location
	ASL A
	EOR #$FF
	STA math_slot_0
	LDX #$40
@loop6
	JSR grab_func
	CLC
	ADC tunnel_location
	AND math_slot_0
	CLC
	ADC #$20
	STA ppu_data
	INC grab_low
	DEX
	BNE @loop6

	JMP tunnel_draw_attr

; doesn't have a ceiling
tunnel_draw_open
	LDA grab_low
	CLC
	ADC #$80
	STA grab_low

	LDY #$08
@loop1
	LDX #$40
@loop2
	JSR grab_func
	CMP #$FF
	BEQ @skip1
	CLC
	ADC tunnel_location
@skip1
	STA ppu_data
	INC grab_low
	DEX
	BNE @loop2
	LDA grab_low
	SEC
	SBC #$40
	STA grab_low
	DEY
	BNE @loop1
	LDA grab_low
	CLC
	ADC #$40
	STA grab_low

	LDX #$00
@loop3
	JSR grab_func
	CLC
	ADC tunnel_location
	STA ppu_data
	INC grab_low
	BNE @skip2
	INC grab_high
@skip2
	INX
	BNE @loop3
	
	LDX #$80
	LDA #$FF
@loop4
	STA ppu_data
	DEX
	BNE @loop4

	LDA #$80
	STA grab_low
	LDA #>tunnel_draw_name_data
	STA grab_high

	LDA tunnel_location
	ASL A
	EOR #$FF
	STA math_slot_0
	LDY #$01
@loop5
	LDX #$40
@loop6
	JSR grab_func
	CMP #$FF
	BEQ @skip3
	CLC
	ADC tunnel_location
	AND math_slot_0
	CLC
	ADC #$20
@skip3
	STA ppu_data
	INC grab_low
	DEX
	BNE @loop6
	LDA grab_low
	SEC
	SBC #$40
	STA grab_low
	DEY
	BNE @loop5
	LDA grab_low
	CLC
	ADC #$40
	STA grab_low

tunnel_draw_attr
	LDA tunnel_ceiling_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA math_slot_0
	LDA tunnel_ceiling_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ORA math_slot_0
	STA math_slot_0
	LDA tunnel_ceiling_palette
	ASL A
	ASL A
	ORA math_slot_0
	ORA tunnel_ceiling_palette
	STA math_slot_0

	LDA tunnel_floor_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA math_slot_1
	LDA tunnel_floor_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ORA math_slot_1
	STA math_slot_1
	LDA tunnel_floor_palette
	ASL A
	ASL A
	ORA math_slot_1
	ORA tunnel_floor_palette
	STA math_slot_1

	LDA tunnel_hud_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA math_slot_2
	LDA tunnel_hud_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ORA math_slot_2
	STA math_slot_2
	LDA tunnel_hud_palette
	ASL A
	ASL A
	ORA math_slot_2
	ORA tunnel_hud_palette
	STA math_slot_2

	LDA ppu_status
	LDA tunnel_table
	CLC
	ADC #$03
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDX #$20
	LDA math_slot_0
@loop1
	STA ppu_data
	DEX
	BNE @loop1
	LDX #$10
	LDA math_slot_1
@loop2
	STA ppu_data
	DEX
	BNE @loop2
	LDX #$08
	LDA math_slot_2
@loop3
	STA ppu_data
	DEX
	BNE @loop3
	LDX #$08
	LDA math_slot_0
@loop4
	STA ppu_data
	DEX
	BNE @loop4
	
	RTS

; tunnel initial position
tunnel_still
	LDA #$E0
	STA tunnel_scroll
	LDA #$01
	STA tunnel_direction
	LDA #$02
	STA tunnel_name
	LDA #$00
	STA tunnel_movement
	RTS

; update walk animation
tunnel_walk
	LDA tunnel_movement
	BEQ @skip

	LDA tunnel_direction
	BEQ @down
	INC tunnel_scroll
	LDA tunnel_scroll
	CMP #$EF
	BEQ @turn
	JMP @skip
@down
	DEC tunnel_scroll
	LDA tunnel_scroll
	CMP #$E0
	BEQ @turn
	JMP @skip
@turn
	LDA tunnel_name
	EOR #$FF
	AND #$02
	STA tunnel_name
	LDA tunnel_direction
	EOR #$FF
	AND #$01
	STA tunnel_direction
	CMP #$01
	BNE @skip
	INC enemies_position
	DEC tunnel_movement
@skip
	RTS

