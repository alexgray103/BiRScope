function [RGB_norm, A] = CCP_weighted_Orientation(CCP_img,qBRM_img)
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;

    [A, C, phi] = solve_qBRM_symbolic(qBRM_img);        

    [RGB, RGB_norm] = convert_phi_to_RGB(qBRM_img,cmap,CCP_img);

end