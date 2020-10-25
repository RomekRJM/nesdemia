ReactOnInputInShop:
  LDA buttons
  AND #BUTTON_LEFT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_LEFT
    BNE :+
    JSR DecreaseBoughUnits
  :

  LDA buttons
  AND #BUTTON_RIGHT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_RIGHT
    BNE :+
    JSR IncreaseBoughUnits
  :

  LDA buttons
  AND #BUTTON_UP
  BEQ :+
    LDA previousButtons
    AND #BUTTON_UP
    BNE :+
    DEC currentShopItem
	LDA currentShopItem
    CMP #$ff
    BNE :+
      LDA #$02
      STA currentShopItem
  :

  LDA buttons
  AND #BUTTON_DOWN
  BEQ :+
    LDA previousButtons
    AND #BUTTON_DOWN
    BNE :+
    INC currentShopItem
	LDA currentShopItem
    CMP #$03
    BNE :+
      LDA #$00
      STA currentShopItem
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

EndReactOnInputInShop:
  LDA buttons
  STA previousButtons
  RTS


IncreaseBoughUnits:
  LDX currentShopItem
  LDA playerLuck, X

  CLC
  ADC luckBought, X
  CMP #$08
  BCC :+
	RTS
  :

  INC luckBought, X
  ; take money from the account
  RTS


DecreaseBoughUnits:
  LDX currentShopItem
  LDA luckBought, X

  BNE :+
	RTS
  :

  DEC luckBought, X
  ; return money to the account
  RTS
