AdjustGameMode:

  LDA gameMode

  LDA previousGameMode
  CMP #MAIN_MENU_MODE
  BNE :+
    LDA gameMode
    CMP #IN_GAME_MODE
    BNE :+
      JSR ChangeToInGame
  :

  LDA gameMode
  STA previousGameMode

  RTS

ChangeToInGame:
  LDA difficultyLevel
  CMP #$00
  BNE :+
    LDA #$01
    STA noViruses
  :

  LDA difficultyLevel
  CMP #$01
  BNE :+
    LDA #$05
    STA noViruses
  :

  LDA difficultyLevel
  CMP #$02
  BNE :+
    LDA #$0A
    STA noViruses
  :

  RTS
