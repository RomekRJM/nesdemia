NextRandomByte:
  LDA randomByte
  ROL
  ROL
  CLC
  ADC randomByte
  CLC
  ADC #$17
  STA randomByte
  RTS

NextRandom3Bits:
  JSR NextRandomByte
  AND #%00000111
  RTS

NextRandom6Bits:
  JSR NextRandomByte
  AND #%01111111
  RTS

NextRandom7Bits:
  JSR NextRandomByte
  AND #%01111111
  RTS

NextRandomBool:
  JSR NextRandomByte
  AND #%00000001
  RTS

NextRandom1or2:
  JSR NextRandomByte
  CMP #$7f
  BCC :+
    LDA #$01
    RTS
  :
  LDA #$02
  RTS

NextRandom128To255:
  JSR NextRandom7Bits
  CLC
  ADC #$7F
  RTS

NextRandom16To206:
  JSR NextRandom7Bits
  STA $00
  JSR NextRandom6Bits
  CLC
  ADC $00
  CMP #$20
  BCS :+
    CLC
    ADC #$20
  :
  CMP #$C8
  BCC :+
    SEC
    SBC #$20
  :

  RTS

InitVariables:
  LDA #$00
  STA gameRendered
  STA gameEndRendered
  STA health
  STA playerAttacks
  STA playerInvincible
  STA playerDashCount
  STA playerDashing

  LDA #$01
  STA nmiTimer
  STA refreshBackground

  LDA #$c0
  STA resetCounter

  LDA #$80
  STA playerTop
  STA playerLeft

  LDA #GAME_TIME_UNIT
  STA countdownTimer

  RTS
