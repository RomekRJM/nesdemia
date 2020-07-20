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
    JSR ClearGfx
    JMP SavePreviousGameMode
  :

  CMP #GAME_COMPLETED_MODE
  BNE :+
    JSR ClearGfx
  :

SavePreviousGameMode:
  LDA gameMode
  STA previousGameMode

  RTS

ClearGfx:
  LDX #$00
  STX refreshBackground

ClearSpritesLoop:
  LDA #$ff
  STA $0200, X
  INX
  BNE ClearSpritesLoop

  RTS
