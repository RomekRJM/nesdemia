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
    CMP #$06
    BCC :+
      LDA #$06
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
  BEQ :+
    LDA previousButtons
    AND #BUTTON_START
    BNE :+
    JSR LoadPassword
    LDA #IN_GAME_MODE
    STA gameMode
  :

EndReactOnInputInPassword:
  LDA buttons
  STA previousButtons
  RTS
