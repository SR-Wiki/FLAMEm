function [output] = LDRC(im, Mask)
w = 50;
[xdim, ydim] = size(im);
output = zeros(xdim, ydim);
Fla = zeros(xdim, ydim);
FlaP = ones(w);
for i0 = 0:xdim-w;
    for i1 = 0:ydim-w;
        p = im(i0+[1:w],i1+[1:w]);
        p = p./max(p(:));
        output(i0+[1:w],i1+[1:w]) = output(i0+[1:w],i1+[1:w]) + p.* max(max(Mask(i0+[1:w],i1+[1:w])));
        Fla(i0+[1:w],i1+[1:w]) = Fla(i0+[1:w],i1+[1:w]) + FlaP;
        
    end
end
output = output./Fla;
end

