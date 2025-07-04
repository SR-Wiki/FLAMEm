function [beSVD_avg, afterSVD_avg, output] = STEP1_1_SVD(input, Stab_option, cutoff1, cutoff2)
    beSVD_avg = mean(abs(input(:,:,:,:)),4);
    if Stab_option == 1
        data_Stab = single(batchStab(input));
    else
        data_Stab = single(beSVD_avg(:,:,:,:));
    end
    [ius_svd,output] = batchSVD3(data_Stab,ceil(cutoff1.*size(data_Stab,4)),floor(cutoff2.*size(data_Stab,4)));
    afterSVD_avg = mean(abs(output(:,:,:,:)),4);
    output = double(output);
end


