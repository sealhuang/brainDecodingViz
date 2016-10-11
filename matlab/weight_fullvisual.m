function [  ] = weight_fullvisual( net,layer_num  )
layers=net.layer_names;
convlayer=[];
for i=1:length(layers)
    if strcmp(layers{i}(1:3),'con')
        convlayer=[convlayer;layers{i}];
    end
end
 
weight=net.layers(convlayer(layer_num,:)).params(1).get_data();%ËÄÎ¬£¬ºË³¤*ºË¿í*ºË×ó±ßÊäÈë*ºËÓÒ±ßÊä³ö(ºË¸öÊý)
b=net.layers(convlayer(layer_num,:)).params(2).get_data();
weight=weight-min(min(min(min(weight))));
weight=weight/max(max(max(max(weight))))*255;
 
[kernel_r,kernel_c,input_num,kernel_num]=size(weight);
map_row=input_num;%ÐÐÊý
map_col=kernel_num;%ÁÐÊý
weight_map=zeros(kernel_r*map_row,kernel_c*map_col);
for i=0:map_row-1
    for j=0:map_col-1
        weight_map(i*kernel_r+1+i:(i+1)*kernel_r+i,j*kernel_c+1+j:(j+1)*kernel_c+j)=weight(:,:,i+1,j+1);
    end
end
figure
imshow(uint8(weight_map))
str1=strcat('weight num:',num2str(map_row*map_col));
title(str1)
 
end