function [phi, ret, Io, RGB, RGB_norm] = solve_qBRM_symbolic_allreturn(img)
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;

   % load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;       

    img = double(img);

    [ret, Io, phi] = solve_qBRM_symbolic_full(img);
    [RGB,RGB_norm] = convert_phi_to_RGB(phi, cmap,ret);

end