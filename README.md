# 6502 Computer Project

This is code is have written for the "6502 computer", based on the tutorials provided by Ben Eater. The computer uses a 6502 microprocessor.

## Ben Eater Links

- Youtube playlist <https://www.youtube.com/playlist?list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH>
- Website <https://eater.net/6502>
- Wozmon for 6502 <https://gist.github.com/beneater/8136c8b7f2fd95ccdd4562a498758217>
- Basic for 6502 <https://github.com/beneater/msbasic>

## Assembler

'vasm6502_oldstyle' is the assembler
Donloaded from here <http://sun.hasenbraten.de/vasm/> - there is also a github mirror here <https://github.com/StarWolf3000/vasm-mirror>

    'vasm6502_oldstyle -Fbin -dotdir'

-Fbin: Outputs binary file  
-dodir: Enables dot directives  

## Programming the EEPROM

Uses the Xgrop program provided with the TL866 II plus EEPROM programmer.  

## Memory map

fffa to fffb non maskable interrupt vector  
fffc to fffd reset vector (low byte/high byte)  
fffe to ffff interrupt request vector  

| Bin | Hex | Area | Notes |
| --- | --- | --- | --- |
| |  | RAM | |
| 1 0000 0000 to 1 1111 1111 | 0100 to 01FF | Stack | 256 bytes - Hard coded in 6502, stack pointer initialised to FF on reset |
| 0110 0000 0000 0000 to 0111 1111 1111 1111 | 6000 to 7FFF|IO| Using 6522 Chip |
| |  | Serial | |
| |  | LCD Display | |
| 1000 0000 0000 0000 to 1111 1111 1111 1111 | 8000 to FFFF | EEPROM (32k of data) | 16th bit is set |

## IO Using 6205 Chip

6000 to 600F

| Address | Description | Notes |
| --- | --- | --- |
| 6000 | Port B ||
| 6001 | Port A ||
| 6002 | Data direction register for port B | Set each bit to 1 for output or 0 for input |
| 6002 | Data direction register for port A | |

## LCD Display

Data lines (D0 to D7) are connected to Port B  
Control signals (E, RW, and RS) are connected to the most significant bits (respectively) of Port A.  

## ea_rom

A simple python script to write a rom to be written to the EEPROM. The program to be written uses the op codes directly (Refer to 6502 data sheet).

Size of file: $2^{15}$ bits (32bit EEPROM)

OP codes used:  
0xea: No OP  
0xa9: Load A (immediate value)  
0x8d: Store A

## Assembly syntax

% Number is binary  
\$ Number is hex  
\# Load immediate  
