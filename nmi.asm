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

  LDA $2002             ; read PPU status to reset the high/low latch

  LDA refreshBackground
  BEQ ShouldUpdatePalette

  LDY #$00

PartialUpdateLoop:
  ; X - how many bytes to update
  LDX partialUpdateMemory, Y
  BEQ ShouldUpdatePalette
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


ShouldUpdatePalette:
  LDA refreshPalette
  BNE :+
    LDA refreshBackground
    BNE AfterPartialUpdate
    BEQ EndNMI
  :

UpdatePalette:
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDY #$00

UpdatePaletteLoop:
  LDA paletteUpdateMemory, Y
  STA $2007
  INY
  CPY #$20
  BNE UpdatePaletteLoop

AfterPartialUpdate:
  BIT $2002
  LDA #$00
  STA $2005
  STA $2005
  STA refreshBackground
  STA refreshPalette

EndNMI:

  soundengine_update

  ; restore registers
  PLA
  TAY
  PLA
  TAX
  PLA

  RTI
