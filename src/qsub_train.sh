#!/bin/bash

#block(name=descatter, threads=5, memory=5000, subtasks=1, gpu=true, hours=66)
    root_gut="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190813_gut_deblur-A_vessel"  # gut
    root_brain="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190812_unpaired_deblur-A_sharp-B_blur"  # brain
    resize_or_crop="crop_and_rotate_and_scale"  #'scale_width_and_crop'  # "none" 'resize_and_crop' 'crop' 'scale_width' 'scale_width_and_crop' 'crop_and_scale' 'crop_and_rotate_and_scale'
    for root in $root_gut $root_brain
    do
        for loadSize in 1888 #1024 512  # 2048 1888 1024 512 256 128
        do
            for fineSize in 256  # 2048 1024 512 256 128 
            do
                echo "start"
                name=11.7-DANN_1.0-"$loadSize"_"$fineSize"_"$resize_or_crop"  # percep_styleB
                python -u train-new_dataloader.py --dataroot $root --result_dir $root --display_dir $root \
                        --name $name \
                        --batch_size 2 --lambdaB 0.1 --lr 0.0002 --model_save_freq 500 --n_ep 1000 \
                        --loadSize $loadSize --fineSize $fineSize --resize_or_crop $resize_or_crop
                        # -m ipdb 
            done
        done
    done

