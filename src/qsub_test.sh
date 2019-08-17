#!/bin/bash

#block(name=descatter, threads=5, memory=5000, subtasks=1, gpu=true, hours=66)
    root_gut="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190813_gut_deblur-A_vessel"  # gut
    root_brain="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190812_unpaired_deblur-A_sharp-B_blur"  # brain
    method_folder="14.1-DANN_1.0_grad_reverse-L1_2percp_1.0-1888_256_crop_and_rotate_and_scale"
    resize_or_crop="crop_and_scale"  #'scale_width_and_crop'  # "none" 'resize_and_crop' 'crop' 'scale_width' 'scale_width_and_crop' 'crop_and_scale' 'crop_and_rotate_and_scale'
    for model_of_epoch in 00099  # {260..400..30}  # {10..300..10} # {7000..40000..500}   # 0: latest
    do
        for root in $root_gut $root_brain
        do
            for loadSize in 1888 #1024 512  # 2048 1888 1024 512 256 128
            do
                for fineSize in 256  # 2048 1024 512 256 128 
                do
                    echo "start"
                    name=$model_of_epoch  # 12.1-DANN_1.0_grad_reverse-"$loadSize"_"$fineSize"_"$resize_or_crop"  # percep_styleB
                    python -u -m ipdb test.py --dataroot $root --result_dir $root/$method_folder/test/ \
                            --name $name \
                            --resume "$root"/"$method_folder"/"$model_of_epoch".pth \
                            --batch_size 1 \
                            --loadSize $loadSize --fineSize $fineSize --resize_or_crop $resize_or_crop
                            # -m ipdb 
                            # --display_dir "$root"/test/"$model_of_epoch"
                done
            done
        done
    done

