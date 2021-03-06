RenderPartialShopBackground:
  LDY #$00

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
  LDA #%10000000
  STA $05

  ; even bar attribute
  LDA #%00100000
  STA $06

  JSR RenderShopBar


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
  LDA #%00001000
  STA $05

  ; even bar attribute
  LDA #%00000010
  STA $06

  JSR RenderShopBar


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
  LDA #%00001000
  STA $05

  ; even bar attribute
  LDA #%00000010
  STA $06

  JSR RenderShopBar

  ; render luck arrows
  LDA #$00
  STA $00

  LDA #$c9
  STA $01

  LDA #$ce
  STA $02

  JSR RenderShopArrows

  ; render attack arrows
  LDA #$01
  STA $00

  LDA #$d9
  STA $01

  LDA #$de
  STA $02

  JSR RenderShopArrows

  ; render speed arrows
  LDA #$02
  STA $00

  LDA #$e1
  STA $01

  LDA #$e6
  STA $02

  JSR RenderShopArrows

  ; We will only be refreshing one cost at a time, as loading all
  ; will note be possible in a single vblank
  ; X - will contain the index of currently refreshed item
  LDA frame
  AND #%00000011
  TAX
  CPX #%00000011
  BEQ ContinueShopRendering

  STX $0b
  JSR ComputeCostOfUpgrading
  JSR Hex2Dec

  LDX $0b
  CPX #$00
  BNE :+
    LDA #$20
    STA $03

    LDA #$b6
    STA $04
  :

  CPX #$01
  BNE :+
    LDA #$21
    STA $03

    LDA #$56
    STA $04
  :

  CPX #$02
  BNE :+
    LDA #$21
    STA $03

    LDA #$f6
    STA $04
  :

  JSR RenderCosts

ContinueShopRendering:
  JSR RenderMoney
  JSR RenderConfirmDialog

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


RenderShopArrows:
  LDA currentShopItem
  CMP $00
  BNE :+
    LDA #%11111111
    STA $03
    JMP RenderArrows
  :

  LDA #%00000000
  STA $03

RenderArrows:
  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA $03
  STA partialUpdateMemory, Y
  INY

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA $02
  STA partialUpdateMemory, Y
  INY

  LDA $03
  STA partialUpdateMemory, Y
  INY

  RTS


RenderCosts:
  LDA #$02
  STA partialUpdateMemory, Y
  INY

  LDA $03
  STA partialUpdateMemory, Y
  INY

  LDA $04
  STA partialUpdateMemory, Y
  INY

  LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA $02
  STA partialUpdateMemory, Y
  INY

  RTS


RenderMoney:
  LDA points
  JSR Hex2Dec

  LDA #$03
  STA partialUpdateMemory, Y
  INY

  LDA #$22
  STA partialUpdateMemory, Y
  INY

  LDA #$96
  STA partialUpdateMemory, Y
  INY

  LDA $00
  STA partialUpdateMemory, Y
  INY

  LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA $02
  STA partialUpdateMemory, Y
  INY

  RTS


RenderConfirmDialog:
  LDA #.LOBYTE(ShopConfirmDialog)
  STA $00
  LDA #.HIBYTE(ShopConfirmDialog)
  STA $01

  LDA #$08
  STA partialUpdateMemory, Y
  INY

  LDA #$23
  STA partialUpdateMemory, Y
  INY

  LDA #$0d
  STA partialUpdateMemory, Y
  INY

  LDX #$00
WriteConfirmDialogLoop:
  LDA shopConfirm
  BEQ ClearConfirmDialog

  STY $03
  TXA
  TAY
  LDA ($00), Y
  LDY $03
  JMP WriteConfirmDialog

ClearConfirmDialog:
  LDA #$88

WriteConfirmDialog:
  STA partialUpdateMemory, Y
  INY
  INX
  CPX #$08
  BNE WriteConfirmDialogLoop

  RTS
