SpawnPowerup:
  DEC powerupLifeTime
  LDA powerupLifeTime
  BNE EndOfPowerupSpawning
  BNE :+
    LDA #POWERUP_LIFE_TIME
    STA powerupLifeTime
  :

  INC powerupTimer
  LDA powerupTimer
  BNE EndOfPowerupSpawning
  ; by default powerup type is dash
  LDY #POWERUP_DASH

  LDA playerLuck
  STA $01
  DEC $01
  LDX $01

  JSR NextRandom5Bits
  CMP LuckLevelGivingDash, X
  BCC EndOfPowerupSpawning ; aka don't spawn it

  CMP LuckLevelGivingAttack, X
  BCC :+
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
  LDA powerupActive
  BNE :+
    RTS
  :
  LDX spriteCounter
  LDY #$00
LoadPowerupSprites:
  LDA powerupType
  BNE :+
    LDA PowerupDashData, Y
    JMP ContinuePowerupLoading
  :
  LDA PowerupAttackData, Y
ContinuePowerupLoading:
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
