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
.define virusCntr $33
.define virusPointer $34
.define playerLeft $35
.define playerTop $36
.define playerRight $37
.define playerBottom $38
.define playerNucleusLeft $39
.define playerNucleusTop $3a
.define playerInvincible $3b
.define playerDashing $3c
.define playerDashCount $3d
.define playerSpeed $3e
.define playerPallete $3f
.define playerAnimationFrame $40
.define playerAnimationChangeFrame $41
.define playerAttacks $42
.define health $43
.define initReset $44
.define resetCounter $45
.define powerupLeft $46
.define powerupTop $47
.define powerupRight $48
.define powerupBottom $49
.define powerupTimer $4a
.define powerupLifeTime $4b
.define powerupType $4c
.define powerupActive $4d
.define dashIndex0 $4e
.define dashIndex1 $4f
.define gameMode $50
.define refreshBackground $51
.define menuCursorTop $52
.define difficultyLevel $53
.define dbg1 $54
.define dbg2 $55

; 0x70 - 0x78 - virus1
; 0x79 - 0x80 - virus2
; 0x81 - 0x89 - virus3
; 0x8a - 0x92 - virus4
; and so on..

.segment "STARTUP"

JOYPAD1 = $4016
JOYPAD2 = $4017

BEGIN_OF_ATTRIBUTES_MEMORY = $bf

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

.include "menu.asm"

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
  .include "background.asm"

  RTS

.include "attributes.asm"

.include "cursor.asm"

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
