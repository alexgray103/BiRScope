function solve_widefield_qBRM_folder(folder_loc, varargin)
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;

   % load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;       

    cd(folder_loc)
    files = dir('*.tif');
    mkdir('qBRM')
    cd('qBRM')
    mkdir('Ret')
    mkdir('RGB_norm')
    mkdir('phi')
%%%%% Uncomment for transmittance
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%     mkdir('trans') 
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cd(folder_loc)

    % try to run flatfield
        if exist('Flatfield', 'dir')
            fprintf('Flatfield Images Detected \n')
            cd('Flatfield')
            ff = double(readTiff('Flatfield.tif'));
            ff_images = ff;
            ff = ff - mean(ff,3);
            if nargin > 1
                if varargin{1}
                    phi_shift = varargin{1};
                end
                if nargin > 2
                    if varargin{2}
                        ff = 0;
                    end
                end
            else
                phi_shift = 0;
            end
        else
            ff = 0;
            disp('No Flatfield Images detected.')
        end
    for i = 1:length(files)
        fprintf('######### Running Analysis on image (%d/%d) ######### \n', i,length(files))
        cd(files(i).folder)
        img = readTiff(files(i).name);
        img = double(img);
        img = img-ff;
        cd('qBRM')
        if length(size(img)) > 3
            if size(img,4) > 10
               [~, phi, A] = analytical_qBRM(img(:,:,1,:),img(:,:,2,:),img(:,:,3,:));

               [~, RGB_norm] = phi_to_rgb_nogpu(phi,cmap,A);
               %%%% DO NOT MAKE EDITS TO ANY OF THIS CODE

               x=0;
            else
                [I0, phi, A, RGB_norm] = qBRM_solve_gpu(img);
            end
            %[A, RGB_norm, phi] = analyze_qBRM_zstack(img, phi_shift);
            %write_zstack(A,sprintf('Ret/ret_%03d.tif',i));
            write_zstack(RGB_norm,sprintf('RGB_norm/RGB_norm_%03d.tif',i));
%             imwrite(single(phi),sprintf('phi/phi_%03d.tif',i));
            save_tiff(single(phi),sprintf('phi/phi_%03d.tif',i));
            cd('Ret')
            save_tiff(single(A),sprintf('ret_%03d.tif',i));
        else
            %[I0, phi, A, RGB_norm] = qBRM_solve_gpu(img, phi_shift);

            %[A, ~, phi] = solve_qBRM_symbolic_full(img);
            %[~,RGB_norm] = convert_phi_to_RGB(phi, cmap,A);
            %[~, RGB_norm] = phi_to_rgb_nogpu(phi,cmap,A);
            [I0, phi, A, RGB_norm] = qBRM_solve_gpu(img);
            imwrite(RGB_norm,sprintf('RGB_norm/RGB_norm_%03d.tif',i));

            %imwrite(single(phi),sprintf('phi/phi_%03d.tif',i));
            saveastiff(single(phi),sprintf('phi/phi_%03d.tif',i));
            cd('Ret')
            saveastiff(single(A),sprintf('ret_%03d.tif',i));

%%%%% Uncomment for transmittance
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%             cd(files(i).folder)
%             cd('qBRM')
%             cd('trans')
%             imwrite(uint8((1/3).*sum(ff_images,3)), sprintf('trans_background_%03d.tif',i)) 
%             imwrite(uint8(I0), sprintf('transmittance_%03d.tif',i))
%             trans_scale_factor = 1/2;
%             imwrite(uint8(trans_scale_factor.*mean2((1/3)*sum(ff_images,3)).*I0./((1/3).*sum(ff_images,3))), sprintf('transmittance_corrected_%03d.tif',i))
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        end
    end
    disp('########### Finished qBRM Analysis ###########')
end