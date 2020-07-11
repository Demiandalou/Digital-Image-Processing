I = imread('beach.png');
J = adapthisteq(I,'clipLimit',0.02,'Distribution','rayleigh');
imshowpair(I,J,'montage');
title('Original Image (left) and Contrast Enhanced Image (right)')
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_6_discussion/adapthisteq_beach.jpg');

% [X, MAP] = imread('lg-image26.jpg');
% RGB = ind2rgb(X,MAP);
% LAB = rgb2lab(RGB);
% L = LAB(:,:,1)/100;
% L = adapthisteq(L,'NumTiles',[8 8],'ClipLimit',0.005);
% LAB(:,:,1) = L*100;
% J = lab2rgb(LAB);
% figure
% imshowpair(RGB,J,'montage')
% title('Original (left) and Contrast Enhanced (right) Image')