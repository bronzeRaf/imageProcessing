%Before running this script be sure you have the desired image loaded in the variable x

%Makes the intensity levels and the histogram and prints results of the 
%images in 3 desired cases. Cases 1,2,3 are made as shown in the comments.
%Comment out or uncomment lines to get the desired functionality.

% Case 1
%given uniform histogram transform parameters
% L = 10;
% v = linspace(0, 1, L);
% h = ones([1, L]) / L;

% Case 2
%given uniform histogram transform parameters
L = 20;
v = linspace(0, 1, L);
h = ones([1, L]) / L;

% Case 3
%given normal histogram transform parameters
% L = 10;
% v = linspace(0, 1, L);
% h = normpdf(v, 0.5) / sum(normpdf(v, 0.5));

% print
y = histtransform(x, h, v);
[hnn, hy] = hist(y(:), 0:1/255:1);
figure
bar(hy, hnn)
figure
imshow(y)