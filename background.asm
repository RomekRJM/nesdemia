RenderBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $3000 address
  LDA #$00
  STA $2006             ; write the low byte of $3000 address

  LDX #$00            ; start at pointer + 0
  LDY #$00

RenderBackgroundLoop:
  LDA (backgroundPointerLo), y
  STA $2007
  INY
  BNE RenderBackgroundLoopCheck
  INX
  INC backgroundPointerHi
RenderBackgroundLoopCheck:
  CPX #.HIBYTE(960)
  BNE RenderBackgroundLoop
  CPY #.LOBYTE(960)
  BNE RenderBackgroundLoop
  RTS
