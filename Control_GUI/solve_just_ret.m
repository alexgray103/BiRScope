function solve_just_ret(folder_loc, varargin)

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
     mkdir('trans') 
%%%%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cd(folder_loc)

    % try to run flatfield
        if exist('Flatfield', 'dir')
            fprintf('Flatfield Images Detected \n')
            cd('Flatfield')
            ff= imread('Flatfield.tif');
            ff_images = ff;
            ff = single(ff) - mean(ff,3);
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
%         ff(:,:,18)=ff(:,:,2);
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
        img = readTiff(files(i).name);
        img = single(img) - ff;
%         img=imgstruct.rgb_img;

        img_num = files(i).name;
        img_num = str2num(img_num(5:7));

        y = toc;
        fprintf('Loaded Image ("%s") %5.2f seconds\n', files(i).name, y)
        img = single(img);
%         if gpuDetected
%             img = single(gpuArray(img));
%         end

        cd('qBRM')
        %disp(length(size(img)))
        [~, ~, ret,~] = analytical_qBRM_gpu_all(img);
        save_tiff(single(ret),sprintf('ret_%03d.tif',img_num));
    end
end