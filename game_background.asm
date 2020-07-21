RenderGameBackground:
  LDA #$00
	STA $2000
	STA $2001

  LDA #.LOBYTE(Background)
  STA backgroundPointerLo       ; put the low byte of the address of background into pointer
  LDA #.HIBYTE(Background)
  STA backgroundPointerHi       ; put the high byte of the address into pointer

  LDA winCondition

  CMP #$00
  BNE :+
    LDX #.LOBYTE(BackgroundLLPils)
    LDY #.HIBYTE(BackgroundLLPils)
    JMP AssignLL
  :
  CMP #$01
  BNE :+
    LDX #.LOBYTE(BackgroundLLViruses)
    LDY #.HIBYTE(BackgroundLLViruses)
    JMP AssignLL
  :
  CMP #$02
  BNE :+
    LDX #.LOBYTE(BackgroundLLSmartViruses)
    LDY #.HIBYTE(BackgroundLLSmartViruses)
    JMP AssignLL
  :
  CMP #$03
  BNE :+
    LDX #.LOBYTE(BackgroundLLUsePowerups)
    LDY #.HIBYTE(BackgroundLLUsePowerups)
    JMP AssignLL
  :
  CMP #$04
  BNE :+
    LDX #.LOBYTE(BackgroundLLSurvive)
    LDY #.HIBYTE(BackgroundLLSurvive)
  :

AssignLL:
  STX LastLinesTextLo
  STY LastLinesTextHi

  LDY #$16

  LDA winCondition
  CMP #WIN_BY_SURVIVING
  BNE :+
    .repeat 2
    LDA #$27 ; whitespace
    STA $00, Y
    INY
    .endrepeat
    JMP ContinueOnLL
  :

  LDA winThresholdDigit1
  STA $00, Y
  INY
  LDA winThresholdDigit0
  STA $00, Y
  INY

ContinueOnLL:
  .repeat 5
  LDA #$27 ; whitespace
  STA $00, Y
  INY
  .endrepeat

  LDA #$1D ; T
  STA $00, Y
  INY
  LDA timeDigit1
  STA $00, Y
  INY
  LDA timeDigit0
  STA $00, Y

  LDY #$00
PopulateSecondToLastLinesLoop:
  LDA $00, Y
  CPY #$16
  BCS :+
    LDA (LastLinesTextLo), Y
  :
  STA backgroundLastLinesTmp, Y
  INY
  CPY #$20
  BNE PopulateSecondToLastLinesLoop

  ; populate last line of footer
  .repeat 32
  LDA #$27 ; whitespace
  STA backgroundLastLinesTmp, Y
  INY
  .endrepeat

  LDA #.LOBYTE(backgroundLastLinesTmp)
  STA backgroundLLPointerLo       ; put the low byte of the address of background's last line into pointer
  LDA #.HIBYTE(backgroundLastLinesTmp)
  STA backgroundLLPointerHi       ; put the high byte of the address into pointer

  JSR RenderBackground

  JSR LoadGameAttributes

  LDA #$00
  STA $2005
  STA $2005

  LDA #%10010000 ; enable NMI change background to use 2nd chr set of tiles ($0000)
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001
