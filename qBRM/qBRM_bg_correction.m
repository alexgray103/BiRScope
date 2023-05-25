function corrected_img = qBRM_bg_correction(qBRM_img,bg_qBRM_img)
    
    % find relative amount of background at each pixel
    bg_mean = mean(bg_qBRM_img,3);
    bg = double(bg_qBRM_img) - bg_mean;

    corrected_img = double(qBRM_img) - bg;
    corrected_img = uint16(corrected_img);
end