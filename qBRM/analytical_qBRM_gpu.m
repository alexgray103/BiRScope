function [I0, phi, ret] = analytical_qBRM_gpu(img)
    %if ~isa(img, 'double')
    %   img = double(img);
    %end
    I0 = (2/3)*sum(img,3);
    %I0 = (2/3)*sum(cat(3,img1,img2,img3),3);
    if isgpuarray(I0)
        I0 = gather(I0);
    end
    term = 2*sqrt(abs((img(:,:,1,:).^2) + (img(:,:,2,:).^2) + (img(:,:,3,:).^2) - img(:,:,1,:).*img(:,:,2,:) - img(:,:,1,:).*img(:,:,3,:) - img(:,:,1,:).*img(:,:,3,:)));
    
   
    ret = term./sum(img,3);
    if isgpuarray(ret)
        ret = gather(ret);
    end
    term2 = (img(:,:,2,:)*sqrt(3)-img(:,:,3,:)*sqrt(3)+term);
    clear term
    %term3 = term2./(-2*img(:,:,1,:) + img(:,:,2,:) + img(:,:,3,:));
    term3 = term2./(sum(img,3)-3*img(:,:,1,:));
    clear term2
    phi = -atan(term3);
    if isgpuarray(phi)
        phi = gather(phi);
    end
end