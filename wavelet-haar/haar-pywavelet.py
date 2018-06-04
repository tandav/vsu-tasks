import numpy as np
import pywt
import matplotlib.pyplot as plt

N = 128
# N = 256
# N = 1024
x = np.linspace(0, 0.1 * N, N, endpoint=False)
f = np.sin(x) + 0.15 * np.sin(20 * x)


def rmse(original, measured):
    return np.sqrt(np.sum(np.square(original - measured)) / len(original))

def nrmse(original, measured):
    return np.sqrt(np.sum(np.square(original - measured)) / len(original) / np.mean(original))

def mae(original, measured):
    return np.mean(np.abs(original - measured))


cA, cD = pywt.dwt(f, 'Haar')
# print(np.min(cA), np.max(cA), np.min(np.abs(cA)))
# print(np.min(cD), np.max(cD), np.min(np.abs(cD)))


# nt = 512
# thresholds   = np.linspace(0, np.max(cA), nt)
# compressions = np.empty_like(thresholds)
# rmse_s       = np.empty_like(thresholds)
# nrmse_s      = np.empty_like(thresholds)
# mae_s        = np.empty_like(thresholds)

# for i, threshold in enumerate(thresholds):
#     print(f'{i}/{nt}')
#     cA_temp = np.copy(cA)
#     cD_temp = np.copy(cD)

#     cA_temp[np.abs(cA_temp) < threshold] = 0
#     cD_temp[np.abs(cD_temp) < threshold] = 0
    
#     filtered_wavelets = np.count_nonzero(np.abs(cA_temp) < threshold) + np.count_nonzero(np.abs(cD_temp) < threshold)
#     compressions[i] = filtered_wavelets / N * 100

#     h = pywt.idwt(cA_temp, cD_temp, 'Haar')
    
#     rmse_s[i]  =  rmse(f, h)
#     nrmse_s[i] = nrmse(f, h)
#     mae_s[i]   =   mae(f, h)




threshold = 0.3 # bigger threshold -> more filtered wavelets, compression percentage is smaller
cA[np.abs(cA) < threshold] = 0
cD[np.abs(cD) < threshold] = 0
filtered_wavelets = np.count_nonzero(np.abs(cA) < threshold) + np.count_nonzero(np.abs(cD) < threshold)

    
h = pywt.idwt(cA, cD, 'Haar')




rmse   =  rmse(f, h)
nrmse  = nrmse(f, h)
mae    =   mae(f, h)


compression = filtered_wavelets / N * 100
# size = (1 - filtered_wavelets / N) * 100

# print(
# f'''
# threshold\t{threshold}
# filtered wavelets:\t{filtered_wavelets}/{N}
# compression:\t{compression}%
# size:\t{size}% of original
# RMSE:\t{rmse}
# NRMSE:\t{nrmse}
# MAE:\t{mae}
# ''')



# print(np.mean(f), np.mean(h))
# print(np.var(f), np.var(h))

# plt.title(f'{N} отсчетов, порог {threshold}, компрессия {compression}')
plt.xlabel(f'порог {threshold}        компрессия {compression:.2f}%        RMSE={rmse:.2f}        MAE={mae:.2f}')
plt.plot(x, f, 'k:', linewidth=1,    label='исходная f(x)')
plt.plot(x, h, 'b-', linewidth=0.8,  label='восстановленная')


fig = plt.gcf()

fig.set_size_inches(19 * 0.39, 4.7 * 0.39) # 1cm = 0.39inch

# plt.plot(compressions,  rmse_s, 'b-', linewidth=0.8,  label='RMSE')
# plt.plot(compressions, nrmse_s, 'r-', linewidth=0.8,  label='NRMSE')
# plt.plot(compressions,   mae_s, 'g--', linewidth=0.8,  label='MAE')
# plt.xlabel('процент компрессии')
# plt.xlim(xmin=0)
# plt.ylim(ymin=0)

plt.legend(loc=0)

plt.grid(color='0.6', linestyle=':', linewidth=0.5)
# plt.tight_layout()
plt.subplots_adjust(left=0.05, right=0.98, top=0.95, bottom=0.25)

fig.savefig(f'images/signals-{threshold}.png', dpi=100)

plt.show()
