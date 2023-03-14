function SCC_upload(file_location)
    try

    current = pwd; % save current dir so that we can go back into it later
    command = "qsub /project/gpumcml/Alex_qBRM/Output_stream/fit_qBRM_cores.qsub";
    % go into directory to use putty scp for upload to the SCC
    cd("C:\Users\blank\OneDrive\_Documents\_BU\_Bigio\MATLAB\qBRM_BMO\APP_designer\SCC\")
    
    % upload files with putty pscp command
    disp('Uploading to SCC')
    system(sprintf('pscp -pw WormTime103 -r "%s" algray@scc1.bu.edu:/project/gpumcml/Alex_qBRM/Images/', file_location));
    
    % SSH into SCC then execute qsub script for fitting
    disp('Running post Processing remotely')
    system("plink.exe -ssh algray@scc1.bu.edu -pw WormTime103 -m test_sh.sh");
    
    %system("plink.exe -ssh scc1.bu.edu -pw WormTime103 -l algray sh /project/gpumcml/Alex_qBRM/Output_stream/Run_fitting.sh");
    % this command generalizes this function to a specific command to the SCC
    %system(sprintf('plink.exe -ssh scc1.bu.edu -pw WormTime103 -l algray %s', command); %
    
    cd(current) % reset working directory for saving
    catch ME
        errordlg(ME.message, 'File Not found')
    end
end