function [output] = STEP3_2_RL(input, pixel, finter1, finter2, FWHM2, iter2, order)
Ipsf2 = single(PSFget(pixel,finter1*finter2*FWHM2));
input = double(input).^order;
input = gather(RL3D(input,Ipsf2.^order,iter2,1));
output = abs(input.^(1/order));
end