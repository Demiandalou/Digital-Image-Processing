% load('moveFixPoints.mat')
load('moveFixPoints0.mat');
I1 = imread('1.jpg');%1 transform to 2
I2 = imread('2.jpg');
% cpselect(I1,I2);
% % wait until selection completed
% uiwait(msgbox('Click OK after closing the CPSELECT window.','Waiting...'));

% 'projective', 'affine','pwl'
tform_0=fitgeotrans(movingPoints,fixedPoints,'projective');
Iout0=imwarp(I1,tform_0,'OutputView',imref2d(size(I2)));
% figure;imshowpair(I2,Iout,'montage');
% figure;imshowpair(I2,Iout,'blend');
%stitch
blender = vision.AlphaBlender('Operation', 'Binary mask','MaskSource', 'Input port');  
mask = imwarp(true(size(I2,1),size(I2,2)), tform_0, 'OutputView', imref2d(size(I2)));
stitched0 = step(blender, I2, Iout0, mask);
%%
tform=dense(movingPoints,fixedPoints);
tform_1 = projective2d(tform);
Iout1=imwarp(I1,tform_1,'OutputView',imref2d(size(I2)));
blender1 = vision.AlphaBlender('Operation', 'Binary mask','MaskSource', 'Input port');  
mask1 = imwarp(true(size(I2,1),size(I2,2)), tform_1, 'OutputView', imref2d(size(I2)));
stitched1 = step(blender1, I2, Iout1, mask1);

%%
load('moveFixPoints.mat');
resimg=TPS(movingPoints,fixedPoints,I1,I2);
% Iout=imwarp(I1,tform,'OutputView',imref2d(size(I2)));
% figure;imshowpair(I2,resimg,'blend');


figure;
subplot(131),imshow(resimg);title("Thin Plate Spline Interpolation");
subplot(132),imshow(stitched1);title("dense correspondence");
subplot(133),imshow(stitched0);title("fitgeotrans");

%%
function resimg=TPS(movingPoints,fixedPoints,I1,I2)
    
    %let Final equation be AS=b
%    A=[varphi(r11) varphi(r12)...varphi(r1n);
%                   ................         ;
%       varphi(rn1) varphi(rn2)...varphi(rnn);
%       x1          ................       xn;
%       y1          ................       yn;
%       1           ................        1;]
%    S=[w11 w21;
%       w12 w22;
%        .   . ;
%        .   . ;
%       w1n w2n;
%       a11 a21;
%       a12 a22;
%       b1  b2 ;]

    [length tmp]=size(movingPoints);
    r=pdist(movingPoints);
    r=squareform(r);
    r(r==0)=1;
    r=r.*r;
    r=r.*log(r);
%     r(1,1:5)\
    %AS=D
    A=[ones([length,1]) movingPoints             r;
       zeros([1,1])  zeros([1,2]) ones([1,length]);
       zeros([2,1])  zeros([2,2])   movingPoints'];
    size(A);
    A(1,1:5);
    
    x_fix = fixedPoints(:,1);
    x_fix=[x_fix;zeros([3,1])];
    y_fix = fixedPoints(:,2);
    y_fix=[y_fix;zeros([3,1])];
    
    x_sol=A\x_fix;
    y_sol=A\y_fix;
    
%     I1=imresize(I1,0.2);
%     I2=imresize(I2,0.2);
    [M,N,L]=size(I2);
    I3=zeros([M,N,L]);
    Distance=ones([M,N]);
%     figure;imshow(I3);
    for i = 1:M
        for j = 1:N
            x_move=0;
            y_move=0;
            for k =1:length
                x_axis=(i-movingPoints(k,1))^2;
                y_axis=(j-movingPoints(k,2))^2;
                ri=sqrt(x_axis+y_axis);
                
                if ri~=0
                    varphi=ri.*ri.*log(ri);
                else
                    varphi=0;
                end
            
                x_move=x_move+varphi.*x_sol(k+3);
                y_move=y_move+varphi.*y_sol(k+3);
            end
            x_move=x_move+x_sol(2)*i+x_sol(3)*j+x_sol(1);
            y_move=y_move+y_sol(2)*i+y_sol(3)*j+y_sol(1);
%             if x_move>=1 && y_move>=1 && x_move<M && y_move<N-1
%                 I2(floor(x_move),floor(y_move),:)=I1(i,j,:);
%             end
            xpos=floor(x_move);
            ypos=floor(y_move);
            for x=xpos:xpos+1
                for y=ypos:ypos+1
                    if x>=1 && y>=1 && x<M-200 && y<N && i>200
                        dist=(x_move-x)^2 + (y_move-y)^2;
                        if Distance(x,y)>dist
                            Distance(x,y)=dist;
                            I2(x+200,y,:)=I1(i-200,j,:);
%                             I3(x,y,:)=I1(i,j,:);
%                             if x<M-160 && i>160
                            I3(x+200,y,:)=I1(i-200,j,:);
%                             end
                        end
                    end
                end
            end
        end
    end
%     resimg=I2;
    %SHOW COMPARE
%     figure;imshow(I2);
    I2_origin = imread('2.jpg');
    I3=uint8(I3);
    figure;imshowpair(I2_origin,I3,'montage');
%     figure;imshow(uint8(I3));
%     Move=[1 0 0;0 1 0;-100 15 1];
%     tform = affine2d(Move);
%     I3 = imwarp(I3,tform);
    
%     figure;imshow(I3);
    resimg=I2;
%     figure;imshow(I1);
    
    
  
end


%%
function tform=dense(movingPoints,fixedPoints)
    [M,N] = size(movingPoints);
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
