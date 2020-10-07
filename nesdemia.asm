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

.define nmiTimer $20
.define buttons $21
.define previousButtons $22
.define frame   $23
.define randomByte $24
.define spriteCounter $25
.define backgroundPointerLo $26
.define backgroundPointerHi $27
.define backgroundLLPointerLo $28
.define backgroundLLPointerHi $29
.define attributePointerLo $2a
.define attributePointerHi $2b
.define pointIndex0 $2c
.define pointIndex1 $2d
.define pointIndex2 $2e
.define renderedNumber $2f
.define renderedNumberOffset $30
.define playerCollidesWithObject $31
.define dim1Source $32
.define dim2Source $33
.define dim1Destination $34
.define dim2Destination $35
.define pillLeft $36
.define pillTop $37
.define pillRight $38
.define pillBottom $39
.define pillTimer $3a
.define pillLifeTime $3b
.define playerLeft $3c
.define playerTop $3d
.define playerRight $3e
.define playerBottom $3f
.define playerNucleusLeft $40
.define playerNucleusTop $41
.define playerInvincible $42
.define playerDashing $43
.define playerDashCount $44
.define playerSpeed $45
.define playerLuck $46
.define playerAttack $47
.define playerPallete $48
.define playerAnimationFrame $49
.define playerAnimationChangeFrame $4a
.define playerAttacks $4b
.define health $4c
.define healthUpdated $4d
.define initReset $4e
.define initNextLevel $4f
.define resetCounter $50
.define powerupLeft $51
.define powerupTop $52
.define powerupRight $53
.define powerupBottom $54
.define powerupTimer $55
.define powerupLifeTime $56
.define powerupType $57
.define powerupActive $58
.define dashIndex0 $59
.define dashIndex1 $5a
.define gameMode $5b
.define previousGameMode $5c
.define refreshBackground $5d
.define menuCursorTop $5e
.define menuOption $5f
.define gameEndRendered $60
.define gameRendered $61
.define creditsRendered $62
.define mainMenuRendered $63
.define virusLeft $64
.define virusTop $65
.define virusRight $66
.define virusBottom $67
.define virusXSpeed $68
.define virusYSpeed $69
.define virusXDirection $6a
.define virusYDirection $6b
.define virusAlive $6c
.define virusMoveFrame $6d
.define virusAnimationFrame $6e
.define virusAnimationChangeFrame $6f
.define virusSmart $70
.define virusCntr $71
.define virusPointer $72
; level specific
.define levelNo $73
.define winCondition $74
.define winThreshold $75
.define points $76
.define kills $77
.define smartKills $78
.define usedPowerups $79
.define timeLimit $7a
.define noViruses $7b
.define smartVirusChance $7c
.define powerupChance $7d
.define attackChance $7e
.define LastLinesTextLo $7f
.define LastLinesTextHi $80
.define winThresholdDigit1 $81
.define winThresholdDigit0 $82
.define timeDigit1 $83
.define timeDigit0 $84
.define countdownTimer $85
.define passwordCurrentDigit $86
.define passwordRendered $87
.define passwordValid $88
.define passwordArray $89 ; 7
; takes 32 bits
.define backgroundLastLinesTmp $90 ; 32
.define dbg1 $b0
.define dbg2 $b1

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

RenderCredits:
  LDA creditsRendered
  BNE :+
    .include "background/credits_background.asm"
    INC creditsRendered
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

.include "background/attributes.asm"

.include "background/background.asm"

.include "background/game_background_partial_update.asm"

.include "background/password_background_partial_update.asm"

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
