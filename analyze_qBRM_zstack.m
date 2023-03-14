function [ret_stack, RGB_stack, phi_stack] = analyze_qBRM_zstack(img, varargin)
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;
    
    % load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;
    fprintf('\n ############ Running qBRM Analysis ############ \n\n')
    if isa(img,"char")
        img = load_RGB_zstack(img);
        if exist('Flatfield', 'dir')
            fprintf('Flatfield Images Detected \n')
            cd('Flatfield')
            ff = readTiff('Flatfield.tif');
            ff_corr = double(ff) - mean(ff,3);
        else
            ff_corr = 0;
            disp('No Flatfield Images detected.')
        end
    else
        ff_corr = 0;
    end
    
    img = double(img);

    img = img - ff_corr;
    
    for ii = 1:size(img,4)
        [A, ~, phi] = solve_qBRM_symbolic_full(img(:,:,:,ii));
        number_shift = 0;
        if nargin > 1
            number_shift = varargin{1};
            number_shift = varargin{1};
            phi_shifted = 2*phi - (2*number_shift*pi/180) - pi;
            %phi_shifted = wrapToPi(phi + deg2rad(number_shift));

        else
            phi_shifted = phi;
        end
        
        phi_stack(:,:,ii) = phi_shifted;
        [~,RGB_norm] = convert_phi_to_RGB(phi_shifted, cmap,A);
        
        ret_stack(:,:,ii) = A;
        RGB_stack(:,:,:,ii) = RGB_norm;
                fprintf('Analyzed Plane (%d/%d) \n',ii,size(img,4))
    end
end