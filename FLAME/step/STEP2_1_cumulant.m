function [output, output_ref] = STEP2_1_cumulant(input, order)
    data = single(input);
    value = abs(data - 1 * mean(data,4));
    output_ref = abs(cumulant0(value, 2));
    % sofi
    data = input;
    value = abs(data - 1 * mean(data,4));
    data3 = abs(cumulant0(value, order));
    output = gather(data3);
end