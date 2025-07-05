%---------------------------------------------------------------------------
%   DEMO for FLAME
%---------------------------------------------------------------------------
clc;clear;close all;
addpath(genpath('FLAME'));
% ************************************************** USAGE *************************************************************************************************************************************
% Load the target mat file using load and change the variable name to input.
% Or use function imRS to load the target tif file. input = imRS('target');
% Folder 'Function_FLAME' contains the functions demo used.
% Necessary Parameters: Important parameters that must be set according to actual needs.
% Expert parameters: Some adjustable parameters that can optimize the reconstruction results. 
% Before adjusting, please ensure that you have a certain understanding of the principles related to the parameters, otherwise it is recommended to use default values.
%************************************************** Workflow ***********************************************************************************************************************************
% STEP1-1. Tissue signal filter
% STEP1-2. MB direction filter
% STEP1-3. Background filter
% STEP1-4. Pre deconvolution
% STEP1-5. MB density filter
% STEP2-1. High-order cumulant calculation
% STEP2-2. Intensity linearization 
% STEP3-1. Post multi-constraint deconvolution
% STEP3-2. Final data fusion
%% main
load testdataStroke_svd;

for i = 1:floor(size(data,4)/30)
input = data(:,:,:,(i-1)*30+1:(i-1)*30+30);
[output_CEUS, output_deconv_n, output_deconv_p] = FLAME(input,'MB_option',1);
SR_volume_n(:,:,:,i) = percennorm(output_deconv_n);
SR_volume_p(:,:,:,i) = percennorm(output_deconv_p);
end

for k = 1:floor(size(data,4)/30)-3
[intensity_n, intensity_p, speed] = fusion(SR_volume_n(:,:,:,k:k+3),SR_volume_p(:,:,:,k:k+3));
end

rendering(intensity_n, intensity_p, speed, output_CEUS,'MB_option',1);