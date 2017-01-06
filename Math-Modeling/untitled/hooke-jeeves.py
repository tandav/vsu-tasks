
def f(x):
    return x[0]**2 - x[0]*x[1] + 3*x[1]**2 - x[0]

x0  = [1,1]
eps = 0.1
d   = 2
h   = [0.2, 0.2]
m   = 0.5


h_bad = True
exploring_search_bad = True

while(h_bad):
    x_base = x1

    for h_i in h:
        if h_i > eps:
            break
    h_bad = False
    print(x_base, f(x_base))


        break
    else:
        success = False
        while not success:
            for i in range(len(x0)):
                x1 = x0
                z = x0
                i = 1
                x1[i] += h[i]
                if f(x1) < f(z):
                    z = x1
                else:
                    x1[i] -= 2 * h[i]
                    if f(x1) < f(z):
                        z = x1
                    else:
                        x1[i] += h[i]
                        z = x1
            z = x1
            for i in range(len(x0)):
                if x1[i] == x0[i]:
                    h[i] /= d
                else:
                    success = True