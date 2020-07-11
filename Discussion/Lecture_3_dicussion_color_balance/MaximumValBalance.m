% Test AWB
clear; clc;
close all;
I = imread('BW1.png');
p=29;%BW2
p=32;%BW1

[iR, iG, iB] = EstimateIlluminantRGB(I, p);
if iR==0
%     iR=iG/1.5+iB/2;%BW1
    iR=iG/2+iB/2;%BW2&3
end
iEstm = [iR, iG, iB];
iEstm
% iEstm = EstimateIlluminantRGB(I, p); 
K = ComputeGainFactorMatrix(iEstm);

O=uint8(zeros([size(I,1),size(I,2)]));
[M,N,L] = size(I);
p=7;
for i = 1:M
    for j = 1:N
        Fxy=double([I(i,j,1), I(i,j,2), I(i,j,3)]');
%         K
        FWB=K*Fxy;
        for p=1:3
            O(i,j,p) = uint8(FWB(p));
        end
    end
end
    
subplot(1,2,1), imshow(I);
%     subplot(1,3,2), imshow(J);
subplot(1,2,2), imshow(O);
% % imwrite(O, strcat('BW3_', num2str(p(i)), '.png'))
% % figure,imshow(double(O),[]);
saveas(gcf,'/Users/mac/Desktop/my/DIP/Discussion/Lecture_3_dicussion_color_balance/BW1MVBalance.jpg');


function [Rc, Gc, Bc] = EstimateIlluminantRGB(I, p)

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    % Estimate Illuminant
    Rc = EstimateIlluminantGrey(R, p);
    Gc = EstimateIlluminantGrey(G, p);
    Bc = EstimateIlluminantGrey(B, p);
    Rc
end

function Ic = EstimateIlluminantGrey(I, p)
    Ic = 0;
    
    L = 256;
    sz = size(I);

    pxlTh = (p*sz(1)*sz(2))/100;    
    histI = imhist(I);

    Imin = min(min(I));
    Imax = max(max(I));

    % Run the loop from 0 to L-2 or Imin to Imax-1
    for k=Imin:(Imax-1)
    
        % Total number of pixels from k to L-1
        j = double(k+1); % Since MATLAB follows 1 indexing 
        cnt1 = sum(histI(j:L));

        % Total number of pixels from k+1 to L-1
        j = j+1; % from the next grey value 
        cnt2 = sum(histI(j:L));

        if( (cnt1 > pxlTh) && (cnt2 < pxlTh) )
            Ic = k;
             break;
        end
    end    
end

function [K] = ComputeGainFactorMatrix(iEstm)

    % k(r,g,b) = ig / i(r,g,b)
    iEstm = double(iEstm);

    iEstm_R = iEstm(1);
    iEstm_G = iEstm(2);
    iEstm_B = iEstm(3);

    iRef_R = iEstm_G; 
    iRef_G = iEstm_G; 
    iRef_B = iEstm_G;

    Kr = iRef_R / iEstm_R; 
    Kg = iRef_G / iEstm_G;
    Kb = iRef_B / iEstm_B;

    K = [Kr, 0, 0;
          0, Kg, 0;
          0, 0, Kb];

end