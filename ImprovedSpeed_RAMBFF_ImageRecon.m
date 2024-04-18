
% Loading the dataset
load("SV113_BenignCyst.mat") % Use the SV cases (1024 elements) 
sound_struct = load("BenignCystSoS.mat");
%% 

% Gain Correction
if exist('gain_correction','var')
    full_dataset = single(full_dataset) .* gain_correction;
else
    full_dataset = single(full_dataset);
end

% Adjust Time Axis
nsamplesoffset = 24; % See RAMBFF1024CoherenceFactor.m
% SV439_Malignancy.mat: approximately 24-24.5
% SV113_BenignCyst.mat: approximately 17.5 
dt = mean(diff(time));
fs = 1/dt; % sampling rate [Hz]
time = time - nsamplesoffset * dt;

% Element Positions -- I'm overwriting this myself
radius = 0.11; % radius of ring array [m]
nelement = size(transducerPositionsXY,2);
transducerPosAngle = pi/2-(2*pi*(0:nelement-1)/nelement);
transducerPosX = radius*cos(transducerPosAngle);
transducerPosY = radius*sin(transducerPosAngle);
transducerPositionsXY = [transducerPosX; transducerPosY];
AptPos = transpose(cat(1,transducerPositionsXY(1,:), ...
    zeros(1,size(transducerPositionsXY,2)),transducerPositionsXY(2,:)));


% Physical Parameters
c = 1500; % sound speed [m/s]
fTx = 2.5e6; % center frequency [Hz]
wavlen = c/fTx; % wavelength [m]

% Points to Focus and Get Image At
npts = ceil(radius/wavlen); % Specify starting small grid dimensions
x_img_small = linspace(-radius,radius,npts);
z_img_small = linspace(-radius,radius,npts);
[X,Y,Z] = meshgrid(x_img_small, 0, z_img_small);
foc_pts = [X(:), Y(:), Z(:)]; 

% High Pass Filter
N = 10; fcutoff = 0.8e6; [b,a] = butter(N, 2*fcutoff/fs,'high');
for tx_idx = 1:size(transducerPositionsXY,2)
    full_dataset(:,:,tx_idx) = ...
        single(filtfilt(b, a, double(full_dataset(:,:,tx_idx))));
    disp(['Highpass Filter, Tx Elem ', num2str(tx_idx)]);
end

% Hilbert Transform
for tx_idx = 1:size(transducerPositionsXY,2)
    full_dataset(:,:,tx_idx) = hilbert(single(full_dataset(:,:,tx_idx)));
    disp(['Hilbert Transform, Tx Elem ', num2str(tx_idx)]);
end

% Element Windowing
n = 4.0; % n = 3 : 1/6th of ring, n = 4 : 1/8th of ring
x = 2*pi*(1:nelement)/nelement-pi; y = x;
[X,Y] = meshgrid(x,y);
window = 1+cos(max(-pi,min(pi,n*wrapToPi(abs(X-Y))))); 

% Angular Windowing for Aperture Growth
anglefcn = @(ang,angrng) (1+cos(max(-pi,min(pi,2*wrapToPi(ang)/angrng))))/2;
angrng = 0.5; % Percentage of Angular Range [-pi/2, pi/2];
cosangfcn = @(cosang) anglefcn(real(acos(cosang)),angrng);

%% 
% Simple one time calculation for times, generate M x N of original grid
%small_times = calc_times(foc_pts,AptPos,c); % Get times from focal points to aperture points
small_times = calc_timesVIAlg(foc_pts,AptPos,sound_struct,100); % Custom Speed of Sound Map Code 
small_acceptwin = calc_acceptwin(foc_pts,AptPos,cosangfcn); % Get corresponding receiver acceptance windows for focal points
reshaped_small_times = zeros(npts,npts,length(AptPos)); % create zero vector for reshaped matrices
reshaped_small_acceptwindow = zeros(npts,npts,length(AptPos));

for i = 1:length(AptPos) % reshape matrix to (npts) x (npts) x (# of elements)
     idx = 1;
    for j = 1:length(small_times)/npts
       reshaped_small_times(j,:,i) = small_times(idx:j*npts,i);
       reshaped_small_acceptwindow(j,:,i) = small_acceptwin(idx:j*npts,i);
       idx = idx + npts;
    end
end

tic
scale_factor = 4; % Set scale factor to enlarge original grid
x_img_scaled = linspace(-radius,radius,scale_factor * npts); % enlarge original grid by scale factor for new focus points
z_img_scaled= linspace(-radius,radius,scale_factor * npts);
[X_scaled,Y,Z_scaled] = meshgrid(x_img_scaled, 0, z_img_scaled);
foc_pts_scaled = [X_scaled(:), Y(:), Z_scaled(:)]; % Get coordinates of new focus points
insideR = (sum(foc_pts_scaled.^2,2) < radius.^2); % Find focus points inside ring array
foc_pts_scaled_insideR = foc_pts_scaled(insideR,:); % find the focus points inside the ring radius
focData_insideR = zeros(size(foc_pts_scaled_insideR,1), 1); % focused Data inside Radius
insideR_idx = find(insideR);% find indices of focus points for final image
[theta_foc,~] = cart2pol(foc_pts_scaled_insideR(:,1),foc_pts_scaled_insideR(:,3)); % Polar Coordinates for Identifying Focal Points for Each Transmitter
toc
%%
for idx_1 = 1:length(AptPos) % idx_1 is transmitters, idx_2 is receivers
    tic 
    [theta_apt,~] = cart2pol(AptPos(idx_1,1),AptPos(idx_1,3)); % Polar Coordinate of element of interest
    slice_foc_pts = wrapToPi(abs(theta_apt - theta_foc)) <= pi/2; % isolate all focus points within a specific angle of element of interest
    slice_foc_pts_idx = find(slice_foc_pts); % indices of qualifying focus points
    slice_foc_pts = foc_pts_scaled_insideR(slice_foc_pts,:); % isolate qualifying focus points
    scaled_times_idx_1 = interp2(x_img_small,z_img_small,reshaped_small_times(:,:,idx_1),slice_foc_pts(:,1),slice_foc_pts(:,3)); % Use interpolation to calculate times and accept windows in scaled matrix
    scaled_acceptwin_idx_1 = interp2(x_img_small,z_img_small,reshaped_small_acceptwindow(:,:,idx_1),slice_foc_pts(:,1),slice_foc_pts(:,3));
    
    for idx_2 = 1:length(AptPos)
        
         scaled_times_idx_2 = interp2(x_img_small,z_img_small,reshaped_small_times(:,:,idx_2),slice_foc_pts(:,1),slice_foc_pts(:,3));
         scaled_acceptwin_idx_2 = interp2(x_img_small,z_img_small,reshaped_small_acceptwindow(:,:,idx_2),slice_foc_pts(:,1),slice_foc_pts(:,3));
        
        if window(idx_1,idx_2) ~= 0
            
            focData_insideR(slice_foc_pts_idx) = focData_insideR(slice_foc_pts_idx) + window(idx_1,idx_2) * ...% Build Focused Data
                scaled_acceptwin_idx_1 .* scaled_acceptwin_idx_2 .*...
                interp1(time,full_dataset(:,idx_1,idx_2),...
                    scaled_times_idx_1 + scaled_times_idx_2,'spline',0);
        end
    end
     disp(['Tx Element ',num2str(idx_1)])
     toc
end

focData_full = zeros(length(foc_pts_scaled),1); % Pad zeros outside of insideR focus points to display properly
focData_full(insideR_idx) = focData_insideR; 
img_h= permute(reshape(focData_full,[numel(x_img_scaled), numel(z_img_scaled)]), [2,1]); % Rearrange focused data into Grid for Image

% Show Reconstructed Image
dBrange = [-60, 0]; 
imagesc(1000*x_img_scaled, 1000*z_img_scaled, ...
    20*log10(abs(img_h)/max(abs(img_h(:)))), dBrange); 
axis image; xlabel('Lateral [mm]'); ylabel('Axial [mm]');
title('DAS Beamforming'); colormap(gray); colorbar();




