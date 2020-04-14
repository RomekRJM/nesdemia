function stopemu()
    print(memory.readbyte(0xc7));
end

memory.register(0xc2, stopemu);

while (true) do
    gui.text(50,50,"virusLeft: " .. memory.readbyte(0xba));
    gui.text(50,60,"virusTop: " .. memory.readbyte(0xbb));
    gui.text(50,70,"virusAlive: " .. memory.readbyte(0xc2));
    emu.frameadvance();
end;
