load('lineparts.mat');
% bgv2=imread('bgv2.jpg');

%CREAT POINT PAIRS FOR PYTHON
fg_mask=zeros(size(fg));
cnt=1;
% points(cnt)
for i=1:474
    for j=1:474
        if ~(fg(i,j,1)==255 && fg(i,j,2)==255 && fg(i,j,3)==255)
            fg_points(cnt,:)=[i,j];
            fg_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

bg_mask=zeros(size(bg));
cnt=1;
% points(cnt)
for i=1:474
    for j=1:474
        if ~(bg(i,j,1)==255 && bg(i,j,2)==255 && bg(i,j,3)==255)
            bg_points(cnt,:)=[i,j];
            bg_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end


jeans_mask=zeros(size(jeans));
cnt=1;
% points(cnt)
for i=1:474
    for j=1:474
        if ~(jeans(i,j,1)==255 && jeans(i,j,2)==255 && jeans(i,j,3)==255)
            jeans_points(cnt,:)=[i,j];
            jeans_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

shirt_mask=zeros(size(shirt));
cnt=1;
% points(cnt)
for i=1:474
    for j=1:474
        if ~(shirt(i,j,1)==255 && shirt(i,j,2)==255 && shirt(i,j,3)==255)
            shirt_points(cnt,:)=[i,j];
            shirt_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

person_mask=zeros(size(person));
cnt=1;
% points(cnt)
for i=1:474
    for j=1:474
        if ~(person(i,j,1)==255 && person(i,j,2)==255 && person(i,j,3)==255) && (j<191 || i<216)
            person_points(cnt,:)=[i,j];
            person_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end

bgv2_mask=zeros(size(bgv2));
cnt=1;
% points(cnt)
for i=1:474
    for j=1:474
        if ~(bgv2(i,j,1)==255 && bgv2(i,j,2)==255 && bgv2(i,j,3)==255)
            bgv2_points(cnt,:)=[i,j];
            bgv2_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end