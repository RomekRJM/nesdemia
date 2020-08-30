@echo on

"C:\Program Files (x86)\Python385\"python mem_map.py

C:\cc65\bin\ca65 -g nesdemia.asm
C:\cc65\bin\ld65 nesdemia.o -o nesdemia.nes music/ggsound.o -C nes.cfg --dbgfile nesdemia.nes.dbg

C:\fceux\fceux.exe nesdemia.nes
