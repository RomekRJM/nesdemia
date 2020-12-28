RenderPartialGameBackground:
  LDY #$00

  JSR RenderLives

  LDA winCondition
  CMP #WIN_BY_SURVIVING
  BEQ ContinueRenderPartialGameBackground

  LDA #$02
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$96
  STA partialUpdateMemory, Y
  INY

  LDA winThresholdDigit1
  STA partialUpdateMemory, Y
  INY

  LDA winThresholdDigit0
  STA partialUpdateMemory, Y
  INY

ContinueRenderPartialGameBackground:
  LDA #$02
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$9d
  STA partialUpdateMemory, Y
  INY

  LDA timeDigit1
  STA partialUpdateMemory, Y
  INY

  LDA timeDigit0
  STA partialUpdateMemory, Y
  INY

  LDA healthUpdated
  BEQ EndRenderPartialGameBackground

  LDA #$23
  STA $00

  LDX health
  CPX #$01
  BCC :+
    LDA #$d2
    STA $01
    LDA #%11111111
    STA $02
    JSR UpdateLungsBackground
  :

  LDX health
  CPX #$02
  BCC :+
    LDA #$db
    STA $01
    LDA #%10101111
    STA $02
    JSR UpdateLungsBackground
  :

  LDX health
  CPX #$03
  BCC :+
    LDA #$db
    STA $01
    LDA #%11111111
    STA $02
    JSR UpdateLungsBackground
  :

  LDX health
  CPX #$04
  BCC :+
    LDA #$e3
    STA $01
    LDA #%11111111
    STA $02
    JSR UpdateLungsBackground
  :


EndRenderPartialGameBackground:
  LDA #$00
  STA healthUpdated
  STA partialUpdateMemory, Y
  INY

  LDA #$01
  STA refreshBackground

  RTS


UpdateLungsBackground:
  LDA #$03
  STA partialUpdateMemory, Y
  INY

  LDA $00
  STA partialUpdateMemory, Y
  INY

  LDA $01
  STA partialUpdateMemory, Y
  INY

  .repeat 3
  LDA $02
  STA partialUpdateMemory, Y
  INY
  .endrepeat

  RTS


RenderLives:
  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$20
  STA partialUpdateMemory, Y
  INY

  LDA #$37
  STA partialUpdateMemory, Y
  INY

  LDA playerLives
  CLC
  ADC #$3c
  CMP #$3c
  BCS :+
    LDA #$3c
  :
  STA partialUpdateMemory, Y
  INY

  RTS
