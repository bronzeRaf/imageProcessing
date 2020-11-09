%Description maker for a contour of a letter

%Gets a whole letter named letter and gives back a cell array R with the
%description of this letter for the outter and (if is there) for the inner
%contour of the letter.
%Takes image of white backround and black text.
function R = breakContours(letter)
    con = getcontour(letter);  %foul contour of the letter
    con = 1-con;               %inverse black and white
    
    %Manage the outer contour
    filled = imfill(con, 'holes'); %fill holes of the letter
    %small erosion to exclude outer contour from the filled letter
    se = strel('disk',1);
    filled = imerode(filled, se);
    %keep only outter contour and drop the other
    outter = con-filled;
    outter(outter<0)=0;     %limit negative pixels to zero
    %get the description of the outter contour (inverted black white)
    R{1} = describeLetter(1-outter);
    
    %Manage the inner contour (if the letter has)
    %check if is there any inner contour
    if con == outter
        %there no inner contour to manage, store 0
        R{2} = 0;
    else
        %inner is the whole contour except the outter contour
        inner = con-outter;
        inner(inner<0)=0;   %limit negative pixels to zero
        %get the description of the inner contour (inverted black white)
        R{2} = describeLetter(1-inner);
    end
end

%Gets a single contour con (only the inner or only the outter one) of a
%letter and produces the description R as the fourier transform of a 
%complex number array.
%Takes image of white backround and black text.
function R1 = describeLetter(con)
    %get size of the letter's contour
    [m, n] = size(con);
    k = 1; %counts how many pixels belongs to the countour
    %initialize real and imaginary part of the description
    a = zeros(1);
    b = zeros(1);
    %double loop for each pixel
    for i = 1:m
        for j = 1:n
            %store indices of every non white pixel
            if con(i,j) < 1
                a(k) = i;
                b(k) = j;
                k = k+1;
            end
        end
    end
    %make complex sequense
    r = complex(a,b);
    %get fft
    tempR1 = fft(r);
    %return description of the contour (exlude DC coefficient)
    R1 = tempR1(2:end);
end