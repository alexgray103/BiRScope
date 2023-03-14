function [I0, phi, ret] = analytical_qBRM(img1,img2,img3)
    %if ~isa(img, 'double')
    %   img = double(img); 
    %end

    term = 2*sqrt(abs((img1.^2) + (img2.^2) + (img3.^2) - img1.*img2 - img1.*img3 - img2.*img3));
    I0 = (2/3)*(img1+img2+img3);

    phi = -atan((img2*sqrt(3)-img3*sqrt(3)+term)./(-2*img1 + img2 + img3));

    ret = term./(img1 + img2 + img3);

end