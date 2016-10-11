function [  ] = feature_fullvisual( net,mapnum )
names=net.blob_names;
featuremap=net.blobs(names{mapnum}).get_data();%»ñÈ¡Ö¸¶¨²ãµÄÌØÕ÷Í¼
[m_size,n_size,num,crop]=size(featuremap)%»ñÈ¡ÌØÕ÷Í¼´óÐ¡£¬³¤*¿í*¾í»ýºË¸öÊý*Í¼Æ¬¸öÊý
row=crop;%ÐÐÊý
col=num;%ÁÐÊý
feature_map=zeros(m_size*row,n_size*col);
for i=0:row-1
    for j=0:col-1
        feature_map(i*m_size+1:(i+1)*m_size,j*n_size+1:(j+1)*n_size)=(mapminmax(featuremap(:,:,j+1,i+1),0,1)*255)';
    end
end
figure
imshow(uint8(feature_map))
str=strcat('feature map num:',num2str(row*col));
title(str)
end