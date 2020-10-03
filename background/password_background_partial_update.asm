RenderPartialPasswordBackground:

  LDX #$00
  LDY #$00

; Begin update password digits
  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$21
  STA partialUpdateMemory, Y
  INY

  LDA #$e9
  STA partialUpdateMemory, Y
  INY

  LDA passwordArray, X
  STA partialUpdateMemory, Y
  INY
  INX

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$21
  STA partialUpdateMemory, Y
  INY

  LDA #$ec
  STA partialUpdateMemory, Y
  INY

  LDA passwordArray, X
  STA partialUpdateMemory, Y
  INY
  INX

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$21
  STA partialUpdateMemory, Y
  INY

  LDA #$ef
  STA partialUpdateMemory, Y
  INY

  LDA passwordArray, X
  STA partialUpdateMemory, Y
  INY
  INX

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$21
  STA partialUpdateMemory, Y
  INY

  LDA #$f2
  STA partialUpdateMemory, Y
  INY

  LDA passwordArray, X
  STA partialUpdateMemory, Y
  INY
  INX

  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA #$21
  STA partialUpdateMemory, Y
  INY

  LDA #$f5
  STA partialUpdateMemory, Y
  INY

  LDA passwordArray, X
  STA partialUpdateMemory, Y
  INY
  INX
; End update password digits

; Clear previous arrows up

  LDA #$0f
  STA partialUpdateMemory, Y
  INY

  LDA #$21
  STA partialUpdateMemory, Y
  INY

  LDA #$a9
  STA partialUpdateMemory, Y
  INY

.repeat 15
  LDA #$88
  STA partialUpdateMemory, Y
  INY
.endrepeat

; Clear previous arrows down

  LDA #$0f
  STA partialUpdateMemory, Y
  INY

  LDA #$22
  STA partialUpdateMemory, Y
  INY

  LDA #$29
  STA partialUpdateMemory, Y
  INY

.repeat 15
  LDA #$88
  STA partialUpdateMemory, Y
  INY
.endrepeat

; Begin update arrow up/down
  LDA passwordCurrentDigit
  BNE :+
    ; high byte of arrow up position
    LDA #$21
    STA $00

    ; low byte of arrow up position
    LDA #$a9
    STA $01

    ; high byte of arrow down position
    LDA #$22
    STA $02

    ; low byte of arrow down position
    LDA #$29
    STA $03
  :

  LDA passwordCurrentDigit
  CMP #$01
  BNE :+
    ; high byte of arrow up position
    LDA #$21
    STA $00

    ; low byte of arrow up position
    LDA #$ac
    STA $01

    ; high byte of arrow down position
    LDA #$22
    STA $02

    ; low byte of arrow down position
    LDA #$2c
    STA $03
  :

  LDA passwordCurrentDigit
  CMP #$02
  BNE :+
    ; high byte of arrow up position
    LDA #$21
    STA $00

    ; low byte of arrow up position
    LDA #$af
    STA $01

    ; high byte of arrow down position
    LDA #$22
    STA $02

    ; low byte of arrow down position
    LDA #$2f
    STA $03
  :

  LDA passwordCurrentDigit
  CMP #$03
  BNE :+
    ; high byte of arrow up position
    LDA #$21
    STA $00

    ; low byte of arrow up position
    LDA #$b2
    STA $01

    ; high byte of arrow down position
    LDA #$22
    STA $02

    ; low byte of arrow down position
    LDA #$32
    STA $03
  :

  LDA passwordCurrentDigit
  CMP #$04
  BNE :+
    ; high byte of arrow up position
    LDA #$21
    STA $00

    ; low byte of arrow up position
    LDA #$b5
    STA $01

    ; high byte of arrow down position
    LDA #$22
    STA $02

    ; low byte of arrow down position
    LDA #$35
    STA $03
  :

  ; update arrow up
  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA $00
  STA partialUpdateMemory, Y
  INY

  LDA $01
  STA partialUpdateMemory, Y
  INY

  LDA #$2a
  STA partialUpdateMemory, Y
  INY

  ; update arrow down
  LDA #$01
  STA partialUpdateMemory, Y
  INY

  LDA $02
  STA partialUpdateMemory, Y
  INY

  LDA $03
  STA partialUpdateMemory, Y
  INY

  LDA #$2c
  STA partialUpdateMemory, Y
  INY

  LDA passwordValid
  BNE :+
    ; Print WRONG
    LDA #$09
    STA partialUpdateMemory, Y
    INY

    LDA $02
    STA partialUpdateMemory, Y
    INY

    LDA $b8
    STA partialUpdateMemory, Y
    INY

    LDA #$20
    STA partialUpdateMemory, Y
    INY

    LDA #$88
    STA partialUpdateMemory, Y
    INY

    LDA #$1b
    STA partialUpdateMemory, Y
    INY

    LDA #$88
    STA partialUpdateMemory, Y
    INY

    LDA #$18
    STA partialUpdateMemory, Y
    INY

    LDA #$88
    STA partialUpdateMemory, Y
    INY

    LDA #$17
    STA partialUpdateMemory, Y
    INY

    LDA #$88
    STA partialUpdateMemory, Y
    INY

    LDA #$10
    STA partialUpdateMemory, Y
    INY

    JMP EndRenderPartialPasswordBackground
  :

  ; clear WRONG
  LDA #$09
  STA partialUpdateMemory, Y
  INY

  LDA $02
  STA partialUpdateMemory, Y
  INY

  LDA $b8
  STA partialUpdateMemory, Y
  INY

.repeat 9
  LDA #$88
  STA partialUpdateMemory, Y
  INY
.endrepeat

EndRenderPartialPasswordBackground:
  LDA #$00
  STA partialUpdateMemory, Y
  INY

  LDA #$01
  STA refreshBackground

  RTS
