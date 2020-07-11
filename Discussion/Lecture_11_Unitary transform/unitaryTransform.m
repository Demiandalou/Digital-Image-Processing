I=imread('barbara.tif');
% [M N]=size(I);
doubleI=double(I);
Img=imresize(doubleI,0.5);

[M N]=size(Img);

%% DFT
% Output=zeros(M,N);
% SumOutner = 0;
% %%Centralized 2D Discrete Fourier Transform
% [nx,ny]=ndgrid([0:M-1]-(M-1)/2,[0:N-1]-(N-1)/2);
% du=1;
% for u = [0:M-1]-(M-1)/2
%     dv=1;
%     for v = [0:N-1]-(N-1)/2  
%         SumOutner=sum(sum(Img.*exp(-1i*2*3.1416*(u*nx/M+v*ny/N))));
%         Output(du,dv) = SumOutner;
%         dv=dv+1;
%     end
%     du=du+1;
% end
% %%Calculate Spectrum and show
% figure;imshow(uint8(abs(Output)/60));

%% DCT
% Output=zeros(M,N);
% SumOutner = 0;
% %%Centralized 2D Discrete Fourier Transform
% [nx,ny]=ndgrid([0:M-1]-(M-1)/2,[0:N-1]-(N-1)/2);
% du=1;
% for u = [0:M-1]-(M-1)/2
%     dv=1;
%     for v = [0:N-1]-(N-1)/2  
% %         SumOutner=sum(sum(Img.*exp(-1i*2*3.1416*(u*nx/M+v*ny/N))));
%         tmp=cosd(u*3.1416*(2*nx+1)/2/N).*cosd(v*3.1416*(2*ny+1)/2/N);
%         SumOutner=2/N*sum(sum(Img.*tmp));
%         Output(du,dv) = SumOutner;
%         dv=dv+1;
%     end
%     du=du+1;
% end
% %%Calculate Spectrum and show
% figure;imshow(uint8(abs(Output)/60));


%% Hadamard
neww = Img;
N = 256;
H = hadamard(N);
y = fwht(neww,N,'sequency'); 
imshow(y);




