%Reads the given image and transforms the image to grayscale. It also 
%makes a figure of the histogram of the image.
%Comment out or uncomment lines to get the desired functionality
 
% photo = 'give your image path';
% 
% % Load image , and convert it to gray -scale
function x = read(photo)
	x = imread(photo);
	x = rgb2gray(x);
	x = double(x) / 255;
	% % % Show the histogram of intensity values
	[hn, hx] = hist(x(:), 0:1/255:1);
	% figure
	% bar(hx, hn)
	%figure
	%imshow(x)
end