LoadLevel:
  LDY levelNo
  CPY #$10
  BCS :+
    LDA #.LOBYTE(Level1_16)
    STA $04
    LDA #.HIBYTE(Level1_16)
    STA $05
    JMP ContinueLoadLevel
  :

  LDA #.LOBYTE(Level17_32)
  STA $04
  LDA #.HIBYTE(Level17_32)
  STA $05

  TYA
  SEC
  SBC #$10
  TAY

ContinueLoadLevel:
  LDA #$00
LoadLevelOffset:
  DEY
  BEQ LoadLevelVariables
  CLC
  ADC #$0c ; number of level variables
  JMP LoadLevelOffset

LoadLevelVariables:
  TAY
  LDA ($04), Y
  STA levelNo
  INY
  LDA ($04), Y
  STA winCondition
  INY
  LDA ($04), Y
  STA winThreshold
  INY
  LDA ($04), Y
  STA winThresholdDigit1
  INY
  LDA ($04), Y
  STA winThresholdDigit0
  INY
  LDA ($04), Y
  STA noViruses
  INY
  LDA ($04), Y
  STA smartVirusChance
  INY
  LDA ($04), Y
  STA powerupChance
  INY
  LDA ($04), Y
  STA attackChance
  INY
  LDA ($04), Y
  STA timeLimit
  INY
  LDA ($04), Y
  STA timeDigit1
  INY
  LDA ($04), Y
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
  LDA points
  STA preLevelPoints

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

; Chance for smart virus ( 0 - 8 )

; Chance for powerup ( 0 - 8 )

; Chance for attack ( 0 - chance for powerup )

; Max allowed time ( 1 unit = 256 game frames )

; Time digit 1

; Time digit 0
Level1_16:; no type win  win1 win0 vir  svir puch ach  time ti1  ti0
.byte $01, $00, $05, $00, $05, $01, $00, $ff, $ff, $3c, $06, $00 ; level 1
.byte $02, $03, $03, $00, $03, $02, $00, $10, $ff, $28, $04, $00 ; level 2
.byte $03, $01, $03, $00, $03, $02, $00, $10, $10, $23, $03, $05 ; level 3
.byte $04, $04, $0f, $01, $05, $05, $00, $10, $18, $0f, $01, $05 ; level 4
.byte $05, $02, $02, $00, $02, $01, $08, $07, $07, $23, $03, $05 ; level 5
.byte $06, $00, $05, $00, $05, $01, $00, $00, $00, $3c, $06, $00 ; level 6
.byte $07, $01, $05, $00, $05, $03, $00, $00, $00, $3c, $06, $00 ; level 7
.byte $08, $02, $03, $00, $03, $04, $01, $00, $00, $3c, $06, $00 ; level 8
.byte $09, $03, $02, $00, $02, $05, $00, $00, $00, $3c, $06, $00 ; level 9
.byte $0a, $04, $14, $02, $00, $05, $01, $00, $00, $14, $02, $00 ; level 10
.byte $0b, $00, $06, $00, $06, $06, $01, $00, $00, $37, $05, $05 ; level 11
.byte $0c, $01, $0a, $01, $00, $06, $01, $00, $00, $37, $05, $05 ; level 12
.byte $0d, $02, $06, $00, $06, $07, $01, $00, $00, $37, $05, $05 ; level 13
.byte $0e, $03, $04, $00, $04, $07, $01, $00, $00, $37, $05, $05 ; level 14
.byte $0f, $04, $14, $02, $00, $07, $01, $00, $00, $14, $02, $00 ; level 15
.byte $10, $00, $07, $00, $07, $07, $02, $00, $00, $37, $05, $05 ; level 16

Level17_32:
.byte $11, $01, $0f, $01, $05, $08, $02, $00, $00, $37, $05, $05 ; level 17
.byte $12, $02, $09, $00, $09, $08, $02, $00, $00, $32, $05, $00 ; level 18
.byte $13, $03, $07, $00, $07, $08, $02, $00, $00, $32, $05, $00 ; level 19
.byte $14, $04, $19, $02, $05, $08, $02, $00, $00, $19, $02, $05 ; level 20
.byte $15, $00, $09, $00, $09, $09, $02, $00, $00, $32, $05, $00 ; level 21
.byte $16, $01, $14, $02, $00, $09, $02, $00, $00, $2d, $04, $05 ; level 22
.byte $17, $02, $0c, $01, $02, $09, $02, $00, $00, $2d, $04, $05 ; level 23
.byte $18, $03, $09, $00, $09, $09, $02, $00, $00, $2d, $04, $05 ; level 24
.byte $19, $04, $1e, $03, $00, $09, $02, $00, $00, $1e, $03, $00 ; level 25
.byte $1a, $00, $0a, $01, $00, $09, $02, $00, $00, $28, $04, $00 ; level 26
.byte $1b, $01, $19, $02, $05, $0a, $03, $00, $00, $28, $04, $00 ; level 27
.byte $1c, $02, $0f, $01, $05, $0a, $03, $00, $00, $23, $03, $05 ; level 28
.byte $1d, $03, $0c, $01, $02, $0a, $03, $00, $00, $23, $03, $05 ; level 29
.byte $1e, $04, $23, $03, $05, $0a, $03, $00, $00, $23, $03, $05 ; level 30
.byte $1f, $00, $0b, $01, $01, $0a, $03, $00, $00, $1e, $03, $00 ; level 31
;.byte $20, $01, $1e, $03, $00, $0a, $03, $00, $00, $1e, $03, $00 ; level 32
.byte $20, $00, $05, $00, $05, $01, $00, $ff, $ff, $3c, $06, $00

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

FistAnimatorX:
  .byte $08, $0b, $0e, $0f, $10, $0f, $0e, $0b
  .byte $08, $05, $02, $01, $00, $01, $02, $05

FistAnimatorY:
  .byte $10, $0f, $0e, $0b, $08, $05, $02, $01
  .byte $00, $01, $02, $05, $08, $0b, $0e, $0f

FistWithVaccineAnimatorX:
  .byte $10, $0f, $0e, $0b, $08, $05, $02, $01
  .byte $01, $02, $05, $08, $0b, $0e, $0f, $10

FistWithVaccineAnimatorY:
  .byte $05, $02, $01, $00, $01, $02, $05, $08
  .byte $08, $05, $02, $01, $00, $01, $02, $05
