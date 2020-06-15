LoadMenuAttributes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$00              ; start out at 0

LoadMenuAttributesLoop:
  LDA MenuAttribute, X
  STA $2007
  INX
  CPX #$40
  BNE LoadMenuAttributesLoop
  RTS
