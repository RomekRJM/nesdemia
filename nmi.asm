NMI:
  ; back up registers
  PHA
  TXA
  PHA
  TYA
  PHA

  ; copy sprite data from $0200 => PPU memory for display
  LDA #$02
  STA $4014

  INC frame
  INC nmiTimer

  LDA refreshBackground
  BEQ EndNMI

  LDA $2002             ; read PPU status to reset the high/low latch
  LDY #$00

PartialUpdateLoop:
  ; X - how many bytes to update
  LDX partialUpdateMemory, Y
  BEQ AfterPartialUpdate
  INY

  ; High / Low bytes of PPU address
  .repeat 2
  LDA partialUpdateMemory, Y
  STA $2006
  INY
  .endrepeat

PartialUpdateInnerLoop:
  LDA partialUpdateMemory, Y
  STA $2007
  INY
  DEX
  BNE PartialUpdateInnerLoop
  JMP PartialUpdateLoop

AfterPartialUpdate:
  BIT $2002
  LDA #$00
  STA $2005
  STA $2005
  STA refreshBackground

EndNMI:
  ; restore registers
  PLA
  TAY
  PLA
  TAX
  PLA

  RTI
