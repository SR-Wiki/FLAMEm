function  [output] = STEP2_2_BC(input1,input2)
for stack_z = 1:size(input1,3)
[output2] = LDRC(input1(:,:,stack_z), input2(:,:,stack_z)).*max(max(input2(:,:,stack_z)));
output(:,:,stack_z) = output2;
end
end