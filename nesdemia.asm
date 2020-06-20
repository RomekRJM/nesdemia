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

.define nmiTimer $04
.define buttons $05
.define previousButtons $06
.define frame   $07
.define randomByte $08
.define spriteCounter $09
.define backgroundPointerLo $0a
.define backgroundPointerHi $0b
.define attributePointerLo $0c
.define attributePointerHi $0d
.define pointIndex0 $0e
.define pointIndex1 $0f
.define pointIndex2 $10
.define renderedNumber $11
.define renderedNumberOffset $12
.define playerCollidesWithObject $13
.define dim1Source $14
.define dim2Source $15
.define dim1Destination $16
.define dim2Destination $17
.define pillLeft $18
.define pillTop $19
.define pillRight $1a
.define pillBottom $1b
.define pillTimer $1c
.define pillLifeTime $1d
.define playerLeft $1e
.define playerTop $1f
.define playerRight $20
.define playerBottom $21
.define playerNucleusLeft $22
.define playerNucleusTop $23
.define playerInvincible $24
.define playerDashing $25
.define playerDashCount $26
.define playerSpeed $27
.define playerPallete $28
.define playerAnimationFrame $29
.define playerAnimationChangeFrame $2a
.define playerAttacks $2b
.define health $2c
.define initReset $2d
.define resetCounter $2e
.define powerupLeft $2f
.define powerupTop $30
.define powerupRight $31
.define powerupBottom $32
.define powerupTimer $33
.define powerupLifeTime $34
.define powerupType $35
.define powerupActive $36
.define dashIndex0 $37
.define dashIndex1 $38
.define gameMode $39
.define previousGameMode $3a
.define refreshBackground $3b
.define menuCursorTop $3c
.define difficultyLevel $3d
.define gameEndRendered $3e
.define virusLeft $3f
.define virusTop $40
.define virusRight $41
.define virusBottom $42
.define virusXSpeed $43
.define virusYSpeed $44
.define virusXDirection $45
.define virusYDirection $46
.define virusAlive $47
.define virusMoveFrame $48
.define virusAnimationFrame $49
.define virusAnimationChangeFrame $4a
.define virusSmart $4b
.define virusCntr $4c
.define virusPointer $4d
.define dbg1 $4e
.define dbg2 $4f
; level specific
.define levelNo $50
.define winCondition $51
.define winThreshold $52
.define points $53
.define kills $54
.define smartKills $55
.define usedPowerups $56
.define timeLimit $57
.define noViruses $58
.define smartVirusChance $59
.define powerupChance $5a
.define attackChance $5b

; 0x70 - 0x78 - virus1
; 0x79 - 0x80 - virus2
; 0x81 - 0x89 - virus3
; 0x8a - 0x92 - virus4
; and so on..

.segment "STARTUP"

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
  .include "game_background.asm"

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
