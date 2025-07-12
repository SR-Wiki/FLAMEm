function [output_CEUS, output_deconv_n, output_deconv_p] = FLAME_function(input, varargin)
% ***************************************************************************
% FLAME
% ***************************************************************************
% ******************************* USAGE *************************************
% Load the target mat file using load and change the variable name to input.
% Or use function imRS to load the target tif file. input = imRS('target');
% Folder 'Function_FLAME' contains the functions demo used.
% Necessary Parameters: Important parameters that must be set according to actual needs.
% Expert parameters: Some adjustable parameters that can optimize the reconstruction results. 
% Before adjusting, please ensure that you have a certain understanding of the principles related to the parameters, otherwise it is recommended to use default values.
%****************************** Workflow **********************************
% STEP1-1. Tissue signal filter
% STEP1-2. MB direction filter
% STEP1-3. Background filter
% STEP1-4. Pre deconvolution
% STEP1-5. MB density filter
% STEP2-1. High-order cumulant calculation
% STEP2-2. Intensity linearization 
% STEP3-1. Post multi-constraint deconvolution
% STEP3-2. Final data fusion
%****************************************************************************

%--------Necessary Parameters--------
% Parameter.SVD_option        |   Enable SVD filtering. {default: 0}
% Parameter.MB_option         |   Enable MB (multi-band) direction filtering. {default: 0}
% Parameter.pixel             |   Pixel size of input data (µm). {default: 60}
% Parameter.fidelity          |   Sparsity reconstruction fidelity (controls data fidelity term weight). {default: 200}
% Parameter.sparsity          |   Sparsity reconstruction strength (controls sparsity term weight). {default: 10}
% Parameter.FWHM2             |   Full-width half-maximum (FWHM) of post-deconvolution kernel (µm). {default: 240}
% Parameter.iter2             |   Number of post-deconvolution iterations. {default: 15}
%--------Expert parameters-------------
% Parameter.Stab_option       |   Remove unstable frames (e.g., due to breathing/heartbeat). {default: 1}
% Parameter.cutoff1           |   Low threshold for SVD filtering (range: 0–1). {default: 0.25}
% Parameter.cutoff2           |  High threshold for SVD filtering (range: 0–1). {default: 0.8}
% Parameter.BF_option1        |   Enable additional background filtering. Note: Significantly reduces speed. {default: 0}
% Parameter.finter1           |   First upsampling factor. Tips: Improves quality but reduces speed/increases memory. Increase only with proportional reduction in fidelity/sparsity. {default: 2}
% Parameter.FWHM1             |   FWHM of pre-deconvolution kernel (µm).  {default: 180}
% Parameter.iter1             |   Number of pre-deconvolution iterations. {default: 10}
% Parameter.hawk_option       |   Enable HAWK processing. Note: Improves quality but increases memory usage. {default: 0}
% Parameter.order             |   Autocorrelation order. Tips: Higher values improve resolution but reduce image continuity/linearity. {default: 6}
% Parameter.finter2           |   Second upsampling factor. {default: 2}
% Parameter.fidelity_z        |   Z-axis fidelity weight. Use 1 for isotropic data. {default: 1}
% Parameter.BF_option2        |   Secondary background filtering. Note: Significantly reduces speed. {default: 0}


% Necessary Parameters
Parameter.SVD_option = 0;
Parameter.MB_option = 0;
Parameter.pixel = 60;
Parameter.fidelity = 5;
Parameter.sparsity = 0.01;
Parameter.FWHM2 = 430;
Parameter.iter2 = 12;

% Expert parameters
Parameter.Stab_option = 1;
Parameter.cutoff1 = 0.25;
Parameter.cutoff2 = 0.8;
Parameter.BF_option1 = 0;
Parameter.finter1 = 1;
Parameter.FWHM1 = 300;
Parameter.iter1 = 5;
Parameter.hawk_option = 0;
Parameter.order = 6;
Parameter.finter2 = 2;
Parameter.fidelity_z = 1;
Parameter.BF_option2 = 0;

if nargin > 2
    Parameter =  read_params(Parameter, varargin);
end
%% mian
if Parameter.SVD_option == 1
[beSVD_avg, afterSVD_avg, output] = STEP1_1_SVD(input, Parameter.Stab_option, Parameter.cutoff1, Parameter.cutoff2);
output_CEUS = mean(abs(afterSVD_avg),4);
else 
output = input;
output_CEUS = mean(abs(output),4);
end
[output_n, output_p, output_n_avg, output_p_avg] = STEP1_2_MB(output, Parameter.MB_option);
[output_n] = STEP1_3_BF(output_n,Parameter.BF_option1);
[output_n,RL1_avg_n] = STEP1_4_RL(output_n, Parameter.FWHM1, Parameter.pixel, Parameter.finter1, Parameter.iter1);
[output_n, hawk_avg_n] = STEP1_5_hawk(output_n, Parameter.hawk_option);
[output_cum_n, output_ref] = STEP2_1_cumulant(output_n, Parameter.order);
[output_BC_n] = STEP2_2_BC(output_cum_n,output_ref);
[output_sparse_n] = STEP3_1_sparse(output_BC_n, Parameter.order, Parameter.fidelity, Parameter.fidelity_z, Parameter.sparsity, Parameter.finter2, Parameter.BF_option2);
[output_deconv_n] = STEP3_2_RL(output_sparse_n, Parameter.pixel, Parameter.finter1, Parameter.finter2, Parameter.FWHM2, Parameter.iter2, Parameter.order);

% if Parameter.SVD_option == 1
% imWS(beSVD_avg,['test_raw']);
% imWS(afterSVD_avg,['test_svd']);
% end
% 
% imWS(output_n_avg,['test_n_avg']);
% imWS(RL1_avg_n,['test_RL1_n']);
% imWS(hawk_avg_n,['test_hawk_n']);
% imWS(output_cum_n.^(1/Parameter.order),['test_SOFI_n']);
% imWS(output_BC_n.^(1/Parameter.order),['test_LDRC_n']);
% imWS(output_sparse_n,['test_sparse_n']);
% imWS(percennorm(output_deconv_n,0.5,99.995),['test_deconv_n']);
% imWS(permute(percennorm(output_deconv_n,0.5,99.995),[3 1 2]),['test_deconv_nT']);

if Parameter.MB_option == 1
[output_p] = STEP1_3_BF(output_p,Parameter.BF_option1);
[output_p, RL1_avg_p] = STEP1_4_RL(output_p, Parameter.FWHM1, Parameter.pixel, Parameter.finter1, Parameter.iter1);
[output_p, hawk_avg_p] = STEP1_5_hawk(output_p, Parameter.hawk_option);
[output_cum_p, output_ref] = STEP2_1_cumulant(output_p, Parameter.order);
[output_BC_p] = STEP2_2_BC(output_cum_p, output_ref);
[output_BC_p] = STEP1_3_BF(output_BC_p,Parameter.BF_option2);
[output_sparse_p] = STEP3_1_sparse(output_BC_p, Parameter.order, Parameter.fidelity, Parameter.fidelity_z, Parameter.sparsity, Parameter.finter2, Parameter.BF_option2);
[output_deconv_p] = STEP3_2_RL(output_sparse_p, Parameter.pixel, Parameter.finter1, Parameter.finter2, Parameter.FWHM2, Parameter.iter2, Parameter.order);

% imWS(output_p_avg,['test_p_avg']);
% imWS(RL1_avg_p,['test_RL1_p']);
% imWS(hawk_avg_p,['test_hawk_p']);
% imWS(output_cum_p.^(1/order),['test_SOFI_p']);
% imWS(output_BC_p.^(1/order),['test_LDRC_p']);
% imWS(output_sparse_p,['test_sparse_p']);
% imWS(percennorm(output_deconv_p,0.5,99.995),['test_deconv_p']);
% imWS(permute(percennorm(output_deconv_n,0.5,99.995),[3 1 2]),['test_deconv_nT']);
else 
[output_deconv_p] = [output_deconv_n];
end




