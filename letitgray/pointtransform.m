%Point Trasform

%Transforms the brightness intensity of the given image X.
%The transformation function consists of 3 linear parts, based on x1, x2 
%and y1, y2 values.
function Y = pointtransform(X, x1, y1, x2, y2)
    %find slope for each of the 3 lines
    a = y1/x1;
    b = (y2-y1)/(x2-x1);
    c = (1-y2)/(1-x2);
    %initialize output
    Y = X;
    %1st linear area y = ax
    Y(X<x1) = a*Y(X<x1);
    %2nd linear area y = b(x - x1) + y1
    Y(X>=x1 & X<x2) = b*(Y(X>=x1 & X<x2)-x1)+y1;
    %3rd linear area y = c(x - x2) + y2
    Y(X>=x2) = c*(Y(X>=x2)-x2)+y2;
end