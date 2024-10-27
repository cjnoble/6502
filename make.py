
import os
import sys

def run_command (command):
    output = os.system(command)
    print(output)

def make (file):

    ASSEMBLER = r"vasm6502_oldstyle"

    run_command(fr"{ASSEMBLER} -Fbin -dotdir -c02 {file}")


if __name__ == "__main__":

    file_name = sys.argv[1]

    make(file_name)

#file = "fib.s"

