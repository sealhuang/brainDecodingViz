%load image
im=imread('../../examples/images/2008_003764cut.jpg');
IMAGE_DIM = 256;
CROPPED_DIM = 227;
pct=imresize(im,[IMAGE_DIM,IMAGE_DIM]);
pct=pct(1:CROPPED_DIM,1:CROPPED_DIM,:);
%get net
[~,~,net]=classification_demo(im, 1);

%get blob and layer names
blob_names=net.blob_names;
layer_names=net.layer_names;
convblob=[];
for i=1:length(blob_names)
    if strcmp(blob_names{i}(1:3),'con')
        convblob=[convblob;blob_names{i}];
    end
end
convlayer=[];
for i=1:length(layer_names)
    if strcmp(layer_names{i}(1:3),'con')
        convlayer=[convlayer;layer_names{i}];
    end
end

%get all blob size
[m_b,~]=size(blob_names);
fmf=[];
for mapnum=1:m_b
    featuremap=net.blobs(blob_names{mapnum}).get_data();
    f=size(featuremap);
    if(length(f)<4)
        break;
    end
    fmf=[fmf;f];
end
fmf

%get featuremap,mask,kernel,weight and its size of conv layers
%[m_b,~]=size(blob_names)
%[m_l,~]=size(layer_names)
[m_b,~]=size(convblob);
[m_l,~]=size(convlayer);
fmap=cell(m_b,1);
mask=cell(m_b,1);
kernal=cell(m_l,1);
wt=cell(m_l,1);

%get featuremap and its size of conv layers
m_size_all=[];n_size_all=[];num_all=[];crop_all=[];
for mapnum=1:m_b
    featuremap=net.blobs(convblob(mapnum,:)).get_data();
    [m_size,n_size,num,crop]=size(featuremap);
    m_size_all=[m_size_all;m_size];
    n_size_all=[n_size_all;n_size];
    num_all=[num_all;num];
    crop_all=[crop_all;crop];
    fmap{mapnum}=featuremap;
    msk=zeros(227,227,num,crop);
    for i=1:num
        for j=1:crop
            msk(:,:,i,j)=imresize(featuremap(:,:,i,j),[227,227]);
        end
    end
    mask{mapnum}=msk;
end
fmapsize=[m_size_all,n_size_all,num_all,crop_all];

%get kernel and the weight of kernel between layers and its size of conv layers
kernel_r_all=[];kernel_c_all=[];input_num_all=[];kernel_num_all=[];
for layer_num=1:m_l
    weight=net.layers(convlayer(layer_num,:)).params(1).get_data();
    [kernel_r,kernel_c,input_num,kernel_num]=size(weight);
    kw=mean(weight,1);kw=mean(kw,2);kw=reshape(kw,input_num,kernel_num);
    wt{layer_num}=kw;
    if layer_num==1
        maxv = max(weight(:));
        minv = min(weight(:));
        weight = (weight - minv)/(maxv - minv)*255;
%         weight=weight-min(min(min(min(weight))));
%         weight=weight/max(max(max(max(weight))))*255;
        weight=uint8(weight);
    end
    kernel_r_all=[kernel_r_all;kernel_r];
    kernel_c_all=[kernel_c_all;kernel_c];
    input_num_all=[input_num_all;input_num];
    kernel_num_all=[kernel_num_all;kernel_num];
    kernel{layer_num}=weight;
end
kernelsize=[kernel_r_all,kernel_c_all,input_num_all,kernel_num_all]

%get mask of each featuremap re

%save data
save net net
save infor fmapsize kernelsize blob_names layer_names fmf fmap mask kernel wt pct






