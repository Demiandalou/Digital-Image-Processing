d=10;
order=2;
im=imread('cameraman.tif');
% im=rgb2gray(imread('Ex_colorEnhance.png'));
clahe_im=adapthisteq(im,'clipLimit',0.02,'Distribution','rayleigh');
% figure;imshowpair(im,clahe_im,'montage');

im=double(im);
figure;
subplot(131)
imshow(im./255)
subplot(132)
imshow(clahe_im)
[M, N]=size(im);
homo_im=homo_filter(im,d,M,N,order);
subplot(133)
imshow(homo_im,[])

function im_e=homo_filter(im,d,r,c,n)
%Butterworth high pass filter
A=zeros(r,c);
for i=1:r
    for j=1:c
        A(i,j)=(((i-r/2).^2+(j-c/2).^2)).^(.5);
        H(i,j)=1/(1+((d/A(i,j))^(2*n)));
    end
end
alphaL=.0999;
aplhaH=1.01;
H=((aplhaH-alphaL).*H)+alphaL;
H=1-H;
%log
im_l=log2(1+im);
%DFT
im_f=fft2(im_l);
im_nf=H.*im_f;
%IDFT
im_n=abs(ifft2(im_nf));
%Inverse log 
im_e=exp(im_n);
end