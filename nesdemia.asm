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
.define frame   $12
.define randomByte $13
.define spriteCounter $14
.define pointIndex0 $15
.define pointIndex1 $16
.define pointIndex2 $17
.define points $18
.define currentPointIndex $19
.define pointIndexOffset $1a
.define playerCollidesWithObject $1b
.define dim1Source $1c
.define dim2Source $1d
.define dim1Destination $1e
.define dim2Destination $1f
.define powerupLeft $20
.define powerupTop $21
.define powerupRight $22
.define powerupBottom $23
.define powerupTimer $24
.define powerupLifeTime $25
.define pillLeft $26
.define pillTop $27
.define pillRight $28
.define pillBottom $29
.define pillTimer $2a
.define pillLifeTime $2b
.define virusLeft $2c
.define virusTop $2d
.define virusRight $2e
.define virusBottom $2f
.define virusXSpeed $30
.define virusYSpeed $31
.define virusXDirection $32
.define virusYDirection $33
.define virusAlive $34
.define virusMoveFrame $35
.define virusAnimationFrame $36
.define virusAnimationChangeFrame $37
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
.define playerSpeed $42
.define playerPallete $43
.define playerAnimationFrame $44
.define playerAnimationChangeFrame $45
.define health $46
.define attributesNeedReloading $47
.define initReset $48
.define resetCounter $49
.define dbg1 $4a
.define dbg2 $4b

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

NO_VIRUSES = $01
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

PLAYER_WIDTH = $10
PLAYER_HEIGHT = $10
PLAYER_DASHING_TIMEOUT = $1f
PLAYER_NORMAL_SPEED = $01
PLAYER_DASH_SPEED = $03
PLAYER_CHANGE_FRAME_INTERVAL = $08

COLLISSION = $01
NO_COLLISSION = $00

LUNG_HEALTHY_ATTRIBUTE = %10101010
LUNG_SICK_ATTRIBUTE = %11111111


.include "init.asm"

.include "pallete.asm"

.include "background.asm"

  ; Enable interrupts
  CLI

MainGameLoop:
  JSR GetControllerInput
  JSR ReactOnInput
  JSR ComputeLogic
  JSR RenderGraphics
  JSR ResetIfNeeded
  JSR WaitForNmi
  JMP MainGameLoop

ComputeLogic:
  JSR SpawnPill
  JSR SpawnPowerup
  JSR CheckCollisions
  JSR MoveViruses
  RTS

CheckCollisions:
  JSR CheckCollisionWithPill
  JSR CheckVirusesCollideWithPlayer
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
  JSR LoadAttributes
  LDA #$00
  STA spriteCounter
  JSR RenderPlayer
  JSR RenderPill
  JSR RenderPowerup
  JSR RenderViruses
  JSR RenderPoints

  RTS

.include "attributes.asm"

.include "player.asm"

.include "virus.asm"

.include "points.asm"

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
