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

  LDA healthUpdated
  BEQ EndRenderPartialGameBackground

  LDA #$23
  STA $00

  LDX health
  CPX #$01
  BNE :+
    LDA #$d2
    STA $01
    LDA #%11111111
    STA $02
  :

  LDX health
  CPX #$02
  BNE :+
    LDA #$db
    STA $01
    LDA #%10101111
    STA $02
  :

  LDX health
  CPX #$03
  BNE :+
    LDA #$db
    STA $01
    LDA #%11111111
    STA $02
  :

  LDX health
  CPX #$04
  BNE :+
    LDA #$e3
    STA $01
    LDA #%11111111
    STA $02
  :

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

EndRenderPartialGameBackground:
  LDA #$00
  STA healthUpdated
  STA partialUpdateMemory, Y
  INY
