function write_image_Seq(directory)
cd(directory)
num_files = dir('*.tif');
mkdir('Image Sequences')


fprintf('Writing Image Sequences     ')
for i = 1:length(num_files)
    cd(directory)
    img = readTiff(sprintf('img_%03d.tif',i));
    cd('Image Sequences')
    mkdir(sprintf('img_%03d',i))
    cd(sprintf('img_%03d',i))
    for ii = 1:size(img,3)
        imwrite(img(:,:,ii), sprintf('img_%03d_%04d.tif',i,ii));
    end
    fprintf('\b\b\b\b\b[%2.0i%%]',round(100*i/length(num_files)))
end
end