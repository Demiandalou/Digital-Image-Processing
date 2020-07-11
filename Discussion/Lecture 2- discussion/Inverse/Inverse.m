I1 = imread('Fig1.tif');

[M,N,L] = size(I1);
I_tmp=double(zeros([size(I1,1),size(I1,2)]));
I_res=(double(I_tmp)+255)-double(I1)
figure,imshow(uint8(I_res),[]);
% figure.imwrite(uint8(I_res),'result.jpg');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Lecture 2- discussion/Inverse/save.jpg');