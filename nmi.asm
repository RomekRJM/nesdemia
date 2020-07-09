NMI:
  ; back up registers
  PHA
  TXA
  PHA
  TYA
  PHA

  ; copy sprite data from $0200 => PPU memory for display
  LDA #$02
  STA $4014

  INC frame
  INC nmiTimer

  DEC countdownTimer
  LDA countdownTimer
  BNE :+
    LDA #GAME_TIME_UNIT
    STA countdownTimer
    INC refreshBackground
    DEC timeLimit
    DEC timeDigit0
    LDA timeDigit0
    CMP #$ff
    BNE :+
    LDA #$09
    STA timeDigit0
    DEC timeDigit1
  :

  ; restore registers
  PLA
  TAY
  PLA
  TAX
  PLA

  RTI
