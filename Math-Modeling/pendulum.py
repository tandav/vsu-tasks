import matplotlib.pyplot as plt
import numpy as np

omega = 3
k = 0.
h = 0.01

ang0 = 0
ang_vel0 = 8
t_r = 50


def f1(y, z):
    return z

def f2(y, z):
    return -omega * np.sin(y) - k*z

def simp_sin(t):
    C1, C2 = ang_vel0, ang0
    return C1/omega * np.sin(t*omega) + C2 * np.cos(t*omega)

def dsimp_sin(t):
    C1, C2 = ang_vel0, ang0
    return C1 * np.cos(t*omega) - C2*omega * np.sin(t*omega)

def step(ang_prev, ang_vel_prev):
    k1 = h * f1(ang_prev, ang_vel_prev)
    l1 = h * f2(ang_prev, ang_vel_prev)
    
    k2 = h * f1(ang_prev + k1 / 2, ang_vel_prev + l1 / 2)
    l2 = h * f2(ang_prev + k1 / 2, ang_vel_prev + l1 / 2)

    k3 = h * f1(ang_prev + k2 / 2, ang_vel_prev + l2 / 2)
    l3 = h * f2(ang_prev + k2 / 2, ang_vel_prev + l2 / 2)

    k4 = h * f1(ang_prev + k3, ang_vel_prev + l3)
    l4 = h * f2(ang_prev + k3, ang_vel_prev + l3)

    ang = ang_prev + (k1 + 2 * k2 + 2 * k3 + k4) / 6
    ang_vel = ang_vel_prev + (l1 + 2 * l2 + 2 * l3 + l4) / 6

    return ang, ang_vel 


X = [ang0]
Y = [ang_vel0]
for i in range(1, 200):
    x, y = step(X[-1], Y[-1])
    X.append(x)
    Y.append(y)
    
T = [0]  
Ang = [ang0]
Ang_vel = [ang_vel0]
Simp_sin = [ang0]
DSimp_sin = [ang_vel0]
for i in range(1, int(t_r/h)):
    x, y = step(Ang[-1], Ang_vel[-1])
    T.append(i * h)
    Ang.append(x)
    Ang_vel.append(y)
    Simp_sin.append(simp_sin(T[-1]))
    DSimp_sin.append(dsimp_sin(T[-1]))


    
    
plt.plot(Simp_sin, DSimp_sin, 'r')
plt.plot(X, Y,'k')
plt.grid(True)
plt.xlim([-5, 5])
plt.ylim([7, 9])
# plt.axis('equal')
plt.show()
