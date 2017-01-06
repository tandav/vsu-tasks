import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button, RadioButtons

# fig, ax = plt.subplots()


n2 = 500
# b = 0.3
fig = plt.figure(figsize=(16,8))
# fig = plt.figure()

plt.subplot(221)
xn_plot, = plt.plot(range(n2+1), np.zeros(n2+1), 'k.')
# xn_plot.set_xdata(range(n2+1))
plt.axis([0, n2, -5, 5])
plt.grid()
plt.title("x(n)")

plt.subplot(223)
yn_plot, = plt.plot(range(n2+1), np.zeros(n2+1), 'k.')
plt.axis([0, n2, -5, 5])
plt.grid()
plt.title("y(n)")

plt.subplot(122)
xy_plot, = plt.plot(0,0, 'k.')
r = 5.5
plt.axis([-r, r, -r, r])
plt.grid()
plt.title("(x, y)")
# plt.tight_layout()
plt.subplots_adjust(bottom=0.25)


ax_a = plt.axes([0.1, 0.15, 0.8, 0.03])
a_slider = Slider(ax_a, 'a', -0.5, 2.5, valinit=0)

ax_b = plt.axes([0.1, 0.05, 0.8, 0.03])
b_slider = Slider(ax_b, 'b', -0.5, 1.2, valinit=1)


def update(val):
    a = a_slider.val
    b = b_slider.val
    x = [0.1]
    y = [0.02]

    for i in range(n2):  # stabilize the points
        x.append(1 - a * x[-1]**2 + y[-1])
        y.append(b * x[-2])

    # for i in range(50):  # stabilize the points
    #     x_next = 1 - a * x[-1]**2 + y[-1]
    #     y_next = b * x[-1]
    #     x.append(x_next)
    #     y.append(y_next)

    xn_plot.set_ydata(x)
    yn_plot.set_ydata(y)
    xy_plot.set_data(x,y)
    fig.canvas.draw_idle()


a_slider.on_changed(update)
b_slider.on_changed(update)

plt.show()