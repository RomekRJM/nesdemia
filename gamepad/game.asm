ReactOnInputInGame:
  LDA #$04
  STA playerNucleusLeft
  STA playerNucleusTop

  LDA playerDashing
  BNE :+
    LDA #PLAYER_NORMAL_SPEED
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
    LDA playerLeft
    SEC
    SBC playerCurrentSpeed
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
    LDA playerLeft
    CLC
    ADC playerCurrentSpeed
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
    LDA playerTop
    SEC
    SBC playerCurrentSpeed
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
    LDA playerTop
    CLC
    ADC playerCurrentSpeed
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

  RTS
