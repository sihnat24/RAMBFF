% LinearArrayRecon - This code reconstructs an image from a linear array using both a constant sound...
% of speed and a sound speed map. It utilizes the following variables:

% C - Varying Sound Speed Matrix
% scat - Ultrasound Data Matrix
% rxApotPos - Positions of Transducer Elements
% time - Time Vector
% x - Coordinate Positions in the Horizontal Direction
% z - Coordinate Positions in the Vertical Direction

load('AbdominalMap3.mat'); % From Link In RAMBFF Release v1.0.0
%% Define Parameters and Points to Focus At 
dBrange = [-40, 0]; c = 1500; 
wave_length = c/1.0e6; 
[X,Y,Z] = meshgrid(x,0,z);
foc_pts = [X(:) Y(:) Z(:)]; % Set up grid of focus points

txAptPos = rxAptPos; % Transmit and receive at same Transducer Points
nelement = size(rxAptPos,1);

%% Reconstruct Images
tic
focData = bfm_fs_fast(time,scat,foc_pts,rxAptPos,txAptPos,c); % Reconstruct with constant speed of sound
focDataVI = bfm_fs_fastVI(x,z,time,scat,foc_pts,rxAptPos,txAptPos,C); % Reconstruct with sound speed map
toc

%% Plot Both Images for Comparison
img_h = reshape(focData, [numel(x), numel(z)])'; 
figure(1) % This image is with a constant speed of sound, c 
imagesc(1000*x, 1000*z, 20*log10(abs(img_h)/max(abs(img_h(:)))), dBrange); 
axis image; xlabel('Lateral [mm]'); ylabel('Axial [mm]');
title('Unadjusted Sound Speed DAS Beamforming'); colormap(gray); colorbar();

img_h2 = reshape(focDataVI, [numel(x), numel(z)])'; 
figure(2) % This image is with the varying sound speed map
imagesc(1000*x, 1000*z, 20*log10(abs(img_h2)/max(abs(img_h2(:)))), dBrange); 
axis image; xlabel('Lateral [mm]'); ylabel('Axial [mm]');
title('Adjusted Sound Speed DAS Beamforming'); colormap(gray); colorbar();