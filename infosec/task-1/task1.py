from PIL import Image

# open original image and convert it to grayscale: (8-bit pixels, black and white)
im = Image.open('bridge.jpg').convert('L') 
im.show()

# print(im.size)

im_w, im_h = im.size
block_w, block_h = 64, 64


h = [] # original image hash vector init
for wi in range(0, im_w, block_w):
    for hi in range(0, im_h, block_h):
        print(wi, hi)
        block = im.crop((wi, hi, wi + block_w, hi + block_h)).resize((32, 32))
        # block = block.resize(32, 32)
        block.save('./blocks/block_' + str(wi) + '_' + str(hi) + '.png')



# for 

# block = im.crop((100, 50, 100, 100))
# block.show()

# with Image.open('bridge.jpg') as im:
#     for i in range()
#     x = 0
#     c = (x, 0, x + 8, 20)
#     # im.crop(c).show()
#     im.crop(c).save('666.png')
