function [transmittance, ret] = fourier_analysis_qBRM(img,angles)
    img = double(img);
    angles = reshape(angles, [1,1,length(angles)]);

    a0 = (1/length(angles))*sum(img,3);
    b1 = (2/length(angles))*sum(img.*cosd(2*angles),3);
    a1 = (2/length(angles))*sum(img.*sind(2*angles),3);
    
    transmittance = 2*a0;
    ret = sqrt((a1.^2) + (b1.^2))./a0;
    % phi requires fitting to extract the angle
end