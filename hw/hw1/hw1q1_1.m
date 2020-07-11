I=double(imread('Ex_ColorEnhance.png'));

%obtain atmospheric light
for i=1:3
    filted=medfilt2(I(:,:,i),[15,15]);
    AL(i)=max(filted(:));
end

%get dark channel
l_bound=2*(zeros(3,1)+1);
h_bound=20*(zeros(3,1)+1);
r_channel=max((AL(1)-I(:,:,1))/(AL(1)-l_bound(1)),(I(:,:,1)-AL(1))/(h_bound(1)-AL(1)));
g_channel=max((AL(2)-I(:,:,2))/(AL(2)-l_bound(2)),(I(:,:,2)-AL(2))/(h_bound(2)-AL(2)));
b_channel=max((AL(3)-I(:,:,3))/(AL(3)-l_bound(3)),(I(:,:,3)-AL(3))/(h_bound(3)-AL(3)));
addbound=cat(3,r_channel,g_channel,b_channel);
t=min(max(addbound,[],3),20);
% figure,imshow(addbound,[])

%get transmission
filter=1/11*[5,5,5;-3,0,-3;-3,-3,-3];
filter_wt=1/11*[-3,-3,-3;-3,0,-3;5,5,5];
J=I/255;
r_channel=imfilter(J(:,:,1),filter,'symmetric').^2;
g_channel=imfilter(J(:,:,2),filter,'symmetric').^2;
b_channel=imfilter(J(:,:,3),filter,'symmetric').^2;
weight=exp(-r_channel-g_channel-b_channel);
fourier2=fft(fft(t).').';
otf=abs(psf2otf(filter,size(t))).^2;
exp_param=1;
for cnt=1:10
    exp_param=exp_param*2;
    dt=imfilter(t,filter,'symmetric');
    wt=max(abs(dt)-weight/exp_param/1,0).*sign(dt);
    pad_handled=imfilter(wt,filter_wt,'circular');
    f_trans=fft(fft(pad_handled).').';
    a=2/exp_param;
    t=abs(ifft(ifft((a*fourier2+f_trans)./(a+otf)).').');
end

%find radiance
t=max(abs(t),0.0002).^0.85;
r_channel=(I(:,:,1)-AL(1))./t+AL(1);
g_channel=(I(:,:,2)-AL(2))./t+AL(2)-10;
b_channel=(I(:,:,3)-AL(3))./t+AL(3);
res=cat(3,r_channel,g_channel,b_channel)./255;
figure;imshow(res);

%intensity transform
J=im2double(res);
m=mean2(J);
res=1./(1+(m./(J+eps)).^2);
% figure;imhist(res);

%color saturation
hsved=rgb2hsv(res);
hsved(:,:,2)=hsved(:,:,2)*1.2;
hsved(hsved>0.9)=1;
res=hsv2rgb(hsved);
% figure;
% imshow(res);

% figure,imshow(res,[]),title('outputimg');
origin=imread('Ex_ColorEnhance.png');
figure;imshowpair(origin,res,'montage');


