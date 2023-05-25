run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down] grid_size_x=6 grid_size_y=6 tile_overlap=25 first_file_index_i=1 directory=C:\\Users\\BMOadmin2\\Documents\\Images\\Default\\widefield_Alldayv2_exp3ms_mag4X file_names=img_basic{iii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.05 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Write to disk] output_directory=C:\\Users\\BMOadmin2\\Documents\\Images\\Default\\widefield_Alldayv2_exp3ms_mag4X");saveAs("Tiff", "C:\\Users\\BMOadmin2\\Documents\\Images\\Default\\widefield_Alldayv2_exp3ms_mag4Xfused.tif");close()