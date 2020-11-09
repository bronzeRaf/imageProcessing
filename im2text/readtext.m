%Text Detector

%Takes image x of white backround and black text. Produces a cell array
%that contain in each cell the text of the image.
function lines = readtext(x)
    %encoder of index to letters
    code = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'];

    %get size of the image
    [M, N] = size(x);
    %fix the rotation to have horizontal text lines
    x = fixrotation(x);
    x = 1-x; %invert image to get white letters
    
    %make descriptions of all the letters in letters cell array
    letters = manageLetters();
    
    %get all the text lines in separate images
    imageLines = givemeline(x);
    %get number of lines in the image
    lineNumber = size(imageLines(:));
    
    %loop for every line of the text
    for i = 1:lineNumber
        clear imageWords;
        %get all the text words in separate images
        imageWords = givemeword(imageLines{i});
        %get number of words in the line
        [wordNumber, ~] = size(imageWords(:));
        %init counter of line character
        count = 1;
        %loop for every word of the line
        for j = 1:wordNumber
            clear imageLetter;
            %get all the word letters in separate images
            imageLetters = givemeletter(imageWords{j});
            %get number of letters in the word
            [letterNumber, ~] = size(imageLetters(:));
            
            %loop for every letter of the word
            for k = 1:letterNumber
                %get letter code
                index = givemechar(imageLetters{k}, letters);
                if index ~= 0
                    %get real letter writen
                    lines{i}(count) = code(index);
                    %next character
                    count = count+1;
                end
            end
            %change word with space
            lines{i}(count) = ' ';
            %next character
            count = count+1;
        end
    end
end

%Gets an image x with horizontal text and produces a cell array imageLines
%that contains separated images for every line of the text.
%Takes image of black backround and white text.
function imageLines = givemeline(x)
    %get size of the image
    [M, N] = size(x);
    
    countLine = 1;  %counter of lines
    flag = 0;       %counter of pixels for current line
    %loop for every row of pixels
    for i = 1:M
        if sum(x(i,:))>55 %check if row contains text (some white pixels)
            flag = flag+1;  %increase pixel line  
            %store row in the cell array in current line
            imageLines{countLine}(flag,:) = x(i,:);
            
        else %need to change line and skip black rows (without text)
            if flag>20  %check if we already filled the textline
                %reset pixel counter and change line
                flag = 0;
                countLine = countLine+1;
            end
        end
    end
end

%Gets an image x with one text line and produces a cell array imageWords
%that contains separated images for every word of the text.
%Takes image of black backround and white text.
function imageWords = givemeword(x)
    %get size of the image
    [M, N] = size(x);
    
    countWord = 1;  %counter of words
    flag = 0;       %counter of pixels for current word
    flag2 = 0;      %counter of sequencial black pixels 
    %loop for every column of pixels
    for i = 1:N
        if sum(x(:,i))>0 %check if row contains text (some white pixels)
            flag2 = 0;      %reset counter cause we found white (letter)
            flag = flag+1;  %increase pixel column  
            %store column in the cell array in current column
            imageWords{countWord}(:, flag) = x(:,i);
            
        else %need to change word and skip black columns (without text)
            flag2 = flag2+1; % increase counter of black columns
            %if we detect 15 sequential black columns after at least a little little white we change word 
            if flag2>15 && flag>15  %check if we already filled the textline
                %reset pixel counter and change line
                flag = 0;
                countWord = countWord+1;
            end
        end
    end
end

%Gets an image x with one text word and produces a cell array imageLetters
%that contains separated images for every letter of the word.
%Takes image of black backround and white text.
function imageLetters = givemeletter(x)
    %get size of the image
    [M, N] = size(x);
    %how many letters fit? every letter needs 35 pixels
    numberLetters = round(N/35);
    %loop for every letter
    for i = 1:numberLetters
        %start index
        start = (i-1)*35 + 1 ;
        %stop index
        stop = i*35;
        %avoid segmentation faults
        if stop > N
            stop = N;
        end
        %write letter to an image
        imageLetters{i}(:,:) = x(:, start:stop);
    end
    %if we got incorrectly a space without letters
    if numberLetters == 0
        imageLetters{1}=0;
    end
end

%Takes an image x that contains a letter and the description of all the 
%known letters named letters. Produces one code that point wich letter 
%from the known we detected.
%Takes image of black backround and white text.
function char = givemechar(xtemp, letters)
    %get size of the image
    [M, N] = size(xtemp);
    %size of letter will give 26x2 (english alphabet has 26 letters)
    letNum = 26;
    if xtemp == 0
        char = 0;
        return;
    end
    
    %expand letter backround adding 20x20 black pixels backround
    x = zeros(M+20,N+20);
    x(11:end-10,11:end-10) = xtemp;
    
    %get the preprocess on the image of the letter (inverted black and white)
    x = preprocessLetter(x);
    
    %invert image black and white
    x = 1-x;
    
    %get the description(s) of the letter we want to detect
    Rx = breakContours(x);
    %assume we have inner contour
    inner1 = 1;
    if Rx{2} == 0
        %we dont have inner contour, turn off the flag
        inner1 = 0;
    end
    %check if descriptor is empty (no letter exists)
    if isempty(Rx{1})
        %we dont have contour, not a letter
        char = 0;
        return;
    end
    score = zeros(letNum,1);
    for i = 1:letNum
        %assume we have inner contour in the checking letter
        inner2 = 1;
        if letters{i,2} == 0
            %we dont have inner contour in the checking letter, turn off the flag
            inner2 = 0;
        end
        if inner1 == inner2 %1 vs 1 or 2 vs 2 contours
            score(i) = getscore(Rx, letters{i,1}, letters{i,2});
            
        else %1 vs 2 contours
            %worst score cause the letters have different number of contours
            score(i) = -1;
        end
    end
    %find best match
    temp = find(score == max(score));
    %return code (index) of character
    char = temp(1);
end

%Gets 2 descriptions of 2 letters R1 (double for each contour) 
%and R2, R22 (2 for each contour) and returns the score of their
%similarity based on their MSE. Higher score means better similarity.
function s = getscore(R1, R2, R22)
    %interpolate R1{1} to fit to R2{1} to equalize their sizes
    r1 = R1{1};
    r2 = R2;
    %sizes
    [n1, ~] = size(r1(:));
    [n2, ~] = size(r2(:));
    %old sample vector
    old = 1:n1;
    %new sample vector
    new = linspace(1,n1,n2);
    %aplly interpolation (linear)
    r1 = interp1(old,r1,new);
    %get the MSE
    temp1 = immse(r1, r2);
    %check for fake empty mse and avoid divide with 0 (latter)
    if isempty(temp1)
        temp1 = 100000;
    end
    
    %same job for 2nd contour description (if is there)
    r1 = R1{2};
    r2 = R22;
    %check if we have 2nd contour
    tester = size(r1);
    if (r2 == 0)
        %we dont have
        temp2 = 0;
    else
        %check for 1 pointed fake contours (clean junks)
        if ((tester(1)<2) || (tester(2)<2))
            %we dont have contour
            temp2 = 0;
        else
            %we have... same job
            %sizes
            [n1, ~] = size(r1(:));
            [n2, ~] = size(r2(:));
            %old sample vector
            old = 1:n1;
            %new sample vector
            new = linspace(1,n1,n2);
            %aplly interpolation (linear)
            r1 = interp1(old,r1,new);
            %get the MSE
            temp2 = immse(r1, r2);
        end
    end
    %add the 2 MSEs
    temp = temp1 + temp2;
    %invert to get higher score as better
    s = 1/temp;
end

%Manages all the job we have to do to make all the descriptions of the
%letters we have saved in letter.mat. Returns a cell array letters that 
%contains all the descriptions from all the letters we had.
function letters = manageLetters()
    %required to load in workspace the l cell array with the letters
    %change to the valid path to gain compatibility
    %the path could be an argument in readtext but we follow the
    %instructions of the project
    load('C:\Users\Raft\Projects & Software\Image Processing Codec Projects\3\workspace\letters.mat');

    %get the description of every letter
    cells = 26; %we have english text with 26 characters
    %loop for every letter we need to describe
    for i = 1:cells
        %get the preprocess on the image of the letter (inverted black and white)
        %we get same preprocess for defined letter as for the unkown letter
        %to increase similarity
        letter = preprocessLetter(1-l{i});
        
        %get the contour description
        R = breakContours(letter);
        %store outter contour descrpription
        letters{i,1} = R{1};
        %store inner contour (if there is not store 0)
        letters{i,2} = R{2};
    end
end

%Takes an image of a letter named oldLetter and preprocesses the image to
%clean junks and to improve the quality of the contour(s) of the letter.
%Finally returns the improved image of the letter newLetter.
%Takes image of black backround and white text.
function newLetter = preprocessLetter(oldLetter)
    %image opening to clean area arround
    se = strel('line', 4, 90);
    oldLetter = imopen(oldLetter, se);
    %erose image to thin the letter
    oldLetter = imerode(oldLetter, se);
    
    %threshold the image of the letter to have only black and white
    newLetter = im2bw(oldLetter, 0.18);
end
