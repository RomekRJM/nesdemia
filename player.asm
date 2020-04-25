RenderPlayer:
  LDX spriteCounter
  LDY #$00
  LDA playerInvincible
  CMP #$01
  BNE LoadPlayerSprites
  LDA frame
  AND #%00010000
  CMP #%00010000
  BNE LoadPlayerSprites
  JSR ChangePlayerPallete
LoadPlayerSprites:
  LDA SpriteData, X
  CPY #$03
  BNE :+
	  CLC
	  ADC playerLeft
  :
  CPY #$00
  BNE :+
	  CLC
	  ADC playerTop
  :
  CPY #$02
  BNE :+
    LDA playerPallete
  :
  INY
  CPY #$04
  BNE :+
	  LDY #$00
  :

  STA $0200, X
  INX
  CPX #$10
  BNE LoadPlayerSprites
	STX spriteCounter

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
