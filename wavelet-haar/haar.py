import matplotlib.pyplot as plt
import numpy as np

N = 128
# N = 1024
threshold = 0.001
# threshold = 0.1
x = np.linspace(0, 12, N, endpoint=False)
x2 = np.linspace(0, 12, N/2, endpoint=False)
# x = np.arange(0, 12, 0.1)
f = np.sin(x) + 0.15 * np.sin(20 * x)



def direct_transform(a):
    if len(a) == 1:
        return a

    result = []
    temp   = []

    for i in range(0, len(a) - 1, 2):
        result.append((a[i] - a[i + 1]) / 2)
        temp.append(  (a[i] + a[i + 1]) / 2)

    result = np.hstack((result, temp))
    return result


def inverse_transform(SourceList):
    n = len(SourceList)
    if n == 1:
        return SourceList

    RetVal    = []
    TmpPart   = []
    # print(a)


    for i in range(n // 2, n):
        TmpPart.append(SourceList[i])

    # part = inverse_transform(temp_part)
    # SecondPart = inverse_transform(SourceList[n // 2 :])
    SecondPart = inverse_transform(TmpPart)
    # print(len(SecondPart), n)


    for i in range(0, n // 2):
        # print()
        RetVal.append(SecondPart[i] + SourceList[i])
        RetVal.append(SecondPart[i] - SourceList[i])

    return RetVal


u = direct_transform(f)
u[u < threshold] = 0
v = inverse_transform(u)
# print(np.allclose(u, v))

print(len(x), len(u))
plt.plot(x, f)
plt.plot(x, u, color='r')
plt.plot(x, v, color='g')
# plt.plot(x2, u)
plt.show()
