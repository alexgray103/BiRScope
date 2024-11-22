function out = stitch_inplace(folder, gridx, gridy, overlap)  
    %Setup variables and image data
    overlap = overlap/100;
    imgds = imageDatastore(folder);
    [ysize, xsize] = size(imread(imgds.Files{2}));

    %Gets the size of the overlapping sections
    oversizex = round(xsize*overlap);
    oversizey = round(xsize*overlap);
    
    %Stitches together the images into rows
    bodyx = xsize - 2*oversizex;
    bodyy = ysize - 2*oversizey;
    im = uint8(zeros(ysize, gridx*bodyx+(gridx+1)*oversizex));
    [~, imsizex] = size(im);
    imcell = {};
    for j = 1:gridy
        startpoint = j*gridx-gridx+1+gridx*gridy;
        if ~mod(j,2)==0
            im1 = imread(imgds.Files{startpoint});
            im(:, 1:oversizex) = im1(:, 1:oversizex);
            for i = startpoint:startpoint+gridx-2
                im2 = imread(imgds.Files{i+1});
                bodyx = xsize - 2*oversizex;
                im1body = im1(:, oversizex+1:xsize-oversizex);
                im2body = im2(:, (oversizex+1):xsize);
                im1over = im1(:, (xsize-oversizex+1):xsize);
                im2over = im2(:, 1:oversizex);
            
                mult1 = [oversizex:-1:1];
                mult2 = [1:oversizex];
                overim = uint8((mult1.*double(im1over) + mult2.*double(im2over))/(oversizex+1));
            
                im(:, (i-startpoint)*(bodyx+oversizex)+oversizex+1:(i-startpoint)*(bodyx+oversizex)+bodyx+oversizex) = im1body;
                im(:, (i-startpoint)*(bodyx+oversizex)+bodyx+oversizex+1:(i-startpoint)*(bodyx+oversizex)+bodyx+2*oversizex) = overim;
                im1 = im2;
            end
            im(:, imsizex-bodyx-oversizex+1:imsizex) = im2body;
        else
            im1 = imread(imgds.Files{startpoint+gridx-1});
            im(:, 1:oversizex) = im1(:, 1:oversizex);
            for i = startpoint+gridx-1:-1:startpoint+1
                im2 = imread(imgds.Files{i-1});
                bodyx = xsize - 2*oversizex;
                im1body = im1(:, oversizex+1:xsize-oversizex);
                im2body = im2(:, (oversizex+1):xsize);
                im1over = im1(:, (xsize-oversizex+1):xsize);
                im2over = im2(:, 1:oversizex);
            
                mult1 = [oversizex:-1:1];
                mult2 = [1:oversizex];
                overim = uint8((mult1.*double(im1over) + mult2.*double(im2over))/(oversizex+1));
           
                im(:, (gridx-i+startpoint-1)*(bodyx+oversizex)+1+oversizex:(gridx-i+startpoint)*(bodyx+oversizex)) = im1body;
                im(:, (gridx-i+startpoint-1)*(bodyx+oversizex)+1+bodyx+oversizex:(gridx-i+startpoint)*(bodyx+oversizex)+oversizex) = overim;
                im1 = im2;
            end
            im(:, imsizex-bodyx-oversizex+1:imsizex) = im2body;
        end
        imcell = [imcell {im}];
    end
    
    %Stitches together the rows into a complete image
    im = uint8(zeros(gridy*bodyy+(gridy+1)*oversizey, gridx*bodyx+(gridx+1)*oversizex));
    [imsizey, ~] = size(im);
    im1 = imcell{1};
    im(1:oversizey, :) = im1(1:oversizey, :);
    for i = 2:length(imcell)
        im2 = imcell{i};
        im1body = im1(oversizey+1:ysize-oversizey, :);
        im2body = im2((oversizey+1):ysize, :);
        im1over = im1((bodyy+oversizey+1):ysize, :);
        im2over = im2(1:oversizey, :);
    
        mult1 = [oversizey:-1:1]';
        mult2 = [1:oversizey]';
        overim = uint8((mult1.*double(im1over) + mult2.*double(im2over))/(oversizey+1));
    
        im((i-2)*(bodyx+oversizey)+oversizey+1:(i-2)*(bodyy+oversizey)+bodyy+oversizey, :) = im1body;
        im((i-2)*(bodyx+oversizey)+bodyy+oversizey+1:(i-2)*(bodyy+oversizey)+bodyy+2*oversizey, :) = overim;
        im1 = imcell{i};
    end
    im(imsizey-bodyy-oversizey+1:imsizey, :) = im2body;
    out = im;
end