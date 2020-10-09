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


LoadPassword:
  LDX #$00
  STX passwordValid
  LDA passwordArray, X

  ASL
  ASL
  ASL
  ASL
  STA $00
  INX

  LDA passwordArray, X
  ORA $00
  STA points
  INX


  LDA passwordArray, X
  LSR
  STA playerSpeed

  LDA passwordArray, X
  AND #%00000001
  ASL
  ASL
  STA $00
  INX
  LDA passwordArray, X
  LSR
  LSR
  ORA $00
  STA playerLuck

  LDA passwordArray, X
  ASL
  AND #%00000110
  STA $00
  INX
  LDA passwordArray, X
  LSR
  LSR
  LSR
  ORA $00
  STA playerAttack

  LDA passwordArray, X
  AND #%00000111
  ASL
  ASL
  STA $00
  INX
  LDA passwordArray, X
  LSR
  LSR
  ORA $00
  STA levelNo

  LDA passwordArray, X
  AND #%00000011
  ASL
  ASL
  ASL
  ASL
  STA $00
  INX
  LDA passwordArray, X
  ORA $00
  ; control sum
  STA $00

  LDA points
  CLC
  ADC playerSpeed
  CLC
  ADC playerLuck
  CLC
  ADC playerAttack
  CLC
  ADC levelNo
  AND #%00111111

  CMP $00
  BNE :+
    LDA #$01
    STA passwordValid
  :

  INC playerSpeed
  INC playerLuck
  INC playerAttack

  JSR InitPoints
  LDA points
  BEQ EndLoadPassword
  STA $00
  INC $00

  :
    JSR PointsToDecimal
    DEC $00
    LDA $00
  BNE :-

EndLoadPassword:
  RTS


InitVariables:
  LDA #$00
  STA gameRendered
  STA gameEndRendered
  STA creditsRendered
  STA mainMenuRendered
  STA passwordRendered
  STA health
  STA playerAttacks
  STA playerInvincible
  STA playerDashCount
  STA playerDashing
  STA passwordValid

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

  ; silence all APU channels
  LDX #$00
  STX $4015

  RTS
