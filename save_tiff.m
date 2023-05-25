function save_tiff(img, filename)
        t=Tiff(filename,'w');
        tagstruct.ImageLength = size(img,1); % image height
        tagstruct.ImageWidth = size(img,2); % image width
        if size(img,3) > 1
            tagstruct.Photometric = Tiff.Photometric.RGB; % https://de.mathworks.com/help/matlab/ref/tiff.html
        else
            tagstruct.Photometric = Tiff.Photometric.MinIsBlack; % https://de.mathworks.com/help/matlab/ref/tiff.html
        end

        switch class(img)
            % Unsupported Matlab data type: char, logical, cell, struct, function_handle, class.
            case {'uint8', 'uint16', 'uint32'}
                tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
            case {'int8', 'int16', 'int32'}
                tagstruct.SampleFormat = Tiff.SampleFormat.Int;
                if options.color
                    errcode = 4; assert(false);
                end
            case {'uint64', 'int64'}
                tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
                data = double(data);
            case {'single', 'double'}
                tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
            otherwise
                % (Unsupported)Void, ComplexInt, ComplexIEEEFP
                errcode = 5; assert(false);
        end

        switch class(img)
            case {'uint8', 'int8'}
                tagstruct.BitsPerSample = 8;
            case {'uint16', 'int16'}
                tagstruct.BitsPerSample = 16;
            case {'uint32', 'int32'}
                tagstruct.BitsPerSample = 32;
            case {'single'}
                tagstruct.BitsPerSample = 32;
            case {'double', 'uint64', 'int64'}
                tagstruct.BitsPerSample = 64;
        end

        tagstruct.SamplesPerPixel = size(img,3);
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; % groups rgb values into a single pixel instead of saving each channel separately for a tiff image
        tagstruct.Software = 'MATLAB';
        setTag(t,tagstruct)
        write(t,squeeze(img(:,:,:,1)));

        for i =2:size(img,4)
            writeDirectory(t);
            setTag(t,tagstruct)
            write(t,squeeze(img(:,:,:,i))) %%%appends the next layer to the same file t
        end
        % do this for as many as you need, or put it in a loop if you can
        close(t) %%% this is necessary otherwise you won't be able to open it in imageJ etc to double check, unless you close matlab
end