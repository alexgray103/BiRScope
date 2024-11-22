function [ret_stack, RGB_stack, phi_stack] = analyze_qBRM_zstack_CCP(img,CCP)
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;
    
    % load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;
    fprintf('\n ############ Running qBRM Analysis ############ \n\n')
    
    for ii = 1:size(img,4)
        [A, ~, phi] = solve_qBRM_symbolic_full(img(:,:,:,ii));
        [~,RGB_norm] = convert_phi_to_RGB(phi, cmap,CCP(:,:,ii));
        phi_stack(:,:,ii) = phi;
        ret_stack(:,:,ii) = A;
        RGB_stack(:,:,:,ii) = RGB_norm;
        fprintf('Analyzed Plane (%d/%d) \n',ii,size(img,4))
    end
end