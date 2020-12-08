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
.define palettePointerLo $17
.define palettePointerHi $18
.define backgroundPointerLo $19
.define backgroundPointerHi $1a
.define backgroundLLPointerLo $1b
.define backgroundLLPointerHi $1c
.define attributePointerLo $1d
.define attributePointerHi $1e
.define pointIndex0 $1f
.define pointIndex1 $20
.define pointIndex2 $21
.define renderedNumber $22
.define renderedNumberOffset $23
.define playerCollidesWithObject $24
.define dim1Source $25
.define dim2Source $26
.define dim1Destination $27
.define dim2Destination $28
.define pillLeft $29
.define pillTop $2a
.define pillRight $2b
.define pillBottom $2c
.define pillTimer $2d
.define pillLifeTime $2e
.define playerLeft $2f
.define playerTop $30
.define playerRight $31
.define playerBottom $32
.define playerNucleusLeft $33
.define playerNucleusTop $34
.define playerInvincible $35
.define playerDashing $36
.define playerDashCount $37
.define playerLuck $38
.define playerAttack $39
.define playerSpeed $3a
.define playerCurrentSpeed $3b
.define playerPallete $3c
.define playerAnimationFrame $3d
.define playerAnimationChangeFrame $3e
.define playerAttacks $3f
.define health $40
.define healthUpdated $41
.define initReset $42
.define initNextLevel $43
.define resetCounter $44
.define powerupLeft $45
.define powerupTop $46
.define powerupRight $47
.define powerupBottom $48
.define powerupLifeTime $49
.define powerupType $4a
.define powerupActive $4b
.define dashIndex0 $4c
.define dashIndex1 $4d
.define gameMode $4e
.define previousGameMode $4f
.define refreshBackground $50
.define refreshPalette $51
.define menuCursorTop $52
.define menuOption $53
.define gameEndRendered $54
.define gameRendered $55
.define creditsRendered $56
.define mainMenuRendered $57
.define preLevelRendered $58
.define virusLeft $59
.define virusTop $5a
.define virusRight $5b
.define virusBottom $5c
.define virusXSpeed $5d
.define virusYSpeed $5e
.define virusXDirection $5f
.define virusYDirection $60
.define virusAlive $61
.define virusMoveFrame $62
.define virusAnimationFrame $63
.define virusAnimationChangeFrame $64
.define virusSmart $65
.define virusCntr $66
.define virusPointer $67
; level specific
.define levelNo $68
.define winCondition $69
.define winThreshold $6a
.define points $6b
.define kills $6c
.define smartKills $6d
.define usedPowerups $6e
.define timeLimit $6f
.define noViruses $70
.define smartVirusChance $71
.define powerupChance $72
.define attackChance $73
.define LastLinesTextLo $74
.define LastLinesTextHi $75
.define winThresholdDigit1 $76
.define winThresholdDigit0 $77
.define timeDigit1 $78
.define timeDigit0 $79
.define countdownTimer $7a
.define passwordCurrentDigit $7b
.define passwordRendered $7c
.define passwordValid $7d
.define creditsScroll $7e
.define ppuHigh $7f
.define ppuLow $80
.define passwordArray $81 ; 7
.define shopRendered $88
.define currentShopItem $89
.define luckBought $8a
.define attackBought $8b
.define speedBought $8c
.define shopConfirm $8d
.define dbg1 $8e
.define dbg2 $8f

;$b5 - $f2 - used by ggsound
.segment "STARTUP"

; 0x0100 - ... - viruses
.define backgroundMemory $0300 ; 1024
.define backgroundLLMemory $0380 ; 32
.define backgroundLastLinesTmp $03A0 ; 32
.define attributeMemory $03C0 ; 64
.define partialUpdateMemory $0400 ; 256
.define paletteUpdateMemory $0500 ; 32

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

POWERUP_LIFE_TIME = $80
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
INIT_GAME_MODE = $ff

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

JSR LoadMenuPalettes

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
  ; it's a hack, we need 2 NMIs to fully reload palette,
  ; which happens after we leave game mode
  CMP #$02
  BEQ :+
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

.include "gfx/palette.asm"

.include "gfx/in_game_palette.asm"

.include "gfx/menu_palette.asm"

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
