
def add_hex_dec (a, b: int):

    return hex(int(a, 16) + b) 


file_name = "a.out"

with open(file_name, "rb") as f:

    # read it in in 32byte chunks???
    size = 32
    data = {}

    for i, chunk in enumerate(iter(lambda :f.read(size), b"")):
        
        chunk = chunk.hex(" ")
        n0 = hex(size*i)
        #
        # print(f"{n0}-{add_hex_dec(n0, size - 1)}: {chunk}")

        data[n0] = chunk

n0 = hex(0)
current_row = data[n0]
last_key = list(data.keys())[-1]

for key, value in data.items():


    n1 = add_hex_dec(key, -1)

    if value != current_row or key == last_key:

        print(f"{n0}-{add_hex_dec(n0, size - 1)}: {current_row}")

        if int(n0, 16) + size -1 != int(n1, 16):
            print("*")
            print(n1)

        n0 = key
        current_row = value
        #print(f"{n0}-{n1}: {data}")

        if key == last_key:
            n1 = add_hex_dec(key, size-1)
            print(f"{n0}-{n1}: {current_row}")


