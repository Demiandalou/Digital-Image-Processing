load('movingFixPoints.mat')
tiger=imread('tiger.jpg');
% transto=imread('tiger.png');
transto=imread('DT.jpg');

% cpselect(tiger,transto);
% % wait until selection completed
% uiwait(msgbox('Click OK after closing the CPSELECT window.','Waiting...'));
%%
% tform=TPS(movingPoints,fixedPoints);
tform=dense(movingPoints,fixedPoints);
tform = projective2d(tform);

%%
Iout=imwarp(tiger,tform,'OutputView',imref2d(size(transto)));
% figure;imshowpair(I2,Iout,'montage');
figure;imshowpair(transto,Iout,'montage');
% TRANSFORM & REGISTRATION FINISHED

%get mask
DT=transto;
tiger=Iout;
%contour
sigma=10;
T=[0.01 0.05];
[g,t] = edge(rgb2gray(tiger), 'canny', T, sigma);
% figure;imshow(g);

LP = [-1 -2 -1;0 0 0;1 2 1];
im = imfilter(tiger,LP);
% figure;imshowpair(g,im,'montage');title('find contour');
[M,N]=size(g);
mask=g;
for i=1:M
    for j=1:N/3+30
        mask(i,j)=0;
    end
end
for i=200:300
%     limit=abs(250-i);
    limit=60;
    for j=1:N/3+limit
        mask(i,j)=0;
    end
end
% figure;imshow(mask);
se = strel('disk',50);
mask = imclose(mask,se);
se = strel('cube',50);
% se = strel('line',50,100);
mask = imerode(mask,se);

for i=1:M/1.2
    for j=200:N
        if tiger(i,j)>20 && (i<150 || i>300 || j>400)
            mask(i,j)=1;
        end
    end
end
% figure;imshowpair(mask_origin,mask,'montage');
% figure;imshowpair(g,mask,'montage');

figure;imshowpair(mask,DT,'blend');
inverse=ones(size(mask));
mask=inverse-mask;
figure;imshow(mask);

%%
function tform=dense(movingPoints,fixedPoints)
    M = 43;
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






