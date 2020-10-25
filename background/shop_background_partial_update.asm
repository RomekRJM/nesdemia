RenderPartialShopBackground:
  LDY #$00

  ; test code - remove me
  LDA #$06
  STA playerLuck

  LDA playerLuck
  STA $00

  LDA luckBought
  STA $01

  LDA #$20
  STA $02

  LDA #$e9
  STA $03

  JSR RenderShopBar


  ; test code - remove me
  LDA #$07
  STA playerAttack

  LDA playerAttack
  STA $00

  LDA attackBought
  STA $01

  LDA #$21
  STA $02

  LDA #$89
  STA $03

  JSR RenderShopBar


  ; test code - remove me
  LDA #$02
  STA playerSpeed

  LDA playerSpeed
  STA $00

  LDA speedBought
  STA $01

  LDA #$22
  STA $02

  LDA #$29
  STA $03

  JSR RenderShopBar


  LDA #$00
  STA partialUpdateMemory, Y

  LDA #$01
  STA refreshBackground

  RTS


RenderShopBar:
  LDA #$10
  STA partialUpdateMemory, Y
  INY

  LDA $00
  CLC
  ADC $01
  STA $04 ; how many bought attributes should we display

  LDA #$08
  SEC
  SBC $04
  STA $05 ; how many empty attributes should we display

  LDA $02
  STA partialUpdateMemory, Y
  INY

  LDA $03
  STA partialUpdateMemory, Y
  INY

  ; bought attributes
  :
    LDA #$30
    STA partialUpdateMemory, Y
    INY

    LDA #$88
    STA partialUpdateMemory, Y
    INY

    DEC $04
    LDX $04
    BNE :-

  LDA $05
  BNE :+
    RTS
  :

  ; empty attributes
  :
    LDA #$2D
    STA partialUpdateMemory, Y
    INY

    LDA #$88
    STA partialUpdateMemory, Y
    INY

    DEC $05
    LDX $05
    BNE :-

  ; change attribute table to display newly bought in different color
  LDA #$01 ; LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$ca
  STA partialUpdateMemory, Y
  INY

  LDA #%11110000
  STA partialUpdateMemory, Y
  INY

  LDA #$01 ; LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$da
  STA partialUpdateMemory, Y
  INY

  LDA #%00001100
  STA partialUpdateMemory, Y
  INY

  RTS
