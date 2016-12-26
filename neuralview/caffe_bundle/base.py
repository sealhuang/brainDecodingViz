# emacs: -*- mode: python; py-indent-offset: 4; indent-tabs-mode: nil -*-
# vi: set ft=python sts=4 ts=4 sw=4 et:

import os
import numpy as np
import matplotlib.pylab as plt
import caffe

def plot_conv1_kernels(net_name):
    """Plot conv1 kernels."""
    caffe_root = '/'.join(caffe.__file__.split('/')[:-3])
    caffe.set_mode_cpu()
    model_def = os.path.join(caffe_root, 'models', net_name, 'deploy.prototxt')
    model_weights = os.path.join(caffe_root, 'models', net_name,
                                 net_name+'.caffemodel')
    net = caffe.Net(model_def, model_weights, caffe.TEST)
    kernels = net.params['conv1'][0].data.transpose(0, 2, 3, 1)
    for i in range(kernels.shape[0]):
        data = kernels[i, ...]
        # normalize data for display
        data = (data - data.min()) / (data.max() - data.min())
        plt.imshow(data)
        



