function z_stack_bb_crop(img,bb_mat,output_size,overlap_threshold)
    myImage = img;
    
    bb_mat;
    overlap_threshold = 0.8;

    [rowstmp,colstmp]= size(myImage);
    block_height     = output_size(2);
    block_width      = output_size(1);
    
    blocks_per_row   = rowstmp/block_height;
    blocks_per_col   = colstmp/block_width;

    
    %// make sure these image have type uint8 so they save properly
    %cropped_image = uint8(zeros(rows,cols), 'like', myImage);
   
    %// loop over the image blocks
    for i = 1:blocks_per_row
        for j = 1:blocks_per_col
            %// get the cropped image from the original image
            idxI = 1+(i-1)*block_height:i*block_height;
            idxJ = 1+(j-1)*block_width :j*block_width;

            if j*block_width > size(myImage,2)
                
            end

            if i*block_height > size(myImage,1)
                
            end

            cropped_image = myImage(idxI,idxJ, :);

                %// pad image with zeros if needed
%                 if ~(mod(rowstmp-1,block_height)==0)
%                     rows = ceil(rowstmp/block_height)*block_height;
%                 end
%                 if ~(mod(colstmp-1,block_width)==0)
%                     cols = ceil(colstmp/block_width)*block_width;
%                 end
            
            imshow(cropped_image)
            drawnow
            input('Press Enter to continue')
        end
    end
end