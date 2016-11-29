import matplotlib.pyplot as plt
import numpy

rs = numpy.linspace(2.8, 4, 4000)
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
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.title("Logistic Map: " "$x_{n+1} = rx_{n}(1-x_{n})", fontsize=18)
plt.xlabel('$r', fontsize=20)
plt.ylabel('$x', fontsize=20, rotation='horizontal')
plt.grid(True)
plt.savefig('logistic-map.png', dpi=200)
# plt.show()