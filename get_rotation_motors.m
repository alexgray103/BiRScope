function DEVICES = get_rotation_motors(port)
% initalize the net assembly for rotation motor
asmb = NET.addAssembly("C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO_DLL.dll");

% import all functions 
import Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.*
import Thorlabs.Elliptec.ELLO_DLL.ELLDevices.*
import Thorlabs.Elliptec.ELLO_DLL.ELLBaseDevice.*
import Thorlabs.Elliptec.ELLO_DLL.ELLDevice.*

adresses = ["0in","1in","2in","3in","4in","5in","6in","7in","8in","9in"...
    "Ain","Bin","Cin","Din","Ein","Fin"];
device_handle = Thorlabs.Elliptec.ELLO_DLL.ELLDevices;
if Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Connect(port)
    disp(sprintf('I connected to port: %s', port))

    % scan for available adresses for each motor
    avail_addresses = device_handle.ScanAddresses('0','F');
    
    for i = 1:length(avail_addresses.Count)
        channel = char(avail_addresses.Item(i-1));
        if device_handle.Configure(avail_addresses.Item(i-1))
            disp(sprintf('Channel:%s',channel(1)))
            disp(sprintf('Device Found at address: %s',avail_addresses.Item(i-1)))
            DEVICES(i).addressed_device = device_handle.AddressedDevice(channel(1));
            
            DEVICES(i).addressed_device.DeviceInfo % print device info in description form
            disp('Homing device...')
            default = System.Reflection.Missing.Value;
            [~] = DEVICES(i).addressed_device.Home(default); %% home in the clockwise direction
            pause(0.5)
            % set the aboslute position to 0:30:150 degrees
            for ii = 30:30:150
                [~] = DEVICES(i).addressed_device.MoveAbsolute(ii);
                pause(0.5)
            end
        end
    end

end


end


