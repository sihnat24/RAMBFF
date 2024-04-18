function acceptwin = calc_acceptwin(foci,elempos,cosangfcn)
% calc_acceptwin - compute acceptance window for each ring-array element
%
% INPUTS:
% foci              - M x 3 matrix with position of focal points of interest [m]
% elempos           - N x 3 matrix with element positions [m]
% cosangfcn         - Function handle for weighting based on cosine of angle
%
% OUTPUT:
% acceptwin         - M x N matrix with weights for all foci and all array elements

% Displacement between elements and foci
foci_tmp = reshape(foci,size(foci,1),1,3);
elempos_tmp = reshape(elempos,1,size(elempos,1),3);
r = foci_tmp - elempos_tmp;
% Directivity of Elements (Assuming Ring Elements Centered at Origin)
radi = sqrt(sum(elempos.^2,2)); radius = mean(radi);
elemdir = -elempos_tmp/radius;
% Displacement to absolute distance and direction
distance = sqrt(sum(r.^2,3)); 
focidir = r./distance;
% Cosine of Angle
cosangle = sum(focidir.*elemdir,3);
acceptwin = cosangfcn(cosangle) .* ... % cosine angle acceptance window 
    (sqrt(sum(foci_tmp.^2,3))<radius) .* ... % inside ring
    (distance<radius); % inside ring radius closest to each element

return;


