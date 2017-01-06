from matplotlib.pyplot import *
import numpy

r_line = numpy.linspace(2.99, 3.6, 1000)
r_xxx = []
eps = 0.01
curr_2_power = 0
branches = []
for r in r_line:
    unique_values = []
    x = 0.7
    for i in range(500): # stabilize the points
        x = r * x * (1 - x)
    unique_values.append(x)
    for i in range(50):
        x = r * x * (1 - x)
        unique = False
        for u in unique_values: # bad: changed size during iteration
            if abs(u - x) < eps:
                break
            unique = True
        if unique:
            unique_values.append(x)
    # branches.append(len(unique_values))
    for u in unique_values:
        # plot(r*250, u*100, 'r,-')
        plot(r, u, 'r.-')
    #     r_xxx.append([r, x]) # Save the point (r, x) in the arr, r=const

# r_xxx = numpy.array(r_xxx)

# plot(r_xxx[:, 0], r_xxx[:, 1], ',') # This draws a scatter plot of (r, x) points.
# plot(branches)
grid(True)
show()
# plt.savefig('logistic-map.png', dpi=200)

# Юзай как Махно - round()