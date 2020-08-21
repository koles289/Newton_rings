# Automatic measurement of Newton rings diameter
This is semesteral thesis for course  called analysis of biomedical images. The images are from school microscope and are deteriorated by heavy noise. Some of this noise comes from environment of measurement, but the images are mostly deteriorated by working incorrectly with microscope or by dirtying the lenses and glass with hands.
The example of provided image is below.<br>

<p align="center">
<img src="https://github.com/koles289/Newton_rings/blob/master/blue_4x_2.png" width="370" align="left" > <img src="https://github.com/koles289/Newton_rings/blob/master/green_10x_3.png" width="370" align="right" >
</p>


<br>On the images we can see concentric circumferences under different light. The theory tells that by calculating the radius of circumferences, we can get the wavelength of used light. For more theory, you can read this article in wikipedia https://en.wikipedia.org/wiki/Newton%27s_rings.

The goal of this project is to determine in the most precise way the exact radius. This task is quite difficult due to heavy noise in images. The solution consist of following steps:<br>
  <b>1. Preprocessing</b>
  <ul>
  <li>a) RBG image is converted to grayscale
  <li>b) Contrast in image is adjusted using apriori information (function adapthisteq in main)
  <li>c) Mask is created in order to determine clearly dehraded pizel based on their Color Saliency
  <li>d) Heavily degraded pixels are restored using inpaint (inpaintnans)
  <li>e) Image is filtered using wavelet denoising (wtdenoise)
  </ul>
<b>2. Binarization</b>
    <ul>
  <li>a) Image is binarized using average
  <li>b) Image is processed using morphological operations of closing and opening
    </ul>
<b>3. Measurement </b> <br>
The integral part of measurement of radius of concentric circumferences in determination of central point. This task is the biggest challenge in radius measurement, as is has direct influence on precion of measured diameter, or in some cases, if we even could finf some diameter. <br>
For finding a central point of circumferences we used used moving window, where we were searching for biggest symmetry peak. In function <i>find simetry.m</i> we calculated symmetri metric as differential imge between native part of image and part of image in window rotated over 180 degrees. <br>
For calculating a radius of circumferences we used two methods: <br>
<ul>
<li> <i>HT3_for_CC.m </i> - This method is using edge representation of image by applying Canny detector to binarized image. From each pixel we calculate the distance to the central point calculated in previus step. The goal of the function is to form clusters of pixels that have the similar distance to central point. The treshold for adding new pixel to cluster is determined by empirical way. Other important parameter in function is treshold for determination, if the cluster of pixels is capable of forming circumference with measured distance. This parameter is set to more than one, as the circumferences are quite distorted.</li>
<li> <i>averageRProfile.m </i> - This method is using classical binarized image, that is heavily denoised. We calculate the radius profile passing from central point and we apply filters to the obtained signal. The place of step change should be the measured radius.</li>
  </ul>
Functions   <i>vlndelka1.m</i> a <i>vlndelka2.m</i> server for calculating the final wavelenght according to used method of profile measuremenet
