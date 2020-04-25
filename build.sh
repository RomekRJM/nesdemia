#!/bin/bash

python mem_map.py

ca65 nesdemia.asm -o nesdemia.o --debug-info
ld65 nesdemia.o -o nesdemia.nes -t nes --dbgfile nesdemia.dbgfile

wine ~/fceux/fceux.exe nesdemia.nes
