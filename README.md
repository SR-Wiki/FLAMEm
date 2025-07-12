# FLAMEm

**FL**uctuation-based high-order super-resolution **A**coustic **M**icroscop**E**

FLAME reconstruction with MATLAB

## FLAME reconstruction

<p align='center'>
<img src='./imgs/workflow.png' align="center" width=900>
</p>

## Instruction

Load the target mat file using load and change the variable name to input. The FLAME reconstruction requires some parameters. 

Necessary Parameters: Important parameters that must be set according to actual needs.
Parameter.SVD_option {default: 0}
Parameter.MB_option {default: 0}
Parameter.pixel {default: 60 * 10^-6}
Parameter.fidelity {default: 200}
Parameter.sparsity {default: 10}
Parameter.FWHM2 {default: 240 * 10^-6}

Expert parameters: Some adjustable parameters that can optimize the reconstruction results.

Parameter.Stab_option {default: 1}
Parameter.cutoff1 {default: 0.25}
Parameter.cutoff2  {default: 0.8}
Parameter.BF_option1 {default: 0}
Parameter.finter1 {default: 2}
Parameter.FWHM1 {180 * 10^-6}
Parameter.iter1 {default: 10}
Parameter.hawk_option {default: 0}
Parameter.order {default: 6}
Parameter.finter2 {default: 2}
Parameter.fidelity_z {default: 1}
Parameter.BF_option2 {default: 0}



Here are 4 examples:

```
[output_CEUS, output_deconv_n, output_deconv_p] = FLAME(input,'SVD_option',0'MB_option',0,'pixel','60 * 10^-6','FWHM2',330 * 10^-6);
[output_CEUS, output_deconv_n, output_deconv_p] = FLAME(input,'MB_option',1,'fidelity',10,'sparsity',1);
[output_CEUS, output_deconv_n, output_deconv_p] = FLAME(input,'SVD_option',1'MB_option',1.'cutoff1',0.1,'cutoff2',0.9);
[output_CEUS, output_deconv_n, output_deconv_p] = FLAME(input,'iter1',5,'iter2',30);
```

## Fusion

Generate better quality intensity and flow velocity images using 4 ultra fast SR frames.

```
for k = 1:floor(size(data,4)/120)
[intensity_n, intensity_p, speed] = fusion(SR_volume_n(:,:,:,(k-1)*4+1:(k-1)*4+4),SR_volume_p(:,:,:,(k-1)*4+1:(k-1)*4+4));
end
```

Rolling fusion can also be chosen to obtain fusion results with higher temporal resolution.

```
for k = 1:floor(size(data,4)/30)-3
[intensity_n, intensity_p, speed] = fusion(SR_volume_n(:,:,:,k:k+3),SR_volume_p(:,:,:,k:k+3));
end
```

## Visualization

Use FLAME's specially designed color encoding to render the final result

```
rendering(intensity_n, intensity_p, speed, output_CEUS,'MB_option',0);
```

You can also export a mat file containing the results and render it using other software

## Declaration

This repository contains the MATLAB source code for **FLAME** .

## Open source [FLAMEm](https://github.com/SR-Wiki/FLAMEm)

This software and corresponding methods can only be used for **non-commercial** use, and they are under Open Data Commons Open Database License v1.0.

