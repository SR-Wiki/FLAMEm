function [intensity1, intensity2, speed] = fusion_function(input1,input2)
% ***************************************************************************
% FLAME_fusion
% ***************************************************************************
% ******************************* USAGE *************************************
% Input more than four super-resolution volumes to obtain intensity and velocity results.
%****************************************************************************
intensity1 = mean(input1,4);
intensity2 = mean(input2,4);
speed1 = std(input1,0,4);
speed2 = std(input2,0,4);
speed = (speed1 + speed2)./2;
end




