function Focus_stack_current_folder_of_images_and_stitch(directory,gridx,gridy, overlap)
    addpath('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions')
    addpath 'C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM'
    solver = load('Symbolic_solution_0_60_120.mat').solve_qBRM_symbolic;

    focus_stacking_wanted = 0;

   % load cmap for RGB image creation
    cmap = load('C:\Users\BMOadmin2\Documents\Control_GUI\BRMscope\Functions\qBRM\cmap_v3.mat').cmap;    

    cd(directory)
    files = dir('*.tif');
    mkdir('qBRM')
    for i = 1:length(files)
        cd(files(i).folder)
        fprintf('\n############# Focus Stacking Image %d/%d ############# \n\n',i,length(files))
        info = imfinfo([files(i).folder,'\',files(i).name]);
        if strcmp(info(1).ColorType,'truecolor')
            cd('qBRM')
            stack = load_RGB_zstack([files(i).folder,'\',files(i).name]);
            [A, RGB_norm, ~] = analyze_qBRM_zstack(stack);
            write_zstack(A,sprintf('ret_%03d.tif',i));
            write_zstack(RGB_norm,sprintf('RGB_norm_%03d.tif',i));
            stack = A;
            
        else
            if ~exist('Focus_Stack','dir')
                mkdir('Focus_Stack')
            end
            cd('Focus_Stack')
            stack = load_zstack([files(i).folder,'\',files(i).name]);
        end
        cd(files(i).folder)
        if focus_stacking_wanted
            [edofimg] = fstack(stack);
            if strcmp(info(1).ColorType,'truecolor')
                imwrite(edofimg,sprintf('Focus_Stack_ret_%03d.tif',i))
                stitch_name = 'Focus_Stack_ret_{iii}.tif';
                fused_name = 'Focus_stack_ret_fused';
            else
                imwrite(edofimg,sprintf('Focus_Stack_%03d.tif',i))
                stitch_name = 'Focus_Stack_{iii}.tif';
                fused_name = 'Focus_stack_fused';
            end
        end
        fprintf(' %%%%%%%%%%%% Focus Stacked Image %d %%%%%%%%%%%%%%\n',i)
    end
    
    fiji_stitching(gridx, gridy, overlap, directory, stitch_name, fused_name);
    movefile('img_t1_z1_c1', 'Focus_stack_Fused.tif'); % change the filename into a tif format

end