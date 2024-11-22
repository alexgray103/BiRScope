function corrected_images = birefringence_correction(flatfield, images)
    corrected_images = images - (flatfield-mean(flatfield));
end