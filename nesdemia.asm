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
.define attributePointerLo $18
.define attributePointerHi $19
.define pointIndex0 $1a
.define pointIndex1 $1b
.define pointIndex2 $1c
.define points $1d
.define renderedNumber $1e
.define renderedNumberOffset $1f
.define playerCollidesWithObject $20
.define dim1Source $21
.define dim2Source $22
.define dim1Destination $23
.define dim2Destination $24
.define pillLeft $25
.define pillTop $26
.define pillRight $27
.define pillBottom $28
.define pillTimer $29
.define pillLifeTime $2a
.define playerLeft $2b
.define playerTop $2c
.define playerRight $2d
.define playerBottom $2e
.define playerNucleusLeft $2f
.define playerNucleusTop $30
.define playerInvincible $31
.define playerDashing $32
.define playerDashCount $33
.define playerSpeed $34
.define playerPallete $35
.define playerAnimationFrame $36
.define playerAnimationChangeFrame $37
.define playerAttacks $38
.define health $39
.define initReset $3a
.define resetCounter $3b
.define powerupLeft $3c
.define powerupTop $3d
.define powerupRight $3e
.define powerupBottom $3f
.define powerupTimer $40
.define powerupLifeTime $41
.define powerupType $42
.define powerupActive $43
.define dashIndex0 $44
.define dashIndex1 $45
.define gameMode $46
.define previousGameMode $47
.define refreshBackground $48
.define menuCursorTop $49
.define difficultyLevel $4a
.define gameEndRendered $4b
.define virusLeft $4c
.define virusTop $4d
.define virusRight $4e
.define virusBottom $4f
.define virusXSpeed $50
.define virusYSpeed $51
.define virusXDirection $52
.define virusYDirection $53
.define virusAlive $54
.define virusMoveFrame $55
.define virusAnimationFrame $56
.define virusAnimationChangeFrame $57
.define virusSmart $58
.define noViruses $59
.define virusCntr $5a
.define virusPointer $5b
.define dbg1 $5c
.define dbg2 $5d

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

POINTS_TO_WIN = $03


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

.segment "VECTORS"
  .word NMI
  .word Reset
  ;

.segment "CHARS"
  .incbin "nesdemia.chr"
