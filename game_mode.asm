AdjustGameMode:
  LDA previousGameMode
  CMP #MAIN_MENU_MODE
  BNE :+
    LDA gameMode
    CMP #IN_GAME_MODE
    BNE :+
      JSR LoadLevel
  :

  LDA previousGameMode
  CMP #IN_GAME_MODE
  BNE SavePreviousGameMode

  LDA gameMode
  CMP #GAME_OVER_MODE
  BNE :+
    JSR ClearSprites
    JMP SavePreviousGameMode
  :

  CMP #GAME_COMPLETED_MODE
  BNE :+
    JSR ClearSprites
  :

SavePreviousGameMode:
  LDA gameMode
  STA previousGameMode

  RTS

ClearSprites:
  LDX #$00

ClearSpritesLoop:
  LDA #$ff
  STA $0200, X
  INX
  BNE ClearSpritesLoop

  RTS
