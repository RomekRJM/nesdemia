RenderLogo:
  JSR LoadFistSprite
  JSR LoadFistWithVaccineSprite
  
  LDA frame
  AND #%0011111
  BNE :+
    RTS
  :

  INC fistAnimator
  LDA fistAnimator
  CMP #FIST_ANIMATOR_LENGTH
  BNE :+
    LDA #$00
    STA fistAnimator
  :
  
  RTS


LoadFistSprite:
  LDX fistAnimator
  LDA FistAnimatorX, X
  STA $01
  LDX spriteCounter
  LDY #$00
  STY $00
LoadFistSpriteLoop:
  LDA Fist, Y
  STA $02
  LDA $00
  BNE :+
    LDA $02
    CLC
    ADC $01
    STA $02
  :
  LDA $02

  STA $0200, X
  INC $00
  LDA $00
  CMP #$04
  BNE :+
    LDA #$00
    STA $00
  :
  INY
  INX
  CPY #$24
  BNE LoadFistSpriteLoop
  STX spriteCounter
  
  RTS

LoadFistWithVaccineSprite:
  LDX spriteCounter
  LDY #$00
LoadFistWithVaccineSpriteLoop:
  LDA FistWithVaccine, Y

  STA $0200, X
  INY
  INX
  CPY #$54
  BNE LoadFistWithVaccineSpriteLoop
  STX spriteCounter
  
  RTS
