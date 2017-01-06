import matplotlib.pyplot as plt

X, Y = [], []

a, b = 1.4, .3

def f(x, y):
    return 1 - a * (x ** 2) + y, b * x

X, Y = [.1], [.02]

for i in range(2000):
    c = f(X[-1], Y[-1])
    X.append(c[0])
    Y.append(c[1])

plt.plot(X, Y, 'o')
plt.show()







