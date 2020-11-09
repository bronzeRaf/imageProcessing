%Bayer to RGB image

%Bayer filter input xb to RGB true colour resized MxN image maker.
%Interpolation works with "nearest" (Nearest Neighbour) or "linear" 
%(Billinear) method.
function xc = bayer2rgb(xb, M, N, method)
%start the timer
tic;

    %create Red Green and Blue empty grids with desired dimensions
    %inside the 3 submatrices of xc
    xc = zeros(M,N,3);
    
    [M0, N0] = size(xb);
    
    SR = M0 / M;
    SC = N0 / N;
    %grid with row and column pair indices
    [cf, rf] = meshgrid(1 : N, 1 : M);
    %transform indices to show on the closer row and column from the input 
    %image before rezise regardless of pixel's colour
    rf = rf * SR;
    cf = cf * SC;
    r = floor(rf);
    c = floor(cf);
    %border the indices
    r(r < 1) = 1;
    c(c < 1) = 1;
    r(r > M0 - 1) = M0;
    c(c > N0 - 1) = N0;
    
    delta_R = abs(rf - r);
    delta_C = abs(cf - c);
    
    %check method type
    if strcmp(method, 'nearest')
        %get the nearest neighbor grid depending on pixel's colour
        [redRowGrid, redColgrid] = redGrid(r,c,M,N);
        [greenRowGrid, greenColgrid] = greenGrid(r,c,M,N);
        [blueRowGrid, blueColGrid] = blueGrid(r,c,M,N);
        %fill in the matrix with the colour indexed in the grids
        xc(:,:,1) = NearestColour(redRowGrid, redColgrid, xb);
        xc(:,:,2) = NearestColour(greenRowGrid, greenColgrid, xb);
        xc(:,:,3) = NearestColour(blueRowGrid, blueColGrid, xb);
    elseif strcmp(method, 'linear')
        %interpolate the pixels based on the grid indexing
        xc(:,:,1) = billinearRed(r, c, xb);
        xc(:,:,2) = billinearGreen(r, c, xb);
        xc(:,:,3) = billinearBlue(r, c, xb);
    else
        %non supported method of interpolation
        error('unknown method... run again with linear or nearest as parameter')
    end

%stop the timer
elapsedTime = toc
end

%Produces the grid with the indexes of nearest red pixel for each pixel.
function [grid1, grid2] = redGrid(r, c, M, N)
    grid1 = r;
    grid2 = c;
    %odd rows take red sample from next row nearest neighbor
    for i = 1:M-1
        if mod(grid1(i,1),2) ~= 0
            grid1(i,1:N) = r(i,1) + 1;
        end
    end
    %last row takes red sample from previous row nearest neghbor
    if mod(grid1(M,1),2) ~= 0
        grid1(M,1:N) = r(M,1) - 1;
    end
    %even columns take red sample from previous column nearest neighbor
    for i = 2:N
        if mod(grid2(1,i),2) == 0
            grid2(1:M,i) = c(1,i) - 1;
        end
    end
end

%Produces the grid with the indexes of nearest green pixel for each pixel.
function [grid1, grid2] = greenGrid(r, c, M, N)
    grid1 = r;
    grid2 = c;
    
    for i = 1:M
        for j = 1:N
        %odd rows and even columns take green sample from previous column
            if mod(grid1(i,j),2) ~= 0
                if mod(grid2(i,j),2) == 0
                    grid2(i,j) = grid2(i,j) - 1;
                end
         %even rows and odd columns take green sample from previous row
            else
                if mod(grid2(i,j),2) ~= 0
                    grid1(i,j) = grid1(i,j) - 1;
                end
            end
        end
    end
end

%Produces the grid with the indexes of nearest blue pixel for each pixel.
function [grid1, grid2] = blueGrid(r, c, M, N)
    grid1 = r;
    grid2 = c;
    %even rows take blue sample from previous row nearest neighbor
    for i = 2:M
        if mod(grid1(i,1),2) == 0
            grid1(i,1:N) = r(i,1) - 1;
        end
    end
    %odd columns take blue sample from next column nearest neighbor
    for i = 1:N-1
        if mod(grid2(1,i),2) ~= 0
            grid2(1:M,i) = c(1,i) + 1;
        end
    end
    %last row takes blue sample from previous row nearest neghbor
    if mod(grid2(1,N),2) ~= 0
        grid2(1:M,N) = c(1,N) - 1;
    end
end

%Fills the sample matrix of the new image (from the input image) with 
%the indexes given in the grids.
function C = NearestColour(grid1, grid2, xb)
    [M, N] = size(grid1);
    C = zeros(M,N);
    %just take copy the sample into the right place
    for i = 1:M
        for j = 1:N
            index1 = grid1(i,j);
            index2 = grid2(i,j);
            C(i,j) = xb(index1,index2);
        end
    end
end

%Gives the sample matrix for the red intensity after billinear 
%interpolation on the input image.
function C = billinearRed(rg, cg, xb)
    [ M, N ] = size (rg);
    [ M0, N0 ] = size (xb);
    C = zeros(M,N);
    %croos every pixel
    for i = 1:M
        for j = 1:N
            if mod(rg(i,j),2) == 0      %check index row
                if mod(cg(i,j),2) == 0  %check index column
                    %interpolation needed
                    %left neighbor pixel
                    index1 = rg(i,j);
                    index2 = cg(i,j) - 1;
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                    %right neighbor pixel
                    index2 = cg(i,j) + 1;
                    if index2 > N0  %out of bounds
                        index2 = N0-1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                else                    %check index column
                    %copy real value
                    index1 = rg(i,j);
                    index2 = cg(i,j);
                    C(i,j) = xb(index1,index2);
                end
            else                        %check index row
                if mod(cg(i,j),2) == 0  %check index column
                    %interpolation needed 1
                    %left up neighbor pixel
                    index1 = rg(i,j) - 1;
                    if index1 == 0  %out of bounds
                        index1 = 2;
                    end
                    index2 = cg(i,j) - 1;
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    %right up neighbor pixel
                    index2 = cg(i,j) + 1;
                    if index2 > N0  %out of bounds
                        index2 = N0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    %left down neighbor pixel
                    index1 = rg(i,j) + 1;
                    if index1 > M0  %out of bounds
                        index1 = M0 - 1;
                    end
                    index2 = cg(i,j) - 1;
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    %right down neighbor pixel
                    index2 = cg(i,j) + 1;
                    if index2 > N0  %out of bounds
                        index2 = N0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    
                else                    %check index column
                    %interpolation needed 2
                    %up neighbor pixel
                    index1 = rg(i,j) - 1;
                    if index1 == 0  %out of bounds
                        index1 = 2;
                    end
                    index2 = cg(i,j);
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                    %down neighbor pixel
                    index1 = rg(i,j) + 1;
                    if index1 > M0  %out of bounds
                        index1 = M0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                end
            end
        end
    end
end

%Gives the sample matrix for the green intensity after billinear 
%interpolation on the input image.
function C = billinearGreen(rg, cg, xb)
    [ M, N ] = size (rg);
    [ M0, N0 ] = size (xb);
    C = zeros(M,N);
    
    for i = 1:M
        for j = 1:N
            %check index column and row
            if ((mod(rg(i,j),2) ~= 0) && (mod(cg(i,j),2) == 0)) || ((mod(rg(i,j),2) == 0) && (mod(cg(i,j),2) ~= 0))
                %interpolation needed
                %up neighbor pixel
                index1 = rg(i,j) - 1;
                if index1 == 0  %out of bounds
                    index1 = 2;
                end
                index2 = cg(i,j);
                C(i,j) = C(i,j) + xb(index1,index2)/4;
                %down neighbor pixel
                index1 = rg(i,j) + 1;
                if index1 > M0  %out of bounds
                    index1 = M0 - 1;
                end
                index2 = cg(i,j);
                C(i,j) = C(i,j) + xb(index1,index2)/4;
                %left neighbor pixel
                index1 = rg(i,j);
                index2 = cg(i,j) - 1;
                if index2 == 0  %out of bounds
                    index2 = 2;
                end
                C(i,j) = C(i,j) + xb(index1,index2)/4;
                %right neighbor pixel
                index1 = rg(i,j);
                index2 = cg(i,j) + 1;
                if index2 > N0  %out of bounds
                    index2 = N0 - 1;
                end
                C(i,j) = C(i,j) + xb(index1,index2)/4;
            else
                %copy real value
                index1 = rg(i,j);
                index2 = cg(i,j);
                C(i,j) = xb(index1,index2);
            end
        end
    end
end

%Gives the sample matrix for the blue intensity after billinear 
%interpolation on the input image.
function C = billinearBlue(rg, cg, xb)
    [ M, N ] = size (rg);
    [ M0, N0 ] = size (xb);
    C = zeros(M,N);
    
    for i = 1:M
        for j = 1:N
            if mod(rg(i,j),2) ~= 0      %check index row
                if mod(cg(i,j),2) ~= 0  %check index column
                    %interpolation needed
                    %left neighbor pixel
                    index1 = rg(i,j);
                    index2 = cg(i,j) - 1;
                    if index2 == 0  %out of bounds
                        index2 = 2;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                    %right neighbor pixel
                    index2 = cg(i,j) + 1;
                    if index2 > N0  %out of bounds
                        index2 = N0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                else                    %check index column
                    %copy real value
                    index1 = rg(i,j);
                    index2 = cg(i,j);
                    C(i,j) = xb(index1,index2);
                end
            else                        %check index row
                if mod(cg(i,j),2) ~= 0  %check index column
                    %interpolation needed 1
                    %left up neighbor pixel
                    index1 = rg(i,j) - 1;
                    index2 = cg(i,j) - 1;
                    if index2 == 0  %out of bounds
                        index2 = 2;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    %right up neighbor pixel
                    index2 = cg(i,j) + 1;
                    if index2 > N0  %out of bounds
                        index2 = N0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    %left down neighbor pixel
                    index1 = rg(i,j) + 1;
                    if index1 > M0  %out of bounds
                        index1 = M0 - 1;
                    end
                    index2 = cg(i,j) - 1;
                    if index2 == 0  %out of bounds
                        index2 = 2;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    %right down neighbor pixel
                    index2 = cg(i,j) + 1;
                    if index2 > N0  %out of bounds
                        index2 = N0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/4;
                    
                else                    %check index column
                    %interpolation needed 2
                    %up neighbor pixel
                    index1 = rg(i,j) - 1;
                    index2 = cg(i,j);
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                    %down neighbor pixel
                    index1 = rg(i,j) + 1;
                    if index1 > M0  %out of bounds
                        index1 = M0 - 1;
                    end
                    C(i,j) = C(i,j) + xb(index1,index2)/2;
                end
            end
        end
    end
end