
; effects sub-routines for Card Chasm NES, goes in last bank


; setup effects sprites
effects_setup
	LDA #<effects_setup_data
	STA grab_low
	LDA #>effects_setup_data
	STA grab_high	
	LDA ppu_status
	LDA #$03
	STA ppu_addr
	LDA #$40
	STA ppu_addr
	LDX #$00
@loop1
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @skip1
	INC grab_high
@skip1
	INX
	CPX #$C0
	BNE @loop1
	LDA ppu_status
	LDA #$05
	STA ppu_addr
	LDA #$40
	STA ppu_addr
	LDX #$00
@loop2
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @skip2
	INC grab_high
@skip2
	INX
	CPX #$C0
	BNE @loop2
	RTS

effects_setup_data
	; normal
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $01,$07,$1F,$7F,$FC,$F9,$F3,$66,$01,$07,$1F,$7F,$FF,$FE,$FC,$78
	.BYTE $00,$00,$00,$00,$01,$07,$1E,$7C,$00,$00,$00,$00,$01,$07,$1F,$7F
	.BYTE $F1,$E7,$8C,$38,$60,$C0,$00,$00,$FE,$F8,$F0,$C0,$80,$00,$00,$00
	.BYTE $01,$06,$1D,$72,$C4,$98,$30,$E0,$01,$07,$1E,$7C,$F8,$E0,$C0,$00
	.BYTE $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	; fire
	.BYTE $00,$04,$00,$10,$00,$2A,$84,$3A,$42,$04,$20,$19,$00,$2A,$A4,$2E
	.BYTE $1C,$2C,$5A,$53,$FF,$44,$18,$3C,$38,$7C,$76,$BF,$ED,$FF,$66,$00
	; lightning
	.BYTE $10,$10,$18,$38,$68,$48,$C8,$88,$10,$10,$18,$38,$68,$48,$C8,$88
	.BYTE $1C,$34,$26,$22,$23,$21,$30,$10,$1C,$34,$26,$22,$23,$21,$30,$10
	.BYTE $10,$70,$5C,$46,$42,$40,$70,$D8,$10,$70,$5C,$46,$42,$40,$70,$D8
	.BYTE $88,$8E,$82,$02,$06,$0F,$19,$10,$88,$8E,$82,$02,$06,$0F,$19,$10
	; ice
	.BYTE $00,$10,$28,$54,$28,$10,$00,$00,$00,$00,$10,$38,$10,$00,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $10,$28,$54,$BA,$54,$28,$10,$00,$00,$10,$38,$7C,$38,$10,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $28,$54,$BA,$7C,$BA,$54,$28,$00,$10,$38,$7C,$FE,$7C,$38,$10,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	; shield
	.BYTE $80,$E0,$90,$EF,$F0,$FF,$FF,$FF,$00,$00,$60,$70,$7F,$7F,$7F,$7F
	.BYTE $FF,$FF,$FC,$FD,$FD,$FD,$C1,$DF,$7F,$7F,$7F,$7E,$7E,$7E,$7E,$60
	.BYTE $DF,$C1,$FD,$FD,$FD,$FC,$FF,$FF,$60,$7E,$7E,$7E,$7E,$7F,$7F,$7F
	.BYTE $7F,$7F,$3F,$3F,$1F,$0F,$07,$00,$3F,$3F,$1F,$1F,$0F,$07,$00,$00
	; heart
	.BYTE $6C,$92,$AA,$BA,$54,$28,$10,$00,$6C,$FE,$D6,$C6,$6C,$38,$10,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; draw effects
effects_draw
	; check timer, decrement if necessary
	LDA effects_timer
	BEQ @blank
	DEC effects_timer

	; determine which effect type it is
	LDA effects_type
	CMP #$02
	BNE @type1
	JMP effects_draw_normal
@type1
	CMP #$03
	BNE @type2
	JMP effects_draw_fire
@type2
	CMP #$04
	BNE @type3
	JMP effects_draw_lightning
@type3
	CMP #$05
	BNE @type4
	JMP effects_draw_ice
@type4
	CMP #$06
	BNE @type5
	JMP effects_draw_shield
@type5
	CMP #$07
	BNE @blank
	JMP effects_draw_heart
@blank
	; blank
	LDA #$EF
	STA oam_page+8
	STA oam_page+12
	STA oam_page+16
	STA oam_page+20
	STA oam_page+24
	STA oam_page+28
	RTS

; normal effect
effects_draw_normal
	DEC effects_timer ; faster
	LDA effects_timer
	ASL A
	STA math_slot_0
	LDA #$80 ; y-value
	SEC
	SBC math_slot_0
	STA oam_page+8
	STA oam_page+12
	STA oam_page+16
	LDX #$34 ; pattern
	STX oam_page+9
	INX
	INX
	STX oam_page+13
	INX
	INX
	STX oam_page+17
	LDA selector_position ; palette
	STA oam_page+10
	STA oam_page+14
	STA oam_page+18
	LDA effects_timer ; x-value
	ASL A
	ASL A
	CLC
	ADC #$44
	STA oam_page+11
	CLC
	ADC #$08
	STA oam_page+15
	CLC
	ADC #$08
	STA oam_page+19
	RTS

; fire effect
effects_draw_fire
	LDA effects_timer ; y-value
	STA math_slot_0
	LDA #$50 ; y-value
	CLC
	ADC math_slot_0
	STA oam_page+8
	STA oam_page+12
	STA oam_page+16
	LDA #$3A ; pattern
	STA oam_page+9
	STA oam_page+13
	STA oam_page+17
	LDA effects_timer ; palette and reflection
	AND #$02
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	ORA selector_position
	STA oam_page+10
	STA oam_page+18
	EOR #$40
	STA oam_page+14
	LDA #$70 ; x-value
	STA oam_page+11
	CLC
	ADC #$10
	STA oam_page+15
	CLC
	ADC #$10
	STA oam_page+19
	RTS

; lightning effect
effects_draw_lightning
	LDA #$40 ; y-value
	STA oam_page+8
	CLC
	ADC #$10
	STA oam_page+12
	CLC
	ADC #$10
	STA oam_page+16
	CLC
	ADC #$10
	STA oam_page+20
	LDA #$3C ; pattern
	STA oam_page+9
	LDA #$3E
	STA oam_page+13
	LDA #$3C
	STA oam_page+17
	LDA #$3E
	STA oam_page+21
	LDA effects_timer ; palette and reflection
	AND #$04
	ASL A
	ASL A
	ASL A
	ASL A
	ORA selector_position
	STA oam_page+10
	STA oam_page+14
	STA oam_page+18
	STA oam_page+22
	LDA #$80 ; x-value
	STA oam_page+11
	STA oam_page+15
	STA oam_page+19
	STA oam_page+23

	; switch palettes
	LDA effects_timer
	AND #$03
	BNE @skip
	LDA selector_position
	ASL A
	ASL A
	TAX
	LDA card_palette_array+2,X
	STA math_slot_0
	LDA card_palette_array+3,X
	STA card_palette_array+2,X
	LDA math_slot_0
	STA card_palette_array+3,X
@skip
	RTS

; ice effect
effects_draw_ice
	LDA effects_timer
	LSR A
	LSR A
	STA math_slot_0
	LDA #$50 ; y-value
	SEC
	SBC math_slot_0
	STA oam_page+8
	LDA #$60
	SEC
	SBC math_slot_0
	STA oam_page+12
	LDA #$58
	SEC
	SBC math_slot_0
	STA oam_page+16
	LDA #$78
	SEC
	SBC math_slot_0
	STA oam_page+20
	LDA #$70
	SEC
	SBC math_slot_0
	STA oam_page+24
	LDA #$80
	SEC
	SBC math_slot_0
	STA oam_page+28
	LDA effects_timer ; pattern
	AND #$03
	TAX
	LDA effects_draw_ice_data,X
	CLC
	ADC #$54
	STA oam_page+9
	STA oam_page+29
	LDA effects_timer
	CLC
	ADC #$01
	AND #$03
	TAX
	LDA effects_draw_ice_data,X
	CLC
	ADC #$54
	STA oam_page+13
	STA oam_page+21
	LDA effects_timer
	CLC
	ADC #$02
	AND #$03
	TAX
	LDA effects_draw_ice_data,X
	CLC
	ADC #$54
	STA oam_page+17
	STA oam_page+25
	LDA selector_position ; palette
	STA oam_page+10
	STA oam_page+14
	STA oam_page+18
	STA oam_page+22
	STA oam_page+26
	STA oam_page+30
	LDA #$78 ; x-value
	STA oam_page+11
	STA oam_page+23
	LDA #$80
	STA oam_page+15
	STA oam_page+27
	LDA #$88
	STA oam_page+19
	STA oam_page+31
	RTS

effects_draw_ice_data
	.BYTE $00,$02,$04,$02

; shield effect
effects_draw_shield
	LDA #$58 ; y-value
	STA oam_page+8
	STA oam_page+12
	CLC
	ADC #$10
	STA oam_page+16
	STA oam_page+20
	LDA #$5A ; pattern
	STA oam_page+9
	STA oam_page+13
	LDA #$5C
	STA oam_page+17
	STA oam_page+21
	LDA selector_position
	STA oam_page+10
	STA oam_page+18
	EOR #$40
	STA oam_page+14
	STA oam_page+22
	LDA #$00
	STA math_slot_0
	LDA effects_timer
	CMP #$10
	BCC @still
	SEC
	SBC #$10
	LSR A
	STA math_slot_0
@still
	LDA #$7C ; x-value
	SEC
	SBC math_slot_0
	STA oam_page+11
	STA oam_page+19
	LDA #$84
	CLC
	ADC math_slot_0
	STA oam_page+15
	STA oam_page+23
	RTS

; heart effect
effects_draw_heart
	LDA effects_timer
	LSR A
	LSR A
	STA math_slot_0
	LDA #$50 ; y-value
	CLC
	ADC math_slot_0
	STA oam_page+8
	LDA #$60
	CLC
	ADC math_slot_0
	STA oam_page+12
	LDA #$58
	CLC
	ADC math_slot_0
	STA oam_page+16
	LDA #$78
	CLC
	ADC math_slot_0
	STA oam_page+20
	LDA #$70
	CLC
	ADC math_slot_0
	STA oam_page+24
	LDA #$80
	CLC
	ADC math_slot_0
	STA oam_page+28
	LDA #$5E
	STA oam_page+9
	STA oam_page+29
	STA oam_page+13
	STA oam_page+21
	STA oam_page+17
	STA oam_page+25
	LDA selector_position ; palette
	STA oam_page+10
	STA oam_page+14
	STA oam_page+18
	STA oam_page+22
	STA oam_page+26
	STA oam_page+30
	LDA effects_timer
	LSR A
	AND #$07
	TAX
	LDA effects_draw_heart_data,X
	CLC
	ADC #$78 ; x-value
	STA oam_page+11
	STA oam_page+23
	CLC
	ADC #$08
	STA oam_page+15
	STA oam_page+27
	CLC
	ADC #$08
	STA oam_page+19
	STA oam_page+31
	RTS

effects_draw_heart_data
	.BYTE $00,$01,$02,$03,$04,$03,$02,$01

; horizontal shaking screen
effects_shake
	LDA effects_timer
	BNE @decrement
	LDA #$FC ; rest position
	STA effects_scroll
	LDA #$00
	STA effects_direction
	RTS
@decrement
	DEC effects_timer
	
	LDA effects_direction
	BEQ @right
@left
	DEC effects_scroll
	LDA effects_scroll
	CMP #$F8 ; left side
	BNE @exit
	LDA #$00
	STA effects_direction
	BEQ @exit
@right
	INC effects_scroll
	LDA effects_scroll
	CMP #$FF ; right side
	BNE @exit
	LDA #$01
	STA effects_direction
@exit
	RTS
