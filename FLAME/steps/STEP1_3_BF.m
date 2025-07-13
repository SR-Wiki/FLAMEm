function  [output] = STEP1_3_BF(input,BF_option1)
if BF_option1 ~= 0
    backgrounds= background_estimation(input.*BF_option1,1,5,'coif3',3);
    backgrounds(backgrounds<0)=0;
    output = input-backgrounds;
    output(input<0)=0;
    output = abs(output);
else
    output = abs(input);
end
end