# emacs: -*- mode: python; py-indent-offset: 4; indent-tabs-mode: nil -*-
# vi: set ft=python sts=4 ts=4 sw=4 et:

import os
import h5py
import numpy as np
import networkx as nx
from networkx.readwrite import json_graph
import json

db_dir = r'/Users/sealhuang/Downloads/cnn_profile'
cnn_file = os.path.join(db_dir, 'infor.mat')

# open h5py file and load netweok weights matrix
f = h5py.File(cnn_file, 'r')

wts = f.get(u'wt')
conn_num = wts.shape[1]
layer_names = ['data'] + ['conv'+str(i+1) for i in range(conn_num)]

# network initialization
G = nx.DiGraph()

#for conn_idx in range(conn_num):
for conn_idx in range(1):
    src_layer = layer_names[conn_idx]
    targ_layer = layer_names[conn_idx+1]
    wt = np.array(f.get(wts[0][conn_idx]))
    wt = wt.transpose()
    src_num, targ_num = wt.shape
    for i in range(src_num):
        for j in range(targ_num):
            if wt[i, j]:
                G.add_edge('_'.join([src_layer, str(i+1)]),
                           '_'.join([targ_layer, str(j+1)]),
                           weight = wt[i, j])

print json_graph.adjacency_data(G)

## save network into json file
#with open('net.json', 'w') as outfile:
#    outfile.write(json.dumps(json_graph.node_link_data(G)))

