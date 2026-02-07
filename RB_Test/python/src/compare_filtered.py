f1 = "src_data\\golden.hex"
f2 = "C:\\Users\\LENOVO\\RB_Test\\RB_Test.sim\\sim_1\\behav\\xsim\\pixels.mem" # Change this path to your path of pixels.mem file

with open(f1, "r") as a:
    lst1 = a.read().split("\n")
    lst1 = [l.split() for l in lst1]
    # print(lst1)

with open(f2, "r") as b:
    lst2 = b.read().split("\n")
    lst2 = [l.split() for l in lst2]
    # print(lst2)

for i in range(len(lst2)-1):
    for j in range(len(lst2[0])-1):
        if lst1[i][j].upper() != lst2[i][j].upper():
            print(i, j, lst1[i][j].upper(), lst2[i][j])
            print("Images don't match!")
            break
    else: continue
    break
else:
    print("Images match!")


## 5x5 Edge Sharpener
# 8080FF8080
# 80FFFEFF80
# FFFE10FEFF
# 80FFFEFF80
# 8080FF8080

# 3x3 Sobel Filter (Hor)
# 0100FF
# 0000FE
# 0200FF

# 3x3 Sobel Filter (Ver)
# 010002
# 000000
# FFFEFF
