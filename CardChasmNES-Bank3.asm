
; CardChasmNES - Card Building game for the NES using the UxROM mapper

	.INCSRC CardChasmNES-Definitions.asm

	; last bank always at $C000 to $FFFF
	.ORG $C000

	.INCSRC CardChasmNES-Main.asm

	.INCSRC CardChasmNES-Setup.asm

	.INCSRC CardChasmNES-Cards.asm

	.INCSRC CardChasmNES-Enemies.asm

	.INCSRC CardChasmNES-Tunnel.asm

	.INCSRC CardChasmNES-Portrait.asm

	.INCSRC CardChasmNES-Effects.asm

	.INCSRC CardChasmNES-String.asm

	.INCSRC CardChasmNES-Game.asm


	.ORG $FD00

; 512 bytes of tunnel name table data
tunnel_draw_name_data
	.BYTE $00,$01,$00,$01, $00,$01,$00,$01, $02,$03,$04,$05, $04,$05,$04,$05
	.BYTE $04,$05,$04,$05, $04,$05,$06,$07, $0E,$0F,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$10,$11, $12,$13,$14,$15, $14,$15,$14,$15
	.BYTE $14,$15,$14,$15, $14,$15,$16,$17, $1E,$1F,$1E,$1F, $1E,$1F,$1E,$1F

	.BYTE $00,$01,$00,$01, $00,$01,$00,$01, $00,$01,$02,$03, $04,$05,$04,$05
	.BYTE $04,$05,$04,$05, $06,$07,$0E,$0F, $0E,$0F,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$10,$11, $10,$11,$12,$13, $14,$15,$14,$15
	.BYTE $14,$15,$14,$15, $16,$17,$1E,$1F, $1E,$1F,$1E,$1F, $1E,$1F,$1E,$1F

	; repeat 6 times
	.BYTE $00,$01,$00,$01, $00,$01,$00,$01, $00,$01,$00,$01, $FF,$FF,$FF,$FF
	.BYTE $FF,$FF,$FF,$FF, $0E,$0F,$0E,$0F, $0E,$0F,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$10,$11, $10,$11,$10,$11, $FF,$FF,$FF,$FF
	.BYTE $FF,$FF,$FF,$FF, $1E,$1F,$1E,$1F, $1E,$1F,$1E,$1F, $1E,$1F,$1E,$1F

	.BYTE $00,$01,$00,$01, $00,$01,$00,$01, $00,$01,$08,$09, $0A,$0B,$0A,$0B
	.BYTE $0A,$0B,$0A,$0B, $0C,$0D,$0E,$0F, $0E,$0F,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$10,$11, $10,$11,$18,$19, $1A,$1B,$1A,$1B
	.BYTE $1A,$1B,$1A,$1B, $1C,$1D,$1E,$1F, $1E,$1F,$1E,$1F, $1E,$1F,$1E,$1F

	.BYTE $00,$01,$00,$01, $00,$01,$00,$01, $08,$09,$0A,$0B, $0A,$0B,$0A,$0B
	.BYTE $0A,$0B,$0A,$0B, $0A,$0B,$0C,$0D, $0E,$0F,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$10,$11, $18,$19,$1A,$1B, $1A,$1B,$1A,$1B
	.BYTE $1A,$1B,$1A,$1B, $1A,$1B,$1C,$1D, $1E,$1F,$1E,$1F, $1E,$1F,$1E,$1F

	.BYTE $00,$01,$00,$01, $00,$01,$08,$09, $0A,$0B,$0A,$0B, $0A,$0B,$0A,$0B
	.BYTE $0A,$0B,$0A,$0B, $0A,$0B,$0A,$0B, $0C,$0D,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$18,$19, $1A,$1B,$1A,$1B, $1A,$1B,$1A,$1B
	.BYTE $1A,$1B,$1A,$1B, $1A,$1B,$1A,$1B, $1C,$1D,$1E,$1F, $1E,$1F,$1E,$1F

	.BYTE $00,$01,$00,$01, $08,$09,$0A,$0B, $0A,$0B,$0A,$0B, $0A,$0B,$0A,$0B
	.BYTE $0A,$0B,$0A,$0B, $0A,$0B,$0A,$0B, $0A,$0B,$0C,$0D, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $18,$19,$1A,$1B, $1A,$1B,$1A,$1B, $1A,$1B,$1A,$1B
	.BYTE $1A,$1B,$1A,$1B, $1A,$1B,$1A,$1B, $1A,$1B,$1C,$1D, $1E,$1F,$1E,$1F
	
	; 128 bytes of $FF

	.BYTE $00,$01,$00,$01, $00,$01,$02,$03, $04,$05,$04,$05, $04,$05,$04,$05
	.BYTE $04,$05,$04,$05, $04,$05,$04,$05, $06,$07,$0E,$0F, $0E,$0F,$0E,$0F
	.BYTE $10,$11,$10,$11, $10,$11,$12,$13, $14,$15,$14,$15, $14,$15,$14,$15
	.BYTE $14,$15,$14,$15, $14,$15,$14,$15, $16,$17,$1E,$1F, $1E,$1F,$1E,$1F


	.ORG $FF00

; interrupts

nmi
	INC vblank_ready
	RTI
	
irq
	RTI

; vectors

	.ORG $FFFA

	.WORD nmi
	.WORD reset
	.WORD irq

