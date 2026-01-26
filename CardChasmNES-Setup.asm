
; setup sub-routines for Card Chasm NES, goes in last bank

; setup game variables
setup
	; disable rendering
	LDA #$00
	STA ppu_status

	; last two tiles
	LDA ppu_status
	LDA #$1F
	STA ppu_addr
	LDA #$E0
	STA ppu_addr
	
	; full tile (table $01, tile $FE)
	LDX #$10
	LDA #$FF
@last_tiles_loop1
	STA ppu_data
	DEX
	BNE @last_tiles_loop1

	; blank tile (table $01, tile $FF)
	LDX #$10
	LDA #$00
@last_tiles_loop2
	STA ppu_data
	DEX
	BNE @last_tiles_loop2

	; sprite zero 
	JSR sprite_zero_setup
	JSR sprite_zero_draw

	; selector
	JSR selector_setup
	LDA #$00
	STA selector_position
	LDA #$00
	STA selector_animation

	; cards
	LDA #$00
	STA card_location
	JSR card_setup
	
	; TEMPORARY!
	; create cards into deck
	LDX #$00
@card_deck_loop1
	LDA #$00 ; type (unused)
	STA card_deck_type,X
	JSR rand_func ; number
	CLC
	ADC #$02
	AND #$03
	CLC
	ADC #$01
	STA card_deck_number,X
	JSR rand_func ; symbol
	AND #$07
	CMP #$06
	BCC @card_deck_sym
	LDA #$00
@card_deck_sym
	PHA
	CLC
	ADC #$02
	STA card_deck_symbol,X
	PLA ; color
	TAY
	LDA setup_card_color_data,Y
	STA card_deck_color,X
	JSR rand_func ; movement
	AND #$03
	CLC
	ADC #$01
	STA card_deck_movement,X
	INX
	CPX #$28 ; 40 cards in deck
	BNE @card_deck_loop1
	JMP setup_card_jump

setup_card_color_data
	; colors associated with each card symbol
	.BYTE $1A,$16,$28,$22,$13,$25

setup_card_jump
	; shuffle cards here
	LDX #$00
@card_deck_loop2
	TXA
	STA card_deck_array,X
	INX
	CPX #$28
	BNE @card_deck_loop2
	JSR card_shuffle
	JSR card_shuffle
	JSR card_shuffle

	; starting hand
	LDA #$00
	STA card_hand_array+0
	LDA #$01
	STA card_hand_array+1
	LDA #$02
	STA card_hand_array+2
	LDA #$03
	STA card_hand_array+3

	LDA #$04
	STA card_deck_position

	LDA #$00
	STA card_shift_timer

	; enemies
	JSR enemies_setup

	; create enemy positions along path
	LDX #$00
	JSR rand_func
	TAY
	LDA random_value_data,Y
	TAY
@enemies_path_loop
	INY
	LDA random_value_data,Y
	AND #$03
	BNE @enemies_path_zero
	JSR rand_func
	AND #$03 ; change later
	CLC
	ADC #$02
	STA enemies_page,X
	BNE @enemies_path_check
@enemies_path_zero
	LDA #$00
	STA enemies_page,X
@enemies_path_check
	INX
	BNE @enemies_path_loop	
	
	; intial setup
	LDA #$00
	STA enemies_position
	LDA #$20 ; end of tunnel
	STA enemies_max
	TAX
	LDA #$02 ; last enemy
	STA enemies_page,X

	; TEMPORARY!
	; decide which tunnel to draw
	; always in 16-byte values
	LDX #$20

	; tunnel setup info
	LDA setup_tunnel_data+0,X
	STA tunnel_address
	LDA setup_tunnel_data+1,X
	STA background_color ; set background color
	LDA setup_tunnel_data+2,X
	STA tunnel_top
	LDA setup_tunnel_data+3,X
	STA tunnel_symmetry
	LDA #$40
	STA tunnel_location
	LDA #$00
	STA tunnel_ceiling_palette
	LDA setup_tunnel_data+4,X
	STA tunnel_ceiling_color1
	LDA setup_tunnel_data+5,X
	STA tunnel_ceiling_color2
	LDA setup_tunnel_data+6,X
	STA tunnel_ceiling_color3
	LDA #$01
	STA tunnel_floor_palette
	LDA setup_tunnel_data+7,X
	STA tunnel_floor_color1
	LDA setup_tunnel_data+8,X
	STA tunnel_floor_color2
	LDA setup_tunnel_data+9,X
	STA tunnel_floor_color3
	LDA #$02
	STA tunnel_hud_palette
	LDA setup_tunnel_data+10,X
	STA tunnel_hud_color1
	LDA setup_tunnel_data+11,X
	STA tunnel_hud_color2
	LDA setup_tunnel_data+12,X
	STA tunnel_hud_color3
	JSR tunnel_setup

	; tunnel draw info
	LDA #$00
	STA tunnel_previous
	STA tunnel_counter
	LDA #$40
	STA tunnel_location
	LDA #$20
	STA tunnel_table
	JSR tunnel_draw
	LDA #$00
	STA tunnel_previous
	STA tunnel_counter
	LDA #$60
	STA tunnel_location
	LDA #$28
	STA tunnel_table
	JSR tunnel_draw

	; tunnel scroll info
	LDA #$E0
	STA tunnel_scroll
	LDA #$01
	STA tunnel_direction
	LDA #$02
	STA tunnel_name

	; do not draw portrait
	LDA #$00
	STA portrait_progress

	; setup effects sprites
	JSR effects_setup

	; effects variables
	LDA #$00
	STA effects_type
	LDA #$00
	STA effects_timer
	LDA #$FC ; rest position
	STA effects_scroll
	LDA #$00
	STA effects_direction

	; bar setup
	LDA #$C0
	STA bar_location
	LDA #$00
	STA bar_position
	LDA #$00
	STA bar_value
	LDA #$00
	STA bar_length
	JSR bar_setup

	; battle variables
	LDA #$00
	STA battle_player_type
	LDA #$00
	STA battle_player_attack
	LDA #$00
	STA battle_enemy_weakness
	LDA #$00
	STA battle_enemy_attack
	LDA #$00
	STA battle_enemy_multi

	; more battle variables
	LDA #$80 ; 128 in decimal
	STA battle_player_health
	LDA #$00 ; max of $40, or 64 in decimal
	STA battle_enemy_health

	; setup string
	LDA #$00
	STA string_location
	LDA #$02
	STA string_palette
	LDA background_color
	STA string_color1
	LDA #$10
	STA string_color2
	LDA #$20
	STA string_color3
	JSR string_setup

	; blank string tiles
	LDX #$00
	LDA string_location
	CLC
	ADC #$30 ; space character
@string_loop
	STA string_array,X
	INX
	CPX #$80
	BNE @string_loop

	; static hud info
	LDX #$27
	LDA #$11
	STA string_array,X
	INX
	LDA #$19
	STA string_array,X

	RTS

; 16 bytes per setup
setup_tunnel_data
	; cave
	.BYTE #>tunnel_data_0 ; address
	.BYTE $08,$01,$00 ; back, top, sym
	.BYTE $06,$27,$37 ; ceiling colors
	.BYTE $06,$27,$37 ; floor colors
	.BYTE $08,$10,$20 ; hud colors
	.BYTE $FF,$FF,$FF ; dummy values

	; trees
	.BYTE #>tunnel_data_1 ; address
	.BYTE $01,$00,$00 ; back, top, sym
	.BYTE $17,$0A,$07 ; ceiling colors
	.BYTE $17,$0A,$07 ; floor colors
	.BYTE $01,$10,$20 ; hud colors
	.BYTE $FF,$FF,$FF ; dummy values

	; castle
	.BYTE #>tunnel_data_2 ; address
	.BYTE $0C,$01,$01 ; back, top, sym
	.BYTE $20,$00,$10 ; ceiling colors
	.BYTE $20,$00,$10 ; floor colors
	.BYTE $0C,$10,$20 ; hud colors
	.BYTE $FF,$FF,$FF ; dummy values


; run once before drawing
sprite_zero_setup
	; setup sprite zero locations to copy
	LDA ppu_status
	LDA #$01
	STA ppu_addr
	LDA #$E0
	STA ppu_addr
	LDA #<sprite_zero_setup_data
	STA grab_low
	LDA #>sprite_zero_setup_data
	STA grab_high	
	LDX #$00
@loop
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @skip
	INC grab_high
@skip
	INX
	CPX #$20
	BNE @loop
	RTS

sprite_zero_setup_data
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF

; draw sprite zero for HUD timing
sprite_zero_draw
	LDA #$AA ; $AA, y-value
	STA oam_page+0
	LDA #$1E ; last sprites on first row
	STA oam_page+1
	LDA #$00 ; palette #0
	STA oam_page+2
	LDA #$E8 ; x-value
	STA oam_page+3
	RTS

; run once before drawing
selector_setup
	; setup selector sprite
	LDA ppu_status
	LDA #$01
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDA #<selector_setup_data
	STA grab_low
	LDA #>selector_setup_data
	STA grab_high	
	LDX #$00
@loop
	JSR grab_func
	STA ppu_data
	INC grab_low
	BNE @skip
	INC grab_high
@skip
	INX
	CPX #$20
	BNE @loop
	RTS

selector_setup_data
	.BYTE $80,$C0,$60,$30,$98,$CC,$66,$33,$80,$C0,$E0,$F0,$78,$3C,$1E,$0F
	.BYTE $33,$66,$CC,$98,$30,$60,$C0,$80,$0F,$1E,$3C,$78,$F0,$E0,$C0,$80

; draw selector sprite
selector_draw
	; set oam data
	LDA selector_position ; y-value
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	STA math_slot_0
	LDA selector_position
	ASL A
	ASL A
	ASL A
	CLC
	ADC math_slot_0
	CLC
	ADC #$10
	CLC
	ADC #$08
	STA oam_page+4
	LDA #$1C ; 2nd to last sprite on first row
	STA oam_page+5
	LDA #$00 ; palette #0
	STA oam_page+6
	LDA selector_animation
	AND #$1F
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$C8 ; x-value
	STA oam_page+7

@exit
	RTS

; clear selector sprite
selector_clear
	; set oam data
	LDA #$EF ; y-value
	STA oam_page+4
	RTS

; move the selector with up or down buttons
selector_move
	LDA buttons_value
	AND #$08 ; up
	BEQ @skip1
	LDA buttons_wait
	BNE @skip1
	LDA selector_position
	BEQ @skip1
	LDA #$01
	STA buttons_wait
	DEC selector_position
@skip1
	LDA buttons_value
	AND #$04 ; down
	BEQ @skip2
	LDA buttons_wait
	BNE @skip2
	LDA selector_position
	CMP #$03
	BEQ @skip2
	LDA #$01
	STA buttons_wait
	INC selector_position
@skip2
	RTS

