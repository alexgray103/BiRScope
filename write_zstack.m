function write_zstack(img, filename)
    if length(size(img))>3
        planes = size(img,4);
    else
        planes = size(img,3);
    end

    fprintf('\n ############ Writing Zstack ############ \n\n')
    for i = 1:planes
        if length(size(img)) >3
            imwrite(img(:,:,:,i), filename,'WriteMode','append')
        else
            imwrite(img(:,:,i), filename,'WriteMode','append')
        end
        fprintf('Wrote %s Image %d/%d \n',filename, i,planes)
    end
end