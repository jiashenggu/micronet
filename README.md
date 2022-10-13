# MicroNet: Improving Image Recognition with Extremely Low FLOPs (ICCV 2021)
A [pytorch](http://pytorch.org/) implementation of [MicroNet](https://arxiv.org/abs/2108.05894).
If you use this code in your research please consider citing
>@article{li2021micronet,
  title={MicroNet: Improving Image Recognition with Extremely Low FLOPs},
  author={Li, Yunsheng and Chen, Yinpeng and Dai, Xiyang and Chen, Dongdong and Liu, Mengchen and Yuan, Lu and Liu, Zicheng and Zhang, Lei and Vasconcelos, Nuno},
  journal={arXiv preprint arXiv:2108.05894},
  year={2021}
}
## Requirements

- Linux or macOS with Python ≥ 3.6.
- *Anaconda3*, *PyTorch ≥ 1.5* with matched [torchvision](https://github.com/pytorch/vision/)

## Models
Model | #Param | MAdds | Top-1 | download
--- |:---:|:---:|:---:|:---:
MicroNet-M3 | 2.6M | 21M  | 62.5 | [model](http://www.svcl.ucsd.edu/projects/micronet/assets/micronet-m3.pth)
MicroNet-M2 | 2.4M | 12M  | 59.4 | [model](http://www.svcl.ucsd.edu/projects/micronet/assets/micronet-m2.pth)
MicroNet-M1 | 1.8M | 6M  | 51.4 | [model](http://www.svcl.ucsd.edu/projects/micronet/assets/micronet-m1.pth)
MicroNet-M0 | 1.0M | 4M  | 46.6 | [model](http://www.svcl.ucsd.edu/projects/micronet/assets/micronet-m0.pth)

## Evaluate MicroNet on ImageNet

Download the pretrained MicroNet M0-M3 with the link above. The scripts used for evaluation can be found [here](script). For example, if you want to test MicroNet-M3, you can use the following command.

```
sh scripts/eval_micronet_m3.sh /path/to/imagenet /path/to/output /path/to/pretrained_model
```

## Train MicroNet on ImageNet

The scripts used for training MicroNet M0-M3 can be found [here](script) and can be implemented as follows (You can choose to use different scripts for 2 gpu or 4 gpu training based on the resources you can access).
```
sh scripts/train_micronet_m3_4gpu.sh /path/to/imagenet /path/to/output
```


The Micro-Facatorized Pointwise convolution has nothing to do with depthwise convolution. It is composed of two group convolution with a shuffle between them. Actually, the code is organized a little differently compared to the description of the paper, although the architecture is exactly the same. In the file micronet.py, the micro-factorized pw convolution depicts the architecture formed by the code from L381-L397 (group conv+shuffle) to L349-L362 (group conv). I'm sorry to cause the confusion. I hope my explanation can help you understand our paper. Thanks!

DepthSpatialSepConv is the Micro-Factorized Depthwise Convolution. ChannelShuffle and ChannelShuffle2 are the same and I use different names for ablation only. I should have removed the ChannelShuffle2. For Micro-Factorized Pointwise Convolution, for easier implementation, I code differently to the order described in the paper. But they are mathematically the same. The codes of the three blocks are from L293 to L397. It is a little hard to explain in great detail and I suggest you run the code and check the architecture that is printed to help you understand this part.

The implementation is very similar. The SpatialSepConvSF is used on layers with different input and output channels.


Yes, it is a plug-and-play model. You have multiple choices to implement. Remember in our paper, we express Micro-Factorized convolution as a matrix decomposition- W = P \Phi Q. For mobilenet, you can view each pointwise convolution as W and decompose it to the multiplication of P\Phi Q. Another way is to view two consecutive pointwise convolutional layers as P and Q and change them to group conv with group number explained in our paper.

You need to use both with order L381-L395 (P\Phi)+ L349-L363 (Q)

s, n, c, ks represents the stride, number of repeated layers, network width and kernel sizes. 
The multiplication of c1 and c2 is the expansion between input channels to the hidden dimension. 
g1 and g2, g3 and g4 are basically the same parameters that represent the group number used in the macro-factorized convolution. 
The rest three parameters are used to decide whether the dynamic shift-max is used or not, while the last parameter is the hyperparameter contained in dynamic shift-max to adjust the reduction ratio.