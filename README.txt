CONTACT INFORMATION
Severin Ihnat
 - Phone: 917 716 6187
 - Email: sihnat2002@gmail.com or si2471@columbia.edu

Christian Voloshen
- Phone: 484 515 4754
- Email: cvoloshen@gmail.com or ctv26@cornell.edu
________________________________________________________________________________


OVERVIEW
This suite of MATLAB scripts and functions is designed to facilitate advanced 
ultrasound image reconstruction using Delay-and-Sum (DAS) beamforming 
techniques. It encompasses processes from loading and correcting data, 
calculating wave propagation times using both constant and variable sound 
speeds, to enhancing image resolution through upscaling. The collective 
functionality of these tools allows for precise beamforming, enabling the 
generation of high-quality ultrasound images for detailed analysis and diagnostics.

CODE DESCRIPTIONS
________________________________________________________________________________
ImprovedSpeed_RAMBFF_ImageRecon.m
-This MATLAB script is designed to perform Delay-and-Sum (DAS) beamforming 
-for ultrasound image reconstruction. It processes a dataset, utilizing a custom 
-sound speed map to generate focused ultrasound images accurately. The code 
-executes several key operations, including data loading, gain correction, 
-high-pass filtering, and beamforming with both element and angular windowing. 

upscale.m
-This MATLAB script visualizes and scales ultrasound images created using 
-Delay-and-Sum (DAS) beamforming. It first displays the original image, 
-applying a logarithmic transformation for better contrast. The image is then 
-scaled up by a factor of 2 using bicubic interpolation, which helps preserve 
-detail and smoothness. Both the original and scaled images are presented with 
-spatial axes in millimeters, and the process concludes with a display of the 
-enhanced, scaled image.

calc_times.m
-This MATLAB function, calc_times, calculates the time of flight for ultrasound 
-waves between array elements and specified focal points, useful in applications 
-like ultrasound image reconstruction. It takes inputs of focal points (foci), 
-element positions (elempos) and a constant speed of sound. The function computes 
-the distance between each element and focal point to determine the propagation time. 
-The output, foc_times, is an M x N matrix that lists these times for all combinations 
-of focal points and elements.

calc_timesVIAlg.m
-This MATLAB function, calc_timesVIAlg, calculates the time of flight for 
-ultrasound waves between array elements and focal points using a detailed 
-sound speed map. It accepts matrices of focal points and element positions, 
-a structure with sound speed parameters, and the number of interpolation steps. 
-The function first calculates distances between elements and foci, then 
-interpolates sound speeds along the path at each step to compute the time of 
-flight incrementally. The resulting foc_times matrix provides the total time of 
-flight for each element-focal point pair, integrating sound speed variations 
-accurately across the propagation path.

calc_acceptwin.m
-This MATLAB function, calc_acceptwin, computes acceptance windows for ultrasound 
-elements by evaluating the angle between each element and focal point. It uses 
-input matrices of focal points and element positions, along with a function 
-that weights based on the cosine of the angle. The function calculates 
-directional cosines and applies the weighting function to determine the 
-acceptance windows. The resulting acceptwin matrix includes these weights, 
-factoring in both spatial relationships and directivity characteristics of the 
-array elements.
