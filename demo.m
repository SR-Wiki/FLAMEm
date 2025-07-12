%---------------------------------------------------------------------------
%   DEMO for FLAME
%---------------------------------------------------------------------------
clc;clear;close all;
addpath(genpath('FLAME'));
% ************************************************** USAGE *************************************************************************************************************************************
% Loading Data
%     For MAT files:
%         Load the target MAT file using the load function and rename the variable to input.
%         Example: input = load('target.mat');
%     For TIFF files:
%         Use the imRS function to load the target TIFF file.
%         Example: input = imRS('target.tif');
% Folder Structure
%     The folder 'Function_FLAME' contains the functions used in the demo.
% Parameter Settings
%     Necessary Parameters:
%         These are critical parameters that must be configured according to actual requirements.
%     Expert Parameters:
%         These are adjustable parameters that can optimize reconstruction results.
%         Note: Before modifying these, ensure you understand their underlying principles. 
%                  Otherwise, it is recommended to use default values.

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