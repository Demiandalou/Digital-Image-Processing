clear all;
close all;
clc;
 
r=127;                              
x=-r:r+1;
sigma=20;
y1=exp(-((x-80).^2)/(2*sigma^2));
y2=exp(-((x+80).^2)/(2*sigma^2));
y=y1+y2;                        %双峰高斯函数，任意函数都可以
 
%im=imread('bg.bmp');  %匹配一个图像的直方图
%y=imhist(im);
y=y/sum(y);         %归一化，使函数符合概率分布的sum(y)==1这样一个规律
plot(y) ;xlabel('a) 待匹配的直方图');           %待匹配的直方图
 
G=[];               %函数的累积直方图
for i=1:256
   G=[G sum(y(1:i))]; 
end
 
img=imread('C:\Users\Administrator\Desktop\数字图像处理\Lecture_4_discussion\histogram_matching\3.jpg');
[m n]=size(img);
hist=imhist(img);       %待处理图像的直方图
p=hist/(m*n);           
figure;plot(p);xlabel('b) 原图直方图');          %原图直方图
 
s=[];                   %待处理图像的累积直方图
for i=1:256
    s=[s sum(p(1:i))];
end
 
for i=1:256
    tmp{i}=G-s(i);
    tmp{i}=abs(tmp{i});         %因为要找距离最近的点，所以取绝对值
    [a index(i)]=min(tmp{i});   %找到两个累积直方图距离最近的点
end
 
imgn=zeros(m,n);
for i=1:m
   for j=1:n
      imgn(i,j)=index(img(i,j)+1)-1;    %由原图的灰度通过索引映射到新的灰度
   end
end
 
imgn=uint8(imgn);
figure;imshow(imgn); 
figure;plot(imhist(imgn)); xlabel('c) 新图的直方图');      %新图的直方图