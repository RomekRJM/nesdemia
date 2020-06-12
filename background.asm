RenderBackground:
  ; reload attribute table
  LDA attributesNeedReloading
  BEQ RenderBackgroundFinished
  LDA #$00
	STA $2000
	STA $2001

  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  LDX #$00              ; start out at 0
RenderBackgroundLoop0:
  LDA Background0, X
  STA $2007
  INX
  BNE RenderBackgroundLoop0
  LDX #$00
RenderBackgroundLoop1:
  LDA Background1, X
  STA $2007
  INX
  BNE RenderBackgroundLoop1
  LDX #$00
RenderBackgroundLoop2:
  LDA Background2, X
  STA $2007
  INX
  BNE RenderBackgroundLoop2
  LDX #$00
RenderBackgroundLoop3:
  LDA Background3, X
  STA $2007
  INX
  CPX #$81
  BNE RenderBackgroundLoop3

  JSR LoadAttributes

  LDA #%10000000 ; enable NMI change background to use first chr set of tiles ($0000)
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001

RenderBackgroundFinished:
  LDA #$00
  STA attributesNeedReloading
