function [output_n, output_p, output_n_avg, output_p_avg] = STEP1_2_MB(input, MB_option);

if MB_option ==1; 
    wn = 7;
    window = hanning(wn);
    %% MB 
    for j = 1:size(input,3)
        data = zeros(size(input,1),size(input,2),size(input,4));
        data(:,:,:) = squeeze((((input(:,:,j,:)))));
    temp = reshape(data,[size(data,1).*size(data,2),size(data,3)]);
    
    pos = zeros(size(temp,2),1);
    neg = zeros(size(temp,2),1);
    pos(1:round(size(temp,2)/2)) = 1;
    neg(round(size(temp,2)/2+1):round(size(temp,2))) = 1;
    
    
    pos = conv(pos,window,'same');
    pos = pos./max((pos));
    neg = conv(neg,window,'same');
    neg = neg./max((neg));
    pos = repmat(pos,1,size(temp,1));
    neg = repmat(neg,1,size(temp,1));
    
        tempfft = (fftshift(fft(temp,[],2)));
        tempfft1 = tempfft.*pos';
        tempfft2 = tempfft.*neg';
        tempfft3 = single(abs(ifft(ifftshift(tempfft1),[],2)));
        tempfft4 = single(abs(ifft(ifftshift(tempfft2),[],2)));
    
    result3 = reshape(abs(tempfft3),[size(data,1),size(data,2),size(data,3)]);
    result4 = reshape(abs(tempfft4),[size(data,1),size(data,2),size(data,3)]);
    
    output_p(:,:,j,:) = single(result3);
    output_n(:,:,j,:) = single(result4);
    end
    
    output_n_avg = mean(output_n,4);
    output_p_avg = mean(output_p,4);
else
    output_n = abs(input);
    output_p = abs(input);
    output_n_avg = mean(output_n,4);
    output_p_avg = mean(output_p,4);
end
end
