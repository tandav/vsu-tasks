import matplotlib.pyplot as plt
import numpy as np
from math import exp

points_arr = [[0, 0], [0, 3], [3, 0], [5, 3]]
def f(x, y):
    return x + y


xlist = np.linspace(0, 5, 50)
ylist = np.linspace(0, 3, 30)
X, Y = np.meshgrid(xlist, ylist)
Z = f(X, Y)



plt.figure()
plt.grid()
plt.xlim([-1, 6])
plt.ylim([-1, 5])

CS = plt.contour(X, Y, Z, 15, linewidths=0.5, colors='k')
# plt.clabel(CS, inline=True, fontsize=10) # black lines + text labels
# CS = plt.contourf(X, Y, Z, 15, cmap=plt.cm.rainbow, vmax=abs(Z).max(), vmin=-abs(Z).max()) # colouring
plt.show()