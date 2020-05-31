RenderPoints:
  LDA #$00
  STA pointIndexOffset
  LDA pointIndex0
  STA currentPointIndex
  JSR RenderPoint

  LDA #$09
  STA pointIndexOffset
  LDA pointIndex1
  STA currentPointIndex
  JSR RenderPoint

  LDA #$12
  STA pointIndexOffset
  LDA pointIndex2
  STA currentPointIndex
  JSR RenderPoint

  LDA #$df
  STA pointIndexOffset
  LDA playerAttacks
  STA currentPointIndex
  JSR RenderPoint

  RTS


RenderPoint:
  LDX spriteCounter
  LDY #$00
LoadPointSprites:
  LDA currentPointIndex
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
    SBC pointIndexOffset
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
