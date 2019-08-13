#!/bin/bash

#block(name=descatter, threads=5, memory=5000, subtasks=1, gpu=true, hours=66)
    root="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190813_gut_deblur-A_vessel"
    resize_or_crop="crop_and_rotate_and_scale"  #'scale_width_and_crop'  # "none" 'resize_and_crop' 'crop' 'scale_width' 'scale_width_and_crop' 'crop_and_scale' 'crop_and_rotate_and_scale'
    for loadSize in 1888 #1024 512  # 2048 1888 1024 512 256 128
    do
        for fineSize in 256  # 2048 1024 512 256 128 
        do
            echo "start"
            name=deblur-percep_styleB-"$loadSize"_"$fineSize"_"$resize_or_crop"
            python -u train-new_dataloader.py --dataroot $root --result_dir $root --display_dir $root \
                    --name $name \
                    --batch_size 2 --lambdaB 0.1 --lr 0.0002 --model_save_freq 500 --n_ep 1000 \
                    --loadSize $loadSize --fineSize $fineSize --resize_or_crop $resize_or_crop
                    # -m ipdb 
        done
    done

