 im4 = imread('boy-sun.jpg');
%  im4 = rgb2gray(im4);

thresh = multithresh(im4,2);
seg_I = imquantize(im4,thresh);

RGB = label2rgb(seg_I); 	 
figure;
imshow(RGB)
axis off
% title('RGB Segmented Image')