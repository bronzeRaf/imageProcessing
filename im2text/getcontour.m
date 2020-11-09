%Contour modeling for a letter

%Gets an image x containing a letter and produces its contour model c.
function c = getcontour(x)
    %invert image to get white letters
    x = 1-x;
    
    %dilation to a disk arround the letter
    %5 was found experimentally after tunning
    se = strel('disk',1);
    dil = imdilate(x, se);
    %dilation - original letter gives the contour
    c = dil-x;
    %thinning of the found edge (contour of the letter)
    c = bwmorph(c,'thin',Inf);

    %invert back the image
    c = 1-c;
end