I1 = imread('Fig1.tif');
I2 = imread('Fig2.tif');

[M,N,L] = size(I1);
% I_res=int8(zeros([size(I1,1),size(I1,2)]));
I_res=double(I1)./double(I2)
figure,imshow(I_res,[]);
% figure.imwrite(uint8(I_res),'result.jpg');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Lecture 2- discussion/Division/save.jpg');