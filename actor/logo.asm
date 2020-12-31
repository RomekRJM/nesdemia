RenderLogo:
  LDA frame
  AND #%00000011
  CMP #%00000011
  BEQ :+
    RTS
  :

  JSR RenderFistSprite
  JSR RenderFistWithVaccineSprite

  INC fistAnimator
  LDA fistAnimator
  CMP #FIST_ANIMATOR_LENGTH
  BNE :+
    LDA #$00
    STA fistAnimator
  :

  RTS


RenderFistSprite:
  LDX fistAnimator
  LDA FistAnimatorX, X
  STA $01
  LDA FistAnimatorY, X
  STA $03
  LDA #.LOBYTE(Fist)
  STA $08
  LDA #.HIBYTE(Fist)
  STA $09
  LDA #$24
  STA $0a

  JSR AnimateCircleMovement

  RTS


RenderFistWithVaccineSprite:
  LDX fistAnimator
  LDA FistWithVaccineAnimatorX, X
  STA $01
  LDA FistWithVaccineAnimatorY, X
  STA $03
  LDA #.LOBYTE(FistWithVaccine)
  STA $08
  LDA #.HIBYTE(FistWithVaccine)
  STA $09
  LDA #$54
  STA $0a

  JSR AnimateCircleMovement

  RTS


AnimateCircleMovement:
  LDX spriteCounter
  LDY #$00
  STY $00
LoadFistSpriteLoop:
  LDA ($08), Y
  STA $02
  LDA $00
  BNE :+
    LDA $02
    CLC
    ADC $03
    STA $02
  :
  LDA $00
  CMP #$03
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
  CPY $0a
  BNE LoadFistSpriteLoop
  STX spriteCounter

  RTS
