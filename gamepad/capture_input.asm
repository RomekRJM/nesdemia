; At the same time that we strobe bit 0, we initialize the ring counter
; so we're hitting two birds with one stone here
GetControllerInput:
  LDA #$01
  ; While the strobe bit is set, buttons will be continuously reloaded.
  ; This means that reading from JOYPAD1 will only return the state of the
  ; first button: button A.
  STA JOYPAD1
  STA buttons
  LSR A        ; now A is 0
  ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
  ; This allows all 8 buttons (newly reloaded) to be read from JOYPAD1.
  STA JOYPAD1
GetControllerInputLoop:
  LDA JOYPAD1
  LSR A	       ; bit 0 -> Carry
  ROL buttons  ; Carry -> bit 0; bit 7 -> Carry
  BCC GetControllerInputLoop
  RTS
