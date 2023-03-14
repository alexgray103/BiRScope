function [RGB, RGB_normalized] = convert_phi_to_RGB(phi,cmap, ret, rgb, varargin)
    % wicked fast
    phinew = (phi+pi/2)/pi;
    phinew2 = uint16((size(cmap,1)-1)*phinew)+1;
    rgb = zeros([size(ret,1),size(ret,2),3,size(ret,4)], 'gpuArray');
    rgb = cmap(phinew2,:);
    r = reshape(rgb(:,1),[2960,2960,1,size(phi,4)]);
    g = reshape(rgb(:,2),[2960,2960,1,size(phi,4)]);
    b = reshape(rgb(:,3),[2960,2960,1,size(phi,4)]);
    clear rgb
    RGB = cat(3,r,g,b);
    clear r g b
    ret = gpuArray(ret);
    RGB_normalized = RGB.*(ret);

% phinew = mat2gray(phi);
%     phinew2 = uint16(size(cmap,1)*phinew);
%     RGB = ind2rgb(phinew2,cmap);
%     %ret = mat2gray(ret); % rescale retardance to 0-1 range
%     RGB_normalized = RGB.*(ret);    

% second attempt to speed up with gpu
%     phinew = mat2gray(phi);
%     phinew2 = squeeze(uint16(size(cmap,1)*phinew));
%     phi_vectorized = phinew2(:);
%     rgb = ind2rgb(phi_vectorized,cmap);
%     r = reshape(rgb(:,1),[2960,2960,1,20]);
%     g = reshape(rgb(:,2),[2960,2960,1,20]);
%     b = reshape(rgb(:,3),[2960,2960,1,20]);
%     RGB = cat(3,r,g,b);
%     %ret = mat2gray(ret); % rescale retardance to 0-1 range
%     RGB_normalized = RGB.*(ret);

    
   
end