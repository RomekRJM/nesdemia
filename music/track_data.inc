song_list:
  .word _Main20Menu
  .word _In20Game

instrument_list:
  .word _Triangle_26_DPCM_0
  .word _Pulse_1
  .word _Pulse_Volume_Slide_2
  .word _Noise_3
  .word _Arpeggio_4
  .word _New_instrument_5
  .word _New_instrument_6
  .word silent_7

dpcm_list:
  .word dpcm_samples_list
  .word dpcm_note_to_sample_index
  .word dpcm_note_to_sample_length
  .word dpcm_note_to_loop_pitch_index

_Triangle_26_DPCM_0:
  .byte 5,7,9,11,ARP_TYPE_ABSOLUTE
  .byte 0,ENV_STOP
  .byte 0,ENV_STOP
  .byte 64,DUTY_ENV_STOP
  .byte ENV_STOP

_Pulse_1:
  .byte 5,19,21,23,ARP_TYPE_ABSOLUTE
  .byte 15,14,14,13,13,12,12,11,11,10,10,9,9,ENV_STOP
  .byte 0,ENV_STOP
  .byte 0,DUTY_ENV_STOP
  .byte ENV_STOP

_Pulse_Volume_Slide_2:
  .byte 5,43,45,48,ARP_TYPE_ABSOLUTE
  .byte 15,15,14,14,13,13,12,12,11,11,10,10,9,9,8,8,7,7,6,6,5,5,4,4,3,3,3,2,2,2,2,1,1,1,1,1,0,ENV_STOP
  .byte 0,ENV_STOP
  .byte 64,0,DUTY_ENV_STOP
  .byte ENV_STOP

_Noise_3:
  .byte 5,8,10,12,ARP_TYPE_ABSOLUTE
  .byte 12,0,ENV_STOP
  .byte 0,ENV_STOP
  .byte 0,DUTY_ENV_STOP
  .byte ENV_STOP

_Arpeggio_4:
  .byte 5,43,45,47,ARP_TYPE_ABSOLUTE
  .byte 15,15,14,14,13,13,12,12,11,11,10,10,9,9,8,8,7,7,6,6,5,5,4,4,3,3,3,2,2,2,2,1,1,1,1,1,0,ENV_STOP
  .byte 0,ENV_STOP
  .byte 64,DUTY_ENV_STOP
  .byte 0,0,3,3,7,7,ENV_LOOP,47

_New_instrument_5:
  .byte 5,17,19,21,ARP_TYPE_ABSOLUTE
  .byte 15,14,12,11,9,8,6,5,3,2,1,ENV_STOP
  .byte 0,ENV_STOP
  .byte 0,DUTY_ENV_STOP
  .byte ENV_STOP

_New_instrument_6:
  .byte 5,46,48,50,ARP_TYPE_ABSOLUTE
  .byte 1,1,2,2,3,3,4,4,5,5,6,6,7,7,7,7,6,6,6,6,6,6,5,5,5,5,5,5,4,4,4,4,4,4,3,3,3,3,3,3,ENV_STOP
  .byte 0,ENV_STOP
  .byte 128,DUTY_ENV_STOP
  .byte ENV_STOP

silent_7:
  .byte 5,7,9,11,ARP_TYPE_ABSOLUTE
  .byte 0,ENV_STOP
  .byte 0,ENV_STOP
  .byte 0,DUTY_ENV_STOP
  .byte ENV_STOP

dpcm_samples_list:
  .byte <(dpcm_sample_Kick_A >> 6)
  .byte <(dpcm_sample_Snare_A >> 6)
  .byte <(dpcm_sample_Tom_A >> 6)

dpcm_note_to_sample_index:
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$ff,$01,$ff,$02,$02,$ff,$02,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

dpcm_note_to_sample_length:
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$0d,$ff,$12,$ff,$24,$24,$ff,$24,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

dpcm_note_to_loop_pitch_index:
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$0f,$ff,$0f,$ff,$0d,$0e,$ff,$0f,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

_Main20Menu:
  .byte 51
  .byte 7
  .byte 0
  .byte 6
  .word _Main20Menu_square1
  .word _Main20Menu_square2
  .word _Main20Menu_triangle
  .word _Main20Menu_noise
  .word _Main20Menu_dpcm

_Main20Menu_square1:
  .byte CAL,<(_Main20Menu_square1_0),>(_Main20Menu_square1_0)
  .byte CAL,<(_Main20Menu_square1_0),>(_Main20Menu_square1_0)
_Main20Menu_square1_loop:
  .byte CAL,<(_Main20Menu_square1_0),>(_Main20Menu_square1_0)
  .byte CAL,<(_Main20Menu_square1_0),>(_Main20Menu_square1_0)
  .byte CAL,<(_Main20Menu_square1_0),>(_Main20Menu_square1_0)
  .byte CAL,<(_Main20Menu_square1_1),>(_Main20Menu_square1_1)
  .byte GOT
  .word _Main20Menu_square1_loop

_Main20Menu_square2:
_Main20Menu_square2_loop:
  .byte CAL,<(_Main20Menu_square2_0),>(_Main20Menu_square2_0)
  .byte CAL,<(_Main20Menu_square2_0),>(_Main20Menu_square2_0)
  .byte CAL,<(_Main20Menu_square2_1),>(_Main20Menu_square2_1)
  .byte CAL,<(_Main20Menu_square2_1),>(_Main20Menu_square2_1)
  .byte CAL,<(_Main20Menu_square2_4),>(_Main20Menu_square2_4)
  .byte CAL,<(_Main20Menu_square2_4),>(_Main20Menu_square2_4)
  .byte GOT
  .word _Main20Menu_square2_loop

_Main20Menu_triangle:
_Main20Menu_triangle_loop:
  .byte CAL,<(_Main20Menu_triangle_0),>(_Main20Menu_triangle_0)
  .byte CAL,<(_Main20Menu_triangle_0),>(_Main20Menu_triangle_0)
  .byte CAL,<(_Main20Menu_triangle_1),>(_Main20Menu_triangle_1)
  .byte CAL,<(_Main20Menu_triangle_1),>(_Main20Menu_triangle_1)
  .byte CAL,<(_Main20Menu_triangle_1),>(_Main20Menu_triangle_1)
  .byte CAL,<(_Main20Menu_triangle_1),>(_Main20Menu_triangle_1)
  .byte GOT
  .word _Main20Menu_triangle_loop

_Main20Menu_noise:
_Main20Menu_noise_loop:
  .byte CAL,<(_Main20Menu_noise_0),>(_Main20Menu_noise_0)
  .byte CAL,<(_Main20Menu_noise_0),>(_Main20Menu_noise_0)
  .byte CAL,<(_Main20Menu_noise_0),>(_Main20Menu_noise_0)
  .byte CAL,<(_Main20Menu_noise_0),>(_Main20Menu_noise_0)
  .byte CAL,<(_Main20Menu_noise_0),>(_Main20Menu_noise_0)
  .byte CAL,<(_Main20Menu_noise_0),>(_Main20Menu_noise_0)
  .byte GOT
  .word _Main20Menu_noise_loop

_Main20Menu_dpcm:
_Main20Menu_dpcm_loop:
  .byte CAL,<(_Main20Menu_dpcm_0),>(_Main20Menu_dpcm_0)
  .byte CAL,<(_Main20Menu_dpcm_1),>(_Main20Menu_dpcm_1)
  .byte CAL,<(_Main20Menu_dpcm_2),>(_Main20Menu_dpcm_2)
  .byte CAL,<(_Main20Menu_dpcm_2),>(_Main20Menu_dpcm_2)
  .byte CAL,<(_Main20Menu_dpcm_2),>(_Main20Menu_dpcm_2)
  .byte CAL,<(_Main20Menu_dpcm_2),>(_Main20Menu_dpcm_2)
  .byte GOT
  .word _Main20Menu_dpcm_loop

_Main20Menu_square1_0:
  .byte STI,7,SL8,A0,STI,2,SL6,D2,SLL,26,CS2,SL6,D2,SLL,18
  .byte DS2
  .byte RET

_Main20Menu_square1_1:
  .byte STI,7,SL8,A0,STI,2,SL6,D2,SLL,26,CS2,SL6,D2,SLL,18
  .byte DS2
  .byte RET

_Main20Menu_square2_0:
  .byte STI,7,SL9,A0,STI,2,SL6,D2,SLL,26,CS2,SL6,D2,SLL,17
  .byte DS2
  .byte RET

_Main20Menu_square2_1:
  .byte STI,1,SL2,F1,SL6,G1,SL8,D1,SLC,CS1,SL2,GS1,SL4,F1,SL6
  .byte G1,D1,SLE,DS1,SL2,GS1,F1
  .byte RET

_Main20Menu_square2_4:
  .byte STI,1,SLL,20,D3,SL2,CS3,SL6,DS3,SL2,CS3,SL0,D3,SLE,DS3
  .byte SL2,GS2,F2
  .byte RET

_Main20Menu_triangle_0:
  .byte STI,0,SL1,G2,STI,7,A0,STI,0,G2,STI,7,SL5,A0,STI,0,SL3
  .byte D2,STI,7,A0,STI,0,CS2,STI,7,SLB,A0,STI,0,SL1,GS2,STI,7
  .byte A0,STI,0,F2,STI,7,A0,STI,0,G2,STI,7,A0,STI,0,G2,STI,7
  .byte SL5,A0,STI,0,SL3,D2,STI,7,A0,STI,0,DS2,STI,7,SLB,A0,STI,0
  .byte SL1,GS2,STI,7,A0,STI,0,F2,STI,7,A0
  .byte RET

_Main20Menu_triangle_1:
  .byte STI,0,SL1,G2,STI,7,A0,STI,0,G3,STI,7,A0,STI,0,G2,STI,7
  .byte A0,STI,0,G3,STI,7,A0,STI,0,D2,STI,7,A0,STI,0,D3,STI,7
  .byte A0,STI,0,D2,STI,7,A0,STI,0,D3,STI,7,A0,STI,0,CS2,STI,7
  .byte A0,STI,0,CS3,STI,7,A0,STI,0,CS2,STI,7,A0,STI,0,CS3,STI,7
  .byte A0,STI,0,CS2,STI,7,A0,STI,0,CS3,STI,7,A0,STI,0,GS3,STI,7
  .byte A0,STI,0,F3,STI,7,A0,STI,0,G2,STI,7,A0,STI,0,G3,STI,7
  .byte A0,STI,0,G2,STI,7,A0,STI,0,G3,STI,7,A0,STI,0,D2,STI,7
  .byte A0,STI,0,D3,STI,7,A0,STI,0,D2,STI,7,A0,STI,0,D3,STI,7
  .byte A0,STI,0,DS2,STI,7,A0,STI,0,DS3,STI,7,A0,STI,0,DS2,STI,7
  .byte A0,STI,0,DS3,STI,7,A0,STI,0,DS2,STI,7,A0,STI,0,DS3,STI,7
  .byte A0,STI,0,GS2,STI,7,A0,STI,0,F3,STI,7,A0
  .byte RET

_Main20Menu_noise_0:
  .byte STI,3,SL2,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
  .byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
  .byte RET

_Main20Menu_dpcm_0:
  .byte STI,0,SL2,C3,SLL,30,C3,SL2,C3,SLL,30,C3
  .byte RET

_Main20Menu_dpcm_1:
  .byte STI,0,SL2,C3,SLL,30,C3,SL2,C3,SLL,20,C3,SL1,C3,C3,D3,C3
  .byte C3,D3,D3,D3,D3,D3
  .byte RET

_Main20Menu_dpcm_2:
  .byte STI,0,SL2,C3,SL6,C3,SL4,D3,SL2,C3,SL6,D3,SL1,C3,SL3,C3
  .byte SL2,D3,SL1,C3,SL3,C3,SL1,G3,D3,SL2,C3,SL6,C3,SL4,D3,SL2
  .byte C3,SL6,D3,SL1,C3,SL3,C3,SL2,D3,SL1,C3,SL3,C3,SL1,G3,G3
  .byte RET

_In20Game:
  .byte 0
  .byte 3
  .byte 128
  .byte 2
  .word _In20Game_square1
  .word _In20Game_square2
  .word _In20Game_triangle
  .word _In20Game_noise
  .word _In20Game_dpcm

_In20Game_square1:
_In20Game_square1_loop:
  .byte CAL,<(_In20Game_square1_4),>(_In20Game_square1_4)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_1),>(_In20Game_square1_1)
  .byte CAL,<(_In20Game_square1_2),>(_In20Game_square1_2)
  .byte CAL,<(_In20Game_square1_1),>(_In20Game_square1_1)
  .byte CAL,<(_In20Game_square1_2),>(_In20Game_square1_2)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte CAL,<(_In20Game_square1_0),>(_In20Game_square1_0)
  .byte GOT
  .word _In20Game_square1_loop

_In20Game_square2:
_In20Game_square2_loop:
  .byte CAL,<(_In20Game_square2_9),>(_In20Game_square2_9)
  .byte CAL,<(_In20Game_square2_0),>(_In20Game_square2_0)
  .byte CAL,<(_In20Game_square2_0),>(_In20Game_square2_0)
  .byte CAL,<(_In20Game_square2_0),>(_In20Game_square2_0)
  .byte CAL,<(_In20Game_square2_0),>(_In20Game_square2_0)
  .byte CAL,<(_In20Game_square2_1),>(_In20Game_square2_1)
  .byte CAL,<(_In20Game_square2_2),>(_In20Game_square2_2)
  .byte CAL,<(_In20Game_square2_1),>(_In20Game_square2_1)
  .byte CAL,<(_In20Game_square2_2),>(_In20Game_square2_2)
  .byte CAL,<(_In20Game_square2_3),>(_In20Game_square2_3)
  .byte CAL,<(_In20Game_square2_4),>(_In20Game_square2_4)
  .byte CAL,<(_In20Game_square2_5),>(_In20Game_square2_5)
  .byte CAL,<(_In20Game_square2_6),>(_In20Game_square2_6)
  .byte CAL,<(_In20Game_square2_7),>(_In20Game_square2_7)
  .byte CAL,<(_In20Game_square2_8),>(_In20Game_square2_8)
  .byte CAL,<(_In20Game_square2_7),>(_In20Game_square2_7)
  .byte CAL,<(_In20Game_square2_8),>(_In20Game_square2_8)
  .byte GOT
  .word _In20Game_square2_loop

_In20Game_triangle:
_In20Game_triangle_loop:
  .byte CAL,<(_In20Game_triangle_9),>(_In20Game_triangle_9)
  .byte CAL,<(_In20Game_triangle_0),>(_In20Game_triangle_0)
  .byte CAL,<(_In20Game_triangle_10),>(_In20Game_triangle_10)
  .byte CAL,<(_In20Game_triangle_0),>(_In20Game_triangle_0)
  .byte CAL,<(_In20Game_triangle_10),>(_In20Game_triangle_10)
  .byte CAL,<(_In20Game_triangle_1),>(_In20Game_triangle_1)
  .byte CAL,<(_In20Game_triangle_2),>(_In20Game_triangle_2)
  .byte CAL,<(_In20Game_triangle_1),>(_In20Game_triangle_1)
  .byte CAL,<(_In20Game_triangle_2),>(_In20Game_triangle_2)
  .byte CAL,<(_In20Game_triangle_0),>(_In20Game_triangle_0)
  .byte CAL,<(_In20Game_triangle_10),>(_In20Game_triangle_10)
  .byte CAL,<(_In20Game_triangle_0),>(_In20Game_triangle_0)
  .byte CAL,<(_In20Game_triangle_10),>(_In20Game_triangle_10)
  .byte CAL,<(_In20Game_triangle_0),>(_In20Game_triangle_0)
  .byte CAL,<(_In20Game_triangle_10),>(_In20Game_triangle_10)
  .byte CAL,<(_In20Game_triangle_0),>(_In20Game_triangle_0)
  .byte CAL,<(_In20Game_triangle_10),>(_In20Game_triangle_10)
  .byte GOT
  .word _In20Game_triangle_loop

_In20Game_noise:
_In20Game_noise_loop:
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte CAL,<(_In20Game_noise_0),>(_In20Game_noise_0)
  .byte GOT
  .word _In20Game_noise_loop

_In20Game_dpcm:
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
_In20Game_dpcm_loop:
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_0),>(_In20Game_dpcm_0)
  .byte CAL,<(_In20Game_dpcm_1),>(_In20Game_dpcm_1)
  .byte GOT
  .word _In20Game_dpcm_loop

_In20Game_square1_0:
  .byte STI,5,SL3,E1,E1,B0,E1,E1,E1,B0,E1,E1,E1,E1,E1,SL6,F1,G1
  .byte RET

_In20Game_square1_1:
  .byte STI,5,SL3,E1,E1,B0,E1,E1,E1,B0,E1,F1,F1,F1,F1,SL6,F1,G1
  .byte RET

_In20Game_square1_2:
  .byte STI,5,SL3,E1,E1,B0,E1,E1,E1,B0,E1,G1,G1,G1,G1,SL6,G1,A1
  .byte RET

_In20Game_square1_4:
  .byte STI,7,SLL,48,A0
  .byte RET

_In20Game_square2_0:
  .byte STI,0,SL9,E3,E3,E3,E3,SLC,E3
  .byte RET

_In20Game_square2_1:
  .byte STI,4,SL9,E3,STI,2,SLF,B3,STI,4,SL9,F3,STI,2,C4,SL3,D4
  .byte C4
  .byte RET

_In20Game_square2_2:
  .byte STI,4,SL9,E3,STI,2,SLF,B3,STI,4,SL9,G3,STI,2,D4,SL3,E4
  .byte D4
  .byte RET

_In20Game_square2_3:
  .byte STI,6,SLL,32,E3,SLA,D3,SL6,A2
  .byte RET

_In20Game_square2_4:
  .byte STI,6,SLL,24,B2,SL9,AS2,A2,SL6,G2
  .byte RET

_In20Game_square2_5:
  .byte STI,2,SL3,D2,SLL,30,E2,STI,6,SL9,F2,SL6,G2
  .byte RET

_In20Game_square2_6:
  .byte STI,6,SLL,32,E2,SL0,D2
  .byte RET

_In20Game_square2_7:
  .byte STI,6,SLL,33,B1,SLF,A1
  .byte RET

_In20Game_square2_8:
  .byte STI,6,SLL,33,B1,SLF,C2
  .byte RET

_In20Game_square2_9:
  .byte STI,6,SLL,33,B1,SLF,C2
  .byte RET

_In20Game_triangle_0:
  .byte STI,0,SL3,E2,E3,E2,E3,E2,E3,E2,E3,E2,E3,E2,E3,SL6,F2,G2
  .byte RET

_In20Game_triangle_1:
  .byte STI,0,SL3,E2,E3,E2,E3,E2,E3,E2,E3,F2,F3,F2,F3,SL6,A2,B2
  .byte RET

_In20Game_triangle_2:
  .byte STI,0,SL3,E2,E3,E2,E3,E2,E3,E2,E3,G2,G3,G2,G3,SL6,G2,A2
  .byte RET

_In20Game_triangle_9:
  .byte STI,0,SL3,E2,E3,E2,E3,E2,E3,E2,E3,E2,E3,E2,E3,STI,6
  .byte SL6,A2,B2
  .byte RET

_In20Game_triangle_10:
  .byte STI,0,SL3,E2,E3,E2,E3,E2,E3,E2,E3,E2,E3,E2,E3,STI,6
  .byte SL6,A2,B2
  .byte RET

_In20Game_noise_0:
  .byte STI,3,SL3,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
  .byte 14
  .byte RET

_In20Game_dpcm_0:
  .byte STI,0,SL6,C3,SL3,D3,D3,SL6,C3,D3,C3,SL3,D3,D3,C3,SL1,D3
  .byte D3,D3,SL3,D3,D3
  .byte RET

_In20Game_dpcm_1:
  .byte STI,0,SL6,C3,SL3,D3,D3,SL6,C3,D3,C3,SL3,D3,D3,C3,SL1,D3
  .byte D3,D3,SL3,D3,D3
  .byte RET

sfx_list:
  .word _sfx_shot
  .word _sfx_laser
  .word _sfx_dpcm
  .word _sfx_zap
  .word _sfx_collide

_sfx_shot:
  .byte 0, 1
  .byte 0, 1
  .word 0
  .word 0
  .word 0
  .word _sfx_shot_noise
  .word 0

_sfx_shot_noise:
  .byte CAL,<(_sfx_shot_noise_0),>(_sfx_shot_noise_0)
  .byte TRM
_sfx_shot_noise_0:
  .byte SLL,32,STI,6,8
  .byte RET

_sfx_laser:
  .byte 0, 1
  .byte 0, 1
  .word _sfx_laser_square1
  .word 0
  .word 0
  .word 0
  .word 0

_sfx_laser_square1:
  .byte CAL,<(_sfx_laser_square1_0),>(_sfx_laser_square1_0)
  .byte TRM
_sfx_laser_square1_0:
  .byte SLL,16,STI,8,B7
  .byte RET

_sfx_dpcm:
  .byte 0, 1
  .byte 0, 1
  .word 0
  .word 0
  .word 0
  .word 0
  .word _sfx_dpcm_dpcm

_sfx_dpcm_dpcm:
  .byte CAL,<(_sfx_dpcm_dpcm_0),>(_sfx_dpcm_dpcm_0)
  .byte TRM
_sfx_dpcm_dpcm_0:
  .byte SLL,8,STI,15,D3
  .byte RET

_sfx_zap:
  .byte 0, 1
  .byte 0, 1
  .word 0
  .word 0
  .word 0
  .word _sfx_zap_noise
  .word 0

_sfx_zap_noise:
  .byte CAL,<(_sfx_zap_noise_0),>(_sfx_zap_noise_0)
  .byte TRM
_sfx_zap_noise_0:
  .byte SLL,16,STI,22,4
  .byte RET

_sfx_collide:
  .byte 0, 1
  .byte 0, 1
  .word 0
  .word 0
  .word 0
  .word _sfx_collide_noise
  .word 0

_sfx_collide_noise:
  .byte CAL,<(_sfx_collide_noise_0),>(_sfx_collide_noise_0)
  .byte TRM
_sfx_collide_noise_0:
  .byte SLL,16,STI,23,0
  .byte RET
