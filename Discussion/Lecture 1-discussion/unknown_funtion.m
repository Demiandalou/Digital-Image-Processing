I = imread('vallay-house2.jpeg');
[M,N,L] = size(I);

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

J(1:2:M,1:2:N) = R(1:2:M,1:2:N);
J(2:2:M,2:2:N) = B(2:2:M,2:2:N);
J(J==0) = G(J==0); 

J_G = uint8(zeros([size(I,1),size(I,2)]));
J_R = uint8(zeros([size(I,1),size(I,2)]));
J_B = uint8(zeros([size(I,1),size(I,2)]));
J_R(1:2:M,1:2:N) = R(1:2:M,1:2:N);
J_B(2:2:M,2:2:N) = B(2:2:M,2:2:N);
J_G(2:2:M,1:2:N) = J(2:2:M,1:2:N);
J_G(1:2:M,2:2:N) = J(1:2:M,2:2:N);
J_com = cat(3,J_R,J_G,J_B);
T = zeros(M,N,3);
%black/grey.white
% figure,imshow(uint8(J),[]);
%RGB
figure,imshow(uint8(J_com));
%black/white
% figure,imshow(uint8(J_R));

%% 
for i = 2:M-1
    for j = 2:N-1
        if mod(i,2) == 0 && mod(j,2) == 1 %G
            T(i,j,1)=round((J(i-1,j)+J(i+1,j))/2);
            T(i,j,2)=round(J(i,j));
            T(i,j,3)=round((J(i,j-1)+J(i,j+1))/2);
        elseif mod(i,2) == 1 && mod(j,2) == 0
            T(i,j,1)=round((J(i,j-1)+J(i,j+1))/2);
            T(i,j,2)=round(J(i,j));
            T(i,j,3)=round((J(i-1,j)+J(i+1,j))/2);
        elseif mod(i,2) == 1 %R
            T(i,j,1)=round(J(i,j));
            T(i,j,2)=round((J(i-1,j)+J(i+1,j)+J(i,j-1)+J(i,j+1))/4);
            T(i,j,3)=round((J(i-1,j-1)+J(i+1,j-1)+J(i+1,j-1)+J(i-1,j+1))/4);
        else %B
            T(i,j,1)=round((J(i-1,j-1)+J(i+1,j-1)+J(i+1,j-1)+J(i-1,j+1))/4);
            T(i,j,2)=round((J(i-1,j)+J(i+1,j)+J(i,j-1)+J(i,j+1))/4);
            T(i,j,3)=round(J(i,j));
        end
    end
end
figure,imshow(uint8(T),[]);
