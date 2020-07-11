% I=im2double(imread('Figure1.tif'));
% F=fftshift(fft2(I));
% % plot(abs(F))
% IF=ifft2(fftshift(F));
% figure; imshow(IF);
% figure;imshowpair(I,IF,'montage');

%%
I=imread('barbara.tif');
resize_I = imresize(imresize(I,0.25),4);
alias_I = I(1:4:end,1:4:end);
alias_I=imresize(alias_I,4);
% imshowpair(I,resize_I,'montage');
figure;
subplot(1,3,1);
imshow(I);
subplot(1,3,2);
imshow(alias_I);
subplot(1,3,3);
imshow(resize_I);
