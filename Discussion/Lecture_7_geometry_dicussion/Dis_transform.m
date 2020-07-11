% 35бу clock-wise rotations, 0.6 scaling and 50 shift on X-axial; 
% 0.8 scaling and 15 shift on Y-axial. 
cos(35);
I=imread('zombie.jpg');
theta=35;
Rotate=[cosd(theta) sind(theta) 0;...
    -sind(theta) cosd(theta) 0; 0 0 1];
% Rotate=[1 0 0;0 cosd(35) -sind(35);0 sind(35) cosd(35)];
Scale=[0.6 0 0;0 0.8 0;0 0 1];
Move=[1 0 0;0 1 0;50 15 1];
% A=Rotate.*Scale.*Move;

tform = affine2d(Rotate);
J1 = imwarp(I,tform);
tform = affine2d(Scale);
J2 = imwarp(J1,tform);
tform = affine2d(Move);
J3 = imwarp(J2,tform);
figure;
% imshow(J);
subplot(1,4,1), imshow(I);title('origin');
subplot(1,4,2), imshow(J1);title('Rotated');
subplot(1,4,3), imshow(J2);title('Scaled');
subplot(1,4,4), imshow(J3);title('shifted');
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_7_geometry_dicussion/ZombieTrans.jpg');


