Reset:
  SEI ; Disables all interrupts
  CLD ; disable decimal mode

  ; Initialize the stack register
  LDX #$FF
  TXS

  INX ; #$FF + 1 => #$00

  ; Zero out the PPU registers
  STX $2000
  STX $2001

  STX $4010

  TXA

CLEARMEM:
  STA $0000, X ; $0000 => $00FF
  STA $0100, X ; $0100 => $01FF
  STA $0300, X
  STA $0400, X
  STA $0500, X
  STA $0600, X
  STA $0700, X
  LDA #$ff
  STA $0200, X ; $0200 => $02FF
  LDA #$00
  INX
  BNE CLEARMEM

  ; Disable sound IRQ
  LDX #$40
  STX $4017

  ; Enable interrupts
  CLI

.repeat 3
; wait for vblank
:
  BIT $2002
  BPL :-
.endrepeat

InitVariables:
  LDA #$00
  STA gameRendered

  LDA #$01
  STA nmiTimer
  STA refreshBackground

  LDA #$05
  STA levelNo

  LDA #$c0
  STA resetCounter

  LDA #$80
  STA playerTop
  STA playerLeft

  LDA #GAME_TIME_UNIT
  STA countdownTimer
