
# imageProcessing
A set of image processing projects in MATLAB.

## Bayer

A set of functions, able to transform a Bayer image to an RGB one. The project supports scaling of the image into a new resolution. There are 2 available algorithms for color selection, the nearest neighbor and the weighted mean of the neighborhood. The project also supports quantization and dequantization of the image. In the "example" folder you can find an example set of images, one Bayer and their products using the project, a 3 bit per color RGB one and an 8 bit per color RBG one. 

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

- To save an image in a PPM encoded format run:
```saveasppm(quanted, name, levels);```
	- quanted = the quanted image
	- name = the name of the output folder
	- levels = the maximum pixel intensity of the quanted image (f.e. 255 for 255 levels of color and 8 bits per color) 

## Letitgray
A set of functions, able to transform a colored image to a grayscale one allowing the user to select the brightness levels of the output. The project provides point transformation as long as histogram transformation. It also provides a probability density function to histogram transformation, to let the user transform an image given a probability density function. The project visualizes histograms and image previews to help the user. 

#### To run the project features use the following...
- To transform an image using a point transformation of 3 linear parts run:
```y = pointtransform(x, x1, y1, x2, y2);```
	- x = the input image
	- x1 = the lower border
	- y1 = the value assigned to pixels with brightness lower than the lower level
	- x2 = the upper border
	- y2 = the value assigned to pixels with brightness higher than the upper level

- To transform an image using a histogram transformation run:
```y = histtransform(x, h, v);```
	- x = the input image
	- h = probabilities of the intensity levels
	- v = histogram intensity levels
	
- To calculate a desired histogram for an image, based on a probability density function run:
```h = pdf2hist(d, f);```
	- d = the density level spaces
	- f = a pointer to a probability density function
	
- To read a colored image and to convert it to a grayscale one run:
```x = read(photo);```
	- photo = the file name of the phot including the path

- The project come with 2 probability density functions. To obtain their pointers run: 
```f = @unf1;```
	- for uniform density function in the space of [0,1]

	```f = @unf2;```
	- for uniform density function in the space of [0,2]

	```f = @normf;```
	- for normal density function of mean 0.5 and standard deviation of 0.1

#### Examples
In the folder "examples" you can find an input image named "example.jpg" and a set of example photos, given through the following code. We assume that the "example.jpg" is loaded into the workspace in a variable named x.
- Running the images1.m script you obtain the:
	- ex1case1.jpg if you uncomment the Case 1 code block
	- ex1case2.jpg if you uncomment the Case 2 code block

- Running the images2.m script you obtain the:
	- ex2case1.jpg if you uncomment the Case 1 code block
	- ex2case2.jpg if you uncomment the Case 2 code block
	- ex2case3.jpg if you uncomment the Case 3 code block

- Running the images3.m script you obtain the:
	- ex3case1.jpg if you uncomment the Case 1 code block
	- ex3case2.jpg if you uncomment the Case 2 code block
	- ex3case3.jpg if you uncomment the Case 3 code block

## Im2Text
A set of functions, able to transform an image containing rotated text to text. The project is able to rotate the image to fit text on an horizontal orientation, to divide text into words and letters and to classify letter images. 

#### To run the project features use the following...

- To transform an image containing black text on white background, to a cell array containing the text of each text line of the image run:
```lines = readtext(x);```
	- x = the input image
	
- To rotate an image containing black text on white background, to have the text on a horizontal orientation run:
```y = fixrotation(x);```
	- x = the input image
	
- To divide an image containing black text on white background, to a cell array containing separate images for every text line run:
```imageLines = givemeline(x);```
	- x = the input image

- To divide an image containing a black text line on white background, to a cell array containing separate images for every word run:
```imageWords = givemeword(x);```
	- x = the input image

- To divide an image containing a black text word on white background, to a cell array containing separate images for every letter run:
```imageLetters = givemeletter(x);```
	- x = the input image

#### Examples
In the "examples" folder you can see an example input image named "example.png". 
- rotated.png = The result image after the rotation using fixrotation(x)
- line.png = A sample image after the line separation using givemeline(x)
- word.png = A sample image after the word separation using givemeword(x)
- letter.png = A sample image after the letter separation using givemeletter(x)
