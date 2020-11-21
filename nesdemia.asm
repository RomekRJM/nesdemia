.segment "HEADER"
.byte "NES"
.byte $1a
.byte $02 ; 2 * 16KB PRG ROM
.byte $01 ; 1 * 8KB CHR ROM
.byte %00000000 ; mapper and mirroring
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00 ; filler bytes
.segment "ZEROPAGE" ; LSB 0 - FF

.define nmiTimer $10
.define buttons $11
.define previousButtons $12
.define frame   $13
.define randomByte $14
.define spriteCounter $15
.define initCompleted $16
.define backgroundPointerLo $17
.define backgroundPointerHi $18
.define backgroundLLPointerLo $19
.define backgroundLLPointerHi $1a
.define attributePointerLo $1b
.define attributePointerHi $1c
.define pointIndex0 $1d
.define pointIndex1 $1e
.define pointIndex2 $1f
.define renderedNumber $20
.define renderedNumberOffset $21
.define playerCollidesWithObject $22
.define dim1Source $23
.define dim2Source $24
.define dim1Destination $25
.define dim2Destination $26
.define pillLeft $27
.define pillTop $28
.define pillRight $29
.define pillBottom $2a
.define pillTimer $2b
.define pillLifeTime $2c
.define playerLeft $2d
.define playerTop $2e
.define playerRight $2f
.define playerBottom $30
.define playerNucleusLeft $31
.define playerNucleusTop $32
.define playerInvincible $33
.define playerDashing $34
.define playerDashCount $35
.define playerLuck $36
.define playerAttack $37
.define playerSpeed $38
.define playerCurrentSpeed $39
.define playerPallete $3a
.define playerAnimationFrame $3b
.define playerAnimationChangeFrame $3c
.define playerAttacks $3d
.define health $3e
.define healthUpdated $3f
.define initReset $40
.define initNextLevel $41
.define resetCounter $42
.define powerupLeft $43
.define powerupTop $44
.define powerupRight $45
.define powerupBottom $46
.define powerupTimer $47
.define powerupLifeTime $48
.define powerupType $49
.define powerupActive $4a
.define dashIndex0 $4b
.define dashIndex1 $4c
.define gameMode $4d
.define previousGameMode $4e
.define refreshBackground $4f
.define menuCursorTop $50
.define menuOption $51
.define gameEndRendered $52
.define gameRendered $53
.define creditsRendered $54
.define mainMenuRendered $55
.define preLevelRendered $56
.define virusLeft $57
.define virusTop $58
.define virusRight $59
.define virusBottom $5a
.define virusXSpeed $5b
.define virusYSpeed $5c
.define virusXDirection $5d
.define virusYDirection $5e
.define virusAlive $5f
.define virusMoveFrame $60
.define virusAnimationFrame $61
.define virusAnimationChangeFrame $62
.define virusSmart $63
.define virusCntr $64
.define virusPointer $65
; level specific
.define levelNo $66
.define winCondition $67
.define winThreshold $68
.define points $69
.define kills $6a
.define smartKills $6b
.define usedPowerups $6c
.define timeLimit $6d
.define noViruses $6e
.define smartVirusChance $6f
.define powerupChance $70
.define attackChance $71
.define LastLinesTextLo $72
.define LastLinesTextHi $73
.define winThresholdDigit1 $74
.define winThresholdDigit0 $75
.define timeDigit1 $76
.define timeDigit0 $77
.define countdownTimer $78
.define passwordCurrentDigit $79
.define passwordRendered $7a
.define passwordValid $7b
.define creditsScroll $7c
.define ppuHigh $7d
.define ppuLow $7e
.define passwordArray $7f ; 7
.define shopRendered $86
.define currentShopItem $87
.define luckBought $88
.define attackBought $89
.define speedBought $8a
.define shopConfirm $8b
.define dbg1 $8c
.define dbg2 $8d

;$b5 - $f2 - used by ggsound
.segment "STARTUP"

; 0x0100 - ... - viruses
.define backgroundMemory $0300 ; 1024
.define backgroundLLMemory $0380 ; 32
.define backgroundLastLinesTmp $03A0 ; 32
.define attributeMemory $03C0 ; 64
.define partialUpdateMemory $0400 ; 256

JOYPAD1 = $4016
JOYPAD2 = $4017

BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

NO_VIRUSES = $0A
VIRUS_MOVE_INTERVAL = $04
VIRUS_CHANGE_FRAME_INTERVAL = $0a
VIRUS_WIDTH = $10
VIRUS_HEIGHT = $10

PILL_LIFE_TIME = $01
PILL_WIDTH = $08
PILL_HEIGHT = $08

POWERUP_LIFE_TIME = $01
POWERUP_WIDTH = $08
POWERUP_HEIGHT = $08
POWERUP_DASH = $00
POWERUP_ATTACK = $01

PLAYER_WIDTH = $10
PLAYER_HEIGHT = $10
PLAYER_DASHING_TIMEOUT = $1f
PLAYER_NORMAL_SPEED = $01
PLAYER_DASH_SPEED = $03
PLAYER_CHANGE_FRAME_INTERVAL = $08
PLAYER_ATTACK_MAX = $09
PLAYER_INVINCIBLE_DURATION = $ff
PLAYER_DASH_INCREMENT = $02
PLAYER_DASH_MAX = $10

PRE_LEVEL_MODE = $00
PASSWORD_GAME_MODE = $01
CREDITS_GAME_MODE = $02
GAME_OVER_MODE = $03
LEVEL_COMPLETED_MODE = $04
GAME_COMPLETED_MODE = $05
MAIN_MENU_MODE = $06
SHOP_MODE = $07
IN_GAME_MODE = $08

LAST_LEVEL = $05

COLLISSION = $01
NO_COLLISSION = $00

LUNG_HEALTHY_ATTRIBUTE = %10101010
LUNG_SICK_ATTRIBUTE = %11111111
ATTRIBUTE_COST_INCREASE = $02

WIN_ON_POINTS = $00
WIN_ON_KILLS = $01
WIN_ON_SMART_KILLS = $02
WIN_ON_POWERUPS = $03
WIN_BY_SURVIVING = $04

GAME_TIME_UNIT = $44

.include "music/tracks.asm"
.include "init.asm"

JSR LoadPalettes

MainGameLoop:
  JSR GetControllerInput

  LDA gameMode
  CMP #MAIN_MENU_MODE
  BNE :+
    JSR ReactOnInputInMenu
    JSR RenderMainMenu
    JSR RenderCursor
    JSR AdjustGameMode
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #GAME_OVER_MODE
  BNE :+
    JSR AdjustGameMode
    JSR RenderGameOver
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #PASSWORD_GAME_MODE
  BNE :+
    JSR ReactOnInputInPassword
    JSR AdjustGameMode
    JSR RenderPassword
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #SHOP_MODE
  BNE :+
    JSR ReactOnInputInShop
    JSR AdjustGameMode
    JSR RenderShop
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #PRE_LEVEL_MODE
  BNE :+
    JSR ReactOnInputInPreLevel
    JSR AdjustGameMode
    JSR RenderPreLevel
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #CREDITS_GAME_MODE
  BNE :+
    JSR ReactOnInputInCredits
    JSR RenderCredits
    JSR AdjustGameMode
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #LEVEL_COMPLETED_MODE
  BNE :+
    JSR AdjustGameMode
    JSR RenderGameCompleted
    JSR NextLevelIfNeeded
    JMP ContinueMainGameLoop
  :

  LDA gameMode
  CMP #GAME_COMPLETED_MODE
  BNE :+
    JSR AdjustGameMode
    JSR RenderGameCompleted
    JMP ContinueMainGameLoop
  :

  JSR ReactOnInputInGame
  JSR ComputeLogic
  JSR RenderGraphics

ContinueMainGameLoop:
  JSR ResetIfNeeded
  JSR WaitForNmi
  JMP MainGameLoop


ComputeLogic:
  JSR UpdateTimer
  JSR AdjustGameMode
  JSR SpawnPill
  JSR SpawnPowerup
  JSR CheckCollisions
  JSR MoveViruses
  JSR DashToDecimal
  JSR CheckWinCondition
  RTS

CheckCollisions:
  JSR CheckCollisionWithPill
  JSR CheckVirusesCollideWithPlayer
  JSR CheckCollisionWithPowerup
  RTS

WaitForNmi:
  LDA nmiTimer			;vblank wait
WaitForNmiLoop:
  CMP nmiTimer
  BEQ WaitForNmiLoop
  RTS

ResetIfNeeded:
  LDA initReset
  BEQ :+
    DEC resetCounter
    LDA resetCounter
    CMP #$A0
    BNE :+
      LDA #GAME_OVER_MODE
      STA gameMode
    :
    LDA resetCounter
    BNE :+
      JMP ($FFFC)
  :

  RTS

NextLevelIfNeeded:
  LDA initNextLevel
  BEQ EndNextLevelIfNeeded
  DEC resetCounter
  LDA resetCounter
  CMP #$A0
  BNE EndNextLevelIfNeeded

  LDA levelNo
  CMP #LAST_LEVEL
  BCC :+
    LDA #GAME_COMPLETED_MODE
    STA gameMode
    JMP EndNextLevelIfNeeded
  :

  LDA #SHOP_MODE
  STA gameMode

EndNextLevelIfNeeded:
  RTS

.include "nmi.asm"

RenderGraphics:
  LDA #$00
  STA spriteCounter
  JSR RenderPlayer
  JSR RenderPill
  JSR RenderPowerup
  JSR RenderViruses
  JSR RenderHUD
  JSR RenderGame

  RTS

RenderGame:
  LDA gameRendered
  BEQ :+
    JSR RenderPartialGameBackground
    RTS
  :

  .include "background/game_background.asm"
  INC gameRendered
  RTS

RenderGameOver:
  LDA gameEndRendered

  BNE :+
    .include "background/game_over_background.asm"
    INC gameEndRendered
  :

  RTS

RenderPassword:
  LDA passwordRendered
  BEQ :+
    JSR RenderPartialPasswordBackground
    RTS
  :

  .include "background/password_background.asm"
  INC passwordRendered

  RTS

RenderPreLevel:
  LDA preLevelRendered
  BEQ :+
    JSR RenderPartialPreLevelBackground
    RTS
  :

  .include "background/pre_level_background.asm"
  INC preLevelRendered

  RTS

RenderShop:
  LDA shopRendered
  BEQ :+
    JSR RenderPartialShopBackground
    RTS
  :

  .include "background/shop_background.asm"
  INC shopRendered

  RTS

RenderCredits:
  LDA creditsRendered
  BNE :+
    .include "background/credits_background.asm"
    INC creditsRendered
  :

  LDA creditsRendered
  BEQ :+
    JSR SlowlyScrollDown
  :

  RTS

RenderGameCompleted:
  LDA gameEndRendered

  BNE :+
    .include "background/game_completed_background.asm"
    INC gameEndRendered
  :

  RTS

RenderMainMenu:
  LDA mainMenuRendered

  BNE :+
    .include "background/menu_background.asm"
    INC mainMenuRendered
  :

  RTS

.include "gamepad/capture_input.asm"

.include "gamepad/game.asm"

.include "gamepad/main_menu.asm"

.include "gamepad/credits.asm"

.include "gamepad/password.asm"

.include "gamepad/shop.asm"

.include "gamepad/pre_level.asm"

.include "background/attributes.asm"

.include "background/background.asm"

.include "background/game_background_partial_update.asm"

.include "background/password_background_partial_update.asm"

.include "background/shop_background_partial_update.asm"

.include "background/pre_level_background_partial_update.asm"

.include "background/game_attributes.asm"

.include "background/menu_attributes.asm"

.include "actor/cursor.asm"

.include "state/game_mode.asm"

.include "actor/player.asm"

.include "gfx/pallete.asm"

.include "actor/virus.asm"

.include "gfx/hud.asm"

.include "actor/pill.asm"

.include "actor/powerup.asm"

.include "utils.asm"

.include "gfx/gfx.asm"

.include "state/level.asm"

.segment "VECTORS"
  .word NMI
  .word Reset
  ;

.segment "CHARS"
  .incbin "gfx/nesdemia.chr"
