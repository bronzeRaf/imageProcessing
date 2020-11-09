%PPM (from rgb) image encoder

%Encodes and saves an x rgb quantized image with maximum  pixel intensity 
%K as a ppm file with the given filename (full path).
%This function could overwrite any same named files.
function saveasppm(x, filename, K)
%start the timer
tic;

    [M, N, c] = size(x);
    %check if we have the intensities of the 3 colours (red, green, blue)
    assert(c == 3, 'Error with input image. Give RGB image and try again!');
    fileID = fopen( filename, 'w' ); %open file for writing
    %check if fopen works
    assert(c ~= -1, 'Error while creating the file. Check permissions or disk space and try again!');
    %check that K is valid
    assert(K >= 0 && K <= 65536, 'Wrong K parameter. K should belong to [0, 65536]!');
    
    %write the header in the file
    fprintf(fileID, 'P6 ' );
    fprintf(fileID, '%d %d ', N, M);
    fprintf(fileID, '%d\n', K); %maximum values
    
    %prepare data format and precision to write in the file the colours
    if K > 255
        format = 'uint16';
        precision = 'ieee-be';
    else
        format = 'uint8';
        precision = 'ieee-le';
    end
    
    %change dimensions of x to write faster (without for)
    x = permute(x,[3 2 1]); %order x as we wish for ppm needs
    fwrite(fileID, x(:, :, :), format, precision);
    
    fclose( fileID );
    
%stop the timer
elapsedTime = toc
end