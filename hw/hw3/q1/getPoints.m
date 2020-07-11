bg=imread('./img/bg.jpg');
gpart=imread('./img/gpart.jpg');
rpart=imread('./img/rpart.jpg');
wpart=imread('./img/wpart.jpg');
ypart=imread('./img/ypart.jpg');

%CREAT POINT PAIRS FOR PYTHON
bg_mask=zeros(size(bg));
cnt=1;
% points(cnt)
for i=1:384
    for j=1:512
        if ~(bg(i,j,1)==255 && bg(i,j,2)==255 && bg(i,j,3)==255)
            bg_points(cnt,:)=[i,j];
            bg_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end


gpart_mask=zeros(size(gpart));
cnt=1;
% points(cnt)
for i=1:384
    for j=1:512
        if ~(gpart(i,j,1)==255 && gpart(i,j,2)==255 && gpart(i,j,3)==255)
            gpart_points(cnt,:)=[i,j];
            gpart_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

rpart_mask=zeros(size(rpart));
cnt=1;
% points(cnt)
for i=1:384
    for j=1:512
        if ~(rpart(i,j,1)==255 && rpart(i,j,2)==255 && rpart(i,j,3)==255)
            rpart_points(cnt,:)=[i,j];
            rpart_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

wpart_mask=zeros(size(wpart));
cnt=1;
% points(cnt)
for i=1:384
    for j=1:512
        if ~(wpart(i,j,1)==255 && wpart(i,j,2)==255 && wpart(i,j,3)==255)
            wpart_points(cnt,:)=[i,j];
            wpart_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

ypart_mask=zeros(size(ypart));
cnt=1;
% points(cnt)
for i=1:384
    for j=1:512
        if ~(ypart(i,j,1)==255 && ypart(i,j,2)==255 && ypart(i,j,3)==255)
            ypart_points(cnt,:)=[i,j];
            ypart_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end