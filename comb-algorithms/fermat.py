import matplotlib.pyplot as plt
import numpy as np
from math import hypot

# points_arr = [[2, 3], [2, 5], [3, 2], [3, 4], [4, 8], [8, 2]]

# points_arr = [[-3, 0], [-1, 0], [5, 0], [-8, -9]]
points_arr = [[0, 0], [0, 4], [4, 0], [15, 4]]
def dist_s(x, y):
    s = 0
    for p in points_arr:
        s += np.hypot(x - p[0], y - p[1])
    return s

def dist_2(x, y):
    s = 0
    for p in points_arr:
        s += (np.hypot(x - p[0], y - p[1]))
    return np.tan(s)


n = 1000

xlist = np.linspace(-1, 16, n)
ylist = np.linspace(-1, 5, n)
# xlist = np.linspace(-10, 10, n)
# ylist = np.linspace(-10, 10, n)

# xlist = np.linspace(0, 5, 50)
# ylist = np.linspace(0, 3, 30)

X, Y = np.meshgrid(xlist, ylist)
Z = dist_s(X, Y)

cn = 100 # contour accuracy


plt.figure()
plt.grid()
# plt.xlim([-1, 6])
# plt.ylim([-1, 5])

# plt.xlim([-1, 6])
# plt.ylim([-1, 5])

CS = plt.contour(X, Y, Z, cn, linewidths=0.5, colors='k')
# plt.clabel(CS, inline=True, fontsize=9, fmt='%1.1f',)
CS = plt.contourf(X, Y, Z, cn, cmap=plt.cm.hot_r, vmax=Z.max(), vmin=Z.min()) # colors edit
# CS = plt.contourf(X, Y, Z, cn, cmap=plt.cm.hot_r, vmax=Z.max()*1.05, vmin=Z.min()*0.97) # colors edit
plt.colorbar()
# plt.axis('equal')

plt.plot(*zip(*points_arr), marker='o', color='b', ls='')
plt.savefig('foo.png')

plt.show()
