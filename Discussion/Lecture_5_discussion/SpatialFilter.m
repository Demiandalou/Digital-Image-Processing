% I=imread('MayaStatue4.jpg');
% % I=imread('boat.jpg')
% 
% %Low Filter
% LP = 1/9 *[1,1,1;1,1,1;1,1,1];
% % LP=fspecial('motion', 20, 45);
% im3 = imfilter(I,LP);
% %Sharpening filter
% f1 = 1/9*[0,-1,0; -1,5,-1;0,-1,0];
% % f1 = 1/9*[1,1,1;1,-8,1;1,1,1];
% % f1 = 1/9*[-1,-1,-1;-1,8,-1;-1,-1,-1];
% % f1=fspecial('unsharp');
% J1 = imfilter(I,f1);
% 
% 
% subplot(1,3,1), imshow(I);
% subplot(1,3,2), imshow(im3);
% subplot(1,3,3), imshow(J1,[]);
% saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_5_discussion/low_sharpen_filt.jpg');

I=imread('Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
% I=imread('Ex_ColorEnhance.png');
J2 = medfilt2(I,[3 3]);
J4 = medfilt2(I,[6 6]);
J3 = medfilt2(I,[11 1]);
J5 = medfilt2(I,[1 11]);
subplot(1,5,1), imshow(I,[]);
subplot(1,5,2), imshow(J2,[]);
subplot(1,5,3), imshow(J4,[]);
subplot(1,5,4), imshow(J3,[]);
subplot(1,5,5), imshow(J5,[]);
% saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_5_discussion/median_filt.jpg');
