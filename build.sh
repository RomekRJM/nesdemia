#!/bin/bash

ca65 nesdemia.asm -o nesdemia.o --debug-info
ld65 nesdemia.o -o nesdemia.nes -t nes --dbgfile nesdemia.dbgfile
python mem_map.py

wine ~/fceux/fceux.exe nesdemia.nes
