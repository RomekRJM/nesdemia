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
.define resetCounter $4d
.define powerupLeft $4e
.define powerupTop $4f
.define powerupRight $50
.define powerupBottom $51
.define powerupTimer $52
.define powerupLifeTime $53
.define powerupType $54
.define powerupActive $55
.define dashIndex0 $56
.define dashIndex1 $57
.define gameMode $58
.define previousGameMode $59
.define refreshBackground $5a
.define menuCursorTop $5b
.define difficultyLevel $5c
.define gameEndRendered $5d
.define gameRendered $5e
.define virusLeft $5f
.define virusTop $60
.define virusRight $61
.define virusBottom $62
.define virusXSpeed $63
.define virusYSpeed $64
.define virusXDirection $65
.define virusYDirection $66
.define virusAlive $67
.define virusMoveFrame $68
.define virusAnimationFrame $69
.define virusAnimationChangeFrame $6a
.define virusSmart $6b
.define virusCntr $6c
.define virusPointer $6d
; level specific
.define levelNo $6e
.define winCondition $6f
.define winThreshold $70
.define points $71
.define kills $72
.define smartKills $73
.define usedPowerups $74
.define timeLimit $75
.define noViruses $76
.define smartVirusChance $77
.define powerupChance $78
.define attackChance $79
.define LastLinesTextLo $7a
.define LastLinesTextHi $7b
.define winThresholdDigit1 $7c
.define winThresholdDigit0 $7d
.define timeDigit1 $7e
.define timeDigit0 $7f
.define countdownTimer $80
; takes 32 bits
.define backgroundLastLinesTmp $81 ; 32
.define dbg1 $a1
.define dbg2 $a2

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

MAIN_MENU_MODE = $00
IN_GAME_MODE = $01
GAME_OVER_MODE = $02
GAME_COMPLETED_MODE = $03

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

.include "init.asm"

JSR LoadPalettes

.include "menu_background.asm"

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

  .include "game_background.asm"
  INC gameRendered
  RTS

RenderGamePartialUpdate:
  .include "game_background_partial_update.asm"
  RTS

RenderGameOver:
  LDA gameEndRendered

  BNE :+
    .include "game_over_background.asm"
    INC gameEndRendered
  :

  RTS

RenderGameCompleted:
  LDA gameEndRendered

  BNE :+
    .include "game_completed_background.asm"
    INC gameEndRendered
  :

  RTS

.include "attributes.asm"

.include "background.asm"

.include "game_attributes.asm"

.include "menu_attributes.asm"

.include "cursor.asm"

.include "game_mode.asm"

.include "player.asm"

.include "pallete.asm"

.include "virus.asm"

.include "hud.asm"

.include "pill.asm"

.include "powerup.asm"

.include "utils.asm"

.include "gfx.asm"

.include "level.asm"

.segment "VECTORS"
  .word NMI
  .word Reset
  ;

.segment "CHARS"
  .incbin "nesdemia.chr"
