LoadGameAttributes:
  LDY health

  CPY #$00
  BNE :+
    LDA #.LOBYTE(Attribute0)
    STA attributePointerLo
    LDA #.HIBYTE(Attribute0)
    STA attributePointerHi
  :

  CPY #$01
  BNE :+
    LDA #.LOBYTE(Attribute1)
    STA attributePointerLo
    LDA #.HIBYTE(Attribute1)
    STA attributePointerHi
  :

  CPY #$02
  BNE :+
    LDA #.LOBYTE(Attribute2)
    STA attributePointerLo
    LDA #.HIBYTE(Attribute2)
    STA attributePointerHi
  :

  CPY #$03
  BNE :+
    LDA #.LOBYTE(Attribute3)
    STA attributePointerLo
    LDA #.HIBYTE(Attribute3)
    STA attributePointerHi
  :

  CPY #$04
  BNE :+
    LDA #.LOBYTE(Attribute4)
    STA attributePointerLo
    LDA #.HIBYTE(Attribute4)
    STA attributePointerHi
  :

  JSR LoadAttributes
  RTS
