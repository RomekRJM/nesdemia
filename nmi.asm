NMI:

  ; copy sprite data from $0200 => PPU memory for display
  LDA #$02
  STA $4014

  INC frame
  INC nmiTimer

  LDA frame
  BNE :+
    DEC timeLimit
  :

  RTI
