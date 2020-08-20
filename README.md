# Automatic measurement of Newton rings diameter
This is semesteral thesis for course  called analysis of biomedical images. The images are from school microscope and are deteriorated by heavy noise. Some of this noise comes from environment of measurement, but the images are mostly deteriorated by working incorrectly with microscope or by dirtying the lenses and glass with hands.
The example of provided image is below.

<img src="https://github.com/koles289/Newton_rings/blob/master/blue_4x_2.png" width="440"> <img src="https://github.com/koles289/Newton_rings/blob/master/green_10x_3.png" width="440">


On the images we can see concentric circumferences under different light. The theory tells that by calculating the radius of circumferences, we can get the wavelength of used light. For more theory, you can read this article in wikipedia https://en.wikipedia.org/wiki/Newton%27s_rings.

The goal of this project is to determine in the most precise way the exact radius. This task is quite difficult due to heavy noise in images. The solution consist of following steps:
1. Preprocessing
a) RBG image is converted to grayscale
b) Contrast in image is adjusted using apriori information (function adapthisteq in main)
c) Mask is created in order to determine clearly dehraded pizel based on their Color Saliency
d) Heavily degraded pixels are restored using inpaint (inpaintnans)
e) Image is filtered using wavelet denoising (wtdenoise)
2. Binarization
a) Image is binarized using average
b) Image is processed using morphological operations of closing and opening
3. Measurement 
The integral part of measuremnt of radius of concentrich circunferences in determination of centrail point. This task is the biggest challenge in 

