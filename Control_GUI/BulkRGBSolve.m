%function imgstack=BulkRGBSolve(fileloc)
fileloc='F:\ParaffinEmbedding\20230613';
direct=dir(fileloc);
for ii=[3:length(direct)]
    dirpath=append(direct(ii).folder,'\',direct(ii).name);
    %solve_qBRM_trans(dirpath)
    solve_widefield_qBRM_folder(dirpath)
    

end
%end
