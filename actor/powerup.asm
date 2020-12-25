SpawnPowerup:
  DEC powerupLifeTime
  LDA powerupLifeTime
  BNE EndOfPowerupSpawning
  BNE :+
    LDA #POWERUP_LIFE_TIME
    STA powerupLifeTime
    LDA #$00
    STA powerupActive
  :

  ; by default powerup type is dash
  LDY #POWERUP_DASH

  LDA playerLuck
  STA $01
  DEC $01
  LDX $01

  LDA LuckLevelGivingDash, X
  STA $05
  LDA powerupChance
  BEQ :+
    STA $05
  :

  LDA LuckLevelGivingAttack, X
  STA $06
  LDA attackChance
  BEQ :+
    STA $06
  :

  JSR NextRandom5Bits
  CMP $05
  BCC EndOfPowerupSpawning ; aka don't spawn it

  CMP $06
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
