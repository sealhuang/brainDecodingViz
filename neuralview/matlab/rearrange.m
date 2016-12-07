load infor;
load net;
data=net.blobs('data').get_data();
threshold=0.5;

wt_new=wt{2};
[m,n]=size(wt_new);
wt_l=wt_new(:,1:(n/2));
wt_r=wt_new(:,(n/2+1):end);
z=zeros(m,n/2);
wt_l=[wt_l,z];
wt_r=[z,wt_r];
wt_new=[wt_l;wt_r];
wt{2}=wt_new;

wt_new=wt{4};
[m,n]=size(wt_new);
wt_l=wt_new(:,1:(n/2));
wt_r=wt_new(:,(n/2+1):end);
z=zeros(m,n/2);
wt_l=[wt_l,z];
wt_r=[z,wt_r];
wt_new=[wt_l;wt_r];
wt{4}=wt_new;

wt_new=wt{5};
[m,n]=size(wt_new);
wt_l=wt_new(:,1:(n/2));
wt_r=wt_new(:,(n/2+1):end);
z=zeros(m,n/2);
wt_l=[wt_l,z];
wt_r=[z,wt_r];
wt_new=[wt_l;wt_r];
wt{5}=wt_new;

img1=pct;
% img1=data(:,:,:,1);
% img1=permute(img1,[2,1,3]);
% img1=img1(:,:,[3,2,1]);
[~,~,n]=size(img1);
for i=1:n
    img_tem=img1;
    img_tem(:)=0;
    img_tem(:,:,i)=img1(:,:,i);
%     img_tem=img_tem(:,:,[3,2,1]);
    imwrite(uint8(img_tem),['img/data',num2str(3-i),'.png']);
end

knl=kernel{1};
knl=knl(:,:,[3,2,1],:);
[~,~,~,n]=size(knl);
for i=1:n
    knl_tem=knl(:,:,:,i);
    imwrite(uint8(knl_tem),['img/kernel',num2str(i-1),'.png']);
end

cnt=0;
for i=1:5
    msk=mask{i};
    msk=permute(msk,[2,1,3,4]);
    [~,~,n,~]=size(msk);
    for j=1:n
        msk_tem=msk(:,:,j,1);
        msk_tem=msk_tem/(max(msk_tem(:))+0.0001);
        str=strel('disk',5);
        msk_tem=imerode(msk_tem,str);
        msk_tem=imdilate(msk_tem,str);
        msk_tem(msk_tem>threshold)=1;
        msk_tem(msk_tem<=threshold)=0.4;
        msk_tem_3(:,:,3)=msk_tem;
        msk_tem_3(:,:,2)=msk_tem;
        msk_tem_3(:,:,1)=msk_tem;
        tsprt=double(img1);
%         tsprt=tsprt(:,:,[3,2,1]);
        tsprt=uint8(tsprt.*msk_tem_3);
        imwrite(tsprt,['img/unit',num2str(cnt),'.png']);
        cnt=cnt+1;
    end
end

save infor_new fmapsize kernelsize blob_names layer_names fmf fmap mask kernel wt













