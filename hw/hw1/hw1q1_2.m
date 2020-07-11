I=imread('Tam_clear.jpg');
%add white
maxI=double(max(I(:)));
I2=double(I)+100;
I2=uint8(I2*maxI/(maxI+100));
% figure;imshow(I2);

% intensity transform
I2=im2double(I2);
m=mean2(I2);
I2=m./sqrt(sqrt(1/I2-1));
% figure;imshow(I2);

% res=1.2./(1+(m./(I3+eps)).^1);

%color saturation
hsved=rgb2hsv(I2);
hsved(:,:,2)=hsved(:,:,2)*0.9;
I2=hsv2rgb(hsved);

%median filter
r=I2(:,:,1);
g=I2(:,:,2); 
b=I2(:,:,3); 
r=medfilt2(r,[3 3]);
g=medfilt2(g,[3 3]);
b=medfilt2(b,[3 3]);
res=cat(3,r,g,b); 
% figure;imshow(I3);
figure;imshowpair(I,res,'montage');
figure;imhist(I);
figure;imhist(res);