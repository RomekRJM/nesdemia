RenderHUD:
  LDA #$df
  STA renderedNumberOffset
  LDA playerAttacks
  STA renderedNumber
  JSR RenderPoint

  LDA #$af
  STA renderedNumberOffset
  LDA dashIndex0
  STA renderedNumber
  JSR RenderPoint

  LDA #$b8
  STA renderedNumberOffset
  LDA dashIndex1
  STA renderedNumber
  JSR RenderPoint

  RTS


RenderPoint:
  LDX spriteCounter
  LDY #$00
LoadPointSprites:
  LDA renderedNumber
  CMP #$00
  BNE :+
    LDA Zero, Y
  :
  CMP #$01
  BNE :+
    LDA One, Y
  :
  CMP #$02
  BNE :+
    LDA Two, Y
  :
  CMP #$03
  BNE :+
    LDA Three, Y
  :
  CMP #$04
  BNE :+
    LDA Four, Y
  :
  CMP #$05
  BNE :+
    LDA Five, Y
  :
  CMP #$06
  BNE :+
    LDA Six, Y
  :
  CMP #$07
  BNE :+
    LDA Seven, Y
  :
  CMP #$08
  BNE :+
    LDA Eight, Y
  :
  CMP #$09
  BNE :+
    LDA Nine, Y
  :
  CPY #$03
    BNE :+
    SEC
    SBC renderedNumberOffset
  :
  STA $0200, X
  INX
  INY
  CPY #$04
  BNE LoadPointSprites
  STX spriteCounter
  RTS


InitPoints:
  LDA #$ff
  STA pointIndex0
  RTS

PointsToDecimal:
  INC pointIndex0
  LDX pointIndex0
  CPX #$0a
  BEQ Tens
  RTS

Tens:
  LDX #$00
  STX pointIndex0
  INC pointIndex1
  LDX pointIndex1
  CPX #$0a
  BEQ Hundreds
  RTS

Hundreds:
  LDX #$00
  STX pointIndex1
  INC pointIndex2

End:
  RTS


DashToDecimal:
  LDA #$00
  STA dashIndex1

  LDA #$ff
  STA dashIndex0
  STA $00

DashToDecimalLoop:
  INC dashIndex0
  LDX dashIndex0
  INC $00
  CPX #$0a
  BEQ DashTens
  JMP ContinueDashToDecimalLoop

DashTens:
  LDX #$00
  STX dashIndex0
  INC dashIndex1

ContinueDashToDecimalLoop:
  LDX $00
  CPX playerDashCount
  BNE DashToDecimalLoop
  BCC DashToDecimalLoop

  RTS


UpdateTimer:
  DEC countdownTimer
  LDA countdownTimer
  BNE :+
    LDA #GAME_TIME_UNIT
    STA countdownTimer
    INC refreshBackground
    DEC timeLimit
    DEC timeDigit0
    LDA timeDigit0
    CMP #$ff
    BNE :+
    LDA #$09
    STA timeDigit0
    DEC timeDigit1
  :

  RTS


UpdateWinThreshold:
  INC refreshBackground
  DEC winThreshold
  DEC winThresholdDigit0
  LDA winThresholdDigit0
  CMP #$ff
  BNE :+
  LDA #$09
  STA winThresholdDigit0
  DEC winThresholdDigit1

  RTS
