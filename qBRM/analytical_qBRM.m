function [I0, phi, ret] = analytical_qBRM(img1,img2,img3, varargin)
    %if ~isa(img, 'double')
    %   img = double(img); 
    %end
    I0 = (2/3)*(img1+img2+img3);
    %I0 = (2/3)*sum(cat(3,img1,img2,img3),3);
    if isgpuarray(I0)
        I0 = gather(I0);
    end
    term = 2*sqrt(abs((img1.^2) + (img2.^2) + (img3.^2) - img1.*img2 - img1.*img3 - img2.*img3));
    

    phi = -atan((img2*sqrt(3)-img3*sqrt(3)+term)./(-2*img1 + img2 + img3));
    if isgpuarray(phi)
        phi = gather(phi);
    end
    
    ret = term./(img1 + img2 + img3);
    if isgpuarray(ret)
        ret = gather(ret);
    end
    
end