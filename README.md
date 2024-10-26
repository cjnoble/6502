# 6502 Computer Project

This is code i have written for the "6502 computer", based on the tutorials provided by Ben Eater. The computer uses a 6502 microprocessor.

## Ben Eater Links

- Youtube playlist <https://www.youtube.com/playlist?list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH>
- Website <https://eater.net/6502>
- Wozmon for 6502 <https://gist.github.com/beneater/8136c8b7f2fd95ccdd4562a498758217>
- Basic for 6502 <https://github.com/beneater/msbasic>

## Components

- W65C02S 8–bit Microprocessor <https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf>
- W65C22S Versatile Interface Adapter (VIA) <https://www.westerndesigncenter.com/wdc/documentation/w65c22.pdf>
- AT28C256 EEPROM 256K (32K x 8) Paged Parallel <https://ww1.microchip.com/downloads/aemDocuments/documents/MPD/ProductDocuments/DataSheets/AT28C256-Industrial-Grade-256-Kbit-Paged-Parallel-EEPROM-Data-Sheet-DS20006386.pdf>
- AS6C62256 32K X8BIT LOW POWER CMOS SRAM <https://www.alliancememory.com/wp-content/uploads/pdf/AS6C62256.pdf>
- HD44780U (LCD-II) (Dot Matrix Liquid Crystal Display Controller/Driver) <https://www.sparkfun.com/datasheets/LCD/HD44780.pdf>

Current configuration (Images form Ben Eater's website):

!["6502 circuit diagram"](https://eater.net/schematics/6502.png)

Currently work in progress:

!["6502 with serial circuit diagram"](https://eater.net/schematics/6502-serial.png)

## Assembler

The assembler used is the 'vasm6502_oldstyle'
Downloaded from here <http://sun.hasenbraten.de/vasm/> - there is also a github mirror here <https://github.com/StarWolf3000/vasm-mirror>

The assembler cna be run with

    vasm6502_oldstyle -Fbin -dotdir <file name>

-Fbin: Outputs binary file  
-dotdir: Enables dot directives  

## Assembling using make.py script

The make.py file makes it easy to run the assembler  

    python make.py <file name>

To view the outputted file (a.out by default):

    python hexdump.py a.out

## Programming the EEPROM

Uses the Xgpro program provided with the TL866 II plus EEPROM programmer.  
Ben also suggests use of the minipro software <https://gitlab.com/DavidGriffith/minipro>

## Memory map

| Bin | Hex | Area | Notes |
| --- | --- | --- | --- |
| 0000 0000 0000 0000 to 0011 1111 1111 1111 | 0000 to 3FFF | RAM | 16th and 15th bit both zero |
| 0000 0000 0000 0000 to 0000 0000 1111 1111 | 0100 to 00FF | Zero Page (Within RAM) |  |
| 0000 0001 0000 0000 to 0000 0001 1111 1111 | 0100 to 01FF | Stack (Within RAM) | 256 bytes - Hard coded in 6502, stack pointer initialised to FF on reset |
| 0100 0000 0000 0000 to 0101 1111 1111 1111 | 4000 to 5FFF | Not Used          |   |
| 0110 0000 0000 0000 to 0110 1111 1111 1111 | 6000 to 6FFF | IO | Using 6522 Chip |
|   TBC                                      | TBC          | Serial      | TBC               |
| 0110 0000 0000 0000 to 0110 0000 0000 1111 | 6000 to 600F | LCD Display | Using 6522 Chip |
| 0111 0000 0000 0000 to 0111 1111 1111 1111 | 7000 to 7FFF | Not Used             |                |
| 1000 0000 0000 0000 to 1111 1111 1111 1111 | 8000 to FFFF | EEPROM (32k of data) | 16th bit is set |
| 1111 1111 1111 1010 to 1111 1111 1111 1011 | FFFA to FFFB | Non maskable interrupt vector |(low byte/high byte) |
| 1111 1111 1111 1100 to 1111 1111 1111 1101 | FFFC to FFFD | Reset Vector | This is where we will start executing code from (low byte/high byte) |
| 1111 1111 1111 1110 to 1111 1111 1111 1111 | FFFE to FFFF | Interrupt request vector | (low byte/high byte) |

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

## Programs for the 6502

### ea_rom.py

A simple python script to write a rom to be written to the EEPROM. The program to be written using the hex values of the op codes directly.

Size of file has to be $2^{15}$ bits (32bit EEPROM)

OP codes used:  
0xea: No OP  
0xa9: Load A (immediate value)  
0x8d: Store A

### ledout.py

A simple program for turning LEDs connected to Port B on and off in a loop.

### hout.s

Written in assembly. Program to send letter "H" to the lcd.

### Hello World!

- hello.s: Unoptimised version os hello world script  
- hello_sub.s: Much better version that makes use of sub routines  
- hello_final.s: Final version using all optimisations  

### div.s

This program converts a 16-bit binary number to ASCII one character at a time.
The result is displayed on the LCD screen.

### fib.s

Program for calculating Fibonacci numbers. Numbers are stored in two adjacent locations of memory to allow 16 bit numbers to be used.  
Each number is converting to ASCII characters, and displaying on the LCD screen.  
Button interrupts are used for continuous calculation.

## Assembly Syntax Cheat Sheet

- **% Number is binary**  
  Indicates that the following number is in binary format.

- **\$ Number is hex**  
  Specifies that the number is in hexadecimal format.

- **\# Load immediate**  
  Denotes that the following value should be loaded directly into a register.

- **.org**  
  Sets the starting memory address for the subsequent code or data.

- **.word**  
  Allocates space for one or more words (2 bytes) of data in memory.

- **.asciiz**  
  Defines a null-terminated string in memory.

- **label:**  
  A named marker representing a specific point in the code for easy reference.

## 6502 Documentation

### 6502 OpCode Matrix

|   | 0       | 1          | 2        | 3        | 4        | 5        | 6        | 7        | 8        | 9        | A        | B       | C         | D       | E       | F       |
|---|---------|------------|----------|----------|----------|----------|----------|----------|----------|----------|----------|---------|-----------|---------|---------|---------|
| 0 | BRK s   | ORA (zp,x) |          |          | TSB zp   | ORA zp   | ASL zp   | RMB0 zp  | PHP      | ORA #    | ASL A    |         | TSB a     | ORA a   | ASL a   | BBR0 r  |
| 1 | BPL r   | ORA (zp),y | ORA (zp) |          | TRB zp   | ORA zp,x | ASL zp,x | RMB1 zp  | CLC      | ORA a,y  | INC A    |         | TRB a     | ORA a,x | ASL a,  | BBR1 r  |
| 2 | JSR a   | AND (zp,x) |          |          | BIT zp   | AND zp   | ROL zp   | RMB2 zp  | PLP s    | AND #    | ROL A    |         | BIT a     | AND a   | ROL a   | BBR2 r  |
| 3 | BMI r   | AND (zp),y | AND (zp) |          | BIT zp,x | AND zp,x | ROL zp,x | RMB3 zp  | SEC i    | AND a,y  | DEC A    |         | BIT a,x   | AND a,x | ROL a,x | BBR3 r  |
| 4 | RTI s   | EOR (zp,x) |          |          |          | EOR zp   | LSR zp   | RMB4 zp  | PHA s    | EOR #    | LSR A    |         | JMP a     | EOR a   | LSR a   | BBR4 r  |
| 5 | BVC r   | EOR (zp),y | EOR (zp) |          |          | EOR zp,x | LSR zp,x | RMB5 zp  | CLI i    | EOR a,y  | PHY s    |         |           | EOR a,x | LSR a,x | BBR5 r  |
| 6 | RTS s   | ADC (zp,x) |          |          | STZ zp   | ADC zp   | ROR zp   | RMB6 zp  | PLA s    | ADC #    | ROR A    |         | JMP (a)   | ADC a   | ROR a   | BBR6 r  |
| 7 | BVS r   | ADC (zp),y | ADC (zp) |          | STZ zp,x | ADC zp,x | ROR zp,x | RMB7 zp  | SEI i    | ADC a,y  | PLY s    |         | JMP (a.x) | ADC a,x | ROR a,x | BBR7 r  |
| 8 | BRA r   | STA (zp,x) |          |          | STY zp   | STA zp   | STX zp   | SMB0 zp  | DEY i    | BIT #    | TXA i    |         | STY a     | STA a   | STX a   | BBS0 r  |
| 9 | BCC r   | STA (zp),y | STA (zp) |          | STY zp,x | STA zp,x | STX zp,y | SMB1 zp  | TYA i    | STA a,y  | TXS i    |         | STZ a     | STA a,x | STZ a,x | BBS1 r  |
| A | LDY #   | LDA (zp,x) | LDX #    |          | LDY zp   | LDA zp   | LDX zp   | SMB2 zp  | TAY i    | LDA #    | TAX i    |         | LDY A     | LDA a   | LDX a   | BBS2 r  |
| B | BCS r   | LDA (zp),y | LDA (zp) |          | LDY zp,x | LDA zp,x | LDX zp,y | SMB3 zp  | CLV i    | LDA A,y  | TSX i    |         | LDY a,x   | LDA a,x | LDX a,y | BBS3 r  |
| C | CPY #   | CMP (zp,x) |          |          | CPY zp   | CMP zp   | DEC zp   | SMB4 zp  | INY i    | CMP #    | DEX i    | WAI i   | CPY a     | CMP a   | DEC a   | BBS4 r  |
| D | BNE r   | CMP (zp),y | CMP (zp) |          |          | CMP zp,x | DEC zp,x | SMB5 zp  | CLD i    | CMP a,y  | PHX s    | STP i   |           | CMP a,x | DEC a,x | BBS5 r  |
| E | CPX #   | SBC (zp,x) |          |          | CPX zp   | SBC zp   | INC zp   | SMB6 zp  | INX i    | SBC #    | NOP i    |         | CPX a     | SBC a   | INC a   | BBS6 r  |
| F | BEQ r   | SBC (zp),y | SBC (zp) |          |          | SBC zp,x | INC zp,x | SMB7 zp  | SED i    | SBC a,y  | PLX s    |         |           | SBC a,x | INC a,x | BBS7 r  |

### Instruction set table

| No. | Mnemonic | Description                                      |
|-----|----------|--------------------------------------------------|
| 1   | ADC      | Add memory to accumulator with Carry             |
| 2   | AND      | "AND" memory with accumulator                    |
| 3   | ASL      | Arithmetic Shift one bit Left, memory or accumulator |
| 4   | BBR      | Branch on Bit Reset                              |
| 5   | BBS      | Branch on Bit Set                                |
| 6   | BCC      | Branch on Carry Clear (Pc=0)                     |
| 7   | BCS      | Branch on Carry Set (Pc=1)                       |
| 8   | BEQ      | Branch if Equal (Pz=1)                           |
| 9   | BIT      | Bit Test                                         |
| 10  | BMI      | Branch if result Minus (Pn=1)                    |
| 11  | BNE      | Branch if Not Equal (Pz=0)                       |
| 12  | BPL      | Branch if result Plus (Pn=0)                     |
| 13  | BRA      | Branch Always                                    |
| 14  | BRK      | Break instruction                                |
| 15  | BVC      | Branch on Overflow Clear (Pv=0)                  |
| 16  | BVS      | Branch on Overflow Set (Pv=1)                    |
| 17  | CLC      | Clear Carry flag                                 |
| 18  | CLD      | Clear Decimal mode                               |
| 19  | CLI      | Clear Interrupt disable bit                      |
| 20  | CLV      | Clear Overflow flag                              |
| 21  | CMP      | Compare memory and accumulator                   |
| 22  | CPX      | Compare memory and X register                    |
| 23  | CPY      | Compare memory and Y register                    |
| 24  | DEC      | Decrement memory or accumulator by one           |
| 25  | DEX      | Decrement X by one                               |
| 26  | DEY      | Decrement Y by one                               |
| 27  | EOR      | Exclusive OR memory with accumulator             |
| 28  | INC      | Increment memory or accumulator by one           |
| 29  | INX      | Increment X register by one                      |
| 30  | INY      | Increment Y register by one                      |
| 31  | JMP      | Jump to new location                             |
| 32  | JSR      | Jump to new location Saving Return (Jump to Subroutine) |
| 33  | LDA      | Load Accumulator with memory                     |
| 34  | LDX      | Load the X register with memory                  |
| 35  | LDY      | Load the Y register with memory                  |
| 36  | LSR      | Logical Shift one bit Right, memory or accumulator |
| 37  | NOP      | No Operation                                     |
| 38  | ORA      | OR memory with Accumulator                       |
| 39  | PHA      | Push Accumulator on stack                        |
| 40  | PHP      | Push Processor status on stack                   |
| 41  | PHX      | Push X register on stack                         |
| 42  | PHY      | Push Y register on stack                         |
| 43  | PLA      | Pull Accumulator from stack                      |
| 44  | PLP      | Pull Processor status from stack                 |
| 45  | PLX      | Pull X register from stack                       |
| 46  | PLY      | Pull Y register from stack                       |
| 47  | RMB      | Reset Memory Bit                                 |
| 48  | ROL      | Rotate one bit Left, memory or accumulator       |
| 49  | ROR      | Rotate one bit Right, memory or accumulator      |
| 50  | RTI      | Return from Interrupt                            |
| 51  | RTS      | Return from Subroutine                           |
| 52  | SBC      | Subtract memory from accumulator with borrow (Carry bit) |
| 53  | SEC      | Set Carry                                        |
| 54  | SED      | Set Decimal mode                                 |
| 55  | SEI      | Set Interrupt disable status                     |
| 56  | SMB      | Set Memory Bit                                   |
| 57  | STA      | Store Accumulator in memory                      |
| 58  | STP      | Stop mode                                        |
| 59  | STX      | Store the X register in memory                   |
| 60  | STY      | Store the Y register in memory                   |
| 61  | STZ      | Store Zero in memory                             |
| 62  | TAX      | Transfer the Accumulator to the X register       |
| 63  | TAY      | Transfer the Accumulator to the Y register       |
| 64  | TRB      | Test and Reset memory Bit                        |
| 65  | TSB      | Test and Set memory Bit                          |
| 66  | TSX      | Transfer the Stack pointer to the X register     |
| 67  | TXA      | Transfer the X register to the Accumulator       |
| 68  | TXS      | Transfer the X register to the Stack pointer register |
| 69  | TYA      | Transfer Y register to the Accumulator           |
| 70  | WAI      | Wait for Interrupt                               |

### Addressing modes

| No. | Addressing Mode                     | Syntax        |
|-----|-------------------------------------|---------------|
| 1   | Absolute                            | a             |
| 2   | Absolute Indexed Indirect           | (a,x)         |
| 3   | Absolute Indexed with X             | a,x           |
| 4   | Absolute Indexed with Y             | a,y           |
| 5   | Absolute Indirect                   | (a)           |
| 6   | Accumulator                         | A             |
| 7   | Immediate                           | #             |
| 8   | Implied                             | i             |
| 9   | Program Counter Relative            | r             |
| 10  | Stack                               | s             |
| 11  | Zero Page                           | zp            |
| 12  | Zero Page Indexed Indirect          | (zp,x)        |
| 13  | Zero Page Indexed with X            | zp,x          |
| 14  | Zero Page Indexed with Y            | zp,y          |
| 15  | Zero Page Indirect                  | (zp)          |
| 16  | Zero Page Indirect Indexed with Y   | (zp),y        |
