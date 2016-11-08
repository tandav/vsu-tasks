from scipy.integrate import odeint
from numpy import *
from matplotlib.pyplot import *

def LotkaVolterra(state,t):
	alpha = 0.01
	beta =  1.1
	sigma = 0.5
	gamma = 2.1
	x = state[0]
	y = state[1]
	xd = x*(alpha - beta*y)
	yd = -y*(gamma - sigma*x)
	return [xd,yd]


t = arange(0, 500, 1)
state0 = [0.5, 0.5]

state = odeint(LotkaVolterra, state0, t)
# figure()

x = [e[0] for e in state]
y = [e[1] for e in state]

plot(t, state)
# plot(x, y)
# ylim([0,8])
xlabel('Time')
ylabel('Population Size')
legend(('x (prey)','y (predator)'))
title('Lotka-Volterra equations')
grid(True)
show()
