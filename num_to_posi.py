# -*- coding: utf-8 -*-
"""
Created on Sun Sep 26 09:07:26 2016

@author: maxuelin
"""
import sys
name_of_layer = sys.argv[1]   #the name of layer
index_of_nodes = int(sys.argv[2])  #the index of the nodes


def div_MOD(struc_of_layer, index):
    [num_layers, num_row, num_column] = struc_of_layer    
    size_of_map = num_row*num_column
    index_of_channels = index/size_of_map + 1 
    mod_of_index = index%size_of_map
    index_row = mod_of_index/num_column + 1
    index_column = mod_of_index%num_column
    
    return [index_of_channels,index_row,index_column]



d = {'conv1':[96,55,55], 'conv2':[256,27,27], 'conv3':[384,13,13], 'conv4':[384,13,13], 'conv5':[256,13,13], 'pool5':[256,6,6]}

a = div_MOD(d[name_of_layer],index_of_nodes)
print 'The position of \"290000\" in \"conv1\" layer is:',a,'in ',d[name_of_layer]
