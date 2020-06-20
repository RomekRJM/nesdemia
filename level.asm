LoadLevel:
  LDA #$00
  LDX levelNo
LoadLevelOffset:
  DEX
  BEQ LoadLevelVariables
  CLC
  ADC #$08 ; number of level variables
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
  STA timeLimit
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

  RTS


CheckWinCondition:
  LDX winCondition
  CPX #$00
  BNE :+
    LDA points
    CMP winThreshold
    BNE EndCheckWinCondition
    BEQ RoundWon
  :
  CPX #$01
  BNE :+
    LDA kills
    CMP winThreshold
    BNE EndCheckWinCondition
    BEQ RoundWon
  :
  CPX #$02
  BNE :+
    LDA smartKills
    CMP winThreshold
    BNE EndCheckWinCondition
    BEQ RoundWon
  :
  CPX #$03
  BNE :+
    LDA usedPowerups
    CMP winThreshold
    BNE EndCheckWinCondition
    BEQ RoundWon
  :
  CPX #$04
  BNE :+
    LDA timeLimit
    BEQ RoundWon
    BNE EndCheckWinCondition
  :

RoundWon:
  LDA #GAME_COMPLETED_MODE
  STA gameMode
  LDA #$01
  STA initReset

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

; Points reqired to win

; Max allowed time ( 1 unit = 256 game frames )

; Number of virues ( 1 - 11 )

; Chance for smart virus ( 0 - number of viruses )

; Chance for powerup ( 0 - 8 )

; Chance for attack ( 0 - chance for powerup )
Level:
  .byte $01, $00, $03, $10, $01, $00, $03, $01  ; 1st level
