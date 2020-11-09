%Before running this script be sure you have the desired image loaded in the variable x

%Makes the intensity levels and the histogram and prints results of the 
%images in 3 desired cases. Cases 1,2,3 are made as shown in the comments.
%Uses pdf functions from unf1.m, unf2.m and normf.m files.
%Comment out or uncomment lines to get the desired functionality.


L = 60; %how many spaces? Change L to decide

% 1) same sized intensity spaces
d = linspace(0, 1, L+1);    %create L equal sized intensity spaces

v = zeros(1,L); %init v for faster memory allocation
%get the middle of each space as a v level value
for i = 1:L
    v(i) = (d(i)+d(i+1))/2;
end

% % Case 1
%uniform [0,1]
% f1 = @unf1;
% ht = pdf2hist(d, f1);

% % Case 2
%uniform [0,2]
% f2 = @unf2;
% ht = pdf2hist(d, f2);

% Case 3
%normal with mean = 0.5 and standart deviation = 0.1
f3 = @normf;
ht = pdf2hist(d, f3);

%print
y = histtransform(x, ht, v);
[hnn, hy] = hist(y(:), 0:1/255:1);
figure
bar(hy, hnn)
figure
imshow(y)