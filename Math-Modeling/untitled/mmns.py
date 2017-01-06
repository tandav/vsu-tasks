import matplotlib.pyplot as plt
import numpy as np
import warnings
warnings.filterwarnings('ignore')

epsx, epsy = .001, .02
u, a, m, h = 0.025, 6.18, 9.1e-31, 6.582e-16
# u, a, m, h = .3, 6.18, 9.1e-31, 6.582e-16
k0         = np.sqrt(2 * u * m) / h
lim        = 10

def eq(k):
	return np.sqrt(k0 ** 2 - k ** 2 + 0j) / k - np.tan(a * k), k / np.sqrt(k0 ** 2 - k ** 2) + np.tan(a * k)

X = np.arange(-lim, lim, epsx)

K, Kap, AB, E = [], [], [], []
#K finding from equation
def isInK(x):
	for i in K:
		if abs(x - i) <= epsy: return True
	return False
for x in X:
	if (abs(eq(x)[0]) <= epsy or abs(eq(x)[1]) <= epsy) and not isInK(x) and x >= 0:
		K.append(int(x * 100) / 100)


for k in K: Kap.append(np.sqrt(k0 ** 2 - k ** 2))#Kap
for kap in Kap:
	AB.append(np.sqrt(1 / (a + 1 / kap)))#AB
	E.append(-.5 * ((h * kap) ** 2) / m)#E

print("Уровней: ",len(K))
print(K)
def phi(j, x):
	#even
	if j % 2 == 0:
		x = abs(x)
		if 0 <= x <= a:  return AB[j] * np.cos(K[j] * x)
		else: 			 return AB[j] * np.cos(K[j] * x) * np.exp(Kap[j] * (a - x))
	#odd
	else:
		s = np.sign(x)
		x = abs(x)
		if 0 <= x <= a:  return s * AB[j] * np.sin(K[j] * x)
		else: 			 return s * AB[j] * np.sin(K[j] * x) * np.exp(Kap[j] * (a - x))

Y = [phi(1,x) for x in X]

#x_kn and integrand
def ingd(k, n, x):
	return np.conj(phi(k, x)) * phi(n, x) * x

def x_kn(k , n):
	sum41 = 0
	for i in np.arange(- 2 * a, 2 * a, .1):
		sum41 += ingd(k, n, i)
	return sum41 * .1

#omega
def om(k, n):
	return (E[n] - E[k]) / h

#oscillator strength
def f(k, n):
	return 2 * m * om(k, n) * (abs(x_kn(k, n)) ** 2) / h

for i in range(1, len(K)):
	for j in range(0, i):
		print("f(" + str(j) + ", " + str(i) + ") = ", int(10000 * f(j, i)) / 10000)
plt.plot(X, Y)
plt.grid(True)
axes = plt.gca()
axes.set_xlim([-2*a,2*a])
# axes.set_ylim([-a,a])
# plt.show()