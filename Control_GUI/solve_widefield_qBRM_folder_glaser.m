function solve_widefield_qBRM_folder_glaser(folder_loc, varargin)
    phishift=pi/4;%10*pi/24;
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;

%    load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;   

% 
%     addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
%     addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
%     solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;
% 
%    % load cmap for RGB image creation
%     cmap = load('C:\Users\BMOadmin\Documents\MATLAB\functions\cmap_v3.mat').cmap; 
%    cmap=load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;

    cd(folder_loc)
    files = dir('*.mat');
    mkdir('qBRM')
    cd('qBRM')
    mkdir('Ret')
    mkdir('RGB_norm')
    mkdir('phi')
%%%%% Uncomment for transmittance
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     mkdir('trans') 
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cd(folder_loc)

    % try to run flatfield
        if exist('Flatfield', 'dir')
            fprintf('Flatfield Images Detected \n')
            cd('Flatfield')
            ffstruct=load('Flatfield.mat');
            angs=ffstruct.angles;
            ff = double(ffstruct.images);
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
        ff(:,:,18)=ff(:,:,2);
%         gpuDetected = 0;
%         if canUseGPU()
%             D = gpuDevice;
%             D.CachePolicy = 'maximum';
%             fprintf('GPU loaded for analysis\n');
%             ff = gpuArray(ff);
%             gpuDetected = 1;
%         end
    for i = 1:length(files)
        fprintf('######### Running Analysis on image (%d/%d) ######### \n', i,length(files))
        cd(files(i).folder)
        fprintf('Loading Image ("%s") \n', files(i).name)
        tic
        imgstruct = load(files(i).name);
        disp(imgstruct)
        img=imgstruct.images;
%         img=imgstruct.rgb_img;

        img_num = files(i).name;
        img_num = str2num(img_num(5:7));

        y = toc;
        fprintf('Loaded Image ("%s") %5.2f seconds\n', files(i).name, y)
        img = single(img);
%         if gpuDetected
%             img = single(gpuArray(img));
%         end
        img = img-ff;

        cd('qBRM')
        %disp(length(size(img)))
        if length(size(img)) > 3
            % new code for doign gpu calculations
            [I0, phi, A, RGB_norm] = multipointGlaserM(img,angs);


            % old code when the GPU wasnt working 
            % if size(img,4) > 10
            %    [~, phi, A] = analytical_qBRM(img(:,:,1,:),img(:,:,2,:),img(:,:,3,:));
            % 
            %    [~, RGB_norm] = phi_to_rgb_nogpu(phi,cmap,A);
            %    %%%% DO NOT MAKE EDITS TO ANY OF THIS CODE
            % 
            %    x=0;
            % else
            %     [I0, phi, A, RGB_norm] = qBRM_solve_gpu(img);
            % end
            %[A, RGB_norm, phi] = analyze_qBRM_zstack(img, phi_shift);
            %write_zstack(A,sprintf('Ret/ret_%03d.tif',i));
            write_zstack(im2uint8(RGB_norm),sprintf('RGB_norm/RGB_norm_%03d.tif',img_num));
%             imwrite(single(phi),sprintf('phi/phi_%03d.tif',i));
            save_tiff(single(phi),sprintf('phi/phi_%03d.tif',img_num));
            
            
            save_tiff(single(A),sprintf('ret_%03d.tif',img_num));

%%%%% Uncomment for transmittance
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            if exist('Flatfield', 'dir')
            else
                ff_images = 1;
            end

            cd(files(i).folder)
            cd('qBRM')
            cd('trans')
            disp('trans')
            write_zstack(uint8((1/3).*sum(ff_images,3)), sprintf('trans_background_%03d.tif',i)) 
            write_zstack(uint8(I0), sprintf('transmittance_%03d.tif',i))
            trans_scale_factor = 1/2;
            
            disp(trans_scale_factor)
            write_zstack(uint8(trans_scale_factor.*mean2((1/3)*sum(ff_images,3)).*I0./((1/3).*sum(ff_images,3))), sprintf('transmittance_corrected_%03d.tif',i))
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            else
            %[I0, phi, A, RGB_norm] = qBRM_solve_gpu(img, phi_shift);

            %[A, ~, phi] = solve_qBRM_symbolic_full(img);
            %[~,RGB_norm] = convert_phi_to_RGB(phi, cmap,A);
            %[~, RGB_norm] = phi_to_rgb_nogpu(phi,cmap,A);
            %[I0, phi, A, RGB_norm] = qBRM_solve_gpu(img);
            [I0, phi, A, RGB_norm] = multipointGlaserM(img,angs);
            imwrite(uint8(255*RGB_norm),sprintf('RGB_norm/RGB_norm_%03d.tif',img_num));

            %imwrite(single(phi),sprintf('phi/phi_%03d.tif',i));
            saveastiff(single(phi),sprintf('phi/phi_%03d.tif',img_num));
            cd('Ret')
            saveastiff(single(A),sprintf('ret_%03d.tif',img_num));
            %%%Uncomment for transmittance~~~~~~~~~~~~
            if exist('Flatfield', 'dir')
                fprintf('Flatfield Images Detected \n')
                cd('Flatfield')
                ffstruct=load('Flatfield.mat');
                ff = double(ffstruct.images);
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
%             else
%                 ff_images = 1;
            end
            ff(:,:,18)=ff(:,:,2);

            cd(files(i).folder)
            cd('qBRM')
            cd('trans')
            disp('trans')
%             disp(size(ff_images))
            write_zstack(uint8((1/3).*sum(ff_images,3)/1000), sprintf('trans_background_%03d.tif',i)) 
            write_zstack(uint8(I0/1000), sprintf('transmittance_%03d.tif',i))
            trans_scale_factor = 1/2000;
           
            disp(trans_scale_factor)
            write_zstack(uint8(trans_scale_factor.*mean2((1/3)*sum(ff_images,3)).*I0./((1/3).*sum(ff_images,3))), sprintf('transmittance_corrected_%03d.tif',i))
        end
    end
    disp('########### Finished qBRM Analysis ###########')
end