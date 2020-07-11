I = imread('Peter_Burr_House.jpg');
% % figure;imshow(I);
% [BW1,threshOut1,Gv1,Gh1] = edge(I,'Prewitt','horizontal');
% [BW2,threshOut2,Gv2,Gh2] = edge(I,'Sobel','horizontal');
% % figure;imshowpair(BW1,BW2,'montage');title('horizontal');
% [BW3,threshOut3,Gv3,Gh3] = edge(I,'Prewitt','vertical');
% [BW4,threshOut4,Gv4,Gh4] = edge(I,'Sobel','vertical');
% % figure;imshowpair(BW3,BW4,'montage');title('vertical');
% 
% mag1=sqrt(Gv1.^2+Gh3.^2);% 0-0.4492
% angle1=atan(Gh3./Gv1);% +-1.5708
% figure;imshowpair(mag1,angle1,'montage');
% edge1 = (abs(angle1+21)<20) & (mag1>0.2);
% figure;imshow(edge1);

% h1=fspecial('log',[101,101],3/10/30);
% surf(h1,'edgecolor','none');

% sigma=10;
% T=[0.05 0.2];
% [g,t] = edge(I, 'canny', T, sigma);
% figure;imshow(g);

leaf=imread('leaf.jpg');
LP = [-1 -2 -1;0 0 0;1 2 1];
im1 = imfilter(leaf,LP);
LP = [-1 0 1;-2 0 2;-1 0 1];
im2 = imfilter(leaf,LP);
LP = [-2 -1 0;-1 0 1;0 1 2];
im3 = imfilter(leaf,LP);
figure;
subplot(131);
imshow(im1);
subplot(132);
imshow(im2);
subplot(133);
imshow(im3);


