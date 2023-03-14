function varargout = BaSIC_correction(images_dir, plot_val)

    % read in Image set and do correction and overwrite all images
    files =dir([images_dir,'\', '*.tif']);
    for i = 1:length(files)  
        IF(:,:,i) = imread([images_dir ,'\', files(i).name]); % original image
        fprintf('loaded_image %d \n',i)
    end
    data_type = class(IF);
    % estimate flatfield and darkfield
    % For fluorescence images, darkfield estimation is often necessary (set
    % 'darkfield' to be true)
    [flatfield,darkfield] = BaSiC(IF,'darkfield','true');  

    % plot estimated shading files
    % note here darkfield does not only include the contribution of microscope
    % offset, but also scattering light that entering to the light path, which
    % adds to every image tile
    if plot_val
        figure; subplot(121); imagesc(flatfield);colorbar; title('Estimated flatfield');
        subplot(122); imagesc(darkfield);colorbar;title('Estimated darkfield');
    end 
   
    % image correction
    for i = 1:length(files)
        IF(:,:,i) = (double(IF(:,:,i))-darkfield)./flatfield;
    end
    cd(images_dir)
    % save images for stitching
    if isa(IF,'uint16')
        IF = IF/256; % convert to 8 bit scale (becuase we mainly only use 4X for this part)    
    end
    
    for i = 1:length(files)
        imwrite(uint8(IF(:,:,i)),sprintf('img_basic%03d.tif', i));
    end
end 