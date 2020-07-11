load('LOGO_CS270.mat');
load('Wuyuan.mat');

% watermark
alpha=0.1;
dct_I=dct2(im2double(Wuyuan));
sorted=sortrows(abs(dct_I(:)));
[imM,imN]=size(Wuyuan);
[wtM,wtN]=size(LOGO_CS270);
k=wtM*wtN;
sorted=sorted(imM*imN-k+1:imM*imN);
wt_flat=im2double(LOGO_CS270(:));
loc_info=zeros(wtM*wtN,2);
dct_I_modi=dct_I;
for i=1:wtM*wtN
    [row,col]=find(abs(dct_I)==sorted(i));
    loc_info(i,:)=[row col];
    c_prime=dct_I(row,col)*(1+alpha*wt_flat(i));
    dct_I_modi(row,col)=c_prime;
end
idct_I=idct2(dct_I_modi);  % watermarked img
figure;imshowpair(Wuyuan,idct_I,'montage');

Shangroao=idct_I;

%RECONS WT
dct_I2=dct2(idct_I);
recons_w=zeros(wtM*wtN,1);
for i=1:wtM*wtN
    c_prime=dct_I2(loc_info(i,1),loc_info(i,2));
    c=dct_I(loc_info(i,1),loc_info(i,2));
    w_prime=uint8((c_prime/c-1)*10);
    recons_w(i)=w_prime;
end
recons_w=imbinarize(recons_w);
recons_wt0=reshape(recons_w,wtM,wtN);
figure;imshow(recons_wt0);

% % NOISE
% Guassian noise : mean = 0, var = 0.0002
Addnoise = idct_I + 0.003*randn(size(idct_I)) + 0;
SRnoise=Addnoise;
% figure;imshow(Addnoise);
dct_I2=dct2(Addnoise);
recons_w=zeros(wtM*wtN,1);
for i=1:wtM*wtN
    c_prime=dct_I2(loc_info(i,1),loc_info(i,2));
    c=dct_I(loc_info(i,1),loc_info(i,2));
    w_prime=uint8((c_prime/c-1)*10);
    recons_w(i)=w_prime;
end
recons_w=imbinarize(recons_w);
recons_wt1=reshape(recons_w,wtM,wtN);
figure;imshow(recons_wt1);
