I1 = imread('Noisy_image1.jpg');
I2 = imread('Noisy_image2.jpg');
I3 = imread('Noisy_image3.jpg');
I4 = imread('Noisy_image4.jpg');

[M,N,L] = size(I1);
I_res=uint8(zeros([size(I1,1),size(I1,2)]));
for i = 1:M
    for j = 1:N
%         I_res(i,j,1)=round((I1(i,j,1)+I2(i,j,1)+I3(i,j,1)+I4(i,j,1))/4);
%         I_res(i,j,2)=round((I1(i,j,2)+I2(i,j,2)+I3(i,j,2)+I4(i,j,2))/4);
%         I_res(i,j,3)=round((I1(i,j,3)+I2(i,j,3)+I3(i,j,3)+I4(i,j,3))/4);
        I_res(i,j)=round((I1(i,j)+I2(i,j)+I3(i,j)+I4(i,j))/4);
    end
end
figure,imshow(uint8(I_res),[]);
% figure.imwrite(uint8(I_res),'result.jpg');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Lecture 2- discussion/Addition/save.jpg');