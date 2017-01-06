import matplotlib.pyplot as plt
import numpy as np
from math import exp

l = 20
M = np.zeros((l, 2*l - 1), dtype=int)
mi = int(M.shape[1] / 2)# mid index

k = 1
for i in range(M.shape[0]):
    for j in range(mi - i, mi + i + 1):
        M[i][j] = k
        k += 1

M = np.transpose(M)

for row in M:
    plt.plot(row)

# print(M)

plt.grid()
plt.show()