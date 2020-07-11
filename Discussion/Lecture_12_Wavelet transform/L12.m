clc;clear;
ORI=double(imread('1.jpg'));
% A1=Harr(512)*ORI*Harr(512)';
% figure(1),imshow(ORI,[]);
% LL=A1(1:256,1:256);
% HL=A1(1:256,257:512);
% LH=A1(257:512,1:256);
% HH=A1(257:512,257:512);
A=Harr(512);
LL=ORI(1:2:512,1:2:512);
HL0=A(257:512,:)*ORI;
HL=HL0(:,1:2:512);
LH0=ORI*A(257:512,:)';
LH=LH0(1:2:512,:);
HH=A(257:512,:)*ORI*A(257:512,:)';
figure(2),subplot(2,2,1),imshow(LL,[]);
figure(2),subplot(2,2,2),imshow(HL,[]);
figure(2),subplot(2,2,3),imshow(LH,[]);
figure(2),subplot(2,2,4),imshow(HH,[]);










% for i=2:512
%     x=2^(ceil(log2(i))-1);  %小波形式一致的行数
%     y=i-x; 
%     z=512/x;    %列数
%     for m = x+1:2*x
%         n=m-x;
%         for k=z*(n-1)+1:z*n
%             if k<=z*n-z/2
%                 H(m,k)=sqrt(x);
%             else
%                 H(m,k)=-sqrt(x);
%             end
%         end
%     end
% end
