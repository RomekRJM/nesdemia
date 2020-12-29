RenderLogo:
  LDX spriteCounter
  LDY #$00
LoadFistSprite:
  LDA Fist, Y
  CPY #$00
  BNE :+
    CLC
    ADC #$01
  :

  STA $0200, X
  INY
  INX
  CPY #$24
  BNE LoadFistSprite
  STX spriteCounter
  
  RTS
