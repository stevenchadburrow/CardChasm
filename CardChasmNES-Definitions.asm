
; CardChasmNES - Card Building game for the NES using the UxROM mapper


; Values for 'game_state'
; $00 = after 'setup' has run, usual waiting state



; Definitions

; zero page

vblank_ready 			.EQU $00

buttons_value 			.EQU $01
buttons_wait			.EQU $02

math_slot_0 			.EQU $03
math_slot_1 			.EQU $04
math_slot_2				.EQU $05
math_slot_3				.EQU $06

background_color		.EQU $07

game_state				.EQU $08
game_delay_low			.EQU $09
game_delay_high			.EQU $0A
game_jump_low			.EQU $0B
game_jump_high			.EQU $0C

selector_position		.EQU $0D
selector_animation		.EQU $0E

card_address 			.EQU $0F
card_location 			.EQU $10
card_x 					.EQU $11
card_y 					.EQU $12
card_palette 			.EQU $13
card_color1 			.EQU $14
card_color2 			.EQU $15
card_color3 			.EQU $16
card_top_number 		.EQU $17
card_top_symbol 		.EQU $18
card_bottom_number 		.EQU $19
card_bottom_symbol 		.EQU $1A
card_shift_timer		.EQU $1B
card_deck_position		.EQU $1C

enemies_position		.EQU $1D
enemies_max				.EQU $1E

tunnel_location			.EQU $1F
tunnel_table 			.EQU $20
tunnel_shift 			.EQU $21
tunnel_scroll			.EQU $22
tunnel_direction		.EQU $23
tunnel_name 			.EQU $24
tunnel_top 				.EQU $25
tunnel_ceiling_palette	.EQU $26
tunnel_ceiling_color1	.EQU $27
tunnel_ceiling_color2	.EQU $28
tunnel_ceiling_color3	.EQU $29
tunnel_floor_palette 	.EQU $2A
tunnel_floor_color1	 	.EQU $2B
tunnel_floor_color2 	.EQU $2C
tunnel_floor_color3 	.EQU $2D
tunnel_hud_palette		.EQU $2E
tunnel_hud_color1		.EQU $2F
tunnel_hud_color2		.EQU $30
tunnel_hud_color3		.EQU $31
tunnel_movement			.EQU $32

portrait_address 		.EQU $33
portrait_location 		.EQU $34
portrait_x 				.EQU $35
portrait_y 				.EQU $36
portrait_palette 		.EQU $37
portrait_color1 		.EQU $38
portrait_color2 		.EQU $39
portrait_color3 		.EQU $3A
portrait_filter			.EQU $3B
portrait_progress		.EQU $3C
portrait_bar			.EQU $3D

string_location			.EQU $3E
string_x 				.EQU $3F
string_y 				.EQU $40
string_palette			.EQU $41
string_color1			.EQU $42
string_color2			.EQU $43
string_color3			.EQU $44
string_counter			.EQU $45

effects_type			.EQU $46
effects_timer			.EQU $47
effects_scroll			.EQU $48
effects_direction		.EQU $49

bar_location			.EQU $4A
bar_position			.EQU $4B
bar_length				.EQU $4C
bar_value				.EQU $4D

battle_player_type		.EQU $4E ; used card type
battle_player_value		.EQU $4F ; used card value
battle_player_attack	.EQU $50 ; value * multi
battle_player_health	.EQU $51 ; max of #$80
battle_enemy_weakness	.EQU $52 ; card type for double damage
battle_enemy_attack		.EQU $53 ; static value pre-assigned
battle_enemy_multi		.EQU $54 ; damage multiplier
battle_enemy_health		.EQU $55 ; max of #$40
battle_choice_position	.EQU $56 ; position in choice array
battle_choice_shake		.EQU $57 ; shake on enemy turn?


; add more variables here

card_hand_array			.EQU $BE ; uses 4 bytes, cards in hand
card_palette_array		.EQU $C2 ; uses 16 bytes, transferred to $3F10 (sprites)

battle_choice_array		.EQU $D2 ; uses 8 bytes, choices in battle 
battle_phrase_top		.EQU $DA ; uses 8 bytes
battle_phrase_bottom	.EQU $E2 ; uses 8 bytes

grab_func 				.EQU $EA ; uses 4 bytes, grabs from memory
grab_low 				.EQU $EB
grab_high 				.EQU $EC
grab_rts 				.EQU $ED

rand_func 				.EQU $EE ; uses 12 bytes, current = 5 * previous + 17
rand_value 				.EQU $FA ; results from rand_func

dec_array 				.EQU $FB ; uses 4 bytes, results of dec_func
dec_value 				.EQU $FF ; holds original hex value for dec_func


; general memory

oam_page 				.EQU $0200 ; sprite oam data ready for dma

; 40 cards in the deck
card_deck_type			.EQU $0300 
card_deck_color			.EQU $0328
card_deck_number		.EQU $0350
card_deck_symbol		.EQU $0378
card_deck_movement		.EQU $03A0
card_deck_array			.EQU $03C8 ; up to 40 cards in library

enemies_page			.EQU $0400 ; enemies along path

string_array			.EQU $0500 ; uses 128 bytes, 32 bytes above enemy, 96 bytes in hud

; add more variables here

; registers

ppu_ctrl 		.EQU $2000
ppu_mask 		.EQU $2001
ppu_status 		.EQU $2002
ppu_scroll 		.EQU $2005
ppu_addr 		.EQU $2006
ppu_data 		.EQU $2007

apu_pul1_ctrl 	.EQU $4000
apu_pul1_sweep 	.EQU $4001
apu_pul1_timer 	.EQU $4002
apu_pul1_len 	.EQU $4003

apu_pul2_ctrl 	.EQU $4004
apu_pul2_sweep 	.EQU $4005
apu_pul2_timer 	.EQU $4006
apu_pul2_len 	.EQU $4007

apu_tri_ctrl 	.EQU $4008
apu_tri_timer 	.EQU $400A
apu_tri_len 	.EQU $400B

apu_nois_ctrl 	.EQU $400C
apu_nois_timer 	.EQU $400E
apu_nois_len 	.EQU $400F

apu_dmc_ctrl	.EQU $4010
apu_dmc_load 	.EQU $4011
apu_dmc_addr 	.EQU $4012
apu_dmc_len 	.EQU $4013

oam_dma 		.EQU $4014
apu_status 		.EQU $4015
joy_one 		.EQU $4016
apu_frm_cnt		.EQU $4017


; string characters
_0				.EQU $00
_1				.EQU $01
_2				.EQU $02
_3				.EQU $03
_4				.EQU $04
_5				.EQU $05
_6				.EQU $06
_7				.EQU $07
_8				.EQU $08
_9				.EQU $09
_A				.EQU $0A
_B				.EQU $0B
_C				.EQU $0C
_D				.EQU $0D
_E				.EQU $0E
_F				.EQU $0F
_G				.EQU $10
_H				.EQU $11
_I				.EQU $12
_J				.EQU $13
_K				.EQU $14
_L				.EQU $15
_M				.EQU $16
_N				.EQU $17
_O				.EQU $18
_P				.EQU $19
_Q				.EQU $1A
_R				.EQU $1B
_S				.EQU $1C
_T				.EQU $1D
_U				.EQU $1E
_V				.EQU $1F
_W				.EQU $20
_X				.EQU $21
_Y				.EQU $22
_Z				.EQU $23
__				.EQU $30

_period			.EQU $24
_comma			.EQU $25
_exclaim		.EQU $26
_question		.EQU $27
_colon			.EQU $28
_quote			.EQU $29
_minus			.EQU $2A
_plus			.EQU $2B
_left			.EQU $2C
_right			.EQU $2D
_forward		.EQU $2E
_backward		.EQU $2F
_space			.EQU $30

; bank #0

font_data_0 	.EQU $8000

tunnel_data_0 	.EQU $8400

portrait_data_0 .EQU $8800
portrait_data_1 .EQU $8C00
portrait_data_2 .EQU $9000
portrait_data_3 .EQU $9400
portrait_data_4 .EQU $9800
portrait_data_5 .EQU $9C00
portrait_data_6 .EQU $A000
portrait_data_7 .EQU $A400
portrait_data_8 .EQU $A800
portrait_data_9 .EQU $AC00
portrait_data_A .EQU $B000
portrait_data_B .EQU $B400
portrait_data_C .EQU $B800
portrait_data_D .EQU $BC00


