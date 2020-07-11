I1 = imread('Fig1.tif');
I2 = imread('Fig2.tif');

J1=double(I1)
J2=double(I2)
[M,N,L] = size(I1);
I_res=J1.*J2
figure,imshow(I_res,[]);
% figure.imwrite(uint8(I_res),'result.jpg');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Lecture 2- discussion/Multiplication/save.jpg');