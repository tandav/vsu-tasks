import matplotlib
matplotlib.use('TKAgg')

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

N = 12
a = 2
l = 3
pl = np.pi / l
h = 0.05


def InitPos(x):
    if x == 0 or x == l: return 0
    return np.cos(- (x - 3) ** 2)

def InitSpeed(x):
    return 0

def A(n):
    a = lambda x, n: InitPos(x) * np.sin(pl * n * x)
    sum_a = 0
    for i in range(int(l / h)):
        sum_a += a(i * h, n) * h
    return sum_a * 2 / l

def B(n):
    b = lambda x, n: InitSpeed(x) * np.sin(pl * n * x)
    sum_b = 0
    for i in range(int(l / h)):
        sum_b += b(i * h, n) * h
    return sum_b * 2 / l


def U(x, t):
    ser = [(A(i) * np.cos(pl * i * a * t) + B(i) * np.sin(pl * i * a * t)) * np.sin(pl * i * x) for i in range(1, N)]
    return sum(ser)


fig, ax = plt.subplots()

X = np.arange(0.0, l, h)
line, = ax.plot(X, U(X, 0))

def animate(i):
    line.set_ydata(U(X, i/50))  # update the data
    return line,

def init():
    line.set_ydata(np.ma.array(X, mask=True))
    return line,

ani = animation.FuncAnimation(fig, animate, np.arange(1, 2000), init_func=init, interval=1, blit=True)
ax.set_ylim([-1,1])
plt.show()
