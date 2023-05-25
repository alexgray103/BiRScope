function [I0, ret, phi, RGB_norm] = qBRM_solve_minibatch_gpu(minibatch, imgset, FF)
    counter = 1;
    I0 = zeros([size(imgset,1),size(imgset,1),1,size(imgset,4)], 'double');
    ret = zeros([size(imgset,1),size(imgset,1),1,size(imgset,4)], 'double');
    phi = zeros([size(imgset,1),size(imgset,1),1,size(imgset,4)], 'double');
    RGB_norm = zeros([size(imgset,1),size(imgset,1),3,size(imgset,4)], 'double');
    iter = floor(size(imgset,4)/minibatch);
    remainder = rem(size(imgset,4),minibatch);
    fprintf(1,'Solving qBRM Progress: %3d%%\n',0);
    for i =1:iter
        sub_counter = 1;
        % store the values from each iteration into the corresponding array 
        [I0(:,:,:,1+(i-1)*minibatch:(i*minibatch)), ...
            phi(:,:,:,1+(i-1)*minibatch:(i*minibatch)), ...
            ret(:,:,:,1+(i-1)*minibatch:(i*minibatch)), ...
            RGB_norm(:,:,:,1+(i-1)*minibatch:(i*minibatch))] = qBRM_solve_gpu(imgset(:,:,:,1+(i-1)*minibatch:(i*minibatch)));
        prog = ( 100*(i/iter) );
        fprintf(1,'\b\b\b\b%3.0f%%',prog);
    end
    % save the remaining images (remainder after doing sets of minibatch
    % images
    [I0(:,:,:,iter*minibatch+1:iter*minibatch+remainder), ...
            phi(:,:,:,iter*minibatch+1:iter*minibatch+remainder), ...
            ret(:,:,:,iter*minibatch+1:iter*minibatch+remainder), ...
            RGB_norm(:,:,:,iter*minibatch+1:iter*minibatch+remainder)] = qBRM_solve_gpu(imgset(:,:,:,iter*minibatch+1:iter*minibatch+remainder));
end