function foc_times = calc_times(foci,elempos,speed_of_sound)
% calc_times - computes focusing times
%
% The function computes the (Tx or Rx) time of arrival for specified focal points
% given the array element positions.

%speed_of_sound input can be a structure with the x vector, z vector, and
%speed_of_sound.map (2D map)

% INPUTS:
% foci              - M x 3 matrix with position of focal points of interest [m]
% elempos           - N x 3 matrix with element positions [m]
% speed_of_sound    - speed of sounds [m/s]; default 1540 m/s
%
% OUTPUT:
% foc_times         - M x N matrix with times of flight for all foci and all array elements

% Displacement between elements and foci
foci_tmp = reshape(foci,size(foci,1),1,3);
elempos_tmp = reshape(elempos,1,size(elempos,1),3);
r = foci_tmp - elempos_tmp;

% Displacement to absolute distance and time of flight
distance = sqrt(sum(r.^2,3));
foc_times = distance./speed_of_sound;

return;

%% Seddams Method 

% we want to figure out how long we go through each pixel, and which pixels
% it goes through 

%we cannot be missing pixels, all of that will affect time of flight
%calculations 

%look into line pixel interections (at what points in  the pixel grid is
%the line crossing over intersections) MATLAB

%Seddans algorithm (think deeply about how we are going to order
%computations because this is going to take a lot of computing)

%sound speed map will have x/z grid, with vectors holding centers of the
%grid. However, for the tracing we care about the grid lines (these will be
%the midpoints between the center points)  

%add some logic for the path (depending on which grid line is intersected
%first, go to the next pixel -> and repeat)

%also need to think about how you store the information -> once you know
%the path and length calculate the time of flight, only need to remember
%the time of flight

%try to organize code to help with computation time

%% Breaking Line into Small Pieces 

%you know the start point you know the end point. Break the distance into
%really small steps 

%use an interpolation operation to find the speed values using
%interpolation

%pieces need to be as small as possible 

%dl/sound speed = sum them all up

%to help parrellalize, you can break each path into the same number of
%pieces. However, this will vary the length between points, so that means
%that lenght has to be stored. You already have the distance in calctimes,
%divide the distance by the num pieces you have decided.

%going to have some logic. 

%can also think about working backwards 

%MATLAB: nearest interpolation, more accurate to do linear interpolation

%% find pixel sound speed that you are in, then work backwards
%find all of the displacement vectors, WHICH WE HAVE
%scale them down (say 99%) add the vectors to the origin, and use linear
%interpolate to calculate the speed of sound

%rinse and repeat 
