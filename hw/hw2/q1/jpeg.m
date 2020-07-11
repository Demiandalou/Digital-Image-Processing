I=imread('lena.tiff');
Y_Table=[16 11 10 16  24  40  51  61;...
         12 12 14 19  26  58  60  55;...
         14 13 16 24  40  57  69  56;...
         14 17 22 29  51  87  80  62;...
         18 22 37 56  68 109 103  77;...
         24 35 55 64  81 104 113  92;...
         49 64 78 87 103 121 120 101;...
         72 92 95 98 112 100 103  99];
zigzag=[ 0  1  8 16  9  2  3 10,...
        17 24 32 25 18 11  4  5,...
        12 19 26 33 40 48 41 34,...
        27 20 13  6  7 14 21 28,...
        35 42 49 56 57 50 43 36,...
        29 22 15 23 30 37 44 51,...
        58 59 52 45 38 31 39 46,...
        53 60 61 54 47 55 62 63];
zigzag=zigzag+1;
inzigzag=[ 0  1  5  6 14 15 27 28,...
           2  4  7 13 16 26 29 42,...
           3  8 12 17 25 30 41 43,...
           9 11 18 24 31 40 44 53,...
          10 19 23 32 38 45 52 54,...
          20 22 33 38 46 51 55 60,...
          21 34 37 47 50 56 59 61,...
          35 36 48 49 57 58 62 63];
inzigzag=inzigzag+1;

%get y_channel
I_ycbcr=rgb2ycbcr(I);
y_channel=im2double(I_ycbcr(:,:,1));
% figure;imshow(y_channel);

% DCT & normalize
[M,N]=size(y_channel);
dct_y=zeros([M,N]);
for i=1:8:M-7
    for j=1:8:N-7
        dct_y(i:i+7,j:j+7)=dct2(y_channel(i:i+7,j:j+7));
    end
end
maxVal=max(max(dct_y));
norm_dct_y=im2uint8(dct_y./maxVal);

%quantize
quantize = repmat(Y_Table,64,64);
quantized = round(norm_dct_y ./uint8(quantize));

%  8x8 block -> 1x64 col & zigzag scan
block2vec=zeros([64,M*N/64]);
cnt=1;
for j=1:8:M-7
    for i=1:8:N-7
        block=quantized(i:i+7,j:j+7);
        block2vec(:,cnt)=block(:);
        cnt=cnt+1;
    end
end


zigzaged=block2vec(zigzag,:);

[encoded,decoded,ret1,ret2,ret3,enco_dict, deco_dict,k,P]=huffmancoding(zigzaged);
% [encoded,decoded,ret1,ret2,ret3,enco_dict,deco_dict,k,P]=huffmancoding(zigzaged(:,1));

colvec=zeros(64,4096);
for i=1:4096
    for j=1:64
        colvec(j,i)=decoded(64*(i-1)+j);
    end
end
inverse_zigzag=colvec(inzigzag,:);
vec2block=zeros(256,256);
cnt=1;
for j=1:8:M-7
    for i=1:8:N-7
        vec2block(i:i+7,j:j+7)=reshape(inverse_zigzag(:,cnt),8,8);
        cnt=cnt+1;
    end
end

inverse_quantize=uint8(vec2block).*uint8(quantize);

% iDCT
inverse_quantize=im2double(inverse_quantize).*maxVal;
[M,N]=size(inverse_quantize);
aftercompression=zeros([M,N]);
for i=1:8:M-7
    for j=1:8:N-7
        aftercompression(i:i+7,j:j+7)=idct2(inverse_quantize(i:i+7,j:j+7));
    end
end
figure;imshow(aftercompression);
% % 
% % 
mse=cal_mse(y_channel,aftercompression)
snr=cal_snr(y_channel,aftercompression)
% compress ratio
bitsafter=0;
for i=1:16
    bitsafter=bitsafter+P(i)*strlength(char(enco_dict{i-1}));
end
compress_ratio=8/bitsafter


function [encoded,decoded,ret1,ret2,ret3,enco_dict,deco_dict,k,Pall]=huffmancoding(zigzaged)%self-implemented
%     zigzaged
    encoded=0;
    decoded=0;
    [M0,N0]=size(zigzaged);%64*4096
    P = zeros(1,18);
    for i = 0:17
         P(i+1) = length(find(zigzaged == i))/(M0*N0);
    end
    k = 0:9;
    p_trun=zeros(1,10);
    for i=1:9
        p_trun(i)=P(i);
    end
    for i=10:17
        p_trun(10)=p_trun(10)+P(i);
    end
    Pall=P;
    P=p_trun;
%     k=[0,1,2,3,4,5,6,7,8,9];
%     P=[0.9760,0.0066,0.0012,0.0003,0.0007,0.0016,0.0010,0.0012,0.0016,0.0097];

    
    [enco_dict,deco_dict,maxlen]=bintreecode(k,P);
    ret1=0;ret2=0;ret3=0;
    encoded='';
    decoded=zeros(M0,N0);
%     enco_dict
% %     deco_dict
    for i=1:N0
        i
        encodedstr=huff_encode(enco_dict,zigzaged(:,i));
        decodestr=huff_decode(deco_dict,maxlen,encodedstr);
        decoded(:,i)=decodestr;
%         size(decodestr)
        encoded=strcat(encoded,encodedstr);
        % report res (last block of first row)
        if i==64
            ret1=zigzaged(:,i);
            ret2=encodedstr;
            ret3=decodestr;
        end
    end
%     decodestr
end

function encoded=huff_encode(enco_dict,zigzaged)
%     zigzaged=zigzaged(:);
    [m,n]=size(zigzaged);
    encoded='';
    for i=1:m
        encoded=strcat(encoded,char(enco_dict{zigzaged(i)}));
    end
%     encoded
end

function decoded=huff_decode(deco_dict,maxlen,encodedstr)
%     encodedstr
%     maxlen=7;
    decoded=zeros(64,1);
    cnt=1;
    while cnt<=64
        if encodedstr(1)=='0'
            decoded(cnt)=0;
%             decoded(cnt)
            [m,encodelen]=size(encodedstr);
            encodedstr=encodedstr(2:encodelen);
            cnt=cnt+1;
        else
%             strlength(encodedstr)
            n=min(maxlen,strlength(encodedstr)-64+cnt);
            flag=0;
            while flag==0
                try
%                     encodedstr(1:n);
                    decoded(cnt)=deco_dict{encodedstr(1:n)};
%                     decoded(cnt)
                    [m,encodelen]=size(encodedstr);
                    encodedstr=encodedstr(n+1:encodelen);
                    flag=1;
                    cnt=cnt+1;
                catch
                    n=n-1;
                end
            end
        end
    end
%     decoded
%     size(decoded)
%     decoded=reshape(decoded,[512,512]);
%     decoded
end

function [dict,decodedict,maxlen]=bintreecode(k,P)
    datasize=size(P);
    len=datasize(2);

    sortnode=zeros(len,2);
    for i = 1:len
        new_node(i)=get_node(k(i),P(i));
        sortnode(i,:)=[P(i),k(i)];
    end
    new_node;
    new_node(5);
    list=new_node;

    cnt=1;
    % while list(1).P~=sum(P)
    while cnt<10
        cnt=cnt+1;
        sortnode=sortrows(sortnode);
        minkp=sortnode(1,:);
        leftnode_idx=1;
        while (list(leftnode_idx).k~=minkp(2)) || (list(leftnode_idx).P~=minkp(1))
            leftnode_idx=leftnode_idx+1;
        end
        leftnode=list(leftnode_idx);
        list(leftnode_idx)=[];

        minkp=sortnode(2,:);
        rightnode_idx=1;
        while (list(rightnode_idx).k~=minkp(2)) || (list(rightnode_idx).P~=minkp(1))
            rightnode_idx=rightnode_idx+1;
        end
        rightnode=list(rightnode_idx);
        list(rightnode_idx)=[];

        nodesize=size(sortnode);
        sortnode=sortnode(2:nodesize(1),:);
        sortnode(1,:)=[leftnode.P+rightnode.P,-abs(leftnode.k)-abs(rightnode.k)];
        rootnode=get_node(-abs(leftnode.k)-abs(rightnode.k),leftnode.P+rightnode.P);
        rootnode.left=leftnode;
        rootnode.right=rightnode;

        % insert current root node
        [m,n]=size(list);
        list(n+1)=rootnode;
    %     prinf=zeros(1,n+1);
    %     for i=1:n+1
    %         prinf(i)=list(i).k;
    %     end
    %     prinf
    end
    aqueue=[rootnode];
    queuesize=size(aqueue);
    dict=py.dict;
    while queuesize(2)~=0
        curnode=aqueue(1);
        aqueue(1)=[];
        if curnode.left.P~=-1
            curnode.left.coding=strcat(curnode.coding,'1');
            if curnode.left.k>=0 && curnode.left.k<=9
                dict{curnode.left.k}=curnode.left.coding;
            end
            queuesize=size(aqueue);
            aqueue(queuesize(2)+1)=curnode.left;
        end
        if curnode.right.P~=-1
            curnode.right.coding=strcat(curnode.coding,'0');
            if curnode.right.k>=0 && curnode.right.k<=9
                dict{curnode.right.k}=curnode.right.coding;
            end
            queuesize=size(aqueue);
            aqueue(queuesize(2)+1)=curnode.right;
        end
        queuesize=size(aqueue);
    end

    % dict
    halfcoding=char(dict{9});
    permlen=8;
    for i = 1:permlen
        halfcoding;
        addcode=dec2bin(i-1,log2(permlen));
        strcode=[halfcoding,addcode];
        dict{9+i-1}=strcode;
    end
    % dict
    decodedict=py.dict;
    for i=1:17
%         k(i);
        coded=dict{i-1};
        decodedict{coded}=i-1;
    end
%     decodedict
    maxlen=7;
end

% a=f(x,y)(origin), b=hat(f)(x,y)(reconstructed)
function mse=cal_mse(a,b)
    [M,N]=size(a);
    res=0;
    for i=1:M
        for j=1:N
            res=res+((b(i,j)-a(i,j)).^2);
        end
    end
    res=res/M/N;
    mse=sqrt(double(res));
end

function snr=cal_snr(a,b)
    [M,N]=size(a);
    res_up=0;
    res_down=0;
    for i=1:M
        for j=1:N
            res_up=res_up+(a(i,j).^2);
            res_down=res_down+((b(i,j)-a(i,j)).^2);
        end
    end
    snr=res_up/res_down;
end

function node=get_node(ki,Pi)
    dummy=struct('k',-1,...
                'P',-1,...
                'left',-1,...
                'right',-1,...
                'coding','',...
                'next',[]);
    node=struct('k',ki,...
                'P',Pi,...
                'left',dummy,...
                'right',dummy,...
                'coding','',...
                'next',[]);
end


