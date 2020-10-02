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
