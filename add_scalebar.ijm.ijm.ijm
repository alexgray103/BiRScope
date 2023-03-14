open("C:/Users/BMOadmin2/Documents/Images/Rosene/Sample_Prep_paper/Drying/20Min/Widefield_CCPv2_exp5ms_mag4X/Fused.tif");
selectWindow("Fused.tif");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=1 pixel_width=1.6025 pixel_height=1.6025 voxel_depth=1");
run("Scale Bar...", "width=4500 height=1538 thickness=250 font=900 color=White background=None location=[Lower Right] horizontal bold overlay");
