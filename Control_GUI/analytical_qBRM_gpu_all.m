function [I0, phi, ret, RGB_norm] = analytical_qBRM_gpu_all(img, ff_I0)
    
    tic
    [I0, phi, ret] = analytical_qBRM(img(:,:,1,:),img(:,:,2,:),img(:,:,3,:));

    %normalized transmittance
    I0_norm = I0./ff_I0;

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
    
    %add phi_augmentation


    RGB = cat(3,r,g,b);
    clear r
    clear g
    clear b
    
    ret = gpuArray(ret);
    %I0 = gpuArray(I0);
    RGB_norm = RGB.*ret.*I0_norm;
    ret = gather(ret);
    RGB_norm = gather(RGB_norm);
    y = toc;
    fprintf('Created orientation map in %5.2f seconds\n', y);
    clear RGB
end