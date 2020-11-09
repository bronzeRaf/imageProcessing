
# imageProcessing
A set of image processing projects in MATLAB.

## Bayer

A set of functions, able to transform a Bayer image to an RGB one. The project supports scaling of the image into a new resolution. There are 2 available algorithms for color selection, the nearest neighbor and the weighted mean of the neighborhood. The project also supports quantization and dequantization of the image.

#### To run the project features use the following..
- To transform a Bayer image to an RGB one and scale it to a new resolution run:
```ImageRGB = bayer2rgb(imageBayer, x, y, algorithm);```
	- imageBayer = the Bayer image
	- x = the width resolution in pixels
	- y = the height resolution in pixels
	- algorithm = the algorithm used for color selection ('nearest' for nearest neighbor or 'linear' for weighted mean of the pixel's neighborhood)

- To quantize an image to specific color levels run:
```quanted = imagequant(img, r, g, b);```
	- img = the image
	- r = the multiplicative inverse of the desired levels of the red color after the quantization (f.e. 1/7 for 7 levels of color and 3 bits per color) 
	- g = the multiplicative inverse of the desired levels of the green color after the quantization (f.e. 1/7 for 7 levels of color and 3 bits per color) 
	- b = the multiplicative inverse of the desired levels of the blue color after the quantization (f.e. 1/7 for 7 levels of color and 3 bits per color) 

- To dequantize an image from specific color levels run:
```dequanted = imagedequant(quanted, r, g, b);```
	- quanted = the quanted image
	- r = the multiplicative inverse of the desired levels of the red color after the dequantization (f.e. 1/7 for 7 levels of color and 3 bits per color) 
	- g = the multiplicative inverse of the desired levels of the green color after the dequantization (f.e. 1/7 for 7 levels of color and 3 bits per color) 
	- b = the multiplicative inverse of the desired levels of the blue color after the dequantization (f.e. 1/7 for 7 levels of color and 3 bits per color) 

- To save an image as a PPM run:
```saveasppm(quanted, name, levels);```
	- quanted = the quanted image
	- name = the name of the output folder
	- levels = the number of levels of the colors of the quanted image (f.e. 255 for 255 levels of color and 8 bits per color) 




