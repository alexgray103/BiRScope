function [sample_structure] = read_sample_notes(file_location)
    fields = {'Sample_Description','Sample_Name','Sample_Thickness',...
            'Magnification', 'Exposure_time','Exposure_units','Acquistion_type',...
            'Microscopy_setup','Grid_size','Overlap','Step_size',...
            'Polarizer_settings','Camera_width'};

    fid = fopen(file_location,'r');
    ii = 0;
    while ~feof(fid)
        ii = ii+1;
        tmp = fgets(fid);
        tmp_split = split(tmp,':');
        data{ii,1} = erase(tmp_split{2,1},';');
    end
    sample_structure = cell2struct(data,fields);
end