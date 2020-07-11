% implement the method pyramid::reduce() to allow construction of an image's Gaussian pyramid
% implement the function pyramid::expand() in preparation for the construction of an image's Laplacian pyramid
% implement the function pyramid::blend()

load('DTtigermask.mat')
DT=imread('DT.jpg');
[M,N,P]=size(DT);

DT=double(DT);
tiger=double(tiger);

level=7;
% construct Gaussian Pyramid of image pair and mask
GaussDT=GaussPyra(DT,level);
Gausstiger=GaussPyra(tiger,level);
GaussMask=GaussPyra(mask,level);
% GaussDT(1,1,1)
% recover
lappDT=LapPyra(GaussDT,level);
lapptiger=LapPyra(Gausstiger,level);
% lappDT(1,1,1)
% pyramid blend
blended=Pyrablend(lappDT,lapptiger,GaussMask,level);
for i=level:-1:1
    tmp=Pyraexpand(blended{i+1});
    [M,N,P]=size(blended{i});
    tmp=tmp(1:M, 1:N, :);
    blended{1,i}=blended{1,i}+tmp;
end
final=uint8(blended{1,1});
% figure;imshow(final);

%HARD-blending
DT=uint8(DT);
hardb=uint8(tiger);
for i=1:M
    for j=1:N
        if mask(i,j)==1
            hardb(i,j,:)=DT(i,j,:);
        end
    end
end
% figure;imshow(hardb);
figure;imshowpair(final,hardb,'montage');


% construct Gaussian Pyramid
function res=GaussPyra(obj,level)
    res=cell(1,level+1);
    res{1}=obj;
%     h=fspecial('gaussian',10,10);
    for i=2:level+1
%         tmp=imfilter(res{1,i-1},h,'symmetric','corr');
%         res{1,i}=tmp;
        tmp=Pyrareduce(res{i-1});        
        res{i}=tmp;
    end
end

% construct Laplacian Pyramid
% each node of L can be obtained directly by convolving W_l - W_(l+1) with the image
function lapp=LapPyra(gaussp,level)
    lapp=cell(1,level+1);
    lapp{level+1}=gaussp{level+1};
    for i=1:level
        reverse=Pyraexpand(gaussp{i+1});
        [M,N,P]=size(gaussp{i});
        lapp{i}=gaussp{i} - reverse(1:M,1:N,:);
    end 
end



function reduced=Pyrareduce(picell)
%     if a = 0.4, the functions resemble the Gaussian probability density function.
% a may be considered a free variable, while b = 1/4 and c = 1/4 ? a/2.
    a=0.4;
    b=1/4;
    c=1/4-a/2;
    w_hat = [c, b, a, b, c];
    kernel=w_hat'*w_hat;
    picell=imfilter(picell,kernel,'conv');
    [M,N,P]=size(picell);
    reduced = picell(1:2:M,1:2:N,:);
end

% Interpolation can be achieved by reversing the REDUCE process. i.e. an EXPAND operation.
function expanded=Pyraexpand(reduced)
    [M,N,P]=size(reduced);
    expanded = zeros([2*M,2*N,P]);
    expanded(1:2:2*M,1:2:2*N,:) = reduced;
    %kernel
    a=0.4;
    b=1/4;
    c=1/4-a/2;
    w_hat = [c, b, a, b, c];
    kernel=w_hat'*w_hat;
    expanded = 4*imfilter(expanded, kernel, 'conv');
end

function blended=Pyrablend(lappa,lappb,gauspm,level)
    blended=cell(1,level+1);
    for i=1:level+1
        blended{1,i}=(1-gauspm{1,i}).*lappb{1,i}+gauspm{1,i}.*lappa{1,i};
    end
end

