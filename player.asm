RenderPlayer:
  LDX spriteCounter
  LDY #$00
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
  INY
  CPY #$04
  BNE :+
	 LDY #$00
  :

  STA $0200, X
  INX
  CPX #$20
  BNE LoadPlayerSprites
	STX spriteCounter

  RTS


CheckCollision:
  LDA #COLLISSION
  STA playerCollidesWithCoin
  LDA playerLeft
  STA dim1Player
  LDA playerRight
  STA dim2Player
  LDA pillLeft
  STA dim1Object
  LDA pillRight
  STA dim2Object
  JSR DetectCollision

  LDA playerTop
  STA dim1Player
  LDA playerBottom
  STA dim2Player
  LDA pillTop
  STA dim1Object
  LDA pillBottom
  STA dim2Object
  JSR DetectCollision

  RTS

DetectCollision:
  LDA dim1Object
  CMP dim1Player
  BCS Check2
  JMP Check3

Check2:
  CMP dim2Player
  BCC Collision
  BEQ Collision

Check3:
  LDA dim2Object
  CMP dim1Player
  BCS Check4
  JMP NoCollision

Check4:
  CMP dim2Player
  BCC Collision
  BEQ Collision
  JMP NoCollision

NoCollision:
  LDA #$00
  STA playerCollidesWithCoin

Collision:
  LDA playerCollidesWithCoin
  AND #$01

EndCollisionCheck:
  RTS
