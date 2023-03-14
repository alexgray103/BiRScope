function zstack = load_zstack(img_location)
    info = imfinfo(img_location);
    %zstack = zeros([info.Width,info.Height,length(info)]);
    zstack(:,:,:) = imread(img_location,'info',info);
end