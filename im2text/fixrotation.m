%Fix Rotation

%Finds the rotation of an input image x that contains text so the output y
%will be an image with horizontal text.
function y = fixrotation(x)
    %invert image to get white letters
    x = 1-x;
    
    %Part 1 : Make an estimation of the rotation
    %dilation to straigt horizantal lines across the text lines
    %0 is assumption (we assume that the rotation must be small)
    %80 was found experimentally after tunning
    se = strel('line',80,0); 
    y = imdilate(x, se);
    %erosion to straigth horizantal lines
    %0 come from the same assumption as in dilation above
    %180 was found experimentally after tunning
    se = strel('line',180,0);
    y = imerode(y, se);
    %DFT and shift
    fy = fft2(y);
    fy = fftshift(fy);
    %magnitude of fourier transform
    absfy = abs(fy);
    %find the peak of the DFT magnitude
    peak = max(absfy(:));
    %threshold at 25% of the peak
    fy(fy < (peak*0.25)) = 0;
    %add 1 to avoid log(0) and make the factor
    absfy = 1+abs(fy);
    c = 255/log(1+peak);
    logfy = c*log(absfy);
    %get scaled and smoothed peak
    sclaedPeak = max(logfy(:));
    %indices of scaled factors bigger than 90% of the max scaled peak
    [row, col] = find(logfy>sclaedPeak*0.9);
    %min and max rows and cols
    mincol = min(col);
    maxcol = max(col);
    minrow = min(row);
    maxrow = max(row);
    %at last find the angle estimation in degrees
    dy = maxcol-mincol;
    dx = maxrow-minrow;
    theta = atan(dy/dx);
    theta = rad2deg(theta);

    %Part 2 : Fix of the estimation (with serial search)
    totalMax = 0; %start the max value from 0 (lower than other values)
    %loop for every possible angle of rotation
    for i = -4:0.1:4
        fixTheta = theta + i; %change theta to check if it is better
        rot = imrotate(y, -fixTheta)';  %rotate image to fix it (maybe)
        curMax = max(sum(rot(:,:)));    %max column sum of the fixed image
        if curMax > totalMax            %if this fix is better
            totalMax = curMax;          %keep the max value
            iMax = i;                   %and angle fix
        end
    end

    %fix the angle (just a better estimation is acceptable)
    theta = theta+iMax;
    
    %rotate the image to fix it
    y = imrotate(x, -theta);
    %invert back the image
    y = 1-y;
end