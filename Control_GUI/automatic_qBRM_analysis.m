function automatic_qBRM_analysis(folder_loc)
    cd(folder_loc)


    %% actually read in the sample notes (used for analysis and stutching
    [sample_notes] = read_sample_notes('Sample_Notes.txt');
    
    grid_size_tmp = split(sample_notes.Grid_size,'x');
    grid_size = [grid_size_tmp{1,1}, grid_size_tmp{2,1}];

    %% Run qBRM analysis on it
    
end