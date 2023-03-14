function corrected_qBRM = full_ff_correction(img, ff_images, dark_frame, corr)
% takes in 6 images, 6 flat-field images and dark-frame image
% then corrects them with method of choice
% corr = "flat-field" - uses flat-field correction
%      = "no correction" - doesnt use any correction


    if strcmp(corr, "flat-field") 
        corrected_qBRM = ff_correction(img, dark_frame, ff_images);
        no_sample_corrected = ff_correction(ff_images,dark_frame,ff_images);
        [num_row, num_col] = size(corrected_qBRM{1,1});
        N = num_row*num_col;
        for i = 1:length(img)
            % Correct for the birefringence of the system
            temp(i).px_traces = double(corrected_qBRM{1,i}) - double(no_sample_corrected{1,i});
            temp(i).px_traces = reshape(temp(i).px_traces,[1,N]); % reshape to vector form
            sample_px_traces(:,i) = temp(i).px_traces; % add vector to storage
        end
    end
    if strcmp(corr, "no correction") 
        corrected_qBRM = img;
        [num_row, num_col] = size(corrected_qBRM{1,1});
        N = num_row*num_col;
        for i = 1:length(img)
            % Correct for the birefringence of the system
            temp(i).px_traces = double(corrected_qBRM{1,i});
            temp(i).px_traces = reshape(temp(i).px_traces,[1,N]); % reshape to vector form
            sample_px_traces(:,i) = temp(i).px_traces; % add vector to storage
        end
    end
    corrected_qBRM = sample_px_traces; % reshape back to image form
 end

