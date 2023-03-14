function addscalebar_fiji(full_path, filename, pixel_size, width, thickness, font)

    fileID = fopen('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\add_scalebar.ijm','w');
    fprintf(fileID, 'open(%s);',full_path);
    fprintf(fileID, 'selectWindow(%s)',filename);

    fprintf(fileID, 'Stack.setXUnit("um");');
    fprintf(fileID,'run("Properties...", "channels=1 slices=1 frames=1 pixel_width=%f pixel_height=1.6025 voxel_depth=1");', pixel_size);
    fprintf(fileID,'run("Scale Bar...", "width=%d height=1538 thickness=%d font=%d color=White background=None location=[Lower Right] horizontal bold overlay");', width, thickness, font);
    fprintf(fileID, 'saveAs("Tiff", "%sscale.tif");', full_path);
    fprintf(fileID, 'close()');
    fclose(fileID);
    

end