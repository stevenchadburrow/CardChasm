
; string sub-routines for Card Chasm NES, goes in last bank


; run once before drawing
string_setup
	; setup string font on top of name table #0
	LDA #$00
	STA grab_low
	LDA #>font_data_0
	STA grab_high
	LDA ppu_status
	LDA string_location
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
@string_loop
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @string_check
	INC grab_high
@string_check
	INX
	BNE @string_loop
	DEY
	BNE @string_loop

	; setup string palette
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA string_palette
	ASL A
	ASL A
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA string_color1
	STA ppu_data
	LDA string_color2
	STA ppu_data
	LDA string_color3
	STA ppu_data

	; get correct attribute value
	LDA string_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA math_slot_0
	LDA string_palette
	ASL A
	ASL A
	ASL A
	ASL A
	ORA math_slot_0
	STA math_slot_0
	LDA string_palette
	ASL A
	ASL A
	ORA math_slot_0
	ORA string_palette
	STA math_slot_0

	; change attribute table above portrait
	LDA ppu_status
	LDA #$23
	STA ppu_addr
	LDA #$CB
	STA ppu_addr
	LDA math_slot_0
	STA ppu_data
	STA ppu_data

	; change attribute table in hud
	LDA ppu_status
	LDA #$23
	STA ppu_addr
	LDA #$F0
	STA ppu_addr
	LDA math_slot_0
	STA ppu_data
	STA ppu_data
	STA ppu_data
	STA ppu_data
	STA ppu_data
	STA ppu_data
	STA ppu_data
	STA ppu_data	

	RTS

string_draw
	; only draw title when not drawing portrait
	LDA portrait_progress
	BEQ @ready	
	RTS
@ready
	LDA string_counter
	CLC
	ADC #$01
	AND #$03
	STA string_counter
	BNE @sub1
	JMP string_draw_portrait
@sub1
	JMP string_draw_hud

string_draw_portrait
	; 4 lines of 8 tiles each above portrait
	LDA #$20
	STA math_slot_0
	LDA #$8C
	STA math_slot_1
	LDX #$00
	LDY #$04
@name_loop
	LDA ppu_status
	LDA math_slot_0
	STA ppu_addr
	LDA math_slot_1
	STA ppu_addr
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA string_array,X
	INX
	STA ppu_data
	LDA math_slot_1
	CLC
	ADC #$20
	STA math_slot_1
	DEY
	BNE @name_loop
	RTS

string_draw_hud
	; 3 lines of 32 tiles each in hud
	LDA string_counter
	SEC
	SBC #$01
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$20
	TAX
	LDY #$20
	LDA ppu_status
	LDA #$23
	STA ppu_addr
	TXA
	STA ppu_addr
@name_loop
	LDA string_array,X
	STA ppu_data
	INX
	DEY
	BNE @name_loop
	RTS


; run once before drawing
bar_setup
	LDA ppu_status
	LDA bar_location
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$10
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDX #$00
@loop
	LDA bar_setup_data,X
	STA ppu_data
	INX
	CPX #$A0
	BNE @loop
	RTS

bar_setup_data
	.BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $FF,$7F,$7F,$7F,$7F,$7F,$7F,$FF,$00,$80,$80,$80,$80,$80,$80,$00
	.BYTE $FF,$BF,$3F,$3F,$3F,$3F,$BF,$FF,$00,$C0,$C0,$C0,$C0,$C0,$C0,$00
	.BYTE $FF,$DF,$1F,$1F,$1F,$1F,$DF,$FF,$00,$E0,$E0,$E0,$E0,$E0,$E0,$00
	.BYTE $FF,$EF,$0F,$0F,$0F,$0F,$EF,$FF,$00,$F0,$F0,$F0,$F0,$F0,$F0,$00
	.BYTE $FF,$F7,$07,$07,$07,$07,$F7,$FF,$00,$F8,$F8,$F8,$F8,$F8,$F8,$00
	.BYTE $FF,$FB,$03,$03,$03,$03,$FB,$FF,$00,$FC,$FC,$FC,$FC,$FC,$FC,$00
	.BYTE $FF,$FD,$01,$01,$01,$01,$FD,$FF,$00,$FE,$FE,$FE,$FE,$FE,$FE,$00
	.BYTE $FF,$FE,$00,$00,$00,$00,$FE,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$00
	.BYTE $FF,$FF,$00,$00,$00,$00,$FF,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$00

; draw enemy health bar in portrait title
bar_draw
	LDA #$08
	STA math_slot_0
	LDX bar_position
	LDY #$00
@loop1
	LDA bar_value
	CMP math_slot_0
	BEQ @equal
	BCS @more
	
@less
	LDA bar_value
	CLC
	ADC #$08
	SEC
	SBC math_slot_0
	CLC
	ADC bar_location
	STA string_array,X
	INX
	INY
	JMP @last
	
@equal
	LDA bar_location
	CLC
	ADC #$08
	STA string_array,X
	INX
	INY
	BNE @last

@more
	LDA bar_location
	CLC
	ADC #$09
	STA string_array,X
	LDA math_slot_0
	CLC
	ADC #$08
	STA math_slot_0
	INX
	INY
	CPY bar_length
	BNE @loop1
	BEQ @exit

@last
	CPY bar_length
	BCS @exit
	LDA bar_location
	STA string_array,X
	INX
	INY
	BNE @last

@exit
	RTS


; calls 'bar_draw'
bar_show
	; enemy health bar
	LDA #$08
	STA bar_position
	LDA #$08
	STA bar_length
	LDA battle_enemy_health
	STA bar_value
	JSR bar_draw

	; player health bar
	LDA #$29
	STA bar_position
	LDA #$10
	STA bar_length
	LDA battle_player_health
	STA bar_value
	JSR bar_draw
	
	; player exit counter
	LDA #$49
	STA bar_position
	LDA #$10
	STA bar_length
	LDA exit_counter
	STA bar_value
	JSR bar_draw

	RTS


; converts value into separate digits of base 10
dec_func
	TXA
	PHA
	LDA #$00 ; always zero
	STA dec_array+0 ; thousands position
	LDA dec_value
	LDX #$00
@sub1
	SEC
	SBC #$64 ; hundred
	BCC @sub2
	INX
	BNE @sub1
@sub2
	CLC
	ADC #$64
	STX dec_array+1 ; hundreds position
	LDX #$00
@sub3
	SEC
	SBC #$0A ; ten
	BCC @sub4
	INX
	BNE @sub3
@sub4
	CLC
	ADC #$0A
	STX dec_array+2 ; tens position
	STA dec_array+3 ; ones position
	PLA
	TAX
	RTS



