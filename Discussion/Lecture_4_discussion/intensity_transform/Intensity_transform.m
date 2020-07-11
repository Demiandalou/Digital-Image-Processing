%Coffee Bean
% I=imread('Fig0316(2)(2nd_from_top).tif');
%Einstein
% I=imread('Fig0241(a)(einstein low contrast).tif');
%BirdsView
% I=imread('Fig0309(a)(washed_out_aerial_image).tif');
%Limo
I=imread('PgaNb.png');

I2=im2double(I);
m=mean2(I2);
contrast=1./(1+(m./(I2+eps)).^10);
subplot(1,2,1), imshow(I);
subplot(1,2,2), imshow(contrast);
% figure,imshow(contrast)

%Coffee Bean
% saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_4_discussion/intensity_transform/coffeBean.jpg');
%Einstein
% saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_4_discussion/intensity_transform/Einstein.jpg');
%BirdsView
% saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_4_discussion/intensity_transform/BirdsView.jpg');
% Limo
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_4_discussion/intensity_transform/Limo.jpg');
