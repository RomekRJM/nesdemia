
while (true) do
	if memory.readbyte(0x0532) > 0 then gui.text(50,50,"UP") end 
	if memory.readbyte(0x0533) > 0 then gui.text(50,60,"DOWN") end
	if memory.readbyte(0x0534) > 0 then gui.text(50,70,"LEFT") end
	if memory.readbyte(0x0535) > 0 then gui.text(50,80,"RIGHT") end
    
	emu.frameadvance();
end;
