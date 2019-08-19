#!/bin/bash

#block(name=descatter, threads=5, memory=5000, subtasks=1, gpu=true, hours=66)
    root_gut="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190813_gut_deblur-A_vessel"  # gut
    root_brain="/home/mengqi/fileserver/results/fluorescence/20190812_DRIT/20190812_unpaired_deblur-A_sharp-B_blur"  # brain
    method_folder="13.1.3-DANN_1.0_grad_reverse_small_shift_trainA-1024_256_crop_and_rotate_and_scale"
    dataset="test_angiography_full"  # path: root/method_folder/dataset
    resize_or_crop="crop_and_scale"  #'scale_width_and_crop'  # "none" 'resize_and_crop' 'crop' 'scale_width' 'scale_width_and_crop' 'crop_and_scale' 'crop_and_rotate_and_scale'
    ## brain: 00121 00191 00198 00233 00349 00360 00369 00420 00421   
    ## gut: 00237 00243 00246 00247 00248 00251 00282 00306 00326 00354 00360 00361 00370 00376 00382 00422 00425 00427 00436 00448 00473
    ## gut 1000_256: 00068 00074 00083 00086 00097 00100 00107 00111 00119 00121 00122 00127 00130 00134 00136 00144 00149 00162 00163 00170 00173 00177 00178 00180 00183 00192 00194 00201 00202 00215 00219 00220 00221 00223 00225 00230 00233 00234 00244 00249 00251 00253 00258 00261 00267 00268 00272 00281 00291 00296 00298 00303 00304 00306 00307 00318  00319 00325 00326 00327 00330 00333 00336 00337 
    for model_of_epoch in 00136  # {00000..00500}  # {260..400..30}  # {10..300..10} # {7000..40000..500}   # 0: latest
    do
        for root in $root_gut  # $root_gut $root_brain
        do
            for loadSize in 1024 #1024 512  # 2048 1888 1024 512 256 128
            do
                for fineSize in 1024  # 2048 1024 512 256 128 
                do
                    echo "start"
                    sleep 1
                    name=$model_of_epoch  # 12.1-DANN_1.0_grad_reverse-"$loadSize"_"$fineSize"_"$resize_or_crop"  # percep_styleB
                    # NOTE: if dataroot is set to result_dir, remember to copy testA/B to the result_dir
                    result_dir=$root/$method_folder/"$dataset"_"$loadSize"_"$fineSize"
                    python -u test.py --dataroot "$result_dir" --result_dir $result_dir \
                            --name $name \
                            --resume "$root"/"$method_folder"/"$model_of_epoch".pth \
                            --batch_size 1 \
                            --loadSize $loadSize --fineSize $fineSize --resize_or_crop $resize_or_crop
                            # -m ipdb 
                            # --num_threads 0 --nThreads 0\  # can use pdb to debug
                            # --display_dir "$root"/test/"$model_of_epoch"
                done
            done
        done
    done

