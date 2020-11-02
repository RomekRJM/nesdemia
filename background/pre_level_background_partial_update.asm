RenderPartialPreLevelBackground:
  LDY #$00

  LDA #$00
  STA partialUpdateMemory, Y

  LDA #$01
  STA refreshBackground

  RTS
