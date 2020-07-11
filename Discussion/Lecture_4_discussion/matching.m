clear all;
close all;
clc;
 
r=127;                              
x=-r:r+1;
sigma=20;
y1=exp(-((x-80).^2)/(2*sigma^2));
y2=exp(-((x+80).^2)/(2*sigma^2));
y=y1+y2;                        %˫���˹���������⺯��������
 
%im=imread('bg.bmp');  %ƥ��һ��ͼ���ֱ��ͼ
%y=imhist(im);
y=y/sum(y);         %��һ����ʹ�������ϸ��ʷֲ���sum(y)==1����һ������
plot(y) ;xlabel('a) ��ƥ���ֱ��ͼ');           %��ƥ���ֱ��ͼ
 
G=[];               %�������ۻ�ֱ��ͼ
for i=1:256
   G=[G sum(y(1:i))]; 
end
 
img=imread('C:\Users\Administrator\Desktop\����ͼ����\Lecture_4_discussion\histogram_matching\3.jpg');
[m n]=size(img);
hist=imhist(img);       %������ͼ���ֱ��ͼ
p=hist/(m*n);           
figure;plot(p);xlabel('b) ԭͼֱ��ͼ');          %ԭͼֱ��ͼ
 
s=[];                   %������ͼ����ۻ�ֱ��ͼ
for i=1:256
    s=[s sum(p(1:i))];
end
 
for i=1:256
    tmp{i}=G-s(i);
    tmp{i}=abs(tmp{i});         %��ΪҪ�Ҿ�������ĵ㣬����ȡ����ֵ
    [a index(i)]=min(tmp{i});   %�ҵ������ۻ�ֱ��ͼ��������ĵ�
end
 
imgn=zeros(m,n);
for i=1:m
   for j=1:n
      imgn(i,j)=index(img(i,j)+1)-1;    %��ԭͼ�ĻҶ�ͨ������ӳ�䵽�µĻҶ�
   end
end
 
imgn=uint8(imgn);
figure;imshow(imgn); 
figure;plot(imhist(imgn)); xlabel('c) ��ͼ��ֱ��ͼ');      %��ͼ��ֱ��ͼ