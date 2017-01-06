import matplotlib.pyplot as plt
import numpy

rs = numpy.linspace(3.4, 3.57, 200)
r_xxx = []
r_s = []
# r_s = [[3.5,3.5], [3.5,3.5]]
for r in rs:
    x = 0.7
    s = 0
    for i in range(500): # stabilize the points
        x = r * x * (1 - x)
    for i in range(50):
        x = r * x * (1 - x)
        s += x
        # r_xxx.append([r, x]) # Save the point (r, x) in the arr, r=const
        plt.plot(r, x, 'b,') # Save the point (r, x) in the arr, r=const
    # r_s.append([r, s/50])
    plt.plot(r, s/50, 'ro')
    # if (r_s[-2][1] > r_s[-3][1] and r_s[-2][1] > r_s[-1][1]) or (r_s[-2][1] < r_s[-3][1] and r_s[-2][1] < r_s[-1][1]):
    #     plt.axvline(r)
r_xxx = numpy.array(r_xxx)
r_s = numpy.array(r_s)

# plt.plot(r_xxx[:, 0], r_xxx[:, 1], ',') # This draws a scatter plot of (r, x) points.
# plt.plot(r_s[:, 0], r_s[:, 1], 'r.-') # This draws a scatter plot of (r, x) points.


# plt.plot([1,1,1,1, 2], [9, 8, 7, 6 ,5], 'ko')
# draw
plt.grid(True)
# plt.savefig('logistic-map.png', dpi=200)
plt.show()