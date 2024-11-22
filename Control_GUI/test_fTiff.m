close all; clear all; clc;
img = readTiff('img_001.tif.tif');
filename = 'test.tif';
compression = 0;
switch 'gray'
    case 'gray'
        img = uint16(sum(img,3));
        img = img-min(img(:));
        img = img*(2^16/max(img(:)));
        filt = [0 1 0; 1 -4 1; 0 1 0];
        img2 = uint16(conv2(img, filt, 'same'));
    case 'color'
        img2 = circshift(img,1,3);
    case 'float'
        img = single(sum(img,3))*pi;
        img2 = -img;
    case 'color_float' %not supported by ImageJ
        img = single(img);
        img = img-min(img(:));
        img = img/max(img(:));
        img2 = 1-img; %also write the inverted image
end

%write
fTIF = Fast_Tiff_Write(filename,0.10625,compression);
fTIF.WriteIMG(permute(img,[2,1,3]));
fTIF.WriteIMG(permute(img2,[2,1,3]));
fTIF.close;
%read
I = imfinfo(filename);
d=imread(filename,'Index',1,'Info',I);
if ismatrix(d)
    d(:,:,2)=imread(filename,'Index',2,'Info',I);
    figure(1);clf;
    subplot(1,2,1);imagesc(d(:,:,1));
    subplot(1,2,2);imagesc(d(:,:,2));
elseif ndims(d)==3
    d(:,:,:,2)=imread(filename,'Index',2,'Info',I);
    figure(1);clf
    subplot(1,2,1);image(d(:,:,:,1));
    subplot(1,2,2);image(d(:,:,:,2));
end
