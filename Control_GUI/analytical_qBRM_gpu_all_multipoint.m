function [I0, phi, ret, RGB_norm] = analytical_qBRM_gpu_all_multipoint(angles,img,phishift)
    
    tic
    
    [ret, phi, I0] = solve_qBRM_multipoint_m(angles, img);
    % figure(),histogram(phi)
    phis = phi+phishift;
    phis(phis>pi/2)=phis(phis>pi/2)-pi;
    
    % phi=phis-min(phis(:))-pi/2;
    % figure(),histogram(phis)
    phi=-phis;
%     [I0, phi, ret] = analytical_qBRM(img(:,:,1,:),img(:,:,2,:),;img(:,:,3,:));
    y = toc;
    fprintf('Completed Analayis of the image in %5.2f seconds\n', y);

    clear img
    tic
    cmap = load('cmap_v3.mat').cmap;
    cmap = gpuArray(cmap);
    phinew = gpuArray(phi);
    phinew = (phinew+pi/2)/pi;
    phinew = uint16((size(cmap,1)-1)*phinew)+1;
    r = reshape(cmap(phinew,1), [size(phinew,1),size(phinew,2),1,size(phinew,4)]);
    g = reshape(cmap(phinew,2), [size(phinew,1),size(phinew,2),1,size(phinew,4)]);
    b = reshape(cmap(phinew,3), [size(phinew,1),size(phinew,2),1,size(phinew,4)]);
    clear phinew
    
    RGB = cat(3,r,g,b);
    clear r
    clear g
    clear b
    
    ret = gpuArray(ret);
    RGB_norm = RGB.*ret;
    ret = gather(ret);
    RGB_norm = gather(RGB_norm);
    y = toc;
    fprintf('Created orientation map in %5.2f seconds\n', y);
    clear RGB
end