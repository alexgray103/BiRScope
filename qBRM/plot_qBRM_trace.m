function plot_qBRM_trace(location1,location2,img)
    val = img(location1,location2,:);
    val = val(:);
    plot(val,'r.')
end