def read_linear_file(filename):
    """Read linear pixel file into a list of integers."""
    with open(filename, 'r') as f:
        lines = f.readlines()
    pixels = [int(val.strip(), 16) for line in lines for val in line.split()]
    return pixels

def read_windowed_file(filename):
    """Read windowed pixel file into a list of lists."""
    with open(filename, 'r') as f:
        lines = f.readlines()
    windows = []
    for line in lines:
        window = [int(x, 16) for x in line.strip().split()]
        windows.append(window)
    return windows

def verify_windowed(linear_pixels, windowed_pixels, image_width):
    """
    Verify if the windowed pixels match the linear pixels.
    Each line in windowed_pixels contains pixels from 5 consecutive rows at the same column index.
    """
    success = 1
    j = 0
    for i, window in enumerate(windowed_pixels):
        window = window[::-1]
        col = i % image_width
        expected = [linear_pixels[row*image_width + col] for row in range(j, j + len(window))]
        if window != expected:
            got_hex = [f"{x:02X}" for x in window]
            expected_hex = [f"{x:02X}" for x in expected]
            print(f"Mismatch at window {i+1}: got {got_hex}, expected {expected_hex}")
            success = 0
            break

        if i % image_width == image_width - 1:
            j += 1
    if success:
        print("All windowed pixels match the linear pixels!")
    else:
        print("Some windowed pixels do not match.")

if __name__ == "__main__":
    image_file = "img_2d.txt"
    windowed_file = "pixels.txt"
    image_width = 512  

    linear_pixels = read_linear_file(image_file)
    windowed_pixels = read_windowed_file(windowed_file)

    verify_windowed(linear_pixels, windowed_pixels, image_width)
