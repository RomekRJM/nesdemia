ReactOnInputInGame:
  DEC playerSpeed
  
  LDA #$04
  STA playerNucleusLeft
  STA playerNucleusTop

  LDA buttons
  CMP previousButtons
  BEQ :+
    LDA #$00
    STA playerSpeedIndex
	STA playerDiagonalSpeedIndex
	STA playerMovesDiagonally
  :
  
  LDA buttons
  AND #%00000011
  BEQ ContinueOnNonDiagonalMove
  
  LDA buttons
  AND #%00001100
  BEQ ContinueOnNonDiagonalMove
  
  JMP GetDiagonalSpeeds

ContinueOnNonDiagonalMove:
  LDA playerSpeedIndex
  CMP #$04
  BNE :+
    LDA #$ff
    STA playerSpeedIndex
  :
  INC playerSpeedIndex
  LDA playerSpeedIndex
  LDX playerSpeed
  CLC
  ADC SpeedIndex, X
  TAX
  LDA SpeedLevel, X
  STA playerSpeedX
  STA playerSpeedY
  
  JMP ContinueReactOnInputInGame

GetDiagonalSpeeds:
  LDA playerDiagonalSpeedIndex
  CMP #$08
  BNE :+
    LDA #$00
	STA playerDiagonalSpeedIndex
  :
  LDA playerDiagonalSpeedIndex
  LDX playerSpeed
  CLC
  ADC DiagonalSpeedIndex, X
  TAX
  LDA DiagonalSpeedLevel, X
  STA playerSpeedX
  INC playerDiagonalSpeedIndex
  
  LDA playerDiagonalSpeedIndex
  LDX playerSpeed
  CLC
  ADC DiagonalSpeedIndex, X
  TAX
  LDA DiagonalSpeedLevel, X
  STA playerSpeedY
  INC playerDiagonalSpeedIndex

ContinueReactOnInputInGame:
  LDA playerDashing
  BNE :+
    LDX playerSpeedIndex
    LDA SpeedLevel, X
    STA playerCurrentSpeed
    JMP CheckButtons
  :

  DEC playerDashing
  LDA playerDashing
  BNE :+
    INC usedPowerups
    LDX winCondition
    CPX #WIN_ON_POWERUPS
    BNE :+
      JSR UpdateWinThreshold
  :
  LDA #PLAYER_DASH_SPEED
  STA playerCurrentSpeed

CheckButtons:
  LDA buttons
  AND #BUTTON_LEFT
  BEQ :+
	LDA playerSpeedX
    LDA playerLeft
    SEC
    SBC playerSpeedX
    STA playerLeft
    CLC
    ADC #PLAYER_WIDTH
    STA playerRight

    LDA #$01
    STA playerNucleusLeft
	:

  LDA buttons
  AND #BUTTON_RIGHT
  BEQ :+
    LDA playerSpeedX
    LDA playerLeft
    CLC
    ADC playerSpeedX
    STA playerLeft
    CLC
    ADC #PLAYER_WIDTH
    STA playerRight

    LDA #$07
    STA playerNucleusLeft
  :

  LDA buttons
  AND #BUTTON_UP
  BEQ :+
    LDA playerSpeedY
    LDA playerTop
    SEC
    SBC playerSpeedY
    STA playerTop
    CLC
    ADC #PLAYER_HEIGHT
    STA playerBottom

    LDA #$01
    STA playerNucleusTop
  :

  LDA buttons
  AND #BUTTON_DOWN
  BEQ :+
    LDA playerSpeedY
    LDA playerTop
    CLC
    ADC playerSpeedY
    STA playerTop
    CLC
    ADC #PLAYER_HEIGHT
    STA playerBottom

    LDA #$07
    STA playerNucleusTop
  :

  LDA buttons
  AND #BUTTON_A
  BEQ :+
    LDA playerDashCount
    BEQ :+
    LDA playerDashing
    BNE :+
      LDA #PLAYER_DASHING_TIMEOUT
      STA playerDashing
      DEC playerDashCount
  :

  LDA buttons
  AND #BUTTON_B
  BEQ :+
    LDA playerAttacks
    BEQ :+
    LDA playerInvincible
    BNE :+
    DEC playerAttacks
    LDA playerAttack
    STA $00
    DEC $00
    LDX $00
    LDA AttackLevelDuration, X
    STA playerInvincible
  :

  LDA playerInvincible
  BEQ :+
    DEC playerInvincible
    LDA playerInvincible
    BNE :+
    INC usedPowerups
    LDX winCondition
    CPX #WIN_ON_POWERUPS
    BNE :+
      JSR UpdateWinThreshold
  :

  LDA buttons
  STA previousButtons
  
  INC playerSpeed

  RTS
