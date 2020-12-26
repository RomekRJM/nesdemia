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

LDA #$00
STA levelNo

LDA #$01
STA playerLuck
STA playerAttack
STA playerCurrentSpeed
STA playerSpeed

; test code !
LDA #$00
STA points

LDA #MAIN_MENU_MODE
STA gameMode
LDA #INIT_GAME_MODE
STA previousGameMode

JSR InitVariables

LDA #$00
STA sound_param_byte_0
LDA #<song_list
STA sound_param_word_0
LDA #>song_list
STA sound_param_word_0+1
LDA #<sfx_list
STA sound_param_word_1
LDA #>sfx_list
STA sound_param_word_1+1
LDA #<instrument_list
STA sound_param_word_2
LDA #>instrument_list
STA sound_param_word_2+1
LDA #<dpcm_list
STA sound_param_word_3
LDA #>dpcm_list
STA sound_param_word_3+1
JSR sound_initialize
LDA #song_index_Main20Menu
JSR ChangeMusicTrack

LDA #$01
STA initCompleted
