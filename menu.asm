RenderMenuBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$30
  STA $2006             ; write the high byte of $3000 address
  LDA #$00
  STA $2006             ; write the low byte of $3000 address
  LDX #$00
RenderMenuBackgroundLoop0:
  LDA MenuBackground0, X
  STA $2007
  INX
  BNE RenderMenuBackgroundLoop0
  LDX #$00
RenderMenuBackgroundLoop1:
  LDA MenuBackground1, X
  STA $2007
  INX
  BNE RenderMenuBackgroundLoop1
  LDX #$00
RenderMenuBackgroundLoop2:
  LDA MenuBackground2, X
  STA $2007
  INX
  BNE RenderMenuBackgroundLoop2
  LDX #$00
RenderMenuBackgroundLoop3:
  LDA MenuBackground3, X
  STA $2007
  INX
  CPX #$81
  BNE RenderMenuBackgroundLoop3


  LDA #%10000000 ; enable NMI change background to use first chr set of tiles ($0000)
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001
