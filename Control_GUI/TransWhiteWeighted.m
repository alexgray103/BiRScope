function [transweighted,transw]=TransWhiteWeighted(trans_corr,RGB_norm,thresh,name)

    transw=trans_corr;
    transw(trans_corr<thresh)=255;
    transw(trans_corr>thresh)=1;
    figure(),imshow(transw)

    transweighted=transw.*(RGB_norm+1);
    figure(),imshow(transweighted)
    imwrite(transweighted,sprintf('trans_highlighted_%s.tif',name))
end