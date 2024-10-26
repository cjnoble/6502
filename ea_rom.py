
rom = bytearray([0xea] * 2**15) # NoOp Instructions at all locations


rom[0] = 0xa9 # Load A immediate value x42
rom[1] = 0x42

rom[2] = 0x8d # Store A at address x6000
rom[3] = 0x00
rom[4] = 0x60 

rom[0x7ffc] = 0x00 #fffc
rom[0x7ffd] = 0x80 #fffd

with open ("rom.bin", "wb") as f:

    f.write(rom)

