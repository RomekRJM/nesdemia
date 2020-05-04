RenderPlayer:
  LDX spriteCounter
  LDY #$00
  LDA playerInvincible
  CMP #$01
  BNE LoadPlayerNucleus
  LDA frame
  AND #%00010000
  CMP #%00010000
  BNE LoadPlayerNucleus
  JSR ChangePlayerPallete
LoadPlayerNucleus:
  LDA PlayerDataNucleus, X

  CPY #$03
  BNE :+
    LDA playerLeft
    CLC
    ADC playerNucleusLeft
  :

  CPY #$00
  BNE :+
    LDA playerTop
    CLC
    ADC playerNucleusTop
  :

  CPY #$02
  BNE :+
    LDA playerPallete
  :

  STA $0200, X
  INX
  INY
  CPX #$04
  BNE LoadPlayerNucleus

  STX spriteCounter
  LDY #$00
  LDX #$00
  STX $00

  INC playerAnimationChangeFrame
  LDA playerAnimationChangeFrame
  CMP #PLAYER_CHANGE_FRAME_INTERVAL
  BNE LoadPlayerCell

  LDA #$00
  STA playerAnimationChangeFrame

  INC playerAnimationFrame
  LDA playerAnimationFrame
  CMP #$04
  BNE LoadPlayerCell

  LDA #$01
  STA playerAnimationFrame
LoadPlayerCell:
  LDA PlayerDataCell, X
  CPY #$00
  BNE :+
	  CLC
	  ADC playerTop
  :
  CPY #$01
  BNE :+
	  LDA playerAnimationFrame
  :
  CPY #$02
  BNE :+
    ORA playerPallete
  :
  CPY #$03
  BNE :+
	  CLC
	  ADC playerLeft
  :
  INY
  CPY #$04
  BNE :+
	  LDY #$00
  :

  STX $00
  LDX spriteCounter
  STA $0200, X
  INX
  STX spriteCounter
  INC $00
  LDX $00
  CPX #$10
  BNE LoadPlayerCell

  RTS


CheckCollisionWithPill:
  LDA #COLLISSION
  STA playerCollidesWithObject

  LDA playerLeft
  STA dim1Source
  LDA playerRight
  STA dim2Source
  LDA pillLeft
  STA dim1Destination
  LDA pillRight
  STA dim2Destination
  JSR DetectCollision

  LDA playerTop
  STA dim1Source
  LDA playerBottom
  STA dim2Source
  LDA pillTop
  STA dim1Destination
  LDA pillBottom
  STA dim2Destination
  JSR DetectCollision

  LDA playerCollidesWithObject
  CMP #COLLISSION
  BNE :+
    INC points
    JSR PointsToDecimal
    JSR ForcePillRespawn
    LDA #NO_COLLISSION
    STA playerCollidesWithObject
  :

  RTS

DetectCollision:
  LDA dim1Source
  CMP dim2Destination
  BCC Check2
  JMP NoCollision

Check2:
  LDA dim2Source
  CMP dim1Destination
  BEQ Collision
  BCS Collision

NoCollision:
  LDA #$00
  STA playerCollidesWithObject

Collision:
  LDA playerCollidesWithObject
  AND #$01

EndCollisionCheck:
  RTS

ChangePlayerPallete:
  LDA playerPallete
  AND #$01
  CMP #$01
  BEQ ZeroPlayerPallete
  INC playerPallete
  LDA playerPallete
  RTS
ZeroPlayerPallete:
  DEC playerPallete
  LDA playerPallete
  RTS

LowerHealth:
  LDA health
  CMP #$04
  BCS :+
    INC health
    INC attributesNeedReloading
  :
  RTS
