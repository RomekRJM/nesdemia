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
    LDA $2002             ; read PPU status to reset the high/low latch
    LDA #$20
    STA $2006             ; write the high byte of $2000 address
    LDA #$e0
    STA $2006             ; write the low byte of $2000 address

    LDA frame
    AND #%00001111
    STA $2007
    BIT $2002
    LDA #$00
    STA $2005
    STA $2005

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
