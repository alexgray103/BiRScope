function [A, C, phi] = solve_qBRM_symbolic(img)
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;     

    img = double(img);

    [A, C, phi] = solver(img(:,:,1,:),img(:,:,2,:),img(:,:,3,:));
    phi = real(phi);
    phi = phi+(pi/2)*single(A<0);
    A = abs(A);
end