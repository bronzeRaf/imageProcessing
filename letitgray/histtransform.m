%Histogram transformation 

%Transforms an input image X to an output image Y based on its given
%histogram intensity levels v and probabilities h (of the levels). The
%images have only one channel (grayscale).
function Y = histtransform(X, h, v)
    %define accuracy of sum(h) == 1
    eps = 0.001;
    %get resolution of the given image
    [reso1, reso2] = size(X);
    %get the total number of pixels of the given image
    pixels = reso1*reso2;
    n = size(h(:));
    
    %check for vector size error
    if size(v(:)) ~= n
        error('h,v must have equal size');
    end
    %limit negative probability values to zero
    h(h<0) = 0;
    %check for non 1 summary of probabilities error
    %todo sum(h)-eps for almost =
    if (sum(h(:)) > 1 + eps) || (sum(h(:)) < 1 - eps)
        sum(h(:))
        error('summary of histogram probabilities should be equal to 1');
    end
    
    Y = X;
    %start the loop of the intensity matching
    for i = 1:n     %each level of intensiti v(i)
        %initialize before the loop
        count = 0;  %number of pixels matched in current intensity level
        prob = 0;   %count/pixels (pdf value for current intensity)
        
        while prob<h(i)         %current level of intensity is not full
            count = count + 1;  %iteration counter increase
            [minValue, minIndex] = min(X(:));
            if minValue == 2    %check if all the pixels matched
                break;
            end
            %match current min value with current accepted value
            Y(minIndex) = v(i);
            %kick out current min value to go to the next one (2 > max)
            X(minIndex) = 2;
            %update current probability
            prob = count/pixels;
        end
    end
    
end