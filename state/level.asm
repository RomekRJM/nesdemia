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
  .byte $01, $00, $05, $00, $05, $01, $01, $01, $01, $3c, $06, $00 ; level 1
  .byte $02, $03, $01, $00, $01, $06, $01, $07, $03, $60, $09, $06 ; level 2
  .byte $03, $04, $5e, $09, $04, $09, $02, $07, $03, $5e, $09, $04 ; level 3
  .byte $04, $00, $06, $00, $06, $0b, $02, $07, $03, $5c, $09, $02 ; level 4
  .byte $05, $01, $05, $00, $05, $0b, $02, $07, $03, $5a, $09, $00 ; level 5
  .byte $06, $02, $06, $00, $06, $0b, $02, $07, $03, $58, $08, $08 ; level 6
  .byte $07, $03, $03, $00, $03, $0b, $02, $07, $03, $56, $08, $06 ; level 7
  .byte $08, $04, $54, $08, $04, $0b, $02, $07, $03, $54, $08, $04 ; level 8
  .byte $09, $00, $07, $00, $07, $0b, $02, $06, $03, $52, $08, $02 ; level 9
  .byte $0a, $01, $0a, $01, $00, $0b, $02, $06, $03, $50, $08, $00 ; level 10
  .byte $0b, $02, $09, $00, $09, $0b, $02, $06, $03, $4e, $07, $08 ; level 11
  .byte $0c, $03, $06, $00, $06, $0b, $02, $06, $03, $4c, $07, $06 ; level 12
  .byte $0d, $04, $4a, $07, $04, $0b, $02, $06, $03, $4a, $07, $04 ; level 13
  .byte $0e, $00, $08, $00, $08, $0b, $02, $06, $03, $48, $07, $02 ; level 14
  .byte $0f, $01, $0f, $01, $05, $0b, $02, $06, $03, $46, $07, $00 ; level 15
  .byte $10, $02, $0c, $01, $02, $0b, $02, $06, $03, $44, $06, $08 ; level 16
  .byte $11, $03, $08, $00, $08, $0b, $02, $05, $02, $42, $06, $06 ; level 17
  .byte $12, $04, $40, $06, $04, $0b, $02, $05, $02, $40, $06, $04 ; level 18
  .byte $13, $00, $09, $00, $09, $0b, $02, $05, $02, $3e, $06, $02 ; level 19
  .byte $14, $01, $14, $02, $00, $0b, $02, $05, $02, $3c, $06, $00 ; level 20
  .byte $15, $02, $0f, $01, $05, $0b, $02, $05, $02, $3a, $05, $08 ; level 21
  .byte $16, $03, $0b, $01, $01, $0b, $02, $05, $02, $38, $05, $06 ; level 22
  .byte $17, $04, $36, $05, $04, $0b, $02, $05, $02, $36, $05, $04 ; level 23
  .byte $18, $00, $0b, $01, $01, $0b, $02, $05, $02, $34, $05, $02 ; level 24
  .byte $19, $01, $19, $02, $05, $0b, $02, $04, $02, $32, $05, $00 ; level 25
  .byte $1a, $02, $12, $01, $08, $0b, $02, $04, $02, $30, $04, $08 ; level 26
  .byte $1b, $03, $0d, $01, $03, $0b, $02, $04, $02, $2e, $04, $06 ; level 27
  .byte $1c, $04, $2c, $04, $04, $0b, $02, $04, $02, $2c, $04, $04 ; level 28
  .byte $1d, $00, $0c, $01, $02, $0b, $02, $04, $02, $2a, $04, $02 ; level 29
  .byte $1e, $01, $1e, $03, $00, $0b, $02, $04, $02, $28, $04, $00 ; level 30
  .byte $1f, $02, $15, $02, $01, $0b, $02, $04, $02, $26, $03, $08 ; level 31
  .byte $20, $03, $10, $01, $06, $0b, $02, $04, $02, $24, $03, $06 ; level 32

LuckLevelGivingDash:
  .byte $16, $14, $12, $10, $0e, $0c, $0a, $08

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
