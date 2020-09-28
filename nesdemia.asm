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
.define playerPallete $46
.define playerAnimationFrame $47
.define playerAnimationChangeFrame $48
.define playerAttacks $49
.define health $4a
.define healthUpdated $4b
.define initReset $4c
.define initNextLevel $4d
.define resetCounter $4e
.define powerupLeft $4f
.define powerupTop $50
.define powerupRight $51
.define powerupBottom $52
.define powerupTimer $53
.define powerupLifeTime $54
.define powerupType $55
.define powerupActive $56
.define dashIndex0 $57
.define dashIndex1 $58
.define gameMode $59
.define previousGameMode $5a
.define refreshBackground $5b
.define menuCursorTop $5c
.define menuOption $5d
.define gameEndRendered $5e
.define gameRendered $5f
.define virusLeft $60
.define virusTop $61
.define virusRight $62
.define virusBottom $63
.define virusXSpeed $64
.define virusYSpeed $65
.define virusXDirection $66
.define virusYDirection $67
.define virusAlive $68
.define virusMoveFrame $69
.define virusAnimationFrame $6a
.define virusAnimationChangeFrame $6b
.define virusSmart $6c
.define virusCntr $6d
.define virusPointer $6e
; level specific
.define levelNo $6f
.define winCondition $70
.define winThreshold $71
.define points $72
.define kills $73
.define smartKills $74
.define usedPowerups $75
.define timeLimit $76
.define noViruses $77
.define smartVirusChance $78
.define powerupChance $79
.define attackChance $7a
.define LastLinesTextLo $7b
.define LastLinesTextHi $7c
.define winThresholdDigit1 $7d
.define winThresholdDigit0 $7e
.define timeDigit1 $7f
.define timeDigit0 $80
.define countdownTimer $81
; takes 32 bits
.define backgroundLastLinesTmp $82 ; 32
.define dbg1 $a2
.define dbg2 $a3

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

LAST_LEVEL = $06

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

.include "background/menu_background.asm"

MainGameLoop:
  JSR GetControllerInput

  LDA gameMode
  CMP #MAIN_MENU_MODE
  BNE :+
    JSR ReactOnInputInMenu
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
    JSR AdjustGameMode
    JSR RenderPassword
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

  JSR ReactOnInput
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

.include "gamepad.asm"

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
  LDA gameRendered

  BNE :+
    .include "background/password_background.asm"
    INC gameRendered
  :

  RTS

RenderGameCompleted:
  LDA gameEndRendered

  BNE :+
    .include "background/game_completed_background.asm"
    INC gameEndRendered
  :

  RTS

.include "background/attributes.asm"

.include "background/background.asm"

.include "background/game_background_partial_update.asm"

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
