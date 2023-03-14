function plot_retardance(ret)
    abs_hot = ret;
    imagesc(abs_hot);
    axis image;
    colorbar;
    set(gca,'XTick',[],'YTick',[]);
    colormap(hot);
    %cl = prctile(abs_hot(:), [7 99.9]);
    cl = [0.0, 1.0];
    caxis([cl(1) cl(2)]);
    
    abs_hot2 = (abs_hot-cl(1))./(cl(2)-cl(1));
    abs_hot2(abs_hot2>1) = 1;
    abs_hot2(abs_hot2<0) = 0;
    abs_hot2 = im2uint8(abs_hot2);
    
    % %normalize retardance image and convert to uint16
    % I = AC_ratio;
    % I3 = I;
    % I3(I3<0) = 0;
    % I3 = single(I3);
    % MAT2TIFF(I3, [filename, 'ac_32bit.tif']);
    %
    % I = r_axer_abs;
    % I = (I-min(min(I)))./(max(max(I))-min(min(I)));
    % I2 = im2uint16(I);
end