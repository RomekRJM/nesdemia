RenderPartialPreLevelBackground:
  LDX #$00

  JSR RenderPreLevelNo

  JSR RenderPreLevelPassword

  JSR RenderPreLevelDescription

  LDA #$00
  STA partialUpdateMemory, X

  LDA #$01
  STA refreshBackground

  RTS


RenderPreLevelNo:
  LDA levelNo
  JSR Hex2Dec

  LDA #$02
  STA $03 ; how many numbers to write ( Level 1 rather than Level 01)

  LDA $01
  BNE :+
    DEC $03
  :

  LDA $03
  STA partialUpdateMemory, X
  INX

  LDA #$20
  STA partialUpdateMemory, X
  INX

  LDA #$53
  STA partialUpdateMemory, X
  INX

  LDA $01
  BEQ :+
    LDA $00
    STA partialUpdateMemory, X
    INX
  :

  LDA $02
  STA partialUpdateMemory, X
  INX

  RTS


RenderPreLevelPassword:
  LDA #$0e
  STA partialUpdateMemory, X
  INX

  LDA #$22
  STA partialUpdateMemory, X
  INX

  LDA #$2a
  STA partialUpdateMemory, X
  INX

  TXA
  PHA
  JSR SavePassword
  PLA
  TAX

  LDY #$00
  :
    LDA $00, Y
    STA partialUpdateMemory, X
    INX

    LDA #$88
    STA partialUpdateMemory, X
    INX

    INY
    CPY #$07
    BNE :-

  RTS


RenderPreLevelDescription:
  LDA winCondition

  CMP #$00
  BNE :+
    LDA #.LOBYTE(BackgroundLLPils)
    STA $00
    LDA #.HIBYTE(BackgroundLLPils)
    STA $01
    JMP WriteWinThreshold
  :
  CMP #$01
  BNE :+
    LDA #.LOBYTE(BackgroundLLViruses)
    STA $00
    LDA #.HIBYTE(BackgroundLLViruses)
    STA $01
    JMP WriteWinThreshold
  :
  CMP #$02
  BNE :+
    LDA #.LOBYTE(BackgroundLLSmartViruses)
    STA $00
    LDA #.HIBYTE(BackgroundLLSmartViruses)
    STA $01
    JMP WriteWinThreshold
  :
  CMP #$03
  BNE :+
    LDA #.LOBYTE(BackgroundLLUsePowerups)
    STA $00
    LDA #.HIBYTE(BackgroundLLUsePowerups)
    STA $01
    JMP WriteWinThreshold
  :
  CMP #$04
  BNE :+
    LDA #.LOBYTE(BackgroundLLSurvive)
    STA $00
    LDA #.HIBYTE(BackgroundLLSurvive)
    STA $01

WriteWinThreshold:
  LDA #$16
  STA partialUpdateMemory, X
  INX

  LDA #$21
  STA partialUpdateMemory, X
  INX

  LDA #$02
  STA partialUpdateMemory, X
  INX

  LDY #$00
WriteWinThresholdLoop:
  LDA ($00), Y
  CMP #$27
  BNE :+
    LDA #$88
  :
  STA partialUpdateMemory, X
  INX

  INY
  CPY #$16
  BNE WriteWinThresholdLoop

  LDA #$03
  STA $03

  TXA
  PHA
  LDA winThreshold
  JSR Hex2Dec
  PLA
  TAX

  LDA $01
  BNE :+
    DEC $03
  :

  LDA $03
  STA partialUpdateMemory, X
  INX

  LDA #$21
  STA partialUpdateMemory, X
  INX

  LDA #$18
  STA partialUpdateMemory, X
  INX

  LDA #$34
  STA partialUpdateMemory, X
  INX

  LDA $01
  BEQ :+
    LDA $01
    STA partialUpdateMemory, X
    INX
  :

  LDA $02
  STA partialUpdateMemory, X
  INX

  RTS
