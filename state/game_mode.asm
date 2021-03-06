AdjustGameMode:
  LDA previousGameMode
  CMP #IN_GAME_MODE
  BEQ :+
    LDA gameMode
    CMP #IN_GAME_MODE
    BNE :+
      JSR InitVariables
      LDA #song_index_In20Game
      JSR ChangeMusicTrack
      JSR LoadInGamePalettes
  :

  LDA previousGameMode
  CMP #IN_GAME_MODE
  BNE :+
    LDA gameMode
    CMP #IN_GAME_MODE
    BEQ :+
      JSR LoadMenuPalettes
      JSR ClearViruses
  :

  LDA previousGameMode
  CMP #PRE_LEVEL_MODE
  BEQ :+
    LDA gameMode
    CMP #PRE_LEVEL_MODE
    BNE :+
      LDA preLevelPoints
      STA points
      INC levelNo
      JSR LoadLevel
      JSR InitVariables
  :

  LDA previousGameMode
  CMP #MAIN_MENU_MODE
  BEQ :+
    LDA gameMode
    CMP #MAIN_MENU_MODE
    BNE :+
      JSR InitVariables
      LDA #song_index_Main20Menu
      JSR ChangeMusicTrack
  :

  LDA previousGameMode
  CMP gameMode
  BEQ :+
    JSR ClearGfx
  :

SavePreviousGameMode:
  LDA gameMode
  STA previousGameMode

  RTS

ClearGfx:
  LDX #$00
  STX refreshBackground

ClearGfxLoop:
  LDA #$ff
  STA $0200, X
  LDA #$00
  STA partialUpdateMemory, X
  INX
  BNE ClearGfxLoop

  RTS

ClearViruses:
  LDA #$00
  TAX

  :
    STA $0100, X
    INX
    CPX #$a0
    BCC :-

  RTS
