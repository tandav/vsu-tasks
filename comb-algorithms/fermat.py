import matplotlib.pyplot as plt
import numpy as np
from math import hypot

points_arr = [[0, 0], [0, 3], [3, 0], [5, 3], [2, 2]]
def dist_s(x, y):
    s = 0
    for p in points_arr:
        s += np.hypot(x - p[0], y - p[1])
    return s


xlist = np.linspace(0, 5, 50)
ylist = np.linspace(0, 3, 30)
X, Y = np.meshgrid(xlist, ylist)
Z = dist_s(X, Y)

cn = 20 # contour accuracy


plt.figure()
plt.grid()
plt.xlim([-1, 6])
plt.ylim([-1, 5])
CS = plt.contour(X, Y, Z, cn, linewidths=0.5, colors='k')
plt.clabel(CS, inline=True, fontsize=10)
CS = plt.contourf(X, Y, Z, cn, cmap=plt.cm.rainbow, vmax=abs(Z).max(), vmin=-abs(Z).max())
plt.plot(*zip(*points_arr), marker='o', color='b', ls='')
plt.show()
