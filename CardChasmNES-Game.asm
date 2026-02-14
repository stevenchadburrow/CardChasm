
; game state sub-routines for Card Chasm NES, goes in last bank


; jump to game state
game_function
	LDX game_state
	LDA game_function_table+0,X
	STA game_jump_low
	LDA game_function_table+1,X
	STA game_jump_high
	JMP (game_jump_low)

; running clear and setup functions
game_function_00
	JSR clear
	JSR setup
	LDA #$02
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
	RTS

; waiting to select card while not in battle	
game_function_02
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
	LDA #$04
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
@skip
	RTS

; walking down the tunnel some distance
game_function_04
	JSR selector_clear
	JSR card_show
	JSR enemies_draw
	JSR tunnel_walk
	JSR bar_show
	LDA tunnel_movement
	BNE @skip
	LDA #$FF
	STA card_shift_timer
	LDA #$06
	STA game_state
	LDA #$1E
	STA game_delay_low
	LDA #$00
	STA game_delay_high
@skip
	RTS

; shifting cards and checking for enemy tile
game_function_06
	JSR selector_clear
	JSR card_shift
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show
	DEC game_delay_low
	BEQ @continue1
	JMP @skip
@continue1
	LDX enemies_position
	LDA enemies_page,X
	BNE @continue2
	JMP @zero
@continue2

	; minus 1 then multiply by 8
	SEC
	SBC #$01
	ASL A
	ASL A
	ASL A
	TAX

	; draw portrait (auto setup included)
	LDA enemies_battle_data+1,X
	STA portrait_address
	LDA #$80
	STA portrait_location
	LDA #$0C
	STA portrait_x
	LDA #$08
	STA portrait_y
	LDA enemies_battle_data+2,X
	STA portrait_color1
	LDA enemies_battle_data+3,X
	STA portrait_color2
	LDA enemies_battle_data+4,X
	STA portrait_color3
	LDA #$03 ; using palette #3
	STA portrait_palette
	LDA #$FF
	STA portrait_filter
	LDA #$01 ; start drawing
	STA portrait_progress
	
	; setup battle variables
	LDA enemies_battle_data+5,X
	STA battle_enemy_weakness
	LDA enemies_battle_data+6,X
	STA battle_enemy_attack
	LDA enemies_battle_data+7,X
	STA battle_enemy_multi
	LDA #$40
	STA battle_enemy_health

	; setup enemy choices
	LDA #$00
	STA battle_choice_position
	LDA enemies_choice_data+0,X
	STA battle_choice_array+0
	LDA enemies_choice_data+1,X
	STA battle_choice_array+1
	LDA enemies_choice_data+2,X
	STA battle_choice_array+2
	LDA enemies_choice_data+3,X
	STA battle_choice_array+3
	LDA enemies_choice_data+4,X
	STA battle_choice_array+4
	LDA enemies_choice_data+5,X
	STA battle_choice_array+5
	LDA enemies_choice_data+6,X
	STA battle_choice_array+6
	LDA enemies_choice_data+7,X
	STA battle_choice_array+7

	; setup enemy name
	LDA enemies_name_data+0,X
	STA string_array+0
	LDA enemies_name_data+1,X
	STA string_array+1
	LDA enemies_name_data+2,X
	STA string_array+2
	LDA enemies_name_data+3,X
	STA string_array+3
	LDA enemies_name_data+4,X
	STA string_array+4
	LDA enemies_name_data+5,X
	STA string_array+5
	LDA enemies_name_data+6,X
	STA string_array+6
	LDA enemies_name_data+7,X
	STA string_array+7

	; load top phrase
	LDA enemies_phrase_top_data+0,X
	STA battle_phrase_top+0
	LDA enemies_phrase_top_data+1,X
	STA battle_phrase_top+1
	LDA enemies_phrase_top_data+2,X
	STA battle_phrase_top+2
	LDA enemies_phrase_top_data+3,X
	STA battle_phrase_top+3
	LDA enemies_phrase_top_data+4,X
	STA battle_phrase_top+4
	LDA enemies_phrase_top_data+5,X
	STA battle_phrase_top+5
	LDA enemies_phrase_top_data+6,X
	STA battle_phrase_top+6
	LDA enemies_phrase_top_data+7,X
	STA battle_phrase_top+7
	
	; load bottom phrase
	LDA enemies_phrase_bottom_data+0,X
	STA battle_phrase_bottom+0
	LDA enemies_phrase_bottom_data+1,X
	STA battle_phrase_bottom+1
	LDA enemies_phrase_bottom_data+2,X
	STA battle_phrase_bottom+2
	LDA enemies_phrase_bottom_data+3,X
	STA battle_phrase_bottom+3
	LDA enemies_phrase_bottom_data+4,X
	STA battle_phrase_bottom+4
	LDA enemies_phrase_bottom_data+5,X
	STA battle_phrase_bottom+5
	LDA enemies_phrase_bottom_data+6,X
	STA battle_phrase_bottom+6
	LDA enemies_phrase_bottom_data+7,X
	STA battle_phrase_bottom+7

	LDA #$10
	STA game_state
	LDA #$1E
	STA game_delay_low
	LDA #$00
	STA game_delay_high
	JMP @skip
@zero
	LDA #$02
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
@skip
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
	JSR enemies_phrase_clear
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
	LDA card_deck_number,X
	STA battle_player_value
	LDY battle_enemy_multi
	LDA card_deck_symbol,X
	CMP battle_enemy_weakness
	BNE @ready
	TYA
	ASL A ; double damage for weakness
	TAY
@ready
	LDA #$00
@multiply
	CLC
	ADC card_deck_number,X
	BCS @max
	CMP #$40
	BCS @max
	DEY
	BNE @multiply
	STA battle_player_attack
	JMP @next
@max
	LDA #$40
	STA battle_player_attack
@next
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

	LDA battle_player_type
	CMP #$06
	BEQ @shield
	CMP #$07
	BEQ @hearts

	; enemy takes damage
	LDA battle_enemy_health
	SEC
	SBC battle_player_attack
	STA battle_enemy_health
	BCS @alive
	LDA #$00
	STA battle_enemy_health
@alive
	JMP @skip

@shield
	; no damage
	JMP @skip

@hearts
	; player gains health
	LDA battle_player_value
	ASL A
	ASL A
	ASL A
	ASL A ; multiply by 16
	CLC
	ADC battle_player_health
	STA battle_player_health
	BCS @max
	CMP #$80
	BCS @max
	JMP @skip
@max
	LDA #$80
	STA battle_player_health
	JMP @skip

@next
	LDA game_delay_low
	CMP #$00
	BNE @skip

	LDA battle_enemy_health
	BEQ @dead

	; shake or phrase
	LDA #$00
	STA battle_choice_shake
	LDX battle_choice_position
	LDA battle_choice_array,X
	BEQ @still
	STA battle_choice_shake
	CMP #$02
	BNE @delay
	JSR enemies_phrase_double
@delay
	LDA #$3C
	STA game_delay_low
	BNE @timers
@still
	JSR enemies_phrase_load
	LDA #$78
	STA game_delay_low
@timers

	LDA #$20
	STA effects_timer
	LDA #$16
	STA game_state
	LDA #$00
	STA game_delay_high
	BEQ @skip

@dead
	; check for reward
	LDX enemies_position
	LDA enemies_page,X
	CMP #$03
	BCC @enemy
	
	; give player new card here	

@enemy
	LDX #$00
	LDA #$30
@space
	STA string_array,X
	INX
	CPX #$20
	BNE @space
	LDA #$FF
	STA card_shift_timer
	LDA #$00
	STA portrait_filter
	LDA #$01 ; start clearing
	STA portrait_progress
	LDA #$18
	STA game_state
	LDA #$1E
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
	JSR bar_show

	LDA battle_choice_shake
	BEQ @still
	JSR effects_shake
@still

	DEC game_delay_low
	LDA game_delay_low
	CMP #$28
	BNE @next

	; enemy battle choice
	LDX battle_choice_position
	LDA battle_choice_position
	CLC
	ADC #$01
	AND #$07
	STA battle_choice_position
	LDA battle_choice_array,X
	BEQ @next

	; player takes damage
	LDA battle_player_type
	CMP #$06
	BEQ @shield

	LDX battle_choice_shake
@double
	LDA battle_player_health
	SEC
	SBC battle_enemy_attack
	STA battle_player_health
	BCC @check
	DEX
	BNE @double
	BEQ @check

@shield
	; reduce damage with shield
	LDA #$00
	STA effects_timer
	LDA battle_enemy_attack
	LDX battle_player_value
@divide
	SEC
	SBC #$08 ; stop 8x value damage
	BCC @zero
	DEX
	BNE @divide
	BEQ @subtract
@zero
	LDA #$00
@subtract
	STA math_slot_0
	LDA battle_player_health
	SEC
	SBC math_slot_0
	STA battle_player_health

@check
	BCS @alive
	LDA #$00
	STA battle_player_health

	JMP init

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

; shifting cards and going back to waiting
game_function_18
	JSR selector_clear
	JSR card_shift
	JSR card_show
	JSR enemies_draw
	JSR tunnel_still
	JSR bar_show

	DEC game_delay_low
	BNE @skip
	LDA battle_enemy_health
	BEQ @dead
	LDA #$12
	STA game_state
	BNE @skip
@dead
	LDA #$02
	STA game_state
@skip
	RTS

game_function_1A
	RTS
game_function_1C
	RTS
game_function_1E
	RTS

game_function_20
	JSR clear
	JSR title_setup
	JSR title_draw ; internal loop

	LDA title_position
	CMP #$03
	BCC @level

	LDA #$22 ; card exchange
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
	RTS

@level
	LDA #$00 ; start level
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
	RTS

game_function_22
	JSR clear
	JSR exchange_setup
	JSR exchange_draw ; internal loop

	LDA #$20 ; back to title screen
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
	RTS

game_function_24
	RTS
game_function_26
	RTS
game_function_28
	RTS
game_function_2A
	RTS
game_function_2C
	RTS
game_function_2E
	RTS


game_function_table
	.WORD game_function_00 ; run clear and setup functions
	.WORD game_function_02 ; waiting to select card outside battle
	.WORD game_function_04 ; walking tunnel animation
	.WORD game_function_06 ; shifting cards and checking for battle
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

	.WORD game_function_20 ; title screen (with internal loop)
	.WORD game_function_22 ; exchange screen (with internal loop)
	.WORD game_function_24
	.WORD game_function_26
	.WORD game_function_28
	.WORD game_function_2A
	.WORD game_function_2C
	.WORD game_function_2E


