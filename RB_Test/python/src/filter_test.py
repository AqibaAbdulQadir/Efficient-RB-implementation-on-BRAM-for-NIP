import numpy as np
from PIL import Image
from constants import SRC_PNG

img = "src_data\\conv.png"
kern = "RB_data\\kernel.mem"

image = Image.open(img)
img_array = np.array(image, dtype=np.uint8)

# Convert hex string to integer
def hex_(val):
    return int(val, 16)

# Read kernel from file
kernel = []
with open(kern, "r") as f:
    for line in f:
        line = line.strip().replace(" ", "")
        row = [hex_(line[i:i+2]) for i in range(0, len(line), 2)]
        kernel.append(row)

filter = np.array(kernel, dtype=np.uint8).T
K = filter.shape[0]
radius = K // 2

height, width = img_array.shape
out_height = height - (K - 1)
out_width  = width - (K - 1)
output = np.zeros((out_height, out_width), dtype=np.uint8)

# Convolution (valid region)
for i in range(out_height):
    for j in range(out_width):
        region = img_array[i:i+K, j:j+K]
        output[i, j] = np.sum(region * filter)

# Save result
output_image = Image.fromarray(output)
output_image.save("src_data\\golden.png")
output_image.show()

# Save hex file
with open("src_data\\golden.hex", "w") as f:
    for row in output:
        for pixel in row:
            f.write(f"{pixel:02X} ")
        f.write("\n")

print(f"Hex pixel file created: src_data\\golden.hex (size {out_height}x{out_width})")
