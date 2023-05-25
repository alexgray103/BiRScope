function [I0, phi, ret, RGB_norm] = qBRM_solve_gpu(img, varargin)
    cmap = gpuArray(load('cmap_v3.mat').cmap);
    if ~isgpuarray(img) || isa(img,'double')
        
        img = gpuArray(double(img));
    end
    
    if ndims(img)>3
        [I0, phi, ret] = analytical_qBRM(img(:,:,1,:),img(:,:,2,:),img(:,:,3,:));
    else
        [I0, phi, ret] = analytical_qBRM(img(:,:,1),img(:,:,2),img(:,:,3));
    end
    clear img
    [ret,I0,phi] = gather(ret,I0,phi);

    if nargin > 1
        if varargin{1}
            phi = 2*phi;
            phi = phi - (2*varargin{1}*pi/180);
            phi = wrapToPi(phi);
            phi = phi/2;
        end
    end

    [~,RGB_norm] = convert_phi_to_RGB(phi,cmap,ret);
    [RGB_norm] = gather(RGB_norm);

end