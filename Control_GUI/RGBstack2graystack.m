function stack = RGBstack2graystack(img)
    for i = size(img,4)
        stack(:,:,i) = rgb2gray(img(:,:,:,i));
        fprintf('Image #%d \n',i)
    end
end