# emacs: -*- mode: python; py-indent-offset: 4; indent-tabs-mode: nil -*-
# vi: set ft=python sts=4 ts=4 sw=4 et:

import os
import h5py
import numpy as np
import networkx as nx
import json

def adjacency_data(G, network_info):
    """Return data in adjacency format that is suitable for JSON serialization
    and use in javascript documents.

    Parameters
    ----------
    G : NetworkX graph
    layer_names : a list with CNN layer information

    Returns
    -------
    data : dict
       A dictionary with adjacency formatted data.
    
    """
    data = {}
    data['network'] = network_info
    data['weights'] = []
    node_num = sum([layer['units'] for layer in network_info])
    for i in range(node_num):
        adj = {'connections': []}
        adj['connections'] = [dict(u=x[0], w=G.get_edge_data(x[0], x[1])['weight']) for x in G.in_edges_iter() if x[1]==i]
        data['weights'].append(adj)
    
    return data


db_dir = os.getcwd()
cnn_file = os.path.join(db_dir, 'infor.mat')

# open h5py file and load netweok weights matrix
f = h5py.File(cnn_file, 'r')

wts = f.get(u'wt')
conn_num = wts.shape[1]
layer_names = ['data'] + ['conv'+str(i+1) for i in range(conn_num)]

# network initialization
G = nx.DiGraph()
network_info = []
node_count = 0
#for conn_idx in range(conn_num):
for conn_idx in range(2):
    wt = np.array(f.get(wts[0][conn_idx]))
    wt = wt.transpose()
    src_num, targ_num = wt.shape
    for i in range(src_num):
        for j in range(targ_num):
            w = round(float(abs(wt[i, j])), 2)
            if w:
                G.add_edge(node_count+i, node_count+src_num+j, weight=w)
    node_count += src_num
    # network info
    src_layer = layer_names[conn_idx]
    targ_layer = layer_names[conn_idx+1]
    if not conn_idx:
        layer_info = {'name': src_layer, 'units': src_num}
        network_info.append(layer_info)
    layer_info = {'name': targ_layer, 'units': targ_num}
    network_info.append(layer_info)

#print adjacency_data(G, network_info)

# save network into json file
json_dir = os.path.join(db_dir, 'src')
if not os.path.exists(json_dir):
    os.mkdir(json_dir)
with open(os.path.join(json_dir, 'net.json'), 'w') as outfile:
    outfile.write(json.dumps(adjacency_data(G, network_info)))


