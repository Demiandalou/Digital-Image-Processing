bg=imread('bg2.jpg');
fg=imread('fg2.jpg');

%CREAT POINT PAIRS FOR PYTHON
fg_mask=zeros(size(fg));
cnt=1;
% points(cnt)
for i=1:667 % 840 for grass land
    for j=1:1000 % 630 for grassland
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
for i=1:667
    for j=1:1000
        if ~(bg(i,j,1)==255 && bg(i,j,2)==255 && bg(i,j,3)==255)
            bg_points(cnt,:)=[i,j];
            bg_mask(i,j,:)=[255,255,255];
            cnt=cnt+1;
        end
    end
end
