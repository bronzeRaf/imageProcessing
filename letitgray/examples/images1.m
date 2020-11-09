%Before running this script be sure you have the desired image loaded in the variable x

%Transforms pointly the intensity levels and prints results of the 
%images in 2 desired cases. Cases 1,2 are made as shown in the comments.
%Comment out or uncomment lines to get the desired functionality.

% Case 1
%given point transform values
% y = pointtransform(x, 0.1961, 0.0392, 0.8039, 0.9608);

% Case 2
%threshold at 0.5 point transform
y = pointtransform(x, 0.5, 0, 0.5, 1);  

%print
[hnn, hy] = hist(y(:), 0:1/255:1);
figure
bar(hy, hnn)
%figure
% imshow(y)