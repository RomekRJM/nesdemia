ReactOnInputInGameCompleted:
  LDA buttons
  AND #BUTTON_START
  BEQ EndReactOnInputInGameCompleted
  ; reset game
  JMP ($FFFC)

EndReactOnInputInGameCompleted:
  LDA buttons
  STA previousButtons
  RTS
