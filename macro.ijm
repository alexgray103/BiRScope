run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down] grid_size_x=14 grid_size_y=18 tile_overlap=10 first_file_index_i=1 directory=E:\\EVStudy\\SM073_widefieldCCP_exp250us_mag4X file_names=img_basic{iii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.05 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Write to disk] output_directory=E:\\EVStudy\\SM073_widefieldCCP_exp250us_mag4X");saveAs("Tiff", "E:\\EVStudy\\SM073_widefieldCCP_exp250us_mag4Xfused.tif");close()