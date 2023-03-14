function plot_orientation(phi, axis_handle,cmap)
    imshow(phi, 'Parent',axis_handle)
    colormap(cmap)
    clim([0 pi])
end