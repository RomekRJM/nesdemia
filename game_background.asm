RenderGameBackground:
  ; reload attribute table
  LDA refreshBackground
  BEQ RenderBackgroundFinished
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
  STX lastLineTextLo
  STY lastLineTextHi

  LDY #$00
PopulateLastLineLoop:
  LDA #$03 ; #$27 - empty tile
  CPY #$16
  BCS :+
    LDA (lastLineTextLo), Y
  :
  STA backgroundLastLineTmp, Y
  INY
  CPY #$20
  BNE PopulateLastLineLoop

  LDA #.LOBYTE(backgroundLastLineTmp)
  STA backgroundLLPointerLo       ; put the low byte of the address of background's last line into pointer
  LDA #.HIBYTE(backgroundLastLineTmp)
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

RenderBackgroundFinished:
  LDA #$00
  STA refreshBackground
