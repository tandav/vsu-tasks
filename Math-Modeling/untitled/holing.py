import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import odeint

t_end = 200
t = np.linspace(0, 1, 51)
h = 0.01

x1_0 = 20
x2_0 = 56


r, K, w, D = 1, 1.5, 1, 1

S, J = .2, .5


def dX_dt(X, t=0):
    """ Return the growth rate of x1 and x2 populations. """
    return np.array([ r * (1 - X[0] / K) * X[0] - w * X[0] * X[1] / (D + X[0]),
                      S * (1 - J * X[1] / X[0]) * X[1] ])

t = np.linspace(0, 15,  1000)
X0 = np.array([10, 5])
X = odeint(dX_dt, X0, t)

f, (ax1, ax2) = plt.subplots(1, 2)

x1, x2 = X.T


ax1.plot(x1, x2)
ax1.set_title("Phase")
ax1.grid()

ax2.plot(t, x1, 'b')
ax2.plot(t, x2, 'r')
ax2.set_title("fdfd")
ax2.grid()

plt.show()