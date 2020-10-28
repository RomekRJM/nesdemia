RenderPartialShopBackground:
  LDY #$00

  ; test code - remove me
  LDA #$03
  STA playerLuck

  LDA playerLuck
  STA $00

  LDA luckBought
  STA $01

  LDA #$20
  STA $02

  LDA #$e9
  STA $03

  ; low nimble attribute table address
  LDA #$ca
  STA $04

  ; odd bar attribute
  LDA #%00110000
  STA $05

  ; even bar attribute
  LDA #%11000000
  STA $06

  JSR RenderShopBar


  ; ; test code - remove me
  ; LDA #$07
  ; STA playerAttack
  ;
  ; LDA playerAttack
  ; STA $00
  ;
  ; LDA attackBought
  ; STA $01
  ;
  ; LDA #$21
  ; STA $02
  ;
  ; LDA #$89
  ; STA $03
  ;
  ; JSR RenderShopBar
  ;
  ;
  ; ; test code - remove me
  ; LDA #$02
  ; STA playerSpeed
  ;
  ; LDA playerSpeed
  ; STA $00
  ;
  ; LDA speedBought
  ; STA $01
  ;
  ; LDA #$22
  ; STA $02
  ;
  ; LDA #$29
  ; STA $03
  ;
  ; JSR RenderShopBar


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
  STA $08 ; how many bought attributes should we display
  STA $0a

  LDA #$08
  SEC
  SBC $08
  STA $09 ; how many empty attributes should we display
  STA $0b

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

    DEC $08
    LDX $08
    BNE :-

  LDA $09
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

    DEC $09
    LDX $09
    BNE :-

  LDA $01
  BNE :+
    RTS
  :

  LDA #$04
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA $04
  STA partialUpdateMemory, Y
  INY

  LDX #$00
ShopAttributeLoop:
  LDA #$00
  STA $0c ; should we move to next attribute ( 0 - yes )
  TXA
  ROR
  AND #$01
  BNE :+
    LDA $06 ; even number
    JMP ColorAttribute
  :
  LDA $05 ; odd number
  INC $0c
ColorAttribute:
  CPX $00
  BCC :+
  BEQ :+
    ORA partialUpdateMemory, Y
    JMP MoveToNextAttribute
  :

  EOR #%11111111 ; build mask that will clear previously set colors
  AND partialUpdateMemory, Y

MoveToNextAttribute:
  STA partialUpdateMemory, Y

  LDA $0c
  BEQ :+
    INY ; only move to next attribute when current was odd
  :

  INX
  CPX #$09
  BNE ShopAttributeLoop

  RTS
