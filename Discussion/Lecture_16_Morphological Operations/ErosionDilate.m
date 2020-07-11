% % FINGER PRINT
% I=imread('fingerprint.tif');
% % se = strel('line',11,90);
% % se = strel('ball',2,2);
% se = strel('cube',2);
% erodedI = imerode(I,se);
% se = strel('line',4,5);
% dilatedI = imdilate(erodedI,se);
% figure;imshowpair(I,dilatedI,'montage');

% % WIREBOND
% I=imread('wirebond-mask.tif');
% se = strel('cube',14);
% erodedI = imerode(I,se);
% % se = strel('line',9,9);
% se = strel('sphere',9);
% dilatedI = imdilate(erodedI,se);
% figure;imshowpair(I,dilatedI,'montage');

% DOT LINE
I=imread('dot_a_lines.gif');
I1=bwmorph(I,'remove');
se = strel('line',2,90);
I2 = imerode(I1,se);
se = strel('line',3,1);
I3= imerode(I1,se);
I4=I2|I3;
% figure;imshowpair(I2,I3,'montage');
% figure;imshow(I4);
se = strel('cube',1);
I5 = imerode(I4,se);
% figure;imshow(I5);
se = strel('disk',5);
I6 = imclose(I5,se);
% figure;imshow(I6);
se = strel('line',3,10);
I7 = imerode(I6,se);
% figure;imshow(I7);
se = strel('line',5,6);
I8 = imdilate(I7,se);
figure;imshow(I8);


