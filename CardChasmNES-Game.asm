
; game state sub-routines for Card Chasm NES, goes in last bank


; jump to game state
game_function
	LDX game_state
	LDA game_function_table+0,X
	STA game_jump_low
	LDA game_function_table+1,X
	STA game_jump_high
	JMP (game_jump_low)

; waiting to select card while not in battle	
game_function_00
	INC selector_animation
	JSR selector_draw
	JSR selector_move
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show
	JSR buttons_activate ; check for pressing A
	BEQ @skip
	LDX selector_position
	LDA card_hand_array,X
	CMP #$FF
	BEQ @skip
	TAX
	LDA card_deck_movement,X
	STA tunnel_movement
	LDX selector_position
	LDA #$FF
	STA card_hand_array,X
	LDA #$02
	STA game_state
@skip
	RTS

; walking down the tunnel some distance
game_function_02
	JSR selector_clear
	JSR card_show
	JSR enemies_draw
	JSR tunnel_walk
	JSR bar_show
	LDA tunnel_movement
	BNE @skip
	LDA #$FF
	STA card_shift_timer
	LDA #$04
	STA game_state
	LDA #$1E
	STA game_delay_low
	LDA #$00
	STA game_delay_high
@skip
	RTS

; shifting cards and checking for enemy tile
game_function_04
	JSR selector_clear
	JSR card_shift
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show
	DEC game_delay_low
	BNE @skip
	LDX enemies_position
	LDA enemies_page,X
	BEQ @zero

	; TEMPORARY!
	; draw portrait (auto setup included)
	LDA #>portrait_data_1
	STA portrait_address
	LDA #$80
	STA portrait_location
	LDA #$0C
	STA portrait_x
	LDA #$08
	STA portrait_y
	LDA #$0F
	STA portrait_color1
	LDA #$15
	STA portrait_color2
	LDA #$20
	STA portrait_color3
	LDA #$03 ; using palette #3
	STA portrait_palette
	LDA #$FF
	STA portrait_filter
	LDA #$01 ; start drawing
	STA portrait_progress
	
	; TEMPORARY!
	; setup battle variables
	LDA #$00
	STA battle_enemy_weakness
	LDA #$0A
	STA battle_enemy_attack
	LDA #$0A
	STA battle_enemy_multi
	LDA #$40
	STA battle_enemy_health
	LDA #$0E
	STA string_array+0
	LDA #$17
	STA string_array+1
	LDA #$0E
	STA string_array+2
	LDA #$16
	STA string_array+3
	LDA #$22
	STA string_array+4

	LDA #$10
	STA game_state
	LDA #$1E
	STA game_delay_low
	LDA #$00
	STA game_delay_high
	JMP @skip
@zero
	LDA #$00
	STA game_state
@skip
	RTS

game_function_06
	RTS
game_function_08
	RTS
game_function_0A
	RTS
game_function_0C
	RTS
game_function_0E
	RTS


; landing on enemy tile, drawing portrait
game_function_10
	JSR selector_clear
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show
	DEC game_delay_low
	BNE @skip
	LDA #$12
	STA game_state
@skip
	RTS

; waiting for card while in battle
game_function_12
	INC selector_animation
	JSR selector_draw
	JSR selector_move
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show
	JSR buttons_activate ; check for pressing A
	BEQ @skip
	LDX selector_position
	LDA card_hand_array,X
	CMP #$FF
	BEQ @skip
	TAX
	LDA card_deck_symbol,X
	STA effects_type
	STA battle_player_type
	LDY battle_enemy_multi
	LDA #$00
@multiply
	CLC
	ADC card_deck_number,X
	DEY
	BNE @multiply
	STA battle_player_attack
	LDA #$20
	STA effects_timer
	LDX selector_position
	LDA #$FF
	STA card_hand_array,X
	LDA #$14
	STA game_state
	LDA #$3C
	STA game_delay_low
	LDA #$00
	STA game_delay_high
@skip
	RTS

; player attack animation while in battle
game_function_14
	JSR selector_clear
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR effects_draw
	JSR bar_show
	DEC game_delay_low
	LDA game_delay_low
	CMP #$28
	BNE @next

	; enemy takes damage
	LDA battle_enemy_health
	SEC
	SBC battle_player_attack
	STA battle_enemy_health
	BCS @alive
	LDA #$00
	STA battle_enemy_health

	JMP reset ; TEMPORARY!

@alive
	JMP @skip

@next
	LDA game_delay_low
	CMP #$00
	BNE @skip
	LDA #$20
	STA effects_timer
	LDA #$16
	STA game_state
	LDA #$3C
	STA game_delay_low
	LDA #$00
	STA game_delay_high
@skip
	RTS

; enemy attack animation while in battle
game_function_16
	JSR selector_clear
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR effects_shake
	JSR bar_show

	DEC game_delay_low
	LDA game_delay_low
	CMP #$28
	BNE @next

	; player takes damage
	LDA battle_player_health
	SEC
	SBC battle_enemy_attack
	STA battle_player_health
	BCS @alive
	LDA #$00
	STA battle_player_health

	JMP reset ; TEMPORARY!

@alive
	JMP @skip

@next
	LDA game_delay_low
	BNE @skip
	LDA #$FC ; rest position
	STA effects_scroll
	LDA #$FF
	STA card_shift_timer
	LDA #$1E
	STA game_delay_low
	LDA #$00
	STA game_delay_high
	LDA #$18
	STA game_state
@skip
	RTS

; shifting cards and going back to wait during battle
game_function_18
	JSR selector_clear
	JSR card_shift
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show

	DEC game_delay_low
	BNE @skip
	LDA #$12
	STA game_state
@skip
	RTS

game_function_1A
	RTS
game_function_1C
	RTS
game_function_1E
	RTS

game_function_table
	.WORD game_function_00 ; waiting to select card outside battle
	.WORD game_function_02 ; walking tunnel animation
	.WORD game_function_04 ; shifting cards and checking for battle
	.WORD game_function_06
	.WORD game_function_08
	.WORD game_function_0A
	.WORD game_function_0C
	.WORD game_function_0E

	.WORD game_function_10 ; draw enemy portrait with delay
	.WORD game_function_12 ; waiting to select card inside battle
	.WORD game_function_14 ; player attack animation with delay
	.WORD game_function_16 ; enemy attack animation with delay
	.WORD game_function_18 ; shifting cards and back to waiting
	.WORD game_function_1A
	.WORD game_function_1C
	.WORD game_function_1E
