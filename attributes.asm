LoadAttributes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$00              ; start out at 0

  LDX #$00
  LDY health

  CPY #$00
  BNE :+
    JSR LoadAttributesLoop0
  :

  CPY #$01
  BNE :+
    JSR LoadAttributesLoop1
  :

  CPY #$02
  BNE :+
    JSR LoadAttributesLoop2
  :

  CPY #$03
  BNE :+
    JSR LoadAttributesLoop3
  :

  CPY #$04
  BNE :+
    JSR LoadAttributesLoop4
  :

  LDX #$00
CopyAttributeData:
  LDA BEGIN_OF_ATTRIBUTES_MEMORY, X
  STA $2007
  INX
  CPX #$40
  BNE CopyAttributeData
  STX dbg2
  RTS

LoadAttributesLoop0:
  LDA Attribute0, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$40
  BNE LoadAttributesLoop0
  RTS

LoadAttributesLoop1:
  LDA Attribute1, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$40
  BNE LoadAttributesLoop1
  RTS

LoadAttributesLoop2:
  LDA Attribute2, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$40
  BNE LoadAttributesLoop2
  RTS

LoadAttributesLoop3:
  LDA Attribute3, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$40
  BNE LoadAttributesLoop3
  RTS

LoadAttributesLoop4:
  LDA Attribute4, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$40
  BNE LoadAttributesLoop4
  RTS
