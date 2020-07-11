load('movingFixPoints.mat')
% I1 = imread('1.jpg');%to do registration transform to 2
% I2 = imread('2.jpg');
I1=imread('LP.jpg');
I2=imread('GG.jpg');
I1=imresize(I1,[size(I2,1),size(I2,2)]);

% cpselect(I1,I2);
% % wait until selection completed
% uiwait(msgbox('Click OK after closing the CPSELECT window.','Waiting...'));

% 'projective', 'affine','pwl'
tform_func=fitgeotrans(movingPoints,fixedPoints,'projective');
Iout_func=imwarp(I1,tform_func,'OutputView',imref2d(size(I2)));
% figure;imshowpair(I2,Iout_func,'montage');

%%
% tform=TPS(movingPoints,fixedPoints);
tform=dense(movingPoints,fixedPoints);
tform = projective2d(tform);

%%
Iout=imwarp(I1,tform,'OutputView',imref2d(size(I2)));
% figure;imshowpair(I2,Iout,'montage');
% figure;imshowpair(I2,Iout,'blend');
% I2, Iout, mask);

% figure;
% imshow(stitched);

figure;
subplot(141);
imshow(I1);
subplot(142);
imshow(I2);
subplot(143);
imshowpair(I2,Iout_func,'blend');
title("fitgeotrans");
subplot(144);
imshowpair(I2,Iout,'blend');
title("self-implemented dense");

%%
function tform=dense(movingPoints,fixedPoints)
    M = 30;
    x_fix = fixedPoints(:,1);
    y_fix = fixedPoints(:,2);
    OneMat = ones(M,1);
    ZeroMat = zeros(M,1);
    %Final: AS=D
    x = movingPoints(:,1);
    y = movingPoints(:,2);
    A = [  x       y      ZeroMat  ZeroMat  OneMat  ZeroMat  -x.*x_fix  -y.*x_fix;
        ZeroMat  ZeroMat     x        y     ZeroMat  OneMat  -x.*y_fix  -y.*y_fix  ];
    D=fixedPoints(:);
    S=pinv(A)*D;
    S(9)=1;
    tform=zeros([3,3]);
    tform(:)=S;
    tform(1,2)=S(3);
    tform(2,2)=S(4);
    tform(3,1)=S(5)
end






