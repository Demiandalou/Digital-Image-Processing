############### res ####################
# 1687 same 15 * 15 patches in processed image(2596).   65%
# 1427 same 15 * 15 patches in original image           55%

# 626 same 20 * 20 patches in processed image(1452).    43%
# 483 same 20 * 20 patches in original image            33%

# 237 same 25 * 25 patches in processed image(884) .    27%
# 198 same 25 * 25 patches in original image            22%

############### script ####################
from img_inpaint import img_inpainting
import cv2
import matplotlib.pyplot as plt
import numpy as np

# processed=cv2.imread("family_patch51_impaint.jpg")
# origin=cv2.imread("family.jpg")
processed=cv2.imread("grass_patch51_impaint.jpg")
origin=cv2.imread("grass_origin.jpg")
# print(processed[0:2,0:2,:])
# print(origin[0:2,0:2,:])

# print(len(processed))
# print(len(processed[0]))

# number of same psize*psize patches
psize=20
patches_process=[]
patches_origin=[]
# for i in range(len(processed)-psize+1):
for i in range(0,len(processed)-psize+1,psize-1):
    # for j in range(len(processed[0])-psize+1):
    for j in range(0,len(processed[0])-psize+1,psize-1):
        patch=processed[i:i+psize,j:j+psize,:]
        patch=patch.flatten()
        patches_process.append(tuple(patch))
        patch=origin[i:i+psize,j:j+psize,:]
        patch=patch.flatten()
        patches_origin.append(tuple(patch))
same_cnt_process=0
same_cnt_origin=0
for i in range(len(patches_process)):
    for j in range(i+1,len(patches_process)):
        if abs(sum(patches_process[i])-sum(patches_process[j]))<psize*2:
            same_cnt_process+=1
            break
for i in range(len(patches_origin)):
    for j in range(i+1,len(patches_origin)):
        if abs(sum(patches_origin[i])-sum(patches_origin[j]))<psize*2:
            same_cnt_origin+=1
            break

print(same_cnt_process,'same',psize,'*',psize,'patches in processed image')
print(same_cnt_origin,'same',psize,'*',psize,'patches in original image')

