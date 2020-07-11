% Test AWB
clear; clc;
close all;
%BW3&1 param
% Kr = 0.8744;
% Kg = 1.0000;
% Kb = 2.0745;
%BW2
Kr = 1.299;
Kg = 1.000;
Kb = 1.299;
K = [Kr, 0, 0;0, Kg, 0;0, 0, Kb];

I = imread('BW2.png');
O=uint8(zeros([size(I,1),size(I,2)]));
[M,N,L] = size(I);
for i = 1:M
    for j = 1:N
%         O(i,j,1)=0.299*double(I(i,j,1));
%         O(i,j,2)=0.587*double(I(i,j,2));
%         O(i,j,3)=0.114*double(I(i,j,3));
        Fxy=double([I(i,j,1), I(i,j,2), I(i,j,3)]');
        FWB=K*Fxy;
        for p=1:3
            O(i,j,p) = uint8(FWB(p));
        end
    end
end
    
subplot(1,2,1), imshow(I);
%     subplot(1,3,2), imshow(J);
subplot(1,2,2), imshow(O);
% imwrite(O, strcat('BW3_', num2str(p(i)), '.png'))
% figure,imshow(double(O),[]);
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_3_dicussion_color_balance/tmp.jpg');


