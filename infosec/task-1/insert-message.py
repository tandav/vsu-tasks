import matplotlib.pyplot as plt
import matplotlib
import numpy as np
import scipy
from scipy import signal
from PIL import Image
from scipy.spatial.distance import hamming

message = np.array([1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1,
                    0, 0, 1, 1, 1, 1, 1, 1,
                    0, 0, 0, 0, 1, 1, 1, 1,
                    0, 0, 0, 0, 0, 1, 1, 1,
                    0, 0, 0, 0, 0, 0, 1, 1,
                    0, 0, 0, 0, 0, 1, 1, 1])

message2 = np.array([1, 1, 1, 1, 0, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1,
                    0, 0, 1, 1, 1, 1, 1, 1,
                    0, 0, 0, 0, 1, 1, 1, 1,
                    0, 0, 1, 0, 0, 1, 1, 1,
                    0, 0, 0, 0, 0, 0, 1, 1,
                    0, 0, 0, 0, 0, 1, 1, 1])


# print(hamming(message, message2))


# 
img = Image.open('bridge.jpg')

pos_x, pos_y = 250, 200
block = img.crop((pos_x, pos_y, pos_x + 64, pos_y + 64))
block = np.array(block)


def insert_message(image, message, L=0.3, padding=2):
    bs = image.shape[0] # image size
    k = 0
    for i in range(padding, bs - padding, 8):
        for j in range(padding, bs - padding, 8):
            # print(i, '\t', j, '\t', k)
            Y = int(np.round(0.299*image[i][j][0] + 0.587*image[i][j][1] + 0.114*image[i][j][2]))
            # Y = int((0.299*image[i][j][0] + 0.587*image[i][j][1] + 0.114*image[i][j][2]))
            #            = 0.299 R + 0.587 G + 0.114 B
            # print(0.299*image[i][j][0] + 0.587*image[i][j][1] + 0.114*image[i][j][2], Y)
            if message[k] == 0:
                image[i][j][2] -= L * Y
            elif message[k] == 1:
                image[i][j][2] += L * Y
            k += 1
    return image


block_with_message = insert_message(block, message, L=0.1)


def extract_message(image, sigma=2, padding=2):
    bs = image.shape[0]
    message = np.zeros(64)
    k = 0
    for y in range(padding, bs - padding, 8):
        for x in range(padding, bs - padding, 8):
            B_hat = 0
            for s in range(1, sigma + 1):
                if y == 2 and x == 2:
                    pass
                    # print('y - s = ', y - s)
                    # print('y + s = ', y + s)
                    # print('x - s = ', x - s)
                    # print('x + s = ', x + s)
                B_hat += int(image[y + s][x][2]) + int(image[y-s][x][2]) + int(image[y][x+s][2]) + int(image[y][x-s][2])
#               print(image[y + s][x][2], image[y-s][x][2], image[y][x+s][2], image[y][x-s][2])
            B_hat /= 4*sigma
            # print(B_hat, '\t', image[y][x][2])
            if image[y][x][2] > B_hat:
                message[k] = 1
            elif image[y][x][2] < B_hat:
                message[k] = 0
            k += 1
    return message

extracted_message = extract_message(block_with_message)
print(message.reshape(8,8))
print(extracted_message.reshape(8,8))
print('\n\ndiff:')
print((message == extracted_message).reshape(8,8)*1)
print(hamming(message, extracted_message))
