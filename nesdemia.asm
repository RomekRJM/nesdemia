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
.define backgroundPointerLo $16
.define backgroundPointerHi $17
.define backgroundLLPointerLo $18
.define backgroundLLPointerHi $19
.define attributePointerLo $1a
.define attributePointerHi $1b
.define pointIndex0 $1c
.define pointIndex1 $1d
.define pointIndex2 $1e
.define renderedNumber $1f
.define renderedNumberOffset $20
.define playerCollidesWithObject $21
.define dim1Source $22
.define dim2Source $23
.define dim1Destination $24
.define dim2Destination $25
.define pillLeft $26
.define pillTop $27
.define pillRight $28
.define pillBottom $29
.define pillTimer $2a
.define pillLifeTime $2b
.define playerLeft $2c
.define playerTop $2d
.define playerRight $2e
.define playerBottom $2f
.define playerNucleusLeft $30
.define playerNucleusTop $31
.define playerInvincible $32
.define playerDashing $33
.define playerDashCount $34
.define playerLuck $35
.define playerAttack $36
.define playerSpeed $37
.define playerPallete $38
.define playerAnimationFrame $39
.define playerAnimationChangeFrame $3a
.define playerAttacks $3b
.define health $3c
.define healthUpdated $3d
.define initReset $3e
.define initNextLevel $3f
.define resetCounter $40
.define powerupLeft $41
.define powerupTop $42
.define powerupRight $43
.define powerupBottom $44
.define powerupTimer $45
.define powerupLifeTime $46
.define powerupType $47
.define powerupActive $48
.define dashIndex0 $49
.define dashIndex1 $4a
.define gameMode $4b
.define previousGameMode $4c
.define refreshBackground $4d
.define menuCursorTop $4e
.define menuOption $4f
.define gameEndRendered $50
.define gameRendered $51
.define creditsRendered $52
.define mainMenuRendered $53
.define virusLeft $54
.define virusTop $55
.define virusRight $56
.define virusBottom $57
.define virusXSpeed $58
.define virusYSpeed $59
.define virusXDirection $5a
.define virusYDirection $5b
.define virusAlive $5c
.define virusMoveFrame $5d
.define virusAnimationFrame $5e
.define virusAnimationChangeFrame $5f
.define virusSmart $60
.define virusCntr $61
.define virusPointer $62
; level specific
.define levelNo $63
.define winCondition $64
.define winThreshold $65
.define points $66
.define kills $67
.define smartKills $68
.define usedPowerups $69
.define timeLimit $6a
.define noViruses $6b
.define smartVirusChance $6c
.define powerupChance $6d
.define attackChance $6e
.define LastLinesTextLo $6f
.define LastLinesTextHi $70
.define winThresholdDigit1 $71
.define winThresholdDigit0 $72
.define timeDigit1 $73
.define timeDigit0 $74
.define countdownTimer $75
.define passwordCurrentDigit $76
.define passwordRendered $77
.define passwordValid $78
.define creditsScroll $79
.define ppuHigh $7a
.define ppuLow $7b
.define passwordArray $7c ; 7
; takes 32 bits
.define backgroundLastLinesTmp $83 ; 32
.define shopRendered $a3
.define currentShopItem $a4
.define luckBought $a5
.define attackBought $a6
.define speedBought $a7

;$b5 - $f2 - used by ggsound
.segment "STARTUP"

; 0x0100 - ... - viruses
.define backgroundMemory $0300 ; 1024
.define backgroundLLMemory $03A0 ; 32
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

IN_GAME_MODE = $00
PASSWORD_GAME_MODE = $01
CREDITS_GAME_MODE = $02
GAME_OVER_MODE = $03
LEVEL_COMPLETED_MODE = $04
GAME_COMPLETED_MODE = $05
MAIN_MENU_MODE = $06
SHOP_MODE = $07

LAST_LEVEL = $05

COLLISSION = $01
NO_COLLISSION = $00

LUNG_HEALTHY_ATTRIBUTE = %10101010
LUNG_SICK_ATTRIBUTE = %11111111

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
  CMP #CREDITS_GAME_MODE
  BNE :+
    JSR ReactOnInputInCredits
    JSR AdjustGameMode
    JSR RenderCredits
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

  LDA #IN_GAME_MODE
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
    JMP RenderGamePartialUpdate
  :

  .include "background/game_background.asm"
  INC gameRendered
  RTS

RenderGamePartialUpdate:
  JSR RenderPartialGameBackground
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
    JMP RenderPartialPasswordBackground
  :

  BNE :+
    .include "background/password_background.asm"
    INC passwordRendered
  :

  RTS

RenderShop:
  LDA shopRendered
  BEQ :+
    JSR RenderPartialShopBackground
  :

  LDA shopRendered
  BNE :+
    .include "background/shop_background.asm"
    INC shopRendered
  :

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

.include "background/attributes.asm"

.include "background/background.asm"

.include "background/game_background_partial_update.asm"

.include "background/password_background_partial_update.asm"

.include "background/shop_background_partial_update.asm"

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
  .incbin "nesdemia.chr"
