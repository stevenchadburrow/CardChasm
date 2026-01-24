
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


	.ORG $FC00

; 256 bytes of randomized values
random_value_data
	.BYTE $BF,$A9,$14,$D5,$98,$52,$4E,$56,$AB,$80,$EF,$3C,$3F,$97,$89,$35
	.BYTE $05,$3A,$D3,$A0,$68,$25,$21,$00,$92,$8C,$5C,$73,$B8,$55,$4A,$6B
	.BYTE $D2,$23,$65,$E9,$A8,$FA,$9A,$F3,$A3,$FF,$BA,$04,$EB,$90,$71,$8F
	.BYTE $58,$BC,$C9,$44,$ED,$5E,$33,$F5,$2A,$96,$32,$03,$93,$02,$50,$DD
	.BYTE $6D,$39,$1E,$99,$51,$82,$EE,$6F,$D4,$B0,$F7,$0D,$DE,$83,$70,$E7
	.BYTE $C7,$26,$86,$63,$DB,$37,$FC,$A4,$1F,$24,$7D,$4F,$7C,$0E,$B5,$E1
	.BYTE $72,$9D,$77,$6E,$E5,$A6,$9C,$C0,$C1,$1D,$AC,$B6,$15,$B7,$A7,$67
	.BYTE $84,$B3,$3B,$7E,$E2,$87,$17,$59,$38,$4D,$0A,$69,$7A,$C5,$20,$8E
	.BYTE $22,$A2,$16,$10,$F2,$3E,$43,$E6,$53,$D7,$FB,$C3,$DC,$D8,$9F,$49
	.BYTE $28,$BB,$AE,$07,$0B,$2D,$1A,$F0,$B1,$FD,$D9,$9E,$29,$DA,$F9,$27
	.BYTE $7B,$BD,$B2,$2F,$88,$B9,$13,$09,$DF,$EC,$F8,$75,$F4,$CE,$F1,$1B
	.BYTE $41,$D6,$5B,$5D,$C6,$42,$76,$4B,$94,$34,$64,$18,$D1,$E8,$9B,$78
	.BYTE $6C,$19,$AA,$C4,$31,$4C,$CC,$F6,$54,$06,$5A,$EA,$12,$D0,$62,$3D
	.BYTE $8D,$E3,$CF,$95,$C2,$CB,$A1,$01,$2B,$6A,$5F,$2C,$11,$85,$74,$45
	.BYTE $30,$CD,$E0,$FE,$7F,$B4,$60,$A5,$E4,$1C,$AF,$91,$79,$8A,$AD,$47
	.BYTE $66,$08,$36,$BE,$40,$46,$48,$2E,$0F,$8B,$61,$0C,$CA,$81,$C8,$57

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

