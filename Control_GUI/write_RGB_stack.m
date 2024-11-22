function write_RGB_stack(img, filename)
    if isa(img,'uint16')
        bitness = 16;
    elseif isa(img,'uint8')
        bitness = 8;
    end

    t=Tiff(filename,'w');
    tagstruct.ImageLength = size(img,1); % image height
    tagstruct.ImageWidth = size(img,2); % image width
    tagstruct.Photometric = Tiff.Photometric.RGB; % https://de.mathworks.com/help/matlab/ref/tiff.html
    tagstruct.BitsPerSample = bitness;
    tagstruct.SamplesPerPixel = 3;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; % groups rgb values into a single pixel instead of saving each channel separately for a tiff image
    tagstruct.Software = 'MATLAB';
    setTag(t,tagstruct)
    
    %actually write the Z stack
    write(t,squeeze(img(:,:,:,1)));
    writeDirectory(t);
    for i =2:size(img,4)
        setTag(t,tagstruct)
        write(t,squeeze(img(:,:,:,i))) %%%appends the next layer to the same file t
        writeDirectory(t);
    end
end