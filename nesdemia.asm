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
.define randomByte $17
.define spriteCounter $18
.define pillLeft $19
.define pillTop $1a
.define pillRight $1b
.define pillBottom $1c
.define pillTimer $1d
.define pillLifeTime $1e
.define pointIndex0 $1f
.define pointIndex1 $20
.define pointIndex2 $21
.define points $22
.define currentPointIndex $23
.define pointIndexOffset $24
.define playerCollidesWithCoin $25
.define dim1Player $26
.define dim2Player $27
.define dim1Object $28
.define dim2Object $29
.define virusLeft $2a
.define virusTop $2b
.define virusRight $2c
.define virusBottom $2d
.define virusXSpeed $2e
.define virusYSpeed $2f
.define virusXDirection $30
.define virusYDirection $31
.define virusAlive $32
.define virusMoveFrame $33
.define virusAnimationFrame $34
.define virusAnimationChangeFrame $35
.define virusCntr $36
.define virusPointer $37
.define dbg1 $38
.define dbg2 $39
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
VIRUS_CHANGE_FRAME_INTERVAL = $1f

PILL_LIFE_TIME = $1a

PLAYER_WIDTH = $10
PLAYER_HEIGHT = $20

PILL_WIDTH = $08
PILL_HEIGHT = $08

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

  JSR InitPoints

MainGameLoop:
  JSR GetControllerInput
  JSR ReactOnInput
  JSR ComputeLogic
  JSR RenderGraphics
  JSR WaitForNmi
  JMP MainGameLoop

ComputeLogic:
  JSR SpawnPill
  JSR CheckCollisions
  JSR MoveViruses
  RTS

CheckCollisions:
  JSR CheckCollision
  LDA playerCollidesWithCoin
  CMP #COLLISSION
  BNE :+
    INC points
    JSR PointsToDecimal
    JSR ForcePillRespawn
    LDA #NO_COLLISSION
    STA playerCollidesWithCoin
  :
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
  JSR RenderViruses
  JSR RenderPoints

  RTS

.include "player.asm"

.include "virus.asm"

.include "points.asm"

.include "pill.asm"

.include "utils.asm"

.include "gfx.asm"

.segment "VECTORS"
  .word NMI
  .word Reset
  ;

.segment "CHARS"
  .incbin "nesdemia.chr"
