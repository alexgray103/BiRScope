

function corrected_sample_px_traces=backgroundCorrrection(angles,image_set,dark_frames,ff_images)
    num_images = length(angles); % Be sure not to analyze both 0 and 180 degree settings - old
    
    
    % Perform flat-field correction
    corrected_image_set = cell(1,num_images);
    corrected_no_sample = cell(1,num_images);

    raw=image_set;
    dark=dark_frames;
    ff=ff_images;
    dark = mean2(dark);
        
        for ii = 1:length(angles)
            m = mean2(ff(:,:,1) - dark);
            corrected_image_set{1,ii} = (double(raw(:,:,ii) - dark).*m)./(double(ff(:,:,ii) - dark));
        end
    dark = mean2(dark);
        for ii = [1:length(angles)]
            
            m = mean2(ff(:,:,1) - dark);
            corrected_no_sample{1,ii} = (double(ff_images(:,:,ii) - dark).*m)./(double(ff(:,:,ii) - dark));
        end
    %figure,imshow(corrected_no_sample{1,1})
    %corrected_image_set = uint16(ff_correction(image_set,dark_frames,ff_images));
    %corrected_no_sample= uint16(ff_correction(ff_images,dark_frames,ff_images));
    disp('Flat-field correction complete.');
    
    %% Background Correction
    
    
    % Anna's new code for faster data redistribution (November 2020)
    t_start = tic;
    [num_row, num_col] = size(corrected_image_set{1,1});
    N = num_row*num_col;
    temp = {};
    sample_px_traces = zeros(num_row ,num_col, num_images);
    % Redistribute image data into data structures for analysis
    for i=1:num_images
        sample_px_traces(:,:,i)=double(corrected_image_set{1,i}) - double(corrected_no_sample{1,i});
    end
  

    corrected_sample_px_traces=sample_px_traces;
    clear return_data
end
