RenderGameOverBackground:

  LDA #$00
  STA $2000
  STA $2001

  LDA #.LOBYTE(GameOverBackground)
  STA backgroundPointerLo
  LDA #.HIBYTE(GameOverBackground)
  STA backgroundPointerHi
  JSR RenderBackground

  JSR LoadMenuAttributes

  LDA #$00
  STA $2005
  STA $2005

  LDA #%10010000 ; enable NMI change background to use second chr set of tiles
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001
