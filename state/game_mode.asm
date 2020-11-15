AdjustGameMode:
  LDA previousGameMode
  CMP #IN_GAME_MODE
  BEQ :+
    LDA gameMode
    CMP #IN_GAME_MODE
    BNE :+
      INC levelNo
      JSR LoadLevel
      JSR InitVariables

      ;load an in game song
      LDA #IN_GAME_SONG
      STA sound_param_byte_0
      JSR play_song
  :

  LDA previousGameMode
  CMP #MAIN_MENU_MODE
  BEQ :+
    LDA gameMode
    CMP #MAIN_MENU_MODE
    BNE :+
      JSR InitVariables

      ;load a menu song
      LDA #MAIN_MENU_SONG
      STA sound_param_byte_0
      JSR play_song
  :

  LDA previousGameMode
  CMP gameMode
  BEQ :+
    JSR ClearGfx
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

ClearGfxLoop:
  LDA #$ff
  STA $0200, X
  LDA #$00
  STA partialUpdateMemory, X
  INX
  BNE ClearGfxLoop

  RTS
