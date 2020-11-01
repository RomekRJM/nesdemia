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


; Returns password in mem addresses $00-$06
SavePassword:
  LDA points
.repeat 4
  ROR
.endrepeat
  AND #%00001111
  STA $00

  LDA points
  AND #%00001111
  STA $01

  LDA playerSpeed
  ASL
  AND #%00001110
  STA $02

  LDA playerLuck
  ROR
  ROR
  AND #%00000001
  ORA $02
  STA $02

  LDA playerLuck
  ASL
  ASL
  AND #%00001100
  STA $03

  LDA playerAttack
  ROR
  AND #%00000011
  ORA $03
  STA $03

  LDA playerAttack
.repeat 3
  ASL
.endrepeat
  AND #%00001000
  STA $04

  LDA levelNo
  ROR
  ROR
  AND #%00000111
  ORA $04
  STA $04

  LDA levelNo
  ASL
  ASL
  AND #%00001100
  STA $05

  JSR ComputeControlSum
  STA $08
.repeat 4
  ROR
.endrepeat
  AND #%00000011
  ORA $05
  STA $05

  LDA $08
  AND #%00001111
  STA $06

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

  JSR ComputeControlSum

  CMP $00
  BNE :+
    LDA #$01
    STA passwordValid
  :

  ; INC playerSpeed
  ; INC playerLuck
  ; INC playerAttack

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

  ; test code !
  LDA #$c4
  STA points

  LDA #GAME_TIME_UNIT
  STA countdownTimer

  ; silence all APU channels
  LDX #$00
  STX $4015

  RTS


SlowlyScrollDown:
  LDA frame
  AND #%00000001
  BEQ :+
    LDA #$00
    STA $2005
    LDA creditsScroll
    STA $2005

    LDA creditsScroll
    CMP #$ef
    BCS :+
      INC creditsScroll
    :

    LDA creditsScroll
    CMP #$ef
    BNE :+
      LDA frame
      CMP #$51
      BNE :+
        LDA #$00
        STA creditsScroll
    :

  RTS


; Takes A reg. hex value and converts it to decimal
; hundreds $00, tens $01, ones $02,
; i.e. A = #$c4, $00 == #$01, $01 == #$09, $02 == #$6
Hex2Dec:
  LDX #$00
  STX $00
  STX $01

Hex2DecHundreds:
  CMP #$64
  BCC Hex2DecTens
  INC $00

  SEC
  SBC #$64
  CMP #$64
  BCS Hex2DecHundreds

Hex2DecTens:
  CMP #$0a
  BCC Hex2DecOnes
  INC $01

  SEC
  SBC #$0a
  CMP #$0a
  BCS Hex2DecTens

Hex2DecOnes:
  STA $02
  RTS


; Returns cost of buing next item in A
ComputeCostOfUpgrading:
  LDX currentShopItem
  LDA playerLuck, X
  CLC
  ADC luckBought, X
  STA $00
  DEC $00
  CMP #$08
  BNE :+
    LDA #$00  ; already has max level
    RTS
  :

  LDA #$01
  :
    CLC
    ADC #ATTRIBUTE_COST_INCREASE
    DEC $00
    LDX $00
    BNE :-

  RTS


; Returns control sum for save/load in A
ComputeControlSum:
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

  RTS
