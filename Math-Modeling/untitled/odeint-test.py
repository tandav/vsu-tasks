import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt


def dy(y, t):
    return -2.5 * y

# Initial condition
y0 = 100.0

# Times at which the solution is to be computed.
t = np.linspace(0, 1, 51)

# Solve the equation.
y = odeint(dy, y0, t)
print(y)
print(len(y))
# Plot the solution.  `odeint` is generally used to solve a system
# of equations, so it returns an array with shape (len(t), len(y0)).
# In this case, len(y0) is 1, so y[:,0] gives us the solution.
plt.plot(t, y[:, 0])
plt.xlabel('t')
plt.ylabel('y')
plt.show()