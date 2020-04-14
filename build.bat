@echo on
C:\cc65\bin\ca65 -g nesdemia.asm
C:\cc65\bin\ld65 nesdemia.o -o nesdemia.nes -t nes --dbgfile nesdemia.nes.dbg
D:\ProgramFilesX\Python38\python mem_map.py
C:\fceux\fceux.exe nesdemia.nes
