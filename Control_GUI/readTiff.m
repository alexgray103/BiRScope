function data = readTiff(filename)
    
    tstack = Tiff(filename);
    
    im = read(tstack);
    [I,J,C] = size(im);
    K = length(imfinfo(filename));
    
    %check if its an RGB image
    if C>1
        stackSize = [I J C K];
        data = zeros(stackSize,'like',im);
        data(:,:,:,1)  = tstack.read();
        for n = 2:K
            tstack.nextDirectory()
            data(:,:,:,n) = tstack.read();
        end
    else
        stackSize = [I J K];
        data = zeros(stackSize,'like',im);
        data(:,:,1)  = tstack.read();
        for n = 2:K
            tstack.nextDirectory()
            data(:,:,n) = tstack.read();
        end
    end
end