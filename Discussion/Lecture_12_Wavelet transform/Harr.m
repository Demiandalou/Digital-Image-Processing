function H = Harr(size)
H(1,1:size)=1;
for i=2:size
    x=2^(ceil(log2(i))-1);  %С����ʽһ�µ�����
%     y=i-x; 
    z=size/x;    %����
    for m = x+1:2*x
        n=m-x;
        for k=z*(n-1)+1:z*n
            if k<=z*n-z/2
                H(m,k)=sqrt(x);
            else
                H(m,k)=-sqrt(x);
            end
        end
    end
end
H=H./sqrt(size);
end

