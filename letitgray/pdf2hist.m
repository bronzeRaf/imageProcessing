%Histogram calculator

%Calculates and normalizes a histogram h from the given pdf function
%pointer f, inside each space, as they are defined in d.
function h = pdf2hist(d, f)
    %take the number of 
    tempn = size(d(:))-1;
    n = tempn(1);
    %initialize histogramm vector (before normalization)
    hh = zeros(n);
    %loop for each level of intensity
    for i = 1:n
        %call integral to calculate the probabilities of the current space
        hh(i) = integral(f,d(i),d(i+1));
    end
    %normalize h to have sum(h)=1
    h = hh/sum(hh);
    
end
