import os

def run_command (command):
    output = os.system(command)
    print(output)

assembler = r"vasm6502_oldstyle"
file = "fib.s"

run_command(fr"{assembler} -Fbin -dotdir {file}")