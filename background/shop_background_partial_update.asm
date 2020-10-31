RenderPartialShopBackground:
  LDY #$00

  ; test code - remove me
  LDA #$08
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
  LDA #%11000000
  STA $05

  ; even bar attribute
  LDA #%00110000
  STA $06

  JSR RenderShopBar


  ; test code - remove me
  LDA #$08
  STA playerAttack

  LDA playerAttack
  STA $00

  LDA attackBought
  STA $01

  LDA #$21
  STA $02

  LDA #$89
  STA $03

  ; low nimble attribute table address
  LDA #$da
  STA $04

  ; odd bar attribute
  LDA #%00001100
  STA $05

  ; even bar attribute
  LDA #%00000011
  STA $06

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

  ; low nimble attribute table address
  LDA #$e2
  STA $04

  ; odd bar attribute
  LDA #%00001100
  STA $05

  ; even bar attribute
  LDA #%00000011
  STA $06

  JSR RenderShopBar


  LDA #$00
  STA partialUpdateMemory, Y

  LDA #$01
  STA refreshBackground

  RTS


RenderShopBar:
  LDA $00
  CLC
  ADC $01
  STA $08 ; how many bought attributes should we display

  LDA #$08
  SEC
  SBC $08
  STA $09 ; how many empty attributes should we display

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
  STA $0a ; should we move to next attribute ( 0 - yes )
  TXA
  AND #$01
  BNE :+
    LDA $06 ; even number
    JMP ColorAttribute
  :
  LDA $05 ; odd number
  INC $0a
ColorAttribute:
  CPX $08
  BEQ UseStandardColor
  BCS UseStandardColor

  CPX $00
  BCC UseStandardColor


  ORA partialUpdateMemory, Y
  JMP MoveToNextAttribute

UseStandardColor:
  EOR #%11111111 ; build mask that will clear previously set colors
  AND partialUpdateMemory, Y

MoveToNextAttribute:
  STA partialUpdateMemory, Y

  LDA $0a
  BEQ :+
    INY ; only move to next attribute when current was odd
  :

  INX
  CPX #$08
  BNE ShopAttributeLoop

; Draw bars
  LDA #$10
  STA partialUpdateMemory, Y
  INY

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

  RTS
