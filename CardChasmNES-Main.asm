
; main functions for Card Chasm NES, goes in last bank


reset
	; disable irq and decimal mode
	SEI
	CLD

	; set stack pointer
	TXS

	; switch to bank 0
	LDA #$00
	STA $C000

	; disable rendering
	LDA #$00
	STA ppu_ctrl
	STA ppu_mask

; audio initialization
reset_audio
	LDX #$13
@loop
	LDA reset_audio_data,X
	STA $4000,X
	DEX
	BPL @loop
	LDA #$00 ; disable all channels
	STA apu_status ; address $4015
	LDA #$C0 ; disable irq
	STA $4017
	JMP reset_audio_end

; initializing audio registers
reset_audio_data
	.BYTE $30,$08,$00,$00
	.BYTE $30,$08,$00,$00
	.BYTE $80,$00,$00,$00
	.BYTE $30,$00,$00,$00
	.BYTE $00,$00,$00,$00

reset_audio_end

; grab function creation
reset_grabber
	LDA #$AD ; LDAa
	STA grab_func+0
	LDA #$00 ; zero
	STA grab_func+1
	LDA #$00 ; zero
	STA grab_func+2
	LDA #$60 ; RTS
	STA grab_func+3

; randomizer function creation
; current = 5 * previous + 17
reset_randomizer
	LDA #$A5 ; LDAz
	STA rand_func+0
	LDA #<rand_value
	STA rand_func+1
	LDA #$0A ; ASL A
	STA rand_func+2
	LDA #$0A ; ASL A
	STA rand_func+3
	LDA #$18 ; CLC
	STA rand_func+4
	LDA #$65 ; ADCz
	STA rand_func+5
	LDA #<rand_value
	STA rand_func+6
	LDA #$69 ; ADC#
	STA rand_func+7
	LDA #$11 ; 17
	STA rand_func+8
	LDA #$85 ; STAz
	STA rand_func+9
	LDA #<rand_value
	STA rand_func+10
	LDA #$60 ; RTS
	STA rand_func+11

	; make sure randomizer is working
	JSR rand_func
	JSR rand_func
	JSR rand_func

	; check for start+select on startup to reset save data
	JSR buttons
	LDA buttons_value
	AND #$30
	CMP #$30
	BEQ @initial

	; check save file header in ram
	LDX #$00
@check
	LDA save_check,X
	CMP reset_save_check_data,X
	BNE @initial
	INX
	CPX #$08
	BNE @check
	JMP reset_save_jump

	; no save file detected, clear ram
@initial
	LDX #$00
	LDA #$00 ; clear value
@clear
	STA save_check,X
	INX
	BNE @clear

	; add save file header
	LDX #$00
@store
	LDA reset_save_check_data,X
	STA save_check,X
	INX
	CPX #$08
	BNE @store
	
	; store intial deck information
	LDX #$00
@deck
	LDA card_deck_initial_data,X
	STA save_deck,X
	INX
	CPX #$50 ; 80 bytes
	BNE @deck 

	; store initial sideboard information
	LDX #$00
@side
	LDA #$00
	STA save_side,X
	INX
	CPX #$80 ; 128 bytes
	BNE @side

	JMP reset_save_jump

reset_save_check_data
	.BYTE $43,$52,$44,$43,$48,$53,$4D,$FF ; CRDCHSM_

reset_save_jump
	; load cards into deck
	JSR card_deck_load	

	; load cards into sideboard
	JSR card_side_load

; wait for two v-blank flags
reset_wait
	BIT ppu_status
@first
	BIT ppu_status
	BPL @first
@second
	BIT ppu_status
	BPL @second

; reset ppu
reset_ppu
	; reset ppu scroll and sprite size
	LDA #$90
	STA ppu_ctrl
	LDA ppu_status
	LDA #$00
	STA ppu_scroll
	LDA #$00
	STA ppu_scroll

	; trigger oam dma
	LDA #$02
	STA oam_dma

init
	; clear sprites and name/attr tables
	JSR clear

	; start at campsite
	LDA #$20
	STA game_state
	LDA #$00
	STA game_delay_low
	STA game_delay_high
	
	; clear v-blank flag
	LDA #$00
	STA vblank_ready

main
	; wait for v-blank flag
	LDA vblank_ready
	BEQ main

	; clear v-blank flag
	LDA #$00
	STA vblank_ready

	; disable rendering
	LDA #$00
	STA ppu_mask

	; change palettes, name table, and attribute table here

	; set background color and sprite colors
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA #$10
	STA ppu_addr
	LDA background_color
	STA ppu_data
	LDX #$01
@palette_loop
	LDA card_palette_array,X
	STA ppu_data
	INX
	CPX #$10
	BNE @palette_loop

	; set ppu nametable and sprite size
	LDA #$B0
	ORA tunnel_name
	STA ppu_ctrl

	; set ppu scroll
	LDA ppu_status
	LDA effects_scroll
	STA ppu_scroll
	LDA tunnel_scroll
	STA ppu_scroll

	; trigger oam dma
	LDA #$02
	STA oam_dma

	; enable rendering
	LDA #$18
	STA ppu_mask

	; helps randomize
	JSR rand_func

	; store buttons
	JSR buttons

	LDA buttons_value
	CMP #$40 ; B
	BNE @buttons_skip1
	LDA exit_counter
	CLC
	ADC #$02
	STA exit_counter
	CMP #$88 ; how long until transition
	BCC @buttons_skip1
	LDA #$20 ; go to title screen
	STA game_state
@buttons_skip1
	LDA exit_counter
	BEQ @buttons_skip2
	DEC exit_counter
@buttons_skip2

	; do most things here

	; check game state to do what is needed
	JSR game_function

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

	; delay to make look pretty
	LDX #$9C
@wait
	DEX
	BNE @wait

	; set ppu nametable and sprite size
	LDA #$B0
	STA ppu_ctrl

	; set ppu addr (not scroll)
	LDA ppu_status
	LDA #$23
	STA ppu_addr
	LDA #$00
	STA ppu_addr

	; do something fixed here
	; randomize a bit more
	JSR rand_func

	; wait to disable rendering
	LDY #$03
@blank1
	LDX #$28
@blank2
	INX
	BNE @blank2
	DEY
	BNE @blank1

	; disable background
	LDA #$10
	STA ppu_mask

	; short wait for v-reg to be good
	LDX #$18
@blank3
	DEX
	BNE @blank3
	
	; disable everything
	LDA #$00
	STA ppu_mask

	; draw portrait depending on progress
	JSR portrait_draw

	; draw strings depending on portrait
	JSR string_draw

	; loop back
@jump
	JMP main


; clear the screen
clear
	; disable rendering
	LDA #$00
	STA ppu_mask

	; clear pattern tables
	LDY #$00
@pattern_page
	LDA ppu_status
	STY ppu_addr
	LDA #$00
	STA ppu_addr
	LDX #$00
@pattern_byte
	LDA #$00
	STA ppu_data
	INX
	BNE @pattern_byte
	INY
	CPY #$20
	BNE @pattern_page

	; clear palettes
	LDA ppu_status
	LDA #$3F
	STA ppu_addr
	LDA #$00
	STA ppu_addr
	LDX #$08
@palettes
	LDA #$0F ; black/transparent
	STA ppu_data
	LDA #$00 ; dark grey
	STA ppu_data
	LDA #$10 ; light grey
	STA ppu_data
	LDA #$20 ; white 
	STA ppu_data
	DEX
	BNE @palettes

	; clear name table
	LDY #$20
	LDA ppu_status
	STY ppu_addr
	LDA #$00
	STA ppu_addr
	LDX #$00
@nametable1
	LDA #$00 ; first tile
	STA ppu_data
	INX
	BNE @nametable1
	INY
	LDA ppu_status
	STY ppu_addr
	LDA #$00
	STA ppu_addr
	CPY #$24
	BNE @nametable1

	; clear attribute table
	LDA ppu_status
	LDA #$23	
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDX #$40
@attrtable1
	LDA #$00 ; first palette
	STA ppu_data
	DEX
	BNE @attrtable1

	; clear name table
	LDY #$28
	LDA ppu_status
	STY ppu_addr
	LDA #$00
	STA ppu_addr
	LDX #$00
@nametable2
	LDA #$00 ; first tile
	STA ppu_data
	INX
	BNE @nametable2
	INY
	LDA ppu_status
	STY ppu_addr
	LDA #$00
	STA ppu_addr
	CPY #$2C
	BNE @nametable2

	; clear attribute table
	LDA ppu_status
	LDA #$2B
	STA ppu_addr
	LDA #$C0
	STA ppu_addr
	LDX #$40
@attrtable2
	LDA #$00 ; first palette
	STA ppu_data
	DEX
	BNE @attrtable2

	; clear sprites
	LDA #$EF
	LDX #$00
@sprites
	STA oam_page+0,X
	INX
	INX
	INX
	INX
	BNE @sprites

	; reset ppu scroll
	LDA #$90
	STA ppu_ctrl
	LDA ppu_status
	LDA #$00
	STA ppu_scroll
	LDA #$00
	STA ppu_scroll

	; trigger oam dma
	LDA #$02
	STA oam_dma

	; clear out scroll values
	LDA #$00
	STA tunnel_name
	STA tunnel_scroll
	STA effects_scroll

	; clear out background color
	LDA #$0F
	STA background_color

	RTS


; shifts through joy one buttons
; values are reversed!
buttons
	LDA buttons_value
	BNE @skip
	STA buttons_wait
@skip
	LDA #$01
	STA joy_one
	LDA #$00
	STA joy_one
	LDA #$00
	STA buttons_value
	LDX #$08
@loop
	ASL buttons_value
	LDA joy_one
	AND #$01
	ORA buttons_value
	STA buttons_value
	DEX
	BNE @loop
	RTS

; pressing A button
; leaves accumulator with value
buttons_activate
	LDA buttons_value
	AND #$80 ; A
	BEQ @exit
	LDA buttons_wait
	BNE @exit
	LDA #$01
	STA buttons_wait
	LDA #$FF
	RTS
@exit
	LDA #$00
	RTS



