ReactOnInputInCredits:
  LDA buttons
  AND #BUTTON_START
  BEQ EndReactOnInputInCredits
  LDA previousButtons
  AND #BUTTON_START
  BNE EndReactOnInputInCredits
  LDA #MAIN_MENU_MODE
  STA gameMode

EndReactOnInputInCredits:
  LDA buttons
  STA previousButtons
  RTS
