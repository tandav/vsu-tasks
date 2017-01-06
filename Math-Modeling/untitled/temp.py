import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button, RadioButtons

fig, ax = plt.subplots()

x = range(10)
# b = 0.3

xy_plot, = plt.plot(0,0, 'ko')
plt.grid()
r = 10
plt.axis([0, 10, -r, r])
plt.title('y = a*x')
plt.subplots_adjust(bottom=0.25)


ax_a = plt.axes([0.1, 0.15, 0.8, 0.03])
a_slider = Slider(ax_a, 'a', -0.5, 2.5, valinit=0)


def update(val):
    a = a_slider.val
    y = [a*i for i in x]



    # for i in range(50):  # stabilize the points
    #     x_next = 1 - a * x[-1]**2 + y[-1]
    #     y_next = b * x[-1]
    #     x.append(x_next)
    #     y.append(y_next)

    xy_plot.set_data(x,y)
    fig.canvas.draw_idle()


a_slider.on_changed(update)

plt.show()