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
.define pointIndex0 $16
.define pointIndex1 $17
.define pointIndex2 $18
.define points $19
.define renderedNumber $1a
.define renderedNumberOffset $1b
.define playerCollidesWithObject $1c
.define dim1Source $1d
.define dim2Source $1e
.define dim1Destination $1f
.define dim2Destination $20
.define pillLeft $21
.define pillTop $22
.define pillRight $23
.define pillBottom $24
.define pillTimer $25
.define pillLifeTime $26
.define virusLeft $27
.define virusTop $28
.define virusRight $29
.define virusBottom $2a
.define virusXSpeed $2b
.define virusYSpeed $2c
.define virusXDirection $2d
.define virusYDirection $2e
.define virusAlive $2f
.define virusMoveFrame $30
.define virusAnimationFrame $31
.define virusAnimationChangeFrame $32
.define noViruses $33
.define virusCntr $34
.define virusPointer $35
.define playerLeft $36
.define playerTop $37
.define playerRight $38
.define playerBottom $39
.define playerNucleusLeft $3a
.define playerNucleusTop $3b
.define playerInvincible $3c
.define playerDashing $3d
.define playerDashCount $3e
.define playerSpeed $3f
.define playerPallete $40
.define playerAnimationFrame $41
.define playerAnimationChangeFrame $42
.define playerAttacks $43
.define health $44
.define initReset $45
.define resetCounter $46
.define powerupLeft $47
.define powerupTop $48
.define powerupRight $49
.define powerupBottom $4a
.define powerupTimer $4b
.define powerupLifeTime $4c
.define powerupType $4d
.define powerupActive $4e
.define dashIndex0 $4f
.define dashIndex1 $50
.define gameMode $51
.define previousGameMode $52
.define refreshBackground $53
.define menuCursorTop $54
.define difficultyLevel $55
.define backgroundPointerLo $56
.define backgroundPointerHi $57
.define dbg1 $58
.define dbg2 $59

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

  JSR ReactOnInput
  JSR ComputeLogic
  JSR RenderGraphics
  JSR ResetIfNeeded

ContinueMainGameLoop:
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
