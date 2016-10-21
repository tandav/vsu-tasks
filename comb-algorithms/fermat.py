from math import *
from numpy import *
import matplotlib.pyplot as plt

def d(x1, y1, x2, y2):
    return sqrt((x2 - x1)**2 + (y2 - y1)**2 )

def phi(point, points_arr):
    s = 0;
    for p in points_arr:
        s += hypot(point[0] - p[0], point[1] - p[1])
    return s
# def d(x1, y1, x2, y2):
#     return sqrt((x2 - x1)**2 + (y2 - y1)**2 )

p0 = [[0, 0], [0, 3], [3, 0], [5, 3]]



n = 100


p1 = []
p2 = []
p3 = []
p4 = []
p5 = []
p6 = []
p7 = []


d_min = 50

for x in linspace(0, 5, 5*n):
    for y in linspace(0, 3, 3*n):
        cd = phi([x,y], p0)
        # if phi < d_min:
        if cd < 13:
            p1.append([x, y])
        if cd < 12:
            p2.append([x, y])
        if cd < 11.5:
            p3.append([x, y])
        if cd < 11:
            p4.append([x, y])
        if cd < 10.5:
            p5.append([x, y])
        if cd < 10.2:
            p6.append([x, y])
        if cd < 10.1:
            p7.append([x, y])



plt.grid()
plt.xlim([-1, 6])
plt.ylim([-1, 5])
# plt.axis('equal')



m = ','
plt.plot(*zip(*p1), marker=m, color='0.9', ls='')
plt.plot(*zip(*p2), marker=m, color='0.7', ls='')
plt.plot(*zip(*p3), marker=m, color='0.5', ls='')
plt.plot(*zip(*p4), marker=m, color='0.3', ls='')
plt.plot(*zip(*p5), marker=m, color='0.2', ls='')
plt.plot(*zip(*p6), marker=m, color='0.1', ls='')
plt.plot(*zip(*p7), marker=m, color='0.05', ls='')

plt.plot(*zip(*p0), marker='o', color='r', ls='')


plt.show()
