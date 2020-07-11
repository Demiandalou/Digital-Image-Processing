I=imread('lena.jpg');
%SR-mountain
style = imread('img2.jpg');
%StarryNight
% style = imread('timg.jpg');

output=imhistmatch(I,style);
subplot(1,3,1), imshow(I);
subplot(1,3,2), imshow(style);
subplot(1,3,3), imshow(output);
%SR-mountain
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_4_discussion/histogram_matching/SR-mountain.jpg');
%Starry Night
% saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_4_discussion/histogram_matching/StarryNight.jpg');

