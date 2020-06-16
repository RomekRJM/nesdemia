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
.define virusLeft $2b
.define virusTop $2c
.define virusRight $2d
.define virusBottom $2e
.define virusXSpeed $2f
.define virusYSpeed $30
.define virusXDirection $31
.define virusYDirection $32
.define virusAlive $33
.define virusMoveFrame $34
.define virusAnimationFrame $35
.define virusAnimationChangeFrame $36
.define noViruses $37
.define virusCntr $38
.define virusPointer $39
.define playerLeft $3a
.define playerTop $3b
.define playerRight $3c
.define playerBottom $3d
.define playerNucleusLeft $3e
.define playerNucleusTop $3f
.define playerInvincible $40
.define playerDashing $41
.define playerDashCount $42
.define playerSpeed $43
.define playerPallete $44
.define playerAnimationFrame $45
.define playerAnimationChangeFrame $46
.define playerAttacks $47
.define health $48
.define initReset $49
.define resetCounter $4a
.define powerupLeft $4b
.define powerupTop $4c
.define powerupRight $4d
.define powerupBottom $4e
.define powerupTimer $4f
.define powerupLifeTime $50
.define powerupType $51
.define powerupActive $52
.define dashIndex0 $53
.define dashIndex1 $54
.define gameMode $55
.define previousGameMode $56
.define refreshBackground $57
.define menuCursorTop $58
.define difficultyLevel $59
.define gameOverRendered $5a
.define dbg1 $5b
.define dbg2 $5c

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

COLLISSION = $01
NO_COLLISSION = $00

LUNG_HEALTHY_ATTRIBUTE = %10101010
LUNG_SICK_ATTRIBUTE = %11111111


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
  LDA gameOverRendered

  BNE :+
    .include "game_over_background.asm"
    INC gameOverRendered
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
