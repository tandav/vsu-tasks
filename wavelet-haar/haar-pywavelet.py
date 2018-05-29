import numpy as np
import pywt
import matplotlib
# matplotlib.rcParams['text.usetex'] = True
# matplotlib.rcParams['text.latex.unicode'] = True
import matplotlib.pyplot as plt

# N = 128
# N = 256
N = 1024
x = np.arange(0, 0.1 * N, 0.1)
f = np.sin(x) + 0.15 * np.sin(20 * x)


cA, cD = pywt.dwt(f, 'Haar')
print(np.min(cA), np.max(cA), np.min(np.abs(cA)))
print(np.min(cD), np.max(cD), np.min(np.abs(cD)))

threshold = 0 # bigger threshold -> more filtered wavelets, compression percentage is smaller
cA[np.abs(cA) < threshold] = 0
cD[np.abs(cD) < threshold] = 0
filtered_wavelets = np.count_nonzero(np.abs(cA) < threshold) + np.count_nonzero(np.abs(cD) < threshold)

    
h = pywt.idwt(cA, cD, 'Haar')


def rmse(original, measured):
    return np.sqrt(np.sum(np.square(original - measured)) / N)

def nrmse(original, measured):
    return np.sqrt(np.sum(np.square(original - measured)) / N / np.mean(original))

def mae(original, measured):
    return np.mean(np.abs(original - measured))

rmse   =  rmse(f, h)
nrmse  = nrmse(f, h)
mae    =   mae(f, h)
# nrmse = rmse(np.array([-100, 20480000, 30]), np.array([1, 2, 3]))

# NRMSD = nrmsd(h, f)

# RMSD = np.sqrt(np.sum(np.square(f - h)) / N)
compression = filtered_wavelets / N * 100
size = (1 - filtered_wavelets / N) * 100

print(
f'''
threshold\t{threshold}
filtered wavelets:\t{filtered_wavelets}/{N}
compression:\t{compression}%
size:\t{size}% of original
RMSE:\t{rmse}
NRMSE:\t{nrmse}
MAE:\t{mae}
''')



# print(np.mean(f), np.mean(h))
# print(np.var(f), np.var(h))

# plt.title(f'{N} отсчетов, порог {threshold}, компрессия {compression}')
# plt.xlabel('x')
plt.plot(x, f, 'k:', linewidth=1,    label='исходная f(x)')
plt.plot(x, h, 'b-', linewidth=0.8,  label='восстановленная')
plt.legend(loc=1)
plt.grid(color='0.6', linestyle=':', linewidth=0.5)
plt.show()
