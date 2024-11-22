function varargout = BaSIC_correction_RGB(images_dir, plot_val)

    % read in Image set and do correction and overwrite all images
    files =dir([images_dir,'\', '*.tif']);
    for i = 1:length(files)  
        IF_tmp(:,:,:,i) = imread([images_dir ,'\', files(i).name]); % original image
        IF(:,:,i) = rgb2gray(IF_tmp(:,:,:,i));
        fprintf('loaded_image %d \n',i)
    end

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
        IF_corr(:,:,:,i) = (double(IF_tmp(:,:,:,i))-darkfield)./flatfield;
    end
    class(IF_corr)
    cd(images_dir)
    % save images for stitching
    mkdir('BaSIC')
    cd('BaSIC')
    IF_corr = IF_corr/256; % convert to 8 bit scale (becuase we mainly only use 4X for this part)
    for i = 1:length(files)
        imwrite(uint8(IF_corr(:,:,:,i)),sprintf('img_basic%03d.tif', i));
    end
end 