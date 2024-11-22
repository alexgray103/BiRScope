function fiji_stitching(gridx, gridy, overlap, directory, names, output_name)
    directory = join(split(directory,'\'),'\\');
    directory = directory{1};
    fileID = fopen('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\macro.ijm','w');
    fprintf(fileID, 'run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down] grid_size_x=%d grid_size_y=%d tile_overlap=%d first_file_index_i=1 directory=%s file_names=%s output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.05 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Write to disk] output_directory=%s");', gridx,gridy,overlap,directory,names,directory);
    fprintf(fileID, 'saveAs("Tiff", "%sfused.tif");', directory);
    fprintf(fileID, 'close()');
    fclose(fileID);

    %%% run macro from command line with ImageJ headless window
    system('"C:\Users\BMOadmin2\Desktop\fiji-win64\Fiji.app\ImageJ-win64.exe" --headless --console -macro C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\macro.ijm')

    movefile('img_t1_z1_c1', output_name); % change the filename into a tif format

end