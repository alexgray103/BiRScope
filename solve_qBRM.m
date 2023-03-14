function [phi, A, C] = solve_qBRM(img)
% fits sinusoid data using levenberg marquardt algorthm
% num_row, num_col - size of original image. 
% img - image data for fitting in 1D format
    
    img = double(img);

    I1 = img(:,:,1);
    I2 = img(:,:,2);
    I3 = img(:,:,3);
    
    [num_row, num_col] = size(I1);

    theta = 2*30*pi/180;
    % solve
    C_pr = (I1+I3)./2;
    asinb = (I1-C_pr);
    acosb = (I2-C_pr-asinb.*cos(theta))./sin(theta);
    A_pr = sqrt(asinb.^2+acosb.^2);
    phi_pr = -(1/2).*atan(asinb./acosb);
    phi_pr = phi_pr + (pi/2).*single(acosb < 0);
    
    %plot fit
%     for i=1:2:10
%         angles = (0:180)*pi/180;
%         a = A_pr(i);
%         b = phi_pr(i);
%         c = C_pr(i);
%         I1_i = I1(i);
%         I2_i = I2(i);
%         I3_i = I3(i);
%         I_pr = a*sin(2*angles - 2*b)+c;
%         hold on;
%         plot(angles, I_pr)
%         plot([0, pi/6, pi/2], [I1(i), I2(i), I3(i)], '.r')
%         xlim([0, pi])
%         hold off;
%     end
%     hist(phi_pr);
    
    A = reshape(abs(A_pr), [num_row num_col]);
    phi = reshape(mod(phi_pr, pi), [num_row num_col]);
    C =  reshape(C_pr, [num_row num_col]);
end