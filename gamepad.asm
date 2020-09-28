; At the same time that we strobe bit 0, we initialize the ring counter
; so we're hitting two birds with one stone here
GetControllerInput:
  LDA #$01
  ; While the strobe bit is set, buttons will be continuously reloaded.
  ; This means that reading from JOYPAD1 will only return the state of the
  ; first button: button A.
  STA JOYPAD1
  STA buttons
  LSR A        ; now A is 0
  ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
  ; This allows all 8 buttons (newly reloaded) to be read from JOYPAD1.
  STA JOYPAD1
GetControllerInputLoop:
  LDA JOYPAD1
  LSR A	       ; bit 0 -> Carry
  ROL buttons  ; Carry -> bit 0; bit 7 -> Carry
  BCC GetControllerInputLoop
  RTS


ReactOnInput:
  LDA #$04
  STA playerNucleusLeft
  STA playerNucleusTop

  LDA playerDashing
  BNE :+
    LDA #PLAYER_NORMAL_SPEED
    STA playerSpeed
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
  STA playerSpeed

CheckButtons:
	LDA buttons
  AND #BUTTON_LEFT
  BEQ :+
    LDA playerLeft
    SEC
    SBC playerSpeed
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
    ADC playerSpeed
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
    SBC playerSpeed
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
    ADC playerSpeed
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
    LDA #PLAYER_INVINCIBLE_DURATION
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


ReactOnInputInMenu:
  LDA buttons
  AND #BUTTON_SELECT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_SELECT
    BNE :+
    INC menuOption
    LDA menuCursorTop
    CLC
    ADC #$10
    STA menuCursorTop
    CMP #$30
    BCC :+
      LDA #$00
      STA menuCursorTop
      STA menuOption
  :

  LDA buttons
  AND #BUTTON_START
  BEQ EndReactOnInputInMenu
  LDA menuOption
  STA gameMode

EndReactOnInputInMenu:
  LDA buttons
  STA previousButtons
  RTS


ReactOnInputInPassword:
  LDA buttons
  AND #BUTTON_LEFT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_LEFT
    BNE :+
    DEC passwordCurrentDigit
    LDA passwordCurrentDigit
    CMP #$ff
    BNE :+
      LDA #$00
      STA passwordCurrentDigit
  :

  LDA buttons
  AND #BUTTON_RIGHT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_RIGHT
    BNE :+
    INC passwordCurrentDigit
    LDA passwordCurrentDigit
    CMP #$04
    BCC :+
      LDA #$04
      STA passwordCurrentDigit
  :

  LDA buttons
  AND #BUTTON_UP
  BEQ :+
    LDA previousButtons
    AND #BUTTON_UP
    BNE :+
    LDX passwordCurrentDigit
    INC passwordArray, X
    LDA passwordArray, X
    CMP #$10
    BNE :+
      LDA #$00
      STA passwordArray, X
  :

  LDA buttons
  AND #BUTTON_DOWN
  BEQ :+
    LDA previousButtons
    AND #BUTTON_DOWN
    BNE :+
    LDX passwordCurrentDigit
    DEC passwordArray, X
    LDA passwordArray, X
    CMP #$ff
    BNE :+
      LDA #$0f
      STA passwordArray, X
  :

  LDA buttons
  AND #BUTTON_START
  BEQ EndReactOnInputInPassword

EndReactOnInputInPassword:
  LDA buttons
  STA previousButtons
  RTS
