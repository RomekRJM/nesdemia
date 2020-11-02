ReactOnInputInShop:
  LDA buttons
  AND #BUTTON_LEFT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_LEFT
    BNE :+
    JSR DecreaseBoughUnits
    JSR UnconfirmInShop
  :

  LDA buttons
  AND #BUTTON_RIGHT
  BEQ :+
    LDA previousButtons
    AND #BUTTON_RIGHT
    BNE :+
    JSR IncreaseBoughUnits
    JSR UnconfirmInShop
  :

  LDA buttons
  AND #BUTTON_UP
  BEQ :+
    JSR UnconfirmInShop
    LDA previousButtons
    AND #BUTTON_UP
    BNE :+
    JSR UnconfirmInShop
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
    JSR UnconfirmInShop
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
    INC shopConfirm
    LDA shopConfirm
    CMP #$02
    BNE :+
    LDA #$00
    STA shopConfirm
    LDA #PRE_LEVEL_MODE
    STA gameMode
  :

EndReactOnInputInShop:
  LDA buttons
  STA previousButtons
  RTS


IncreaseBoughUnits:
  JSR ComputeCostOfUpgrading
  STA $00
  LDA points
  SEC
  SBC $00
  BCS :+
    RTS
  :
  STA points

  LDX currentShopItem
  LDA playerLuck, X

  CLC
  ADC luckBought, X
  CMP #$08
  BCC :+
    RTS
  :

  INC luckBought, X
  RTS


DecreaseBoughUnits:
  LDX currentShopItem
  LDA luckBought, X

  BNE :+
    RTS
  :

  DEC luckBought, X

  JSR ComputeCostOfUpgrading
  CLC
  ADC points
  STA points

  RTS


UnconfirmInShop:
  LDA #$00
  STA shopConfirm
  RTS