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
.define playerLeft $13
.define playerTop $14
.define playerRight $15
.define playerBottom $16
.define playerInvincible $17
.define randomByte $18
.define spriteCounter $19
.define pillLeft $1a
.define pillTop $1b
.define pillRight $1c
.define pillBottom $1d
.define pillTimer $1e
.define pillLifeTime $1f
.define pointIndex0 $20
.define pointIndex1 $21
.define pointIndex2 $22
.define points $23
.define currentPointIndex $24
.define pointIndexOffset $25
.define playerCollidesWithObject $26
.define dim1Source $27
.define dim2Source $28
.define dim1Destination $29
.define dim2Destination $2a
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
.define virusCntr $37
.define virusPointer $38
.define powerupLeft $39
.define powerupTop $3a
.define powerupRight $3b
.define powerupBottom $3c
.define powerupTimer $3d
.define powerupLifeTime $3e
.define dbg1 $3f
.define dbg2 $40
.define playerPallete $41
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

NO_VIRUSES = $08
VIRUS_MOVE_INTERVAL = $04
VIRUS_CHANGE_FRAME_INTERVAL = $0a

PILL_LIFE_TIME = $1a
PILL_WIDTH = $08
PILL_HEIGHT = $08

POWERUP_LIFE_TIME = $01
POWERUP_WIDTH = $08
POWERUP_HEIGHT = $08

PLAYER_WIDTH = $10
PLAYER_HEIGHT = $10

COLLISSION = $01
NO_COLLISSION = $00


Reset:
  SEI ; Disables all interrupts
  CLD ; disable decimal mode

  ; Disable sound IRQ
  LDX #$40
  STX $4017

  ; Initialize the stack register
  LDX #$FF
  TXS

  INX ; #$FF + 1 => #$00

  ; Zero out the PPU registers
  STX $2000
  STX $2001

  STX $4010

  :
    BIT $2002
    BPL :-

  TXA

CLEARMEM:
  STA $0000, X ; $0000 => $00FF
  STA $0100, X ; $0100 => $01FF
  STA $0300, X
  STA $0400, X
  STA $0500, X
  STA $0600, X
  STA $0700, X
  LDA #$FF
  STA $0200, X ; $0200 => $02FF
  LDA #$00
  INX
  BNE CLEARMEM
; wait for vblank
  :
    BIT $2002
    BPL :-

  LDA #$02
  STA $4014
  NOP

  ; $3F00
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
  LDA #$01
  STA nmiTimer

.include "pallete.asm"

.include "background.asm"

  ; Enable interrupts
  CLI

MainGameLoop:
  JSR GetControllerInput
  JSR ReactOnInput
  JSR ComputeLogic
  JSR RenderGraphics
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

NMI:
  LDA #$02 ; copy sprite data from $0200 => PPU memory for display
  STA $4014
  INC frame
  INC nmiTimer
  RTI

.include "gamepad.asm"

RenderGraphics:
  LDA #$00
  STA spriteCounter
  JSR RenderPlayer
  JSR RenderPill
  JSR RenderPowerup
  JSR RenderViruses
  JSR RenderPoints

  RTS

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
