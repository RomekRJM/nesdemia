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
	LDA buttons
  AND #BUTTON_LEFT
  BEQ :+
    DEC playerLeft
    LDA #PLAYER_WIDTH
    CLC
    ADC playerLeft
    STA playerRight
	:

  LDA buttons
  AND #BUTTON_RIGHT
  BEQ :+
    INC playerLeft
    LDA #PLAYER_WIDTH
    CLC
    ADC playerLeft
    STA playerRight
  :

  LDA buttons
  AND #BUTTON_UP
  BEQ :+
    DEC playerTop
    LDA #PLAYER_HEIGHT
    CLC
    ADC playerTop
    STA playerBottom
  :

	LDA buttons
  AND #BUTTON_DOWN
  BEQ :+
    INC playerTop
    LDA #PLAYER_HEIGHT
    CLC
    ADC playerTop
    STA playerBottom
  :

  RTS
