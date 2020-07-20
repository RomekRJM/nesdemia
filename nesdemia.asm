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
.define initReset $4b
.define resetCounter $4c
.define powerupLeft $4d
.define powerupTop $4e
.define powerupRight $4f
.define powerupBottom $50
.define powerupTimer $51
.define powerupLifeTime $52
.define powerupType $53
.define powerupActive $54
.define dashIndex0 $55
.define dashIndex1 $56
.define gameMode $57
.define previousGameMode $58
.define refreshBackground $59
.define menuCursorTop $5a
.define difficultyLevel $5b
.define gameEndRendered $5c
.define gameRendered $5d
.define virusLeft $5e
.define virusTop $5f
.define virusRight $60
.define virusBottom $61
.define virusXSpeed $62
.define virusYSpeed $63
.define virusXDirection $64
.define virusYDirection $65
.define virusAlive $66
.define virusMoveFrame $67
.define virusAnimationFrame $68
.define virusAnimationChangeFrame $69
.define virusSmart $6a
.define virusCntr $6b
.define virusPointer $6c
; level specific
.define levelNo $6d
.define winCondition $6e
.define winThreshold $6f
.define points $70
.define kills $71
.define smartKills $72
.define usedPowerups $73
.define timeLimit $74
.define noViruses $75
.define smartVirusChance $76
.define powerupChance $77
.define attackChance $78
.define LastLinesTextLo $79
.define LastLinesTextHi $7a
.define winThresholdDigit1 $7b
.define winThresholdDigit0 $7c
.define timeDigit1 $7d
.define timeDigit0 $7e
.define countdownTimer $7f
; takes 32 bits
.define backgroundLastLinesTmp $80 ; 32
.define dbg1 $a0
.define dbg2 $a1

.segment "STARTUP"

; 0x0100 - ... - viruses
.define backgroundMemory $0300 ; 1024
.define backgroundLLMemory $03A0 ; 32
.define attributeMemory $03C0 ; 64

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

POINTS_TO_WIN = $1A

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
    RTS
  :

  .include "game_background.asm"
  INC gameRendered

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
