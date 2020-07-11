function out = colorthresh(im,t)

close all
figure(1)
imshow(im)

im = double(im);

g = round(ginput(1));
c = reshape([im(g(2),g(1),:)],[3,1]);
disp(['Color = ',num2str([im(g(2),g(1),:)])]);

[m,n,p] = size(im);
q = zeros(m,n);
c = c/sum(c);

for i = 1:m, for j = 1:n
        r = reshape([im(i,j,:)],[3,1]);
        r = r/sum(r);
        q(i,j) = norm(r-c);
    end,end


q = q/max(q(:));
size(q)

figure(2)
imshow(q,[])

if nargin <2
    t = otsu(q);
    disp(['Otsu threshold = ', num2str(round(255*t))]);
else
    t = t/255;
end

figure(3)
imhist(q);
hold on;
plot([t,t],[0,10000],'r','linewidth',2);

figure(4)
imshow(q < t)

out = q<t;
        