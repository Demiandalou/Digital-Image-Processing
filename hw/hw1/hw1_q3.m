I = imread('Lenna.png');
[M,N,L]=size(I);
gray_I=rgb2gray(I);
% imshow(gray_I);
for i = 1:M
    for j = 1:N
        gray_I(i,j)=ceil(gray_I(i,j)/32);
    end
end
% figure;imshow(gray_I);
afterContrast0=zeros(size(gray_I));
afterContrast45=zeros(size(gray_I));
afterContrast90=zeros(size(gray_I));
afterContrast135=zeros(size(gray_I));

afterCorr0=zeros(size(gray_I));
afterCorr45=zeros(size(gray_I));
afterCorr90=zeros(size(gray_I));
afterCorr135=zeros(size(gray_I));

energy0=zeros(size(gray_I));
energy45=zeros(size(gray_I));
energy90=zeros(size(gray_I));
energy135=zeros(size(gray_I));

homo0=zeros(size(gray_I));
homo45=zeros(size(gray_I));
homo90=zeros(size(gray_I));
homo135=zeros(size(gray_I));

for i=1:M-6
    for j=1:N-6
        patch=gray_I(i:i+6,j:j+6);
        
        glcm0=vary_angle_glcm(patch,0);
        glcm45=vary_angle_glcm(patch,45);
        glcm90=vary_angle_glcm(patch,90);
        glcm135=vary_angle_glcm(patch,135);
        
        %CONTRAST
        afterContrast0(i+3,j+3)=cal_contrast(glcm0);
        afterContrast45(i+3,j+3)=cal_contrast(glcm45);
        afterContrast90(i+3,j+3)=cal_contrast(glcm90);
        afterContrast135(i+3,j+3)=cal_contrast(glcm135);

        %CORR
        afterCorr0(i+3,j+3)=cal_corr(glcm0);
        afterCorr45(i+3,j+3)=cal_corr(glcm45);
        afterCorr90(i+3,j+3)=cal_corr(glcm90);
        afterCorr135(i+3,j+3)=cal_corr(glcm135);

        %ENERGY
        energy0(i+3,j+3)=cal_energy(glcm0);
        energy45(i+3,j+3)=cal_energy(glcm45);
        energy90(i+3,j+3)=cal_energy(glcm90);
        energy135(i+3,j+3)=cal_energy(glcm135);

        %HOMO
        homo0(i+3,j+3)=cal_homo(glcm0);
        homo45(i+3,j+3)=cal_homo(glcm45);
        homo90(i+3,j+3)=cal_homo(glcm90);
        homo135(i+3,j+3)=cal_homo(glcm135);

    end
end
% figure;imshow(afterContrast0);
contrast_avg=(afterContrast0+afterContrast45+afterContrast90+afterContrast135)/4;
contrast_avg=handle_by_padarray(contrast_avg);
figure;imshow(contrast_avg);

% figure;imshow(afterCorr0);
corr_avg=(afterCorr0+afterCorr45+afterCorr90+afterCorr135)/4;
corr_avg=handle_by_padarray(corr_avg);
figure;imshow(corr_avg);

% figure;imshow(energy0);
energy_avg=(energy0+energy45+energy90+energy135)/4;
energy_avg=handle_by_padarray(energy_avg);
figure;imshow(energy_avg);

% figure;imshow(homo0);
homo_avg=(homo0+homo45+homo90+homo135)/4;
homo_avg=handle_by_padarray(homo_avg);
figure;imshow(homo_avg);

% figure;imshowpair(contrast_avg,corr_avg,'montage');
% figure;imshowpair(energy_avg,homo_avg,'montage');


function glcm = vary_angle_glcm(patch,angle)
    glcm=zeros(8,8);
    if angle==0
        for i=1:7
            for j=1:6
                glcm(patch(i,j),patch(i,j+1))=glcm(patch(i,j),patch(i,j+1))+1;
            end
        end
    elseif angle==45
        for i=2:7
            for j=1:6
                glcm(patch(i,j),patch(i-1,j+1))=glcm(patch(i,j),patch(i-1,j+1))+1;
            end
        end
    elseif angle==90
        for i=2:7
            for j=1:7
                glcm(patch(i,j),patch(i-1,j))=glcm(patch(i,j),patch(i-1,j))+1;
            end
        end
    elseif angle==135
        for i=2:7
            for j=2:7
                glcm(patch(i,j),patch(i-1,j-1))=glcm(patch(i,j),patch(i-1,j-1))+1;
            end
        end
    end
end

function contrast=cal_contrast(glcm)
    normglcm=glcm/sum(glcm(:));
    contrast=0;
    for i=1:8
        for j=1:8
            contrast=contrast+(i-j)^2*normglcm(i,j);
        end
    end
end

function corr=cal_corr(glcm)
    normglcm=glcm/sum(glcm(:));
    mu_i=0;
    mu_j=0;
    sigma_i=0;
    sigma_j=0;
    %cal mu_i,mu_j
    for i=1:8
        for j=1:8
            mu_i=mu_i+i*normglcm(i,j);
            mu_j=mu_j+j*normglcm(i,j);
            
        end
    end
    %cal sigmas
    for i=1:8
        for j=1:8
            sigma_i=sigma_i+normglcm(i,j)*((i-mu_i)^2);
            sigma_j=sigma_j+normglcm(i,j)*((j-mu_j)^2);
        end
    end
    %cal corr
    corr=0;
    for i=1:8
        for j=1:8
            corr=corr+normglcm(i,j)*(i-mu_i)*(j-mu_j)/(sqrt(sigma_i)*sqrt(sigma_j));
        end
    end
    corr=min(1,corr);
end

function energy=cal_energy(glcm)
    normglcm=glcm/sum(glcm(:));
    energy=0;
    for i=1:8
        for j=1:8
            energy=energy+(normglcm(i,j))^2;
        end
    end
end

function homo=cal_homo(glcm)
    normglcm=glcm/sum(glcm(:));
    homo=0;
    for i=1:8
        for j=1:8
            homo=homo+normglcm(i,j)/(1+abs(i-j));
        end
    end
end


function res_img = handle_by_padarray(avg_img)
    avg_img(510:512,:)=[];
    avg_img(1:3,:)=[];
    avg_img(:,510:512)=[];
    avg_img(:,1:3)=[];
    res_img=padarray(avg_img,[6 6],'replicate','pre');
end

