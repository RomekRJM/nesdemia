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
.define renderedNumber $19
.define renderedNumberOffset $1a
.define playerCollidesWithObject $1b
.define dim1Source $1c
.define dim2Source $1d
.define dim1Destination $1e
.define dim2Destination $1f
.define pillLeft $20
.define pillTop $21
.define pillRight $22
.define pillBottom $23
.define pillTimer $24
.define pillLifeTime $25
.define virusLeft $26
.define virusTop $27
.define virusRight $28
.define virusBottom $29
.define virusXSpeed $2a
.define virusYSpeed $2b
.define virusXDirection $2c
.define virusYDirection $2d
.define virusAlive $2e
.define virusMoveFrame $2f
.define virusAnimationFrame $30
.define virusAnimationChangeFrame $31
.define virusCntr $32
.define virusPointer $33
.define playerLeft $34
.define playerTop $35
.define playerRight $36
.define playerBottom $37
.define playerNucleusLeft $38
.define playerNucleusTop $39
.define playerInvincible $3a
.define playerDashing $3b
.define playerDashCount $3c
.define playerSpeed $3d
.define playerPallete $3e
.define playerAnimationFrame $3f
.define playerAnimationChangeFrame $40
.define playerAttacks $41
.define health $42
.define attributesNeedReloading $43
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
.define dbg1 $50
.define dbg2 $51

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
  JSR LoadAttributes
  LDA #$00
  STA spriteCounter
  JSR RenderPlayer
  JSR RenderPill
  JSR RenderPowerup
  JSR RenderViruses
  JSR RenderHUD

  RTS

.include "attributes.asm"

.include "player.asm"

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
