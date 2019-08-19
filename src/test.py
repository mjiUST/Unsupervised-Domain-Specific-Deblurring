import os
import numpy as np
import torch
import torch.nn as nn

from dataset import dataset_single
from model import UID
from networks import PerceptualLoss16,PerceptualLoss
from options import TestOptions
from saver import Saver, save_imgs
from shutil import copyfile
from skimage.measure import compare_psnr as PSNR
from skimage.measure import compare_ssim as SSIM
from skimage.io import imread
from skimage.transform import resize
from data import CreateDataLoader



def main():
    
    # parse options
    parser = TestOptions()
    opts = parser.parse()
    result_dir = os.path.join(opts.result_dir, opts.name, 'test')
    orig_dir = opts.orig_dir
    blur_dir = opts.dataroot

    if not os.path.exists(result_dir):
        os.makedirs(result_dir)

    saver = Saver(opts)

    # data loader
    print('\n--- load dataset ---')
    dataset_domain = 'A' if opts.a2b else 'B'
    #     dataset = dataset_single(opts, 'A', opts.input_dim_a)
    # else:
    #     dataset = dataset_single(opts, 'B', opts.input_dim_b)
    # loader = torch.utils.data.DataLoader(dataset, batch_size=1, num_workers=opts.nThreads)
    loader = CreateDataLoader(opts)

    # model
    print('\n--- load model ---')
    model = UID(opts)
    model.setgpu(opts.gpu)
    model.resume(opts.resume, train=False)
    model.eval()

    # test
    print('\n--- testing ---')
    for idx1, data in enumerate(loader):
        # img1, img_name_list = data[dataset_domain], data[dataset_domain+'_paths']
        # img1 = img1.cuda(opts.gpu).detach()
        images_a, images_b = data['A'], data['B']
        img_name_list = data['A_paths']
        if len(img_name_list) > 1:
            print("Warning, there are more than 1 sample in the test batch.")
        images_a = images_a.cuda(opts.gpu).detach()
        images_b = images_b.cuda(opts.gpu).detach()
        images_a = torch.cat([images_a]*2, dim=0)  # because half of the batch is used as real_A_random
        images_b = torch.cat([images_b]*2, dim=0)  # because half of the batch is used as real_B_random
        print('{}/{}'.format(idx1, len(loader)))
        with torch.no_grad():
            model.inference(images_a, images_b)
            # img = model.test_forward(img1, a2b=opts.a2b)
        saver.write_img(idx1, model)
        # for _img, _img_name in zip(img, img_name_list):
        #     save_imgs(img, _img_name.split('/')[-1], result_dir)

    return

if __name__ == '__main__':
  main()
