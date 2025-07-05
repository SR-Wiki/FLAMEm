function [a,b,c] = calc_line_eq(x1,y1,x2,y2)
a = y2-y1;
b = x1-x2;
c = x2*y1 - x1*y2;
end