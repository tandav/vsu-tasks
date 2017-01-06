import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import odeint
from scipy.optimize import fsolve
from matplotlib.widgets import Slider, Button, RadioButtons

r, K, w, D = 6, 1.8, 1, 1
S, J = .4, .1


def dX_dt(X, t=0):
    """ Return the growth rate of x1 and x2 populations. """
    return np.array([ r * (1 - X[0] / K) * X[0] - w * X[0] * X[1] / (D + X[0]),
                      S * (1 - J * X[1] / X[0]) * X[1] ])





f, (ax1, ax2) = plt.subplots(1, 2)

phase,    = ax1.plot(0, 0, 'b')
special1, = ax1.plot(0, 0, '--', color = '0.75')
special2, = ax1.plot(0, 0, '--', color = '0.75')
spec_pt,  = ax1.plot(0, 0, 'ro')
x1_t,     = ax2.plot(0, 0, 'b')
x2_t,     = ax2.plot(0, 0, 'r')


low_bound, hi_bound = -10, 10
r_slider = Slider(plt.axes([0.05, 0.1, 0.4, 0.03]), 'r', low_bound, hi_bound, valinit=6)
K_slider = Slider(plt.axes([0.05, 0.2, 0.4, 0.03]), 'K', low_bound, hi_bound, valinit=7.8)
w_slider = Slider(plt.axes([0.05, 0.3, 0.4, 0.03]), 'w', low_bound, hi_bound, valinit=1.1)
D_slider = Slider(plt.axes([0.5, 0.1, 0.4, 0.03]), 'D', low_bound, hi_bound, valinit=1)
S_slider = Slider(plt.axes([0.5, 0.2, 0.4, 0.03]), 'S', low_bound, hi_bound, valinit=1.5)
J_slider = Slider(plt.axes([0.5, 0.3, 0.4, 0.03]), 'J', low_bound, hi_bound, valinit=.1)

txt = ax1.text(0.95, 0.01, 'start', verticalalignment='bottom',
            horizontalalignment='right',transform=ax1.transAxes, fontsize=12)

t = np.linspace(0, 15, 10000)

def update(val):
    global r, K, w, D, S, J
    r = r_slider.val
    K = K_slider.val
    w = w_slider.val
    D = D_slider.val
    S = S_slider.val
    J = J_slider.val

    X0 = np.array([12, 11])
    X = odeint(dX_dt, X0, t)
    x1, x2 = X.T


    phase.set_data(x1, x2)
    special1.set_data(x1, r / w * (1 - x1 / K) * (D + x1))
    special2.set_data(x1, x1 / J)

    special_x = fsolve(lambda x1: r / w * (1 - x1 / K) * (D + x1) - x1 / J, 0.5)
    special_y = special_x / J

    k = K / special_x
    d = D / special_x
    spec_pt.set_data(special_x, special_y)

    if (r * (k - d - 2) / (k * (1 + d)) - S > 0):
        txt.set_text('Особая точка:\n' + str(special_x) + str(special_y) + '\nНеустойчивый фокус\nПредельный цикл')
    else:
        txt.set_text('Особая точка:\n' + str(special_x) + str(special_y) + '\nУстойчивый фокус\nПредельного цикла нет')
    #
    # if (r * (k - d - 2) / (k * (1 + d)) - S > 0):
    #     ax1.text(0.95, 0.01, 'Особая точка:\n' + str(special_x) + str(special_y) + '\nНеустойчивый фокус\nПредельный цикл', verticalalignment='bottom',
    #         horizontalalignment='right',transform=ax1.transAxes, fontsize=12)
    # else:
    #     ax1.text(0.95, 0.01, 'Особая точка:\n' + str(special_x) + str(special_y) + '\nУстойчивый фокус\nПредельного цикла нет', verticalalignment='bottom',
    #         horizontalalignment='right',transform=ax1.transAxes, fontsize=12)

    x1_t.set_data(t, x1)
    x2_t.set_data(t, x2)

    ax1.relim()
    ax1.autoscale_view(True, True, True)

    ax2.relim()
    ax2.autoscale_view(True, True, True)
    # ax1.axis([min(x1), max(x1), min(x2), max(x2)])
    # ax2.axis([min(x1), max(x1), min(x2), max(x2)])

    f.canvas.draw_idle()





ax1.set_title("Phase Portrait")
ax1.set_xlabel('x1')
ax1.set_ylabel('x2', rotation=0)

#



ax1.grid()
# ax1.axis([min(x1), max(x1), min(x2), max(x2)])


# ax2.plot(t, x1, 'b')
# ax2.plot(t, x2, 'r')
ax2.set_xlabel('t')
ax2.set_title("x1(t), x2(t)")
ax2.grid()


r_slider.on_changed(update)
K_slider.on_changed(update)
w_slider.on_changed(update)
D_slider.on_changed(update)
S_slider.on_changed(update)
J_slider.on_changed(update)

plt.subplots_adjust(bottom=0.5)
plt.show()

