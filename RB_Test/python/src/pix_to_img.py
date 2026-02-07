from PIL import Image
import numpy as np
from constants import PIXELS_PATH


f = PIXELS_PATH
with open(f, "r") as f:
    file_ = f.read()
    hex_values = file_.split()
    n = len(file_.split('\n')) - 1

if len(hex_values) != n * n:
    raise ValueError(f"Expected {n*n} pixels, got {len(hex_values)}")


pixels = np.array([int(h, 16) for h in hex_values], dtype=np.uint8)
image_array = pixels.reshape((n, n))
img = Image.fromarray(image_array, mode="L")

# Save or display
img.save("src_data\\output.png")
img.show()


