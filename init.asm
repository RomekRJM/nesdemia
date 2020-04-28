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


InitVariables:
  LDA #$c0
  STA health
