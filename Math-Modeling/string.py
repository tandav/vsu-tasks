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
n = 50 # number of string-length-chunks
# n = 32 # number of string-length-chunks
h = l / n # string step
a = 3 # a^2 = N/ro some sort of tension coefficient
b = 20 # time in seconds
m = 20000 # number of time-chunks
k = b / m # chunk of time in seconds
r = (a * k) / h
# N = 10 # number of harmonics in Fourier method
N = 10 # number of harmonics in Fourier method
pl = np.pi / l

def initial_state(x):
    if x == 0 or x == l:
        return 0
    # return np.cos(- (x - 3) ** 2)
    # return x*np.sin(x)
    return x**2

def initial_speed(x):
    return 0


def initial_state(x):
    if x == 0 or x == l: return 0
    return np.cos(- (x - 3) ** 2)

def initial_speed(x):
    return 0

def AFunc(x, n):
    return initial_state(x) * np.sin(pl * N * x)

def BFunc(x, n):
    return initial_speed(x) * np.sin(pl * N * x)

def A_Integeral(n):
    sum41 = 0
    for i in range(n):
        sum41 += AFunc(i * h, N) * h
    return sum41

def B_Integeral(n):
    sum41 = 0
    for i in range(n):
        sum41 += BFunc(i * h, N) * h
    return sum41

def A(n): # try change n to z/p/s/v/whatever
    return  2 / l * A_Integeral(n)

def B(n): # try change n to z/p/s/v/whatever
    return 2 / (np.pi * N * a) * B_Integeral(n)

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
symbolic, = ax.plot(X, U_prev, 'k')
numeric, = ax.plot(X, U_prev)



t = k
def update_frame(frame_number):
    global t, U_prev, U_pprev
    symbolic.set_ydata(U(X, t))  # update the data
    t += k # mb trouble is here

    U_curr = u_curr(U_prev, U_pprev)
    numeric.set_ydata(U_curr)  # update the data
    U_pprev = U_prev
    U_prev = U_curr

    return symbolic, numeric

def init():
    symbolic.set_ydata(U_pprev)
    numeric.set_ydata(U_pprev)
    return symbolic, numeric

# ani = animation.FuncAnimation(fig, update_frame, init_func=init, interval=k*1000000, blit=True)
ani = animation.FuncAnimation(fig, update_frame, init_func=init, interval=k*1, blit=True)
ax.set_ylim([-2,2])
plt.grid(True)
plt.show()
