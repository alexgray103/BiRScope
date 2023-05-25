function ff_corr = load_ff()
    current = pwd;
    if exist('Flatfield', 'dir')
        fprintf('Flatfield Images Detected \n')
        cd('Flatfield')
        ff = double(readTiff('Flatfield.tif'));
        ff_corr = ff - mean(ff,3);
    else
        ff_corr = 0;
        disp('No Flatfield Images detected.')
    end
    cd(current)
end