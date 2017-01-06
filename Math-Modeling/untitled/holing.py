import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import ode

t_end = 200

h = 0.01

x0, y0 = 20, 56

r, K, w, D = 1, 1.5, 1, 1

S, J = .2, .5

def dx1(x1, x2):
    return r * (1 - x1 / K) * x1 - w * x1 * x2 / (D + x1)


def dx2(x1, x2):
    return S * (1 - J * x2 / x1) * x2


def step(x_prev, y_prev):
    k1 = h * dx1(x_prev, y_prev)
    l1 = h * dx2(x_prev, y_prev)

    k2 = h * dx1(x_prev + k1 / 2, y_prev + l1 / 2)
    l2 = h * dx2(x_prev + k1 / 2, y_prev + l1 / 2)

    k3 = h * dx1(x_prev + k2 / 2, y_prev + l2 / 2)
    l3 = h * dx2(x_prev + k2 / 2, y_prev + l2 / 2)

    k4 = h * dx1(x_prev + k3, y_prev + l3)
    l4 = h * dx2(x_prev + k3, y_prev + l3)

    x_ret = x_prev + (k1 + 2 * k2 + 2 * k3 + k4) / 6
    y_ret = y_prev + (l1 + 2 * l2 + 2 * l3 + l4) / 6

    return x_ret, y_ret


T = [0]
X1 = [x0]
X2 = [y0]

for i in range(1, int(t_end / h)):
    x1, x2 = step(X1[-1], X2[-1])
    T.append(i * h)
    X1.append(x1)
    X2.append(x2)

f, (ax1, ax2) = plt.subplots(1, 2)

a, bet = D / K, S / r

cond1 = a >= 1 or a < 1 and a + bet >= 1

cond2 = a + bet < 1 and (1 - a - bet) ** 2 - 8 * a * bet <= 0

print(a, bet)

print(cond1, cond2)


ax1.plot(X1, X2)
ax1.set_title("Phase")
ax1.grid()

ax2.plot(T, X2)
ax2.plot(T, X1, 'r')
ax2.set_title("Red - victim")
ax2.grid()

plt.show()