RenderGameBackground:
  ; reload attribute table
  LDA refreshBackground
  BEQ RenderBackgroundFinished
  LDA #$00
	STA $2000
	STA $2001

  LDA #.LOBYTE(Background)
  STA backgroundPointerLo       ; put the low byte of the address of background into pointer
  LDA #.HIBYTE(Background)
  STA backgroundPointerHi       ; put the high byte of the address into pointer
  LDA #.LOBYTE(BackgroundLLBlack)
  STA backgroundLLPointerLo       ; put the low byte of the address of background's last line into pointer
  LDA #.HIBYTE(BackgroundLLBlack)
  STA backgroundLLPointerHi       ; put the high byte of the address into pointer

  JSR RenderBackground

  JSR LoadGameAttributes

  LDA #$00
  STA $2005
  STA $2005

  LDA #%10010000 ; enable NMI change background to use 2nd chr set of tiles ($0000)
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001

RenderBackgroundFinished:
  LDA #$00
  STA refreshBackground
