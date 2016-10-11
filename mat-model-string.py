# macOS only ############
import matplotlib       #
matplotlib.use('TKAgg') #
#########################

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

# mb add some ascii style schematic
# solution outline.
# Dlya naglyadnosti
# here in comments
# or on github (pics, .md, etc)


l = 3. # length of the string
n = 40 # number of length chunks
# h = 0.1
h = l/n # string step
a = 3. # a^2 = N/ro - sorta tension coefficient
b = 100 # seconds
m = 20000 # number of time chunks
k = b / m # chunk of time in seconds
r = a * k / h

def initial_state(x):
    if x == 0 or x == l: return 0
    return np.cos(- (x - 3) ** 2)

def InitSpeed(x):
    return 0






def u_curr(U_prev, U_pprev):
    U_curr = np.zeros(n)
    for i in range(1, n - 1):
        U_curr[i] = 2 * (1 - r**2) * U_prev[i] + (U_prev[i+1] + U_prev[i-1]) * r**2 - U_pprev[i]
    return U_curr



# Draw
fig, ax = plt.subplots()

X = np.linspace(0, l, n)

U_pprev = [initial_state(s) for s in X]
U_prev = U_pprev # TODO add += speed

line, = ax.plot(X, U_prev)



def animate(frame_number):
    global U_prev, U_pprev
    U_curr = u_curr(U_prev, U_pprev)
    line.set_ydata(U_curr)  # update the data
    U_pprev = U_prev
    U_prev = U_curr
    # print(frame_number)
    return line,

def init():
    line.set_ydata(U_prev)
    return line,

ani = animation.FuncAnimation(fig, animate, init_func=init, interval=k*1000, blit=True)
ax.set_ylim([-2,2])
plt.show()
