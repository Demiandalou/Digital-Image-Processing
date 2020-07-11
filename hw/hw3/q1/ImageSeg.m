I = im2double(imread('pepper.png'));
% 
% foreground-backgroung
[fbmask,fbimg]=foreback(I);
figure;imshowpair(fbmask,fbimg,'montage');
% foreground-backgroung-simple(lesser effect)
% [mask,partimg] = segment(I,0.12,353,370);
%Green
[gmask,gimg]=Green(I);
figure;imshowpair(gmask,gimg,'montage');

%White
Remain=fbimg-gimg;
[wmask,wimg] =White(Remain);
figure;imshowpair(wmask,wimg,'montage');

%Red
Remain=Remain-wimg;
[rmask,rimg] = Red(Remain);
figure;imshowpair(rmask,rimg,'montage');

function [mask,img]=segment(I,thr,m,n)
    [M,N,P]=size(I);
    mask = zeros([M,N]);
    img= zeros(size(I));
    avg = I(m,n);
%     avg = I(m,n,:);
    region = 1;
    seg_region = zeros(5000,5); 
    idx=0;
    pixdist=0;
    while pixdist<thr
        for direction=1:4
            if direction==1
                mpos=m-1;npos=n;
            elseif direction==2
                mpos=m+1;npos=n;
            elseif direction==3
                mpos=m;npos=n-1;
            else
                mpos=m;npos=n+1;
            end
            % pixel validate?
            if mpos>=1 && mpos<=M && npos>=1 && npos<=N && mask(mpos,npos)==0
                idx=idx+1;
                mask(mpos,npos)=1;
                seg_region(idx,1)=mpos;
                seg_region(idx,2)=npos;
                
                seg_region(idx,3)=I(mpos,npos);
%                 seg_region(idx,3:5)=I(mpos,npos,:);
            end
        end
        dist = abs(seg_region(1:idx,3)-avg);
%         dist=zeros([idx,1]);
%         for i=1:idx
%             dist(i)=cal_mse(avg,seg_region(i,3:5));
%         end
        [pixdist, num] = min(dist);
        mask(m,n)=1; 
        img(m,n,:)=I(m,n,:);
        region=region+1;
        avg= (avg*region + seg_region(num,3))/(region+1);
        m = seg_region(num,1);
        n = seg_region(num,2);
        seg_region(num,:)=seg_region(idx,:); 
        idx=idx-1;
    end
    se = strel('disk',4);
    mask = imclose(mask,se);
end

function [mask,img]=foreback(I)
    [mask1,partimg] = segment(I,0.05,29,246);
%     [mask2,partimg] = segment(I,0.10,310,331);
    [mask2,partimg] = segment(I,0.112,310,246);
    [mask3,partimg] = segment(I,0.10,371,36);
    [mask4,partimg] = segment(I,0.10,356,82);
    [mask5,partimg] = segment(I,0.05,375,243);
    [mask6,partimg] = segment(I,0.03,374,508);
    mask=logical(mask1+mask2+mask3+mask4+mask5+mask6);
    mask = ~ mask;
    se = strel('disk',5);
    mask = imopen(mask,se);
    img=zeros(size(I));
    [M,N,P]=size(I);
    for i=1:M
        for j=1:N
            if mask(i,j)==1
                img(i,j,:)=I(i,j,:);
            end
        end
    end             
end

function [mask,img]=Green(I)
    [mask1,img]=segment(I,0.1,141,104);
    [mask2,img]=segment(I,0.13,88,370);
    [mask3,img]=segment(I,0.05,119,136);
    [mask4,img]=segment(I,0.05,112,148);
    [mask5,img]=segment(I,0.12,124,292);
    [mask6,img]=segment(I,0.1,157,315);
    [mask7,img]=segment(I,0.07,134,322);
    [mask8,img]=segment(I,0.06,288,292);
    [mask9,img]=segment(I,0.05,263,280);
    [mask10,img]=segment(I,0.1,110,457);
    [mask11,img]=segment(I,0.08,207,121);
    [mask12,img]=segment(I,0.1,155,237);
    [mask13,img]=segment(I,0.1,296,116);
    [mask14,img]=segment(I,0.1,278,148);
    [mask15,img]=segment(I,0.1,223,334);
    [mask16,img]=segment(I,0.09,209,173);
    [mask17,img]=segment(I,0.122,241,286);
    mask=logical(mask1+mask2+mask3+mask4+mask5+mask6...
      +mask7+mask8+mask9+mask10+mask11+mask12+mask13...
      +mask14+mask15+mask16+mask17);
    se = strel('disk',6);
    mask = imclose(mask,se);
    se = strel('cube',4);
    mask = imerode(mask,se);%remove some edges to make it more smooth

    img=zeros(size(I));
    [M,N,P]=size(I);
    for i=1:M
        for j=1:N
            if mask(i,j)==1
                img(i,j,:)=I(i,j,:);
            end
        end
    end   
end

function [mask,img]=White(I)
    [mask1,img] = segment(I,0.2,105,225);
    [mask2,img] = segment(I,0.2,303,497);
    mask=logical(mask1+mask2)
    img=zeros(size(I));
    [M,N,P]=size(I);
    for i=1:M
        for j=1:N
            if mask(i,j)==1
                img(i,j,:)=I(i,j,:);
            end
        end
    end   
end

function [mask,img]=Red(I)
    maskR=logical((I~=0));
    maskR=maskR(:,:,1);
    se = strel('disk',7);
    maskR = imopen(maskR,se);
    [mask1,img1] = segment(I,0.05,202,265);
    [mask2,img2] = segment(I,0.03,256,152);
    [mask3,img3] = segment(I,0.1,274,142);
    mask=logical(mask1+mask2+mask3);
    se = strel('disk',5);
    mask = imclose(mask,se);
    mask=logical(maskR-mask);
    se = strel('cube',11);
    mask = imerode(mask,se);

    img=zeros(size(I));
    [M,N,P]=size(I);
    for i=1:M
        for j=1:N
            if mask(i,j)==1
                img(i,j,:)=I(i,j,:);
            end
        end
    end  
end


function mse=cal_mse(avg,segmean)
    mse=0;
    for i=1:3
        mse=mse+(avg(i)-segmean(i))^2;
    end
end








