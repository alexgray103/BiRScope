function [RGB, RGB_normalized] = phi_to_rgb_nogpu(phi,cmap,ret, sh)
    % wicked fast
    if nargin>3
        phi2=phi+pi/2;
        phi2(isnan(phi2))=0;
        %find shift
        phi1=phi2(:,:,:,15);
        shift = sh*pi/180 - mean(mean(phi1));
        %apply shift to data
        for j=1:size(phi,4)
            phi_sh(:,:,:,j) = mod(phi2(:,:,1,j)+shift, pi);
        end
        phinew = (phi_sh)/pi;
    else
        phinew = (phi+pi/2)/pi;
    end
    phinew2 = uint16((size(cmap,1)-1)*phinew)+1;
    disp('here')
    rgb = cmap(phinew2,:);
    disp('here')
    r = reshape(rgb(:,1),[2960,2960,1,size(phi,4)]);
    g = reshape(rgb(:,2),[2960,2960,1,size(phi,4)]);
    b = reshape(rgb(:,3),[2960,2960,1,size(phi,4)]);
    disp('here')
    clear rgb
    RGB = cat(3,r,g,b);
    clear r g b
    RGB_normalized = RGB.*(ret);
end