export DATA_PATH=$1/imagenet
export OUTPUT_PATH=$2/micronet-m2-eval
export WEIGHT_PATH=$3

CUDA_VISIBLE_DEVICES=3 python main.py --arch MicroNet -d $DATA_PATH -c $OUTPUT_PATH -j 48 --input-size 224 -b 512 -e --weight $WEIGHT_PATH \
                                                         MODEL.MICRONETS.BLOCK DYMicroBlock \
                                                         MODEL.MICRONETS.NET_CONFIG msnx_dy9_exp6_12M_221 \
                                                         MODEL.MICRONETS.STEM_CH 8 \
                                                         MODEL.MICRONETS.STEM_GROUPS 4,2 \
                                                         MODEL.MICRONETS.STEM_DILATION 1 \
                                                         MODEL.MICRONETS.STEM_MODE spatialsepsf \
                                                         MODEL.MICRONETS.OUT_CH 1024 \
                                                         MODEL.MICRONETS.DEPTHSEP True \
                                                         MODEL.MICRONETS.POINTWISE group \
                                                         MODEL.MICRONETS.DROPOUT 0.1 \
                                                         MODEL.ACTIVATION.MODULE DYShiftMax \
                                                         MODEL.ACTIVATION.ACT_MAX 2.0 \
                                                         MODEL.ACTIVATION.LINEARSE_BIAS False \
                                                         MODEL.ACTIVATION.INIT_A_BLOCK3 1.0,0.0 \
                                                         MODEL.ACTIVATION.INIT_A 1.0,1.0 \
                                                         MODEL.ACTIVATION.INIT_B 0.0,0.0 \
                                                         MODEL.ACTIVATION.REDUCTION 8 \
                                                         MODEL.MICRONETS.SHUFFLE True \
