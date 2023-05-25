function software_test()

    DEFAULTPATH = ['C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.DeviceManagerCLI.dll';
        'C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.GenericMotorCLI.dll';
        'C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.KCube.DCServoCLI.dll';
        'C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.IntegratedStepperMotorsCLI.dll'
        'C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.Benchtop.BrushlessMotorCLI.dll';
        "C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO.exe";
        "C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO_DLL.dll";];

    SOFTWAREPACKAGE = ["KINESIS";"KINESIS";"KINESIS";"KINESIS";"KINESIS";"ELLIPTEC";"ELLIPTEC"];
    val = 1:length(DEFAULTPATH);
    message_error = [];
    for i = 1:length(DEFAULTPATH)
        % check if the file path exists and add to the val array for
        % software that needs to be downloaded
        if ~exist(DEFAULTPATH(i))
            val(i) = 1;
        else
            val(i) = 0;
        end
    end
    message = DEFAULTPATH(logical(val));
    type = SOFTWAREPACKAGE(logical(val));
    match = wildcardPattern + "\";
    message = erase(message,match);


    for ii = 1:length(message)
        message_error = strcat(sprintf('-%s\n',[message(ii), ' ']), message_error);
    end
    disp(message_error)
    assert(~any(val), sprintf('Missing Software Packages for: \n \n %s', message_error))
end