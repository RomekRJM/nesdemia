LoadLevel:
  LDA #$00
  LDX levelNo
LoadLevelOffset:
  DEX
  BEQ LoadLevelVariables
  CLC
  ADC #$0c ; number of level variables
  JMP LoadLevelOffset

LoadLevelVariables:
  TAX
  LDA Level, X
  STA levelNo
  INX
  LDA Level, X
  STA winCondition
  INX
  LDA Level, X
  STA winThreshold
  INX
  LDA Level, X
  STA winThresholdDigit1
  INX
  LDA Level, X
  STA winThresholdDigit0
  INX
  LDA Level, X
  STA noViruses
  INX
  LDA Level, X
  STA smartVirusChance
  INX
  LDA Level, X
  STA powerupChance
  INX
  LDA Level, X
  STA attackChance
  INX
  LDA Level, X
  STA timeLimit
  INX
  LDA Level, X
  STA timeDigit1
  INX
  LDA Level, X
  STA timeDigit0

  RTS


CheckWinCondition:
  LDX winCondition
  CPX #$04
  BNE :+
    LDA timeLimit
    BEQ RoundWon
    BNE EndCheckWinCondition
  :

  LDA timeLimit
  BNE :+
    LDA #$01
    STA initReset
  :

  LDX winThreshold
  BNE EndCheckWinCondition

RoundWon:
  LDA #LEVEL_COMPLETED_MODE
  STA gameMode
  LDA #$01
  STA initNextLevel

EndCheckWinCondition:
  RTS

.segment "RODATA"
; Level number ( can be used to look up description )

; What needs to be done to win
; 0 - gather x pills
; 1 - kill x viruses ( of any type )
; 2 - kill x smart viruses
; 3 - use x powerups
; 4 - survive till the end of the level

; Win threshold ( has to be equal to Max allowed time in survive time mode)

; Win threshold digit 1

; Win threshold digit 0

; Number of virues ( 1 - 11 )

; Chance for smart virus ( 0 - number of viruses )

; Chance for powerup ( 0 - 8 )

; Chance for attack ( 0 - chance for powerup )

; Max allowed time ( 1 unit = 256 game frames )

; Time digit 1

; Time digit 0
Level:; no   type win  win1 win0 vir  svir puch ach  time ti1  ti0
  .byte $01, $00, $00, $05, $01, $01, $01, $01, $3c, $00, $3c ; level 1
  .byte $02, $03, $00, $01, $06, $01, $07, $03, $60, $06, $60 ; level 2
  .byte $03, $04, $09, $04, $09, $02, $07, $03, $5e, $04, $5e ; level 3
  .byte $04, $00, $00, $06, $0b, $02, $07, $03, $5c, $02, $5c ; level 4
  .byte $05, $01, $00, $05, $0b, $02, $07, $03, $5a, $00, $5a ; level 5
  .byte $06, $02, $00, $06, $0b, $02, $07, $03, $58, $08, $58 ; level 6
  .byte $07, $03, $00, $03, $0b, $02, $07, $03, $56, $06, $56 ; level 7
  .byte $08, $04, $08, $04, $0b, $02, $07, $03, $54, $04, $54 ; level 8
  .byte $09, $00, $00, $07, $0b, $02, $06, $03, $52, $02, $52 ; level 9
  .byte $0a, $01, $01, $00, $0b, $02, $06, $03, $50, $00, $50 ; level 10
  .byte $0b, $02, $00, $09, $0b, $02, $06, $03, $4e, $08, $4e ; level 11
  .byte $0c, $03, $00, $06, $0b, $02, $06, $03, $4c, $06, $4c ; level 12
  .byte $0d, $04, $07, $04, $0b, $02, $06, $03, $4a, $04, $4a ; level 13
  .byte $0e, $00, $00, $08, $0b, $02, $06, $03, $48, $02, $48 ; level 14
  .byte $0f, $01, $01, $05, $0b, $02, $06, $03, $46, $00, $46 ; level 15
  .byte $10, $02, $01, $02, $0b, $02, $06, $03, $44, $08, $44 ; level 16
  .byte $11, $03, $00, $08, $0b, $02, $05, $02, $42, $06, $42 ; level 17
  .byte $12, $04, $06, $04, $0b, $02, $05, $02, $40, $04, $40 ; level 18
  .byte $13, $00, $00, $09, $0b, $02, $05, $02, $3e, $02, $3e ; level 19
  .byte $14, $01, $02, $00, $0b, $02, $05, $02, $3c, $00, $3c ; level 20
  .byte $15, $02, $01, $05, $0b, $02, $05, $02, $3a, $08, $3a ; level 21
  .byte $16, $03, $01, $01, $0b, $02, $05, $02, $38, $06, $38 ; level 22
  .byte $17, $04, $05, $04, $0b, $02, $05, $02, $36, $04, $36 ; level 23
  .byte $18, $00, $01, $01, $0b, $02, $05, $02, $34, $02, $34 ; level 24
  .byte $19, $01, $02, $05, $0b, $02, $04, $02, $32, $00, $32 ; level 25
  .byte $1a, $02, $01, $08, $0b, $02, $04, $02, $30, $08, $30 ; level 26
  .byte $1b, $03, $01, $03, $0b, $02, $04, $02, $2e, $06, $2e ; level 27
  .byte $1c, $04, $04, $04, $0b, $02, $04, $02, $2c, $04, $2c ; level 28
  .byte $1d, $00, $01, $02, $0b, $02, $04, $02, $2a, $02, $2a ; level 29
  .byte $1e, $01, $03, $00, $0b, $02, $04, $02, $28, $00, $28 ; level 30
  .byte $1f, $02, $02, $01, $0b, $02, $04, $02, $26, $08, $26 ; level 31
  .byte $20, $03, $01, $06, $0b, $02, $04, $02, $24, $06, $24 ; level 32


LuckLevelGivingDash:
  2.byte $16, $14, $12, $10, $0e, $0c, $0a, $08

LuckLevelGivingAttack:
  .byte $1b, $1a, $19, $18, $17, $16, $15, $14

AttackLevelDuration:
  .byte $73, $87, $9b, $af, $c3, $d7, $eb, $ff

SpeedLevel:
  .byte $01, $01, $01, $00
  .byte $01, $01, $01, $01
  .byte $01, $01, $02, $01
  .byte $01, $02, $02, $01
  .byte $02, $02, $02, $01
  .byte $02, $02, $02, $02
  .byte $02, $03, $02, $02
  .byte $02, $03, $03, $02
  .byte $03, $03, $03, $02
  .byte $03, $03, $03, $03
  .byte $03, $04, $03, $03
  .byte $03, $04, $04, $03
  .byte $04, $04, $04, $03
  .byte $04, $04, $04, $04

DiagonalSpeedLevel:
  .byte $01, $00, $01, $01, $00, $01, $01, $01
  .byte $01, $01, $01, $01, $01, $01, $00, $00
  .byte $01, $01, $01, $01, $01, $01, $01, $01
  .byte $02, $01, $01, $01, $01, $02, $01, $01
  .byte $02, $01, $01, $02, $02, $01, $01, $02
  .byte $02, $01, $01, $02, $02, $01, $01, $02
  .byte $02, $01, $01, $02, $02, $02, $02, $02
  .byte $02, $02, $02, $02, $02, $02, $02, $02
  .byte $03, $02, $02, $02, $02, $03, $02, $02
  .byte $03, $02, $02, $03, $03, $02, $02, $03
  .byte $03, $02, $02, $03, $03, $02, $02, $03
  .byte $03, $02, $02, $03, $03, $03, $03, $03
  .byte $03, $03, $03, $03, $03, $03, $03, $03
  .byte $04, $03, $03, $03, $03, $04, $03, $03

SpeedIndex:
  .byte $00, $04, $08, $0c, $10, $14, $18, $1c, $20, $24, $28, $2c, $30, $34

DiagonalSpeedIndex:
  .byte $00, $08, $10, $18, $20, $28, $30, $38, $40, $48, $50, $58, $60, $68
