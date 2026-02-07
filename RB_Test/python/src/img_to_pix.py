from PIL import Image
from constants import SRC_PNG

INPUT_IMAGE = SRC_PNG
OUTPUT_HEX  = "RB_data\\img_2d.txt"  
EXT_MEM = "RB_data\\ext_mem.mem"

SIZE        = (512, 512)

img = Image.open(INPUT_IMAGE)
img = img.convert("L")
img = img.resize(SIZE)
img.save(f"src_data//conv.png")

pixels = img.load()

with open(OUTPUT_HEX, "w") as f:
    for y in range(512):
        for x in range(512):
            f.write(f"{pixels[x, y]:02x} ")
        f.write("\n")

print("✔ Image converted to 512x512 raw hex file")

with open(EXT_MEM, "w") as f:
    for y in range(512):
        for x in range(512):
            f.write(f"{pixels[x, y]:02x} ")
            f.write("\n")

print("✔ Image stored as external memory")
