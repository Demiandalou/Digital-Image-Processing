im = imread('barbara.tif');
imagesc(im)
[a2,h2,v2,d2] = haart2(im,2);
imagesc(a2);

[psi,xval] = wavefun('haar',10);
figure;
plot(xval,psi);
title('Real-valued Haar Wavelet');

%Morlet
[psi,xval] = wavefun('morl',10);
figure;
plot(xval,psi);
title('Real-valued Morlet Wavelet');

%Mexican hat
lb = -5;
ub = 5;
N = 1000;
[psi,xval] = mexihat(lb,ub,N);
figure;
plot(xval,psi)
title('Mexican Hat Wavelet')

%Meyer
% wav='coif2';
% [phi,psi,xval] = wavefun(wav); 
% plot(xval,psi);
% title(['meyer ',wav]); 
