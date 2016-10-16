# emacs: -*- mode: python; py-indent-offset: 4; indent-tabs-mode: nil -*-
# vi: set ft=python sts=4 ts=4 sw=4 et:

import os
import h5py
import numpy as np
import networkx as nx
import json
from itertools import chain
from networkx.readwrite import json_graph

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
    for n, nbrdict in G.adjacency_iter():
        adj = {'connections': []}
        for nbr, d in nbrdict.items():
            adj['connections'].append(dict(chain([('u', nbr), ('w', d['weight'])])))
        data['weights'].append(adj)
    return data


db_dir = r'/Users/sealhuang/Downloads/cnn_profile'
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
for conn_idx in range(1):
    wt = np.array(f.get(wts[0][conn_idx]))
    wt = wt.transpose()
    src_num, targ_num = wt.shape
    for i in range(src_num):
        for j in range(targ_num):
            if wt[i, j]:
                G.add_edge(node_count+i, node_count+src_num+j,
                           weight=abs(wt[i, j]))
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
#print json_graph.adjacency_data(G)

# save network into json file
with open('net.json', 'w') as outfile:
    #outfile.write(json.dumps(json_graph.adjacency_data(G)))
    outfile.write(json.dumps(adjacency_data(G, network_info)))


