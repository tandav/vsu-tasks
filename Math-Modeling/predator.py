from scipy.integrate import odeint
from numpy import *
from matplotlib.pyplot import *
# import matplotlib.pyplot as plt


r1 = 1
r2 = 2.1
a1 = 1.5
a2 = 1.2
b1 = 0.3
b2 = 0.3

# r1 = 1
# r2 = 2.1
# a1 = 1.5
# a2 = 1.2
# b1 = 0.3
# b2 = 0.3

def LotkaVolterra(state,t):
	n1 = state[0]
	n2 = state[1]
	n1d = n1 * (r1 - b1*n1 - a2*n2)
	n2d = n2 * (r2 - b2*n2 - a1*n1)
	return [n1d, n2d]



t = arange(0, 30, 0.01)
state0 = [2, 1]

state = odeint(LotkaVolterra, state0, t)

x = [e[0] for e in state]
y = [e[1] for e in state]
figure()
plot(t, state)
grid(True)
title('Lotka-Volterra equations')
xlabel('Time')
ylabel('Population Size')


figure() 
plot(x, y)

lx = [r2/a1, r1/b1]
ly = [r2/b2, r1/a2]

# plot([r2/a1, r2/b2, 'ro-')
# plot([r2/a1, r1/b1], 'ro-')
# plot([0, r1/a2, 'ro-')
grid(True)
title('Phase Portrait')
axis('equal')
xlabel('N1')
ylabel('N2')

# ylim([0,8])
# legend(('x (prey)','y (predator)'))
show()
