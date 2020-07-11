I=imread('beach.png');
% 'average'
h = fspecial('average',10);
img0 = imfilter(I,h);
h = fspecial('average',20);
img1 = imfilter(I,h);
h = fspecial('average',30);
img2 = imfilter(I,h);
subplot(1,4,1), imshow(I),title('origin');
subplot(1,4,2), imshow(img0),title('hsize=10');
subplot(1,4,3), imshow(img1),title('hsize=20');
subplot(1,4,4), imshow(img2),title('hsize=30');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_6_discussion/fspecial_avg.jpg');

h = fspecial('disk',10);
img0 = imfilter(I,h);
h = fspecial('disk',20);
img1 = imfilter(I,h);
h = fspecial('disk',30);
img2 = imfilter(I,h);
subplot(1,4,1), imshow(I),title('origin');
subplot(1,4,2), imshow(img0),title('radius=10');
subplot(1,4,3), imshow(img1),title('radius=20');
subplot(1,4,4), imshow(img2),title('radius=30');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_6_discussion/fspecial_disk.jpg');

%'laplacian'  Approximates the two-dimensional Laplacian operator
h = fspecial('laplacian',0.2);
img0 = imfilter(I,h);
h = fspecial('laplacian',0.5);
img1 = imfilter(I,h);
h = fspecial('laplacian',0.8);
img2 = imfilter(I,h);
subplot(1,4,1), imshow(I),title('origin');
subplot(1,4,2), imshow(img0),title('alpha=0.2');
subplot(1,4,3), imshow(img1),title('alpha=0.5');
subplot(1,4,4), imshow(img2),title('alpha=0.8');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_6_discussion/fspecial_laplacian.jpg');

%'log' Laplacian of Gaussian filter
h = fspecial('log',10,0.2);
img0 = imfilter(I,h);
h = fspecial('log',20,0.4);
img1 = imfilter(I,h);
h = fspecial('log',30,0.6);
img2 = imfilter(I,h);
subplot(1,4,1), imshow(I),title('origin');
subplot(1,4,2), imshow(img0),title('hsize=10,beta=0.2');
subplot(1,4,3), imshow(img1),title('hsize=10,beta=0.4');
subplot(1,4,4), imshow(img2),title('hsize=20,beta=0.4');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_6_discussion/fspecial_log.jpg');

%'sobel' Sobel horizontal edge-emphasizing filter
h = fspecial('sobel');
img0 = imfilter(I,h);
subplot(1,2,1), imshow(I),title('origin');
subplot(1,2,2), imshow(img0),title('sobel');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_6_discussion/fspecial_sobel.jpg');




