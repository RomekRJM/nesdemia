RenderPartialGameBackground:
  LDY #$00

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$9e
  STA partialUpdateMemory, Y
  INY

  LDA timeDigit1
  STA partialUpdateMemory, Y
  INY

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$9f
  STA partialUpdateMemory, Y
  INY

  LDA timeDigit0
  STA partialUpdateMemory, Y
  INY

  LDA #$00
  STA partialUpdateMemory, Y
  INY
