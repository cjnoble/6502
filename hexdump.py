import sys

SIZE = 16 # Size of each chunk

def add_hex_and_int (hex_str: str, b: int) -> str:
    return hex(int(hex_str, 16) + b) 

def print_line(n0, n1, current_row, row_char=""):
    print(f"{int(n0, 16):08x}-{int(n1, 16):08x}: {current_row} [{row_char}]")
    return

def get_ascii_character(value: int, placeholder: str = '.') -> str:
    # Check if the value is an ASCII character we want (32-127)
    if 32 < value <= 127:
        return chr(value)
    return placeholder  # Return placeholder for non-ASCII characters

def decode_row_char(value: str, placeholder: str = '.') -> str:
    decoded_chars = []
    for h in value.split(" "):
        try:
            byte_value = int(h, 16)  # Convert hex string to an integer
            char = get_ascii_character(byte_value, placeholder)  # Get the ASCII character
            decoded_chars.append(char)  # Append either the character or placeholder
        except ValueError:
            decoded_chars.append(placeholder)  # If conversion fails, append placeholder
    return " ".join(decoded_chars)  # Join without commas for clean output

def hex_dump(file_name):

    with open(file_name, "rb") as f:

        # read it in in byte chunks
        data = {} # Initilise dict, key = location as hex, value = hex value at that location 

        for i, chunk in enumerate(iter(lambda :f.read(SIZE), b"")):
            
            chunk_hex = chunk.hex(" ")
            n0 = hex(SIZE*i)

            data[n0] = chunk_hex

    if not data:
        return  # Handle empty file case

    n0 = hex(0)
    n1 = n0
    previous_line = ""
    previous_key = int(n0, 16) - SIZE
    last_key = list(data.keys())[-1]

    for key, value in data.items():

        row_char = decode_row_char(data[key])

        # print if value is different from the current row or if it's the last row
        if value != previous_line or key == last_key:
            
            n0 = key
            previous_line = value
            
            n1 = add_hex_and_int(key, SIZE-1)

            if int(n0, 16) - SIZE != previous_key:
                # If we skipped a line that was the same as the previous, then print "*"
                print("*")
                print(hex(int(n0, 16) -1 )) # previous n1

            print_line(n0, n1, value, row_char)

            previous_key = int(n0, 16)

        else:
            #current line is same as previous
            pass

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python hexdump.py <filename>")
        sys.exit(1)

    file_name = sys.argv[1] #file_name = "rom.bin"
    hex_dump(file_name)