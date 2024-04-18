function foc_times = calc_timesVIAlg(foci,elempos,sound_struct,steps)
% calc_timesVIAlg - compute time of flight with sound speed map
%
% The function computes the (Tx or Rx) time of arrival for specified focal points
% given the array element positions.
%
% INPUTS:
% foci              - M x 3 matrix with position of focal points of interest [m]
% elempos           - N x 3 matrix with element positions [m]
% sound_struct      - Structure containing parameters for sound speed map: VEL_ESTIM,xi,yi
% steps             - Amount of steps for each distance vector between foci and elempos
%
% OUTPUT:
% foc_times         - M x N matrix with times of flight for all foci and all array elements

%% Distance Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
foci_tmp = reshape(foci,size(foci,1),1,3); % Vectorize distance 
elempos_tmp = reshape(elempos,1,size(elempos,1),3);
r = foci_tmp - elempos_tmp; 
distance = sqrt(sum(r.^2,3)); % Calculate distance for each transducer focal point pair 
step_distance = distance/steps; % Individualized step distance for each pair 
foc_times = zeros(length(foci_tmp),length(elempos)); % Zero matrix for initial times 
%% Interpolate Sound Speed Times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:steps
    tic
    % Linear interpolation from elempos to foci
    t = (steps - i + 1/2) / steps; % Normalized position along the line
    newCoords = (1 - t) .* (elempos_tmp) + t .* (foci_tmp); % Start at Focus Point Here, MxNx3 Matrix produced
    newCoords_speeds = interp2(sound_struct.xi, sound_struct.yi, sound_struct.VEL_ESTIM, newCoords(:,:,1), newCoords(:,:,3), 'linear'); % Interpolate new points to sound speed map
    new_times = step_distance./newCoords_speeds; % m / (m/s) is time, s
    foc_times = foc_times + new_times; % combine times for each pair from each step
    disp(['Step ', num2str(i)]);
    toc
end





