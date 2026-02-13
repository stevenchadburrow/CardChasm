
; title sub-routines for Card Chasm NES

title_setup
	; disable rendering
	LDA #$00
	STA ppu_ctrl
	LDA #$00
	STA ppu_mask

	; clear name table with zeros
	LDA ppu_status
	LDA #$20
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDY #$04
	LDX #$00
	LDA #$FE ; blank tile (from top half of sprite zero)
@clear
	STA ppu_data
	INX
	BNE @clear
	DEY
	BNE @clear

	; change to bank #1
	LDA #$01
	STA $C000
	
	; draw title to pattern table #1
	LDA ppu_status
	LDA #$10
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDA #$80
	STA grab_high
	LDA #$00
	STA grab_low
	LDX #$00
	LDY #$00
@pattern
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @increment1
	INC grab_high
@increment1
	INX
	BNE @increment2
	INY
@increment2
	CPY #$10
	BNE @pattern

	; change to bank #0
	LDA #$00
	STA $C000

	; draw font to pattern table #0
	LDA #$00
	STA grab_low
	LDA #>font_data_0
	STA grab_high
	LDA ppu_status
	LDA #$00
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

	; setup nametable for title
	LDA ppu_status
	LDA #$20
	STA ppu_addr
	LDA #$40
	STA ppu_addr
	LDX #$00
@name
	STX ppu_data
	INX
	BNE @name

	; setup nametable for font
	LDY #$00
	LDX #$00
@font1
	LDA ppu_status
	LDA #$22
	STA ppu_addr
	TYA
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$06 ; horizontal shift
	STA ppu_addr
@font2
	LDA title_string_data,X
	STA ppu_data
	TXA
	INX
	AND #$07
	CMP #$07
	BNE @font2
@font3
	INY
	CPY #$04
	BNE @font1
	
	; setup attribute table
	LDA ppu_status
	LDA #$23
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDX #$10
	LDA #$00
@attribute1
	STA ppu_data
	DEX
	BNE @attribute1
	LDX #$30
	LDA #$55
@attribute2
	STA ppu_data
	DEX
	BNE @attribute2

	; setup background palettes
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA #$00
	STA ppu_data
	LDA #$10
	STA ppu_data
	LDA #$20
	STA ppu_data
	LDA #$0F
	STA ppu_data
	LDA #$0F
	STA ppu_data
	LDA #$10
	STA ppu_data
	LDA #$20
	STA ppu_data

	; setup sprite palettes
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA #$10
	STA ppu_addr
	LDA #$0F ; backgound color
	STA ppu_data
	LDA #$00
	STA ppu_data
	LDA #$10
	STA ppu_data
	LDA #$20
	STA ppu_data
	LDA #$0F 
	STA ppu_data
	LDA #$06
	STA ppu_data
	LDA #$16
	STA ppu_data
	LDA #$26
	STA ppu_data

	; sprite zero copy to pattern table
	LDA ppu_status
	LDA #$0F
	STA ppu_addr
	LDA #$E0
	STA ppu_addr
	LDA #<title_zero_data
	STA grab_low
	LDA #>title_zero_data
	STA grab_high	
	LDX #$00
@zero1
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @zero2
	INC grab_high
@zero2
	INX
	CPX #$20
	BNE @zero1

	; sprite zero oam setup
	LDA #$3F
	STA oam_page+0
	LDA #$FE
	STA oam_page+1
	LDA #$00
	STA oam_page+2
	LDA #$F8
	STA oam_page+3

	; selector sprite to pattern table
	LDA ppu_status
	LDA #$0F
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDA #<title_selector_data
	STA grab_low
	LDA #>title_selector_data
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
	LDA #$7B
	STA oam_page+0,X
	LDA #$FC
	STA oam_page+1,X
	LDA #$01
	STA oam_page+2,X
	LDA #$1C
	STA oam_page+3,X

	; fire sprite to pattern table
	LDA ppu_status
	LDA #$0F
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDA #<title_fire_data
	STA grab_low
	LDA #>title_fire_data
	STA grab_high	
	LDX #$00
@fire1
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @fire2
	INC grab_high
@fire2
	INX
	CPX #$80
	BNE @fire1

	; fire sprite oam setup
	LDY #$00
	LDX #$08
@fire3
	LDA title_sprite_position_data+2,Y
	STA oam_page+0,X
	STA oam_page+4,X
	CLC
	ADC #$10
	STA oam_page+8,X
	STA oam_page+12,X
	LDA #$F0
	STA oam_page+1,X
	CLC
	ADC #$02
	STA oam_page+5,X
	CLC
	ADC #$02
	STA oam_page+9,X
	CLC
	ADC #$02
	STA oam_page+13,X
	LDA #$01
	STA oam_page+2,X
	STA oam_page+6,X
	STA oam_page+10,X
	STA oam_page+14,X
	LDA title_sprite_position_data+0,Y
	STA oam_page+3,X
	STA oam_page+11,X
	CLC
	ADC #$08
	STA oam_page+7,X
	STA oam_page+15,X
	TXA
	CLC
	ADC #$10
	TAX
	INY
	CPY #$02
	BNE @fire3

	; pillar sprite to pattern table
	LDA ppu_status
	LDA #$0F
	STA ppu_addr
	LDA #$80
	STA ppu_addr
	LDA #<title_pillar_data
	STA grab_low
	LDA #>title_pillar_data
	STA grab_high	
	LDX #$00
@pillar1
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @pillar2
	INC grab_high
@pillar2
	INX
	CPX #$40
	BNE @pillar1

	; pillar sprite oam setup
	LDY #$00
	LDX #$28
@pillar3
	LDA title_sprite_position_data+2,Y
	CLC
	ADC #$1C
	STA oam_page+0,X
	STA oam_page+4,X
	LDA #$F8
	STA oam_page+1,X
	LDA #$FA
	STA oam_page+5,X
	LDA #$00
	STA oam_page+2,X
	STA oam_page+6,X
	LDA title_sprite_position_data+0,Y
	STA oam_page+3,X
	CLC
	ADC #$08
	STA oam_page+7,X
	TXA
	ADC #$08
	TAX
	INY
	CPY #$02
	BNE @pillar3

	; reset variables
	LDA #$00
	STA title_position
	STA title_timer
	
	RTS

title_zero_data
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF

title_selector_data
	.BYTE $80,$C0,$60,$30,$98,$CC,$66,$33,$80,$C0,$E0,$F0,$78,$3C,$1E,$0F
	.BYTE $33,$66,$CC,$98,$30,$60,$C0,$80,$0F,$1E,$3C,$78,$F0,$E0,$C0,$80

title_fire_data
	.BYTE $00,$00,$04,$00,$00,$00,$11,$03,$00,$00,$04,$00,$04,$40,$10,$03
	.BYTE $40,$03,$12,$09,$0A,$89,$39,$04,$49,$03,$13,$4A,$0D,$A6,$37,$1B
	.BYTE $00,$00,$00,$10,$00,$80,$02,$D0,$00,$00,$00,$10,$00,$88,$82,$50
	.BYTE $B0,$44,$B0,$28,$99,$B0,$B0,$E4,$70,$A4,$50,$D8,$E9,$DA,$70,$D4
	.BYTE $3B,$2D,$1D,$06,$79,$51,$2E,$50,$35,$3B,$1E,$3B,$57,$3F,$5B,$6F
	.BYTE $2B,$7D,$67,$1E,$2C,$37,$1D,$06,$3F,$77,$5F,$2B,$1F,$2F,$13,$07
	.BYTE $9C,$56,$AA,$FA,$BA,$44,$FA,$BF,$E8,$EA,$F6,$DE,$F6,$F8,$F6,$D7
	.BYTE $64,$9C,$6F,$9B,$D6,$EE,$54,$F0,$FA,$FA,$F5,$FD,$FA,$B6,$EC,$F0

title_pillar_data
	.BYTE $00,$00,$60,$7C,$9F,$67,$19,$0E,$00,$00,$60,$FC,$7F,$1F,$07,$19
	.BYTE $0B,$0A,$0A,$0A,$0A,$1A,$06,$01,$1E,$1F,$1F,$1F,$1F,$07,$01,$00
	.BYTE $00,$00,$06,$3E,$F9,$E6,$98,$68,$00,$00,$06,$3F,$FE,$F8,$E0,$98
	.BYTE $A8,$A8,$A8,$A8,$A8,$B8,$E0,$80,$78,$F8,$F8,$F8,$F8,$E0,$80,$00

title_sprite_position_data
	.BYTE $10,$E0, $2C,$2C ; x-coords, then y-coords

title_string_data
	.BYTE _C,_A,_V,_E,_R,_N,__,__
	.BYTE _F,_O,_R,_E,_S,_T,__,__
	.BYTE _D,_U,_N,_G,_E,_O,_N,__
	.BYTE _C,_A,_R,_D,_S,__,__,__

title_draw
	; enable rendering
	LDA #$18
	STA ppu_mask
	LDA #$B0 ; background on nametable #1
	STA ppu_ctrl

	; clear v-blank flag
	LDA #$00
	STA vblank_ready

title_draw_loop
	; wait for v-blank flag
	LDA vblank_ready
	BEQ title_draw_loop

	; clear v-blank flag
	LDA #$00
	STA vblank_ready

	; disable rendering
	LDA #$00
	STA ppu_mask

	; change fire palette
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA #$14
	STA ppu_addr
	LDA #$0F
	STA ppu_data
	LDA title_timer
	AND #$02
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$06
	STA ppu_data
	CLC
	ADC #$10
	STA ppu_data
	CLC
	ADC #$10
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
	LDA title_position
	CMP #$03 ; max number of tunnels
	BCS @button1
	LDA buttons_value
	AND #$80 ; A
	BEQ @button1
	LDA buttons_wait
	BNE @button1
	JMP title_draw_exit
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
	LDA title_position
	BEQ @button3
	SEC
	SBC #$01
	STA title_position	
	LDA #$01
	STA buttons_wait
@button3
	LDA buttons_value
	AND #$04 ; down
	BEQ @button4
	LDA title_position
	CMP #$03 ; one less than max positions
	BEQ @button4
	CLC
	ADC #$01
	STA title_position
	LDA #$01
	STA buttons_wait
@button4

	; increment timer for animation purposes
	INC title_timer

	; animate selector sprite
	LDA title_position
	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$7B
	STA oam_page+4
	LDA #$FC
	STA oam_page+5
	LDA #$01
	STA oam_page+6
	LDA title_timer
	AND #$1C
	LSR A
	LSR A
	CLC
	ADC #$1C
	STA oam_page+7

	; animate fire sprites
	LDY #$00
	LDX #$08
@fire
	LDA title_sprite_position_data+2,Y
	STA oam_page+0,X
	STA oam_page+4,X
	CLC
	ADC #$10
	STA oam_page+8,X
	STA oam_page+12,X
	LDA #$F0
	STA oam_page+1,X
	CLC
	ADC #$02
	STA oam_page+5,X
	CLC
	ADC #$02
	STA oam_page+9,X
	CLC
	ADC #$02
	STA oam_page+13,X
	LDA title_timer
	AND #$08
	STA math_slot_0
	ASL A
	ASL A
	ASL A
	ORA #$01
	STA oam_page+2,X
	STA oam_page+6,X
	STA oam_page+10,X
	STA oam_page+14,X
	LDA title_sprite_position_data+0,Y
	CLC
	ADC math_slot_0
	STA oam_page+3,X
	STA oam_page+11,X
	LDA title_sprite_position_data+0,Y
	CLC
	ADC #$08
	SEC
	SBC math_slot_0
	STA oam_page+7,X
	STA oam_page+15,X
	TXA
	CLC
	ADC #$10
	TAX
	INY
	CPY #$02
	BNE @fire


	; wait for sprite zero hit
@zero1
	LDA vblank_ready
	BNE @jump
	LDA ppu_status
	AND #$40
	BNE @zero1

@zero2
	LDA vblank_ready
	BNE @jump
	LDA ppu_status
	AND #$40
	BEQ @zero2

	; short wait
	LDX #$B4
@wait
	DEX
	BNE @wait

	; switch nametables
	LDA #$A0
	STA ppu_ctrl

@jump
	JMP title_draw_loop

title_draw_exit
	RTS





