import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import odeint
from scipy.optimize import fsolve

r, K, w, D = 6, 1.8, 1, 1
S, J = .4, .1

def dX_dt(X, t=0):
    """ Return the growth rate of x1 and x2 populations. """
    return np.array([ r * (1 - X[0] / K) * X[0] - w * X[0] * X[1] / (D + X[0]),
                      S * (1 - J * X[1] / X[0]) * X[1] ])

t = np.linspace(0, 15,  10000)
X0 = np.array([12, 11])
X = odeint(dX_dt, X0, t)
f, (ax1, ax2) = plt.subplots(1, 2)

x1, x2 = X.T
ax1.plot(x1, x2)
ax1.plot(x1, r / w * (1 - x1 / K) * (D + x1), 'k--')
ax1.plot(x1, x1 / J, 'k--')




ax1.set_title("Phase Portrait")
ax1.set_xlabel('x1')
ax1.set_ylabel('x2', rotation=0)

special_x = fsolve(lambda x1 : r / w * (1 - x1 / K) * (D + x1) - x1 / J, 0.5)
special_y = special_x / J
k = K / special_x
d = D / special_x
ax1.plot(special_x, special_y, 'ro')

if (r * (k - d - 2) / (k * (1 + d)) - S > 0):
    ax1.text(0.95, 0.01, 'Особая точка:\n' + str(special_x) + str(special_y) + '\nНеустойчивый фокус\nПредельный цикл', verticalalignment='bottom',
        horizontalalignment='right',transform=ax1.transAxes, fontsize=12)
else:
    ax1.text(0.95, 0.01, 'Особая точка:\n' + str(special_x) + str(special_y) + '\nУстойчивый фокус\nПредельного цикла нет', verticalalignment='bottom',
        horizontalalignment='right',transform=ax1.transAxes, fontsize=12)
# ax1.text(3, 8, 'boxed italics text in data coords', bbox={'facecolor':'red', 'alpha':0.2, 'pad':10})
ax1.grid()
ax1.axis([min(x1), max(x1), min(x2), max(x2)])


ax2.plot(t, x1, 'b')
ax2.plot(t, x2, 'r')
ax2.set_xlabel('t')
ax2.set_title("x1(t), x2(t)")
ax2.grid()
plt.tight_layout()
plt.show()