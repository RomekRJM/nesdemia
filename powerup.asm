SpawnPowerup:
  LDA powerupLifeTime
  BNE :+
    LDA #POWERUP_LIFE_TIME
    STA powerupLifeTime
  :

  INC powerupTimer
  BNE EndOfPowerupSpawning
  DEC powerupLifeTime
  BNE EndOfPowerupSpawning
  ; by default powerup type is dash
  LDY #POWERUP_DASH
  ; powerups have 3/8 chance to be spawned
  JSR NextRandom3Bits
  CMP #$05
  BCC EndOfPowerupSpawning ; aka don't spawn it
  BNE :+
    ; this powerup is attack
    LDY #POWERUP_ATTACK
  :
  STY powerupType

  LDA frame
  JSR NextRandom16To206
  STA powerupLeft
  CLC
  ADC #POWERUP_WIDTH
  STA powerupRight
  JSR NextRandom16To206
  STA powerupTop
  CLC
  ADC #POWERUP_HEIGHT
  STA powerupBottom

  LDA #$01
  STA powerupActive

EndOfPowerupSpawning:
  RTS

ForcePowerupRespawn:
  LDA #$ff
  STA powerupTimer
  LDA #$01
  STA powerupLifeTime
  RTS

RenderPowerup:
  LDX spriteCounter
  LDY #$00
LoadPowerupSprites:
  LDA PowerupData, Y
  CPY #$03
  BNE :+
    CLC
    ADC powerupLeft
  :
  CPY #$00
  BNE :+
   CLC
   ADC powerupTop
  :

  STA $0200, X
  INX
  INY
  CPY #$04
  BNE LoadPowerupSprites
  STX spriteCounter
  RTS
