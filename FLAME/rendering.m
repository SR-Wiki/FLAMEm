function rendering_function(intensity_n, intensity_p, speed, output_CEUS, varargin)

Parameter.MB_option = 0;

if nargin > 4
    Parameter =  read_params(Parameter, varargin);
end

if Parameter.MB_option == 0
rendering_single(intensity_n, speed, output_CEUS);
else if Parameter.MB_option == 1
rendering_dual(intensity_n, intensity_p, speed, output_CEUS);
    end
end
end