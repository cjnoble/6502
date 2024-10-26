# 6502 Computer Project

This is code is have written for the "6502 computer", based on the tutorials provided by Ben Eater. The computer uses a 6502 microprocessor.

## Ben Eater Links

- Youtube playlist <https://www.youtube.com/playlist?list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH>
- Website <https://eater.net/6502>
- Wozmon for 6502 <https://gist.github.com/beneater/8136c8b7f2fd95ccdd4562a498758217>
- Basic for 6502 <https://github.com/beneater/msbasic>

## Assembler

'vasm6502_oldstyle' is the assembler
Downloaded from here <http://sun.hasenbraten.de/vasm/> - there is also a github mirror here <https://github.com/StarWolf3000/vasm-mirror>

    vasm6502_oldstyle -Fbin -dotdir <file name>

-Fbin: Outputs binary file  
-dotdir: Enables dot directives  

## Assembling using make.py script

To 

    python make.py <file name>

To view the outputted file (a.out by default):

    python hexdump.py a.out

## Programming the EEPROM

Uses the Xgrop program provided with the TL866 II plus EEPROM programmer.  

## Memory map

| Bin | Hex | Area | Notes |
| --- | --- | --- | --- |
| 0000 0000 0000 0000 to 0011 1111 1111 1111 | 0000 to 3FFF | RAM | 16th and 15th bit both zero |
| 0000 0000 0000 0000 to 0000 0000 1111 1111 | 0100 to 00FF | Zero Page (Within RAM) |  |
| 0000 0001 0000 0000 to 0000 0001 1111 1111 | 0100 to 01FF | Stack (Within RAM) | 256 bytes - Hard coded in 6502, stack pointer initialised to FF on reset |
||4000 to 5FFF| Not Used ||
| 0110 0000 0000 0000 to 0111 1111 1111 1111 | 6000 to 7FFF|IO| Using 6522 Chip |
| |  | Serial | |
| | 6000 to 600F | LCD Display | Using 6522 Chip |
| 1000 0000 0000 0000 to 1111 1111 1111 1111 | 8000 to FFFF | EEPROM (32k of data) | 16th bit is set |
|1111 1111 1010 1100 to 1111 1111 1111 1011|FFFA to FFFB | Non maskable interrupt vector |(low byte/high byte) |
|1111 1111 1111 1100 to 1111 1111 1111 1101| FFFC to FFFD | Reset Vector | This is where we will start executing code from (low byte/high byte) |
|1111 1111 1111 1110 to 1111 1111 1111 1111| FFFE to FFFF | Interrupt request vector | (low byte/high byte) |

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
