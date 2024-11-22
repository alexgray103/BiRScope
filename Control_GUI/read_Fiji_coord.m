function Exp_Fiji = read_Fiji_coord(filename, image_names)

    fid = fopen(filename,'r');
    
    for ii=1:4
        kk = fgets(fid);
    end
    
    ii=0;
    while ~feof(fid)
        ii = ii +1;
        kk = fgets(fid);
        %img(:,ii)=sscanf(kk,['img_%d_z_15.tif; ; ( %f, %f)']);
        img(:,ii)=sscanf(kk,[image_names,'%03d.tif ; ; ( %f, %f)']);
    end
    fclose(fid);
    Exp_Fiji=img;
end