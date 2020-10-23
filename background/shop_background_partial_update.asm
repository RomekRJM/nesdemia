RenderPartialShopBackground:
  LDY #$00

  ; test code - remove me
  LDA #$06
  STA playerLuck
  
  LDA playerLuck
  STA $00
  
  ; Needs to be incremented. Think about increasing it after load game.
  INC $00

  LDA #$20
  STA $01

  LDA #$8c
  STA $02
  
  JSR RenderShopBar
  
  ; test code - remove me
  LDA #$07
  STA playerAttack
  
  LDA playerAttack
  STA $00
  
  ; Needs to be incremented. Think about increasing it after load game.
  INC $00

  LDA #$21
  STA $01

  LDA #$2c
  STA $02
  
  JSR RenderShopBar
  
  ; test code - remove me
  LDA #$02
  STA playerSpeed
  
  LDA playerSpeed
  STA $00
  
  ; Needs to be incremented. Think about increasing it after load game.
  INC $00

  LDA #$21
  STA $01

  LDA #$cc
  STA $02
  
  JSR RenderShopBar
  
  LDA #$00
  STA partialUpdateMemory, Y
  
  LDA #$01
  STA refreshBackground
  
  RTS
  
  
RenderShopBar:
  LDA $00
  STA partialUpdateMemory, Y
  INY
  
  LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA $02
  STA partialUpdateMemory, Y
  INY
  
  LDA #$12
  :
    STA partialUpdateMemory, Y
    INY
	
    DEC $00
    LDX $00
    BNE :-

  RTS

