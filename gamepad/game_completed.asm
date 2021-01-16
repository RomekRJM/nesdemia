ReactOnInputInGameCompleted:
  LDA previousButtons
  AND #BUTTON_START
  BEQ EndReactOnInputInGameCompleted
  LDA buttons
  AND #BUTTON_START
  BNE EndReactOnInputInGameCompleted
  ; reset game
  JMP ($FFFC)

EndReactOnInputInGameCompleted:
  LDA buttons
  STA previousButtons
  RTS
