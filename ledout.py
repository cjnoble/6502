

code = bytearray([
    0xa9, 0xff, # Load A imediate value $ff (1111 1111)
    0x8d, 0x02, 0x60, # Store A at address $6002 (PORT B DIR)

    0xa9, 0x55, # Load A imediate value $55 (0101 0101)
    0x8d, 0x00, 0x60, # Store A at address $6000 (PORT B)

    0xa9, 0xaa, # Load A imediate value $aa (1010 1010)
    0x8d, 0x00, 0x60, # Store A at address $6000 (PORT B)

    0x4c, 0x05, 0x80 # JMP $8005

])

rom = code + bytearray([0xea] * (2**15 - len(code)))

# Prgram counter will start at 8000, which is 0000 of ROM
rom[0x7ffc] = 0x00 #fffc
rom[0x7ffd] = 0x80 #fffd

with open ("rom.bin", "wb") as f:

    f.write(rom)

