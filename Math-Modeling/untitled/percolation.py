import numpy as np
# from pylab import imshow, show
import matplotlib.pyplot as plt

from random import random


L = 7 # side length
p = 0.4
a = np.zeros((L + 1, L + 1), dtype=int) # grid / matrix / array

for i in range(1, L+1):
    for j in range(1, L+1):
        if random() <= p:
            a[i][j] = 1

# labels = range(int(L*L/2))
labels = [i for i in range(int(L*L/2))]


label_counter = 0
label = np.zeros((L + 1, L + 1))



def find(x):
    global labels
    y = x
    while (labels[y] != y):
        y = labels[y]
    while (labels[x] != x):
        z = labels[x]
        labels[x] = y
        x = z
    return y


def union(x, y):
    global labels
    labels[find(x)] = find(y)


for i in range(1, L+1): # rows
    for j in range(1, L+1): # cols
        if a[i][j]:
            left = a[i][j - 1]
            above = a[i - 1][j]
            if left == 0 and above == 0:
                label_counter += 1
                label[i][j] = label_counter
            elif left != 0 and above == 0:
                label[i][j] = find(left)
            elif left == 0 and above != 0:
                label[i][j] = find(above)
            else:
                union(left, above)
                label[i][j] = find(left)

# for i in range(1, L+1): # rows
#     for j in range(1, L+1): # cols
#         label[i][j] *= 100

print(label)
plt.imshow(label, interpolation='none', cmap='nipy_spectral_r')
plt.show()