% Original image display
figure;
imagesc(1000*x_img_scaled, 1000*z_img_scaled, ...
    20*log10(abs(img_h)/max(abs(img_h(:)))), dBrange);
axis image;
xlabel('Lateral [mm]');
ylabel('Axial [mm]');
title('Original DAS Beamforming');
colormap(gray);
colorbar();

% Scaling the image by a factor of 2
scaled_img_h = imresize(img_h, 2.0, 'bicubic');  % Using bicubic interpolation
%bc its is good for scaling images. It considers a larger 

% Display scaled image
figure;

%create new horizontal and verticale exis 
% 'min/max determine the range of the original x-axis, scaled by 1000.
% 'size(scaled_img_h, 2)' provides the number of horizontal points in the scaled image.
new_x_img_scaled = linspace(min(1000*x_img_scaled), max(1000*x_img_scaled), size(scaled_img_h, 2));
new_z_img_scaled = linspace(min(1000*z_img_scaled), max(1000*z_img_scaled), size(scaled_img_h, 1));

imagesc(new_x_img_scaled, new_z_img_scaled, ...
    20*log10(abs(scaled_img_h)/max(abs(scaled_img_h(:)))), dBrange);
axis image;
xlabel('Lateral [mm]');
ylabel('Axial [mm]');
title('Scaled DAS Beamforming (2x)');
colormap(gray);
colorbar();