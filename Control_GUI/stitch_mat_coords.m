function  fused_array = stitch_mat_coords(filepath, filename, val, image_names)
    
    Xsize = 2960;
    Ysize = 2960;
    Xoverlap = 0.1;
    Yoverlap = 0.1;
    
    % use following 3 lines if stitch using 2P coordinates
    f=strcat(filepath, '\','TileConfiguration.registered.txt');
    coord = read_Fiji_coord(f, image_names);

    fprintf('read coordinates')
    % define coordinates for each tile
    Xcen=zeros(size(coord,2),1);
    Ycen=zeros(size(coord,2),1);
    index=coord(1,:);

    for ii=1:size(coord,2)
        Xcen(coord(1,ii))=round(coord(3,ii));
        Ycen(coord(1,ii))=round(coord(2,ii));
    end

    Xcen=Xcen-min(Xcen);
    Ycen=Ycen-min(Ycen);

    Xcen=Xcen+round(Xsize/2);
    Ycen=Ycen+round(Ysize/2);

    % tile range -199~+200
    stepx = Xoverlap*Xsize;
    x = [0:stepx-1 repmat(stepx,1,round((1-2*Xoverlap)*Xsize)) round(stepx-1):-1:0]./stepx;
    stepy = Yoverlap*Ysize;
    y = [0:stepy-1 repmat(stepy,1,round((1-2*Yoverlap)*Ysize)) round(stepy-1):-1:0]./stepy;

    [rampy,rampx]=meshgrid(y, x);
 
    ramp=gpuArray(rampy.*rampx);
    ramp = single(ramp); % blending mask
    cd(filepath);
    
    %read in first image to set size of gpuArray (set second dimension as 2
    %to make it easier to store GPUarray
    img = imread(sprintf('RGB_norm_%03d.tif', 1),1);
    img = zeros([size(img,1),size(img,2),1], 'single');
    Mosaic = zeros(max(Xcen)+Xsize ,max(Ycen)+Ysize, 'single');
    Masque = zeros(size(Mosaic), 'single');
    fused_array = zeros([size(Mosaic,1), size(Mosaic,2),3], 'uint8');

    fprintf(1,'Computation Progress: %3d%%\n',0);
    for ii = 1:val
        for i=1:length(index)
            in = index(i);
            % load file and linear blend
            imgtmp = imread(sprintf(filename, i));
            %img = squeeze(img(:,:,ii));
            img(:,:,1) = imgtmp(:,:,ii);
            img = im2single(img);
            row = round(Xcen(in)-Xsize/2+1:Xcen(in)+Xsize/2);                                                 %changed by stephan
            column = round(Ycen(in)-Ysize/2+1:Ycen(in)+Ysize/2);
            Masque(row,column) = Masque(row,column)+ramp;
            Mosaic(row,column) = Mosaic(row,column)+img.*ramp;
            prog = ( 100*(i/length(index)) );
	        fprintf(1,'\b\b\b\b%3.0f%%',prog); pause(0.1); % Deleting 4 characters (The three digits and the % symbol)
        end
        fprintf('finished thjat paryt \n')
        % process the blended image
        MosaicFinal=Mosaic./Masque;
        fprintf('finished thjat paryt \n')
        MosaicFinal=MosaicFinal-min(min(MosaicFinal));
        fprintf('finished thjat paryt \n')
        MosaicFinal(isnan(MosaicFinal))=0;
        fprintf('Working on saving it')
        % resize image to 10 000 px size
        fprintf('saved it')
        fused_array(:,:,ii) = MosaicFinal;
    end
end

