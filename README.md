# CONTACT INFORMATION
**Severin Ihnat**  
- Phone: 917 716 6187  
- Email: [sihnat2002@gmail.com](mailto:sihnat2002@gmail.com) or [si2471@columbia.edu](mailto:si2471@columbia.edu)  

**Christian Voloshen**  
- Phone: 484 515 4754  
- Email: [cvoloshen@gmail.com](mailto:cvoloshen@gmail.com) or [ctv26@cornell.edu](mailto:ctv26@cornell.edu)  

---

# OVERVIEW
This suite of MATLAB scripts and functions is designed to facilitate advanced ultrasound image reconstruction using **Delay-and-Sum (DAS)** beamforming techniques. It encompasses processes such as loading and correcting data, calculating wave propagation times using both constant and variable sound speeds and enhancing image resolution through upscaling. The collective functionality of these tools allows for precise beamforming, enabling the generation of high-quality ultrasound images for detailed analysis and diagnostics.

---

# CODE DESCRIPTIONS

### **ImprovedSpeed_RAMBFF_ImageRecon.m**
This MATLAB script is designed to perform **Delay-and-Sum (DAS)** beamforming for ultrasound image reconstruction. It processes a dataset, utilizing a custom sound speed map to generate focused ultrasound images accurately. The code executes several key operations, including:  
- Data loading  
- Gain correction  
- High-pass filtering  
- Beamforming with both element and angular windowing  

---

### **upscale.m**
This MATLAB script visualizes and scales ultrasound images created using **Delay-and-Sum (DAS)** beamforming.  
Key functionalities:  
1. Displays the original image, applying a logarithmic transformation for better contrast.  
2. Scales up the image by a factor of 2 using **bicubic interpolation**, preserving detail and smoothness.  
3. Presents both the original and scaled images with spatial axes in millimeters.  

The process concludes with the display of the enhanced, scaled image.

---

### **calc_times.m**
The `calc_times` MATLAB function calculates the **time of flight** for ultrasound waves between array elements and specified focal points.  
#### Inputs:  
- `foci` – Focal points  
- `elempos` – Element positions  
- `c` – Constant speed of sound  

#### Process:  
1. Computes distances between each element and focal point.  
2. Determines the propagation time.  

#### Outputs:  
- `foc_times` – An M x N matrix listing times for all combinations of focal points and elements.

---

### **calc_timesVIAlg.m**
The `calc_timesVIAlg` MATLAB function calculates the **time of flight** for ultrasound waves using a detailed **sound speed map**.  
#### Inputs:  
- Matrices of focal points and element positions  
- Sound speed parameters  
- Number of interpolation steps  

#### Process:  
1. Calculates distances between elements and focal points.  
2. Interpolates sound speeds along the path at each step.  
3. Computes the time of flight incrementally.  

#### Outputs:  
- `foc_times` – A matrix providing total time of flight for each element-focal point pair, accurately integrating sound speed variations along the propagation path.

---

### **calc_acceptwin.m**
The `calc_acceptwin` MATLAB function computes **acceptance windows** for ultrasound elements by evaluating the angle between each element and focal point.  
#### Inputs:  
- Matrices of focal points and element positions  
- A weighting function based on the cosine of the angle  

#### Process:  
1. Calculates directional cosines.  
2. Applies the weighting function to determine acceptance windows.  

#### Outputs:  
- `acceptwin` – A matrix including weights that factor in spatial relationships and the directivity characteristics of the array elements.
