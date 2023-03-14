function [A, C, phi, RGB, RGB_norm] = full_qBRM_analysis(img_location, plane)
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'

   % load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;    

    img = imread(img_location, plane);

    if size(img,3) ~= 3
        error('Not qBRM image. qBRM images must be in RGB format')
    end

    img = double(img);

    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;

    [A, C, phi] = solve_qBRM_symbolic_full(img, solver);   
    
    [RGB,RGB_norm] = convert_phi_to_RGB(phi, cmap,A);

end