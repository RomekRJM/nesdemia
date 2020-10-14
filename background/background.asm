RenderBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA ppuHigh
  STA $2006             ; write the high byte of $2000 address
  LDA ppuLow
  STA $2006             ; write the low byte of $2000 address

  LDX #$00            ; start at pointer + 0
  LDY #$00

RenderBackgroundLoop:
  LDA (backgroundPointerLo), Y
  STA $2007
  INY
  BNE RenderBackgroundLoopCheck
  INX
  INC backgroundPointerHi
RenderBackgroundLoopCheck:
  CPX #.HIBYTE(896)
  BNE RenderBackgroundLoop
  CPY #.LOBYTE(896)
  BNE RenderBackgroundLoop

  LDY #$00
  LDX #$40
RenderBackgroundLastLinesLoop:
  DEX
  LDA (backgroundLLPointerLo), Y
  STA $2007
  INY
  TXA
  BNE RenderBackgroundLastLinesLoop
  RTS
