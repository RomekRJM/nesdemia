ReactOnInputInPreLevel:
  LDA buttons
  AND #BUTTON_START
  BEQ :+
    LDA previousButtons
    AND #BUTTON_START
    BNE :+
    JSR SavePassword
    LDA #IN_GAME_MODE
    STA gameMode
  :

EndReactOnInputInPreLevel:
  LDA buttons
  STA previousButtons
  RTS
