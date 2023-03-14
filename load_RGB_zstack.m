function zstack = load_RGB_zstack(img_location)
    info = imfinfo(img_location);
    %zstack = zeros([info.Width,info.Height,length(info)]);
    for i = 1:length(info)
        zstack(:,:,:,i) = imread(img_location,i);
        fprintf('Loaded Image %d/%d \n',i,length(info))
    end
end