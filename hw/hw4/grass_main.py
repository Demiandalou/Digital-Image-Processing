from img_inpaint import img_inpainting
import cv2
import matplotlib.pyplot as plt
import numpy as np

patch_size=51
I=cv2.imread("grassland.jpg")
mask = cv2.imread('grass_mask.png')
mask = cv2.cvtColor(mask, cv2.COLOR_BGR2GRAY)
I[np.where(mask!=0)] = [0,0,0]
plt.imshow(cv2.cvtColor(I, cv2.COLOR_BGR2RGB))
plt.title('create mask')
plt.show()
img_inpainting(I,mask,patch_size)
plt.imshow(cv2.cvtColor(I, cv2.COLOR_BGR2RGB))
cv2.imwrite('grass_patch51_impaint.jpg', I) 
plt.title('patch size '+str(patch_size))
plt.show()
