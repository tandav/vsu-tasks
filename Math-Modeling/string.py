# macOS only ############
import matplotlib       #
matplotlib.use('TKAgg') #
#########################

import matplotlib.animation as animation
import matplotlib.pyplot as plt
import numpy as np


# TODO
# 1. speed
# 2. comment all for people
# 3. mb add some ascii style schematic
# solution, outline.
# Dlya naglyadnosti
# here in comments
# or on github (pics, .md, etc)


l = 3 # length of the string
n = 500 # number of string-length-chunks
# n = 32 # number of string-length-chunks
dx = l / n # string step
a = 3 # a^2 = N/ro some sort of tension coefficient
b = 20 # time in seconds
m = 20000 # number of time-chunks
dt = b / m # chunk of time in seconds
# r = 0.095
r = (a * dt) / dx
# N = 10 # number of harmonics in Fourier method
N = 30 # number of harmonics in Fourier method
pl = np.pi / l

def initial_state(x):
	if x == 0 or x == l: return 0
	return np.sin(2*x)
	# return np.sin(2*x*np.pi/3)

def initial_speed(x):
    return 0

def AFunc(x, n):

	return initial_state(x) * np.sin(pl * n * x)

def BFunc(x, n):

	return initial_speed(x) * np.sin(pl * n * x)

def AIntegral(n):
	sum41 = 0
	for i in range(int(l / dx)): sum41 += AFunc(i * dx, n) * dx
	return sum41

def BIntegral(n):
	sum41 = 0
	for i in range(int(l / dx)): sum41 += BFunc(i * dx, n) * dx
	return sum41

def A(n):
	return AIntegral(n) * 2 / l

def B(n):
	return (BIntegral(n) * 2) / (np.pi * n * a)

def U(x, t):
	ser = [(A(i) * np.cos(pl * i * a * t) + B(i) * np.sin(pl * i * a * t)) * np.sin(pl * i * x) for i in range(1, N)]
	return sum(ser)


def u_curr(U_prev, U_pprev):
    U_curr = np.zeros(n)
    for i in range(1, n - 1):
        U_curr[i] = 2 * (1 - r**2) * U_prev[i] + (U_prev[i+1] + U_prev[i-1]) * r**2 - U_pprev[i]
    return U_curr



# Drawing stuff
fig, ax = plt.subplots()

X = np.linspace(0, l, n)
U_pprev = [initial_state(s) for s in X]

U_prev = U_pprev # TODO add += speed
fourier, = ax.plot(X, U_prev, 'k')
numeric, = ax.plot(X, U_prev)



t = dt
def update_frame(frame_number):
    global t, U_prev, U_pprev
    fourier.set_ydata(U(X, t))  # update the data
    t += dt # mb trouble is here

    U_curr = u_curr(U_prev, U_pprev)
    numeric.set_ydata(U_curr)  # update the data
    U_pprev = U_prev
    U_prev = U_curr

    return fourier, numeric

def init():
    fourier.set_ydata(U_pprev)
    numeric.set_ydata(U_pprev)
    return fourier, numeric

# ani = animation.FuncAnimation(fig, update_frame, init_func=init, interval=dt*1000000, blit=True)
ani = animation.FuncAnimation(fig, update_frame, init_func=init, interval=dt*1, blit=True)
ax.set_ylim([-2,2])
plt.grid(True)
plt.show()
