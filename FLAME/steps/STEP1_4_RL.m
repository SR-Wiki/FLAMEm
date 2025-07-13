function [output,RL1_avg] = STEP1_4_RL(input, FWHM1, pixel, finter1, iter1)
output = zeros(size(input,1)*finter1, size(input,2)*finter1, ...
                  size(input,3)*finter1, size(input,4), 'single');
Ipsf1 = single(PSFget(pixel, finter1*FWHM1));
    
for i = 1:size(input,4)
    data = gpuArray(single(input(:,:,:,i)));
    data = data ./ max(data(:));
           
    data_fI = abs(single(fourierInterpolation(data, [finter1,finter1,finter1], 'both')));
    data_fI = gather(data_fI ./ max(data_fI(:))); 
            
    output(:,:,:,i) = gather(abs(RL3D(data_fI, Ipsf1, iter1, 1)));
    clear data data_fI;
end
RL1_avg = mean(output,4);
end
