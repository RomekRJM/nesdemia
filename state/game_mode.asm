AdjustGameMode:
  LDA previousGameMode
  CMP #IN_GAME_MODE
  BEQ :+
    LDA gameMode
    CMP #IN_GAME_MODE
    BNE :+
      JSR LoadLevel
      JSR InitVariables
  :

  LDA gameMode
  CMP #PASSWORD_GAME_MODE
  BNE :+
    JSR ClearGfx
    JMP SavePreviousGameMode
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

  LDA gameMode
  CMP #LEVEL_COMPLETED_MODE
  BNE :+
    JSR ClearGfx
    INC levelNo
  :

  LDA gameMode
  CMP #GAME_COMPLETED_MODE
  BNE :+
    LDA #$01
    STA initReset
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
