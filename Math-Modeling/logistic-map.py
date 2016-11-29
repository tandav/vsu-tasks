import matplotlib.pyplot as plt
import numpy

rs = numpy.linspace(2.8, 4, 1000)
r_xxx = []

for r in rs:
    x = 0.7
    for i in range(500): # stabilize the points
        x = r * x * (1 - x)
    for i in range(50):
        x = r * x * (1 - x)
        r_xxx.append([r, x]) # Save the point (r, x) in the arr, r=const

r_xxx = numpy.array(r_xxx)

plt.plot(r_xxx[:, 0], r_xxx[:, 1], ',') # This draws a scatter plot of (r, x) points.

# draw
plt.title('Logistic Map', fontsize=18)
plt.xlabel('r', fontsize=16)
plt.ylabel('x', fontsize=16)
plt.grid(True)
plt.show()

