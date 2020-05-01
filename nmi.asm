NMI:
  ; reload attribute table
  LDA attributesNeedReloading
  BEQ CopySpriteDataToPPU

  ; Attributes
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$33
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDA #$00
  STA attributesNeedReloading

  LDX #$00

CopyAttributeDataToPPU:
  LDA BEGIN_OF_ATTRIBUTES_MEMORY, X
  STA $2007          ; write to PPU
  INX
  CPX #$41
  BNE CopyAttributeDataToPPU

CopySpriteDataToPPU:
  ; copy sprite data from $0200 => PPU memory for display
  LDA #$02
  STA $4014
  INC frame
  INC nmiTimer
  RTI
