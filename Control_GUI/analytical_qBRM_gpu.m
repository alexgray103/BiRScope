function [I0, phi, ret] = analytical_qBRM_gpu(img)
    %if ~isa(img, 'double')
    %   img = double(img);
    %end
    I0 = (2/3)*sum(img,3);
    %I0 = (2/3)*sum(cat(3,img1,img2,img3),3);
    if isgpuarray(I0)
        I0 = gather(I0);
    end

    img1 = img(:,:,1,:);
    img2 = img(:,:,2,:);
    img3 = img(:,:,3,:);
    [~] = gather(img);
    % split up all mbasic computations to save gpu memory
    term_tmp = (img(:,:,1,:).^2);
    disp('here')
    term_tmp = term_tmp+ (img(:,:,2,:).^2);
    disp('here')
    term_tmp = term_tmp+ (img(:,:,3,:).^2);
    disp('here')
    term_tmp = term_tmp- img(:,:,1,:).*img(:,:,2,:);
    disp('here')
    term_tmp = term_tmp- img(:,:,1,:).*img(:,:,3,:);
    disp('here')
    term_tmp = term_tmp - img(:,:,1,:).*img(:,:,3,:);
    disp('here')
    term_tmp = term_tmp - img(:,:,1,:).*img(:,:,3,:);
    disp('here')
    term_tmp = abs(term_tmp);
    disp('here')
    term_tmp = sqrt(term_tmp);
    disp('here')
    term = 2*term_tmp;

    %term = 2*sqrt(abs((img(:,:,1,:).^2) + (img(:,:,2,:).^2) + (img(:,:,3,:).^2) - img(:,:,1,:).*img(:,:,2,:) - img(:,:,1,:).*img(:,:,3,:) - img(:,:,1,:).*img(:,:,3,:)));
    
   
    ret = term./sum(img,3);
    if isgpuarray(ret)
        ret = gather(ret);
    end
    % condesnse this math as well for gpu purposes
    term = term-img(:,:,3,:)*sqrt(3);
    disp('here')
    term = term+img(:,:,2,:)*sqrt(3);
    disp('here')
    %term = (img(:,:,2,:)*sqrt(3)-img(:,:,3,:)*sqrt(3)+term);
    
    %clear term
    %term3 = term2./(-2*img(:,:,1,:) + img(:,:,2,:) + img(:,:,3,:));
    term = term./(sum(img,3)-3*img(:,:,1,:));
    disp('here')
    %clear term
    term = -atan(term);
    if isgpuarray(term)
        phi = gather(term);
    end
end