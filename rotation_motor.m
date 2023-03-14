classdef rotation_motor < handle

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Author: Alex Gray, MS. Boston University
    %%% Software control for ELL Rotation stages (ELL14) for ThorLabs motors
    %%% utilizing Elliptec software package
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Example code to connect motor: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

motor_list = rotation_motor.list_devices("COM4")
motor_1 = rotation_motor("COM4")
motor_1.Connect(motor_list(1));
motor_1.Home();

%}
    properties
        DLL_DEFAULT_PATH = "C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO_DLL.dll";
        COM_port; % COM port used for communication with motors
        connected; % make sure that device is configured

        % device specific information
        DEVICE_SPECS;
        
        % Motor characteristics
        Position;
        HomeOffset;
        JogStepsize;
        Units;
        addressed_device; %% Hold the addressed device info
        motor; % Object for the actul connected device
        motor_label;
    end 

    properties (Hidden)
        % Should be hidden later on 
            x;

    end

    properties (Hidden)
        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Constructor Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function motor_handle = rotation_motor(COM_port) % motor constructer
            rotation_motor.load_DLL;
            assert(Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Connect(COM_port), 'Cannot connect to port: %s', COM_port)
            motor_handle.COM_port = COM_port;
            
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%  Motor Functions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Sealed)
        function Connect(motor_handle, address)
            try
                motor_handle.motor = Thorlabs.Elliptec.ELLO_DLL.ELLDevices;
                
                % check if port is available
                assert(Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Connect(motor_handle.COM_port), 'Cannot connect to port: %s', motor_handle.COM_port)

                % configure device
                assert(motor_handle.motor.Configure(address(1)), 'Unable to Configure Device at Address: %s (port: %s)', address(1), motor_handle.COM_port)
                motor_handle.connected = 1;
                % Connect motor with the given address (Only use the first char
                % of address (other characters are motor info)
                motor_handle.addressed_device = motor_handle.motor.AddressedDevice(address(1));
                motor_handle.UpdateDeviceInfo(address);
                motor_handle.update_motorInfo();
            catch ME
                errordlg(ME.message, 'ERROR')
            end
        end

        function update_motorInfo(motor_handle)
            motor_handle.addressed_device.GetMotorInfo('1');
            motor_handle.addressed_device.GetMotorInfo('2');
            motor_handle.addressed_device.GetPosition();
            motor_handle.addressed_device.GetHomeOffset();
            motor_handle.addressed_device.GetJogstepSize();
            motor_handle.Position = motor_handle.addressed_device.Position.ToDouble(motor_handle.addressed_device.Position)/motor_handle.DEVICE_SPECS.pulsesperDegree;
            motor_handle.HomeOffset = motor_handle.addressed_device.HomeOffset.ToDouble(motor_handle.addressed_device.HomeOffset)/motor_handle.DEVICE_SPECS.pulsesperDegree;
            motor_handle.JogStepsize = motor_handle.addressed_device.JogstepSize.ToDouble(motor_handle.addressed_device.JogstepSize)/motor_handle.DEVICE_SPECS.pulsesperDegree;
        end

        function moveToPosition(motor_handle, Pos)
            motor_handle.addressed_device.MoveToPosition(Pos)
        end

        function getDescription(motor_handle)
            % get device info in the form of System*Strings then convert to
            % MATLAB char
            tmp_description = motor_handle.addressed_device.DeviceInfo.Description();
            description = cell(tmp_description.Count,1);
            for i = 1:tmp_description.Count
                description{i,1} = char(tmp_description.Item(i-1));
            end
            motor_handle.device_info = description;
        end
        function home_success =  Home(motor_handle)
            if motor_handle.connected
                disp('Homing...')
                default = System.Reflection.Missing.Value;
                home_success = motor_handle.addressed_device.Home(default); %% home in the clockwise direction
                if home_success
                    disp('Successfully Homed Motor ')
                else
                    errordlg('Motor Was not Homed...')
                end
            else
                errordlg('Motor Has not been initialized')
            end
        end
        
        function success = readdress_device(motor_handle, newAddress)
            assert(ischar(newAddress), 'New Address must be a Char')
            success = motor_handle.motor.ReaddressDevice(motor_handle.addressed_device.Address,newAddress);
            motor_handle.update_motorInfo();
            motor_handle.DEVICE_SPECS.Address = newAddress;
            motor_handle.DEVICE_SPECS.FULL_ADDRESS = strcat(newAddress, motor_handle.DEVICE_SPECS.FULL_ADDRESS(2:end));
        end

        function SetAddress(motor_handle, newAddress)
            if motor_handle.connected
                %try
                    % Explicitly send motor command to change address becuase this
                    % callback was not working: motor_handle.addressed_device.SetAddress(char(newAddress))
                    Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.SendStringB(motor_handle.addressed_device.DeviceInfo.Address, "ca", uint8(newAddress))
                    
                    disp(sprintf('Device %s Address has been set to %s (New device Name #%s)', motor_handle.addressed_device.DeviceInfo.Address, newAddress,newAddress))
                    Disconnect(motor_handle);
                    tmp = rotation_motor.list_devices(motor_handle.COM_port,newAddress,newAddress);
                    disp(tmp)
                    motor_handle = rotation_motor(motor_handle.COM_port);
                    motor_handle.Connect(tmp{1,1})
                    
                    disp('Connected to Device at New Address')
                    
                %catch ME
                %    errordlg(ME.message, 'Error','error')
                %end
            else
                errordlg('Motor Not Connected', 'ERROR', 'error')
            end
        end

        function MoveAbsolute(motor_handle, degree_location)
            if (isnumeric(degree_location)) && (length(degree_location) ==1)
                [~] = motor_handle.addressed_device.MoveAbsolute(degree_location*motor_handle.DEVICE_SPECS.pulsesperDegree);
            else
                errordlg('input to MoveAbsolute() must be a Positive Decimal')
            end
        end
        
        function pos = getPosition(motor_handle)
            motor_handle.addressed_device.GetPosition();
            pos = motor_handle.addressed_device.Position;
        end
        
        % convert all address info to DEVICE SPECS
        function UpdateDeviceInfo(motor_handle, address)
            motor_handle.DEVICE_SPECS.FULL_ADDRESS = address;
            motor_handle.DEVICE_SPECS.Address = motor_handle.addressed_device.Address;
            motor_handle.DEVICE_SPECS.devicetype = address(4:5); % get device type
            motor_handle.DEVICE_SPECS.SerialNum = address(6:13); % get device serial number
            motor_handle.DEVICE_SPECS.year = address(14:17); % get year of device manufacturing
            motor_handle.DEVICE_SPECS.firmware = strcat(address(18),'.',address(19)); %  put firmware in the proper format x.x
            motor_handle.DEVICE_SPECS.travel = hex2dec(address(22:25));
            motor_handle.DEVICE_SPECS.pulsepermeasurementUnit = hex2dec(address(26:33));
            motor_handle.DEVICE_SPECS.pulsesperDegree = motor_handle.DEVICE_SPECS.pulsepermeasurementUnit/motor_handle.DEVICE_SPECS.travel;
        end

        function message = Disconnect(motor_handle)
            if motor_handle.connected
                Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Disconnect();
                motor_handle.connected = 0;
                message = 'Motor Disconnected';
            else
                message = 'Unable to Disconnect Motor';
                errordlg('Motor was never Connected')
            end
        end


    end

    methods (Static)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % method to scan all potential motor locations and list motor
        % addresses
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function value = format_value(system_decimal_value)
            % Take in a System.Decimal Value and return teh Double
            % equivelent of that value
            value = system_decimal_value.ToDouble(system_decimal_value);
        end

        function channel = list_devices(port, varargin)
            minAddress = '0';
            maxAddress = 'F';
            if length(varargin) == 2 
                assert(ischar(varargin{1}), 'Address values must be of type Char')
                assert(ischar(varargin{2}), 'Address values must be of type Char')
                minAddress = varargin{1};
                maxAddress = varargin{2};
            elseif length(varargin) > 1
                error('Too many Inputs')
            end
            rotation_motor.load_DLL;

            device_handle = Thorlabs.Elliptec.ELLO_DLL.ELLDevices;

            %%% Check connection to COM port for motors
            assert(Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Connect(port), 'No motor Found at port: %s, check connection and try again', port)

            % scan for available adresses for each motor from 0-F
            %%% value is returned as a System*String so need to convert %%%
            fprintf("Scanning addresses '%s' to '%s'...\n", minAddress, maxAddress)
            avail_addresses = device_handle.ScanAddresses(minAddress,maxAddress);
            channel = cell(1,avail_addresses.Count); % create struct to hold all available addresses

            % go through each available motor and store address
            for i = 1:avail_addresses.Count
                channel{1,i} = char(avail_addresses.Item(i-1));
            end
            Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Disconnect();
        end

        function connect_multiple_devices(COM_port)
            disp(['This will provide you a walk through to connect multiple devices. \n' ...
                'Please Reset all motors to an adress of 0 the connect one at a time following prompts \n' ...
                'After resetting all motors... disconnect all motors except for one then continue.'])
            rotation_motor.load_DLL; % load our DLL file
            disp('   ')
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
            disp('   ')
            num_motors = input('Input the Number of Motors to be connected:  ');
            disp('   ')
            com_port = input('What COM port are these motors connected to (Only input the number)? ');

            disp('   ')
            com_port = strcat("COM",string(com_port));
            
%             %Create motor object 
%             motor = Thorlabs.Elliptec.ELLO_DLL.ELLDevices;
%             % check if port is available
%             assert(Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Connect(com_port), 'Cannot connect to port: %s', com_port)
%            
            % create motor object
            motor_1 = rotation_motor("COM4");


            motor_options = {'0','1','2','3','4','5','6','7','8','9',...
                'A','B','C','D','E','F'};
            disp(strjoin(motor_options))
            for i = 1:num_motors
                disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
                disp(sprintf('Connecting to motor %d...', i))
                
                %read in motor at address 0
                address = rotation_motor.list_devices("COM4", '0','0');
                if length(address) < 1
                    disp(' ')
                    disp('No device Located at Address "0". Make sure that all motors have been reset to Address 0 before readdressing multiple devices')
                    return 
                end
                disp(sprintf('Device Found at Address: %s', address{1,1}))

                % connect and configure device
                disp('Configuring Device at address "0"...')
                motor_1.Connect(address{1,1});
                disp('  ')
                disp('Device Configured at address "0"...')
                disp(sprintf('Motor Address Options %s', strjoin(motor_options)))
                disp('   ')

                %assert(length(address) < 2, 'Address must only be only cahracter ranging from "0" to "F"')
                success = motor_1.readdress_device(num2str(i));
                if success
                 disp(' ')
                    disp(sprintf('Re-Addressing Motor %d to Address %d...', i,i))
                    disp('Succesfully Re-Addressed Motor')
                else
                    errordlg('Something Went Wrong. Motor was not Re-Addressed. Check Connection and address value and Try Again.')
                    return
                end

                uiwait(msgbox(sprintf(['Please connect next motor to "Module %d" port on the BUS distributor board. Wait for motor to be initialized ' ...
                     '(Red LED will turn off)'], i+1)))


%                 % configure device
%                 address = rotation_motor.list_devices("COM4", '0','0');
%                 address = address{1,1};
% 
%                 disp(sprintf('Device Found at Address: %s', address))
%                 
%                 % check if port is available
%                 assert(Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Connect(com_port), 'Cannot connect to port: %s', com_port)
%                 
%                 % configure device
%                 motor.Configure(address(1))
% 
%                 
%                 
%                 
%                 
%                 disp('   ')
%                 motor_options = erase(string(address), motor_options);
% 
%                 % actually readdress the motor
%                 if motor.ReaddressDevice('0',char(address))
%                     disp(sprintf('Re-Addressing Motor %d to Address %d...', i,address))
%                     disp('   ')
%                     disp('Succesfully Re-Addressed Motor')
%                 else
%                     disp('ERROR!! Unable to Readdress motor')
%                 end
%                 
            end
            address = rotation_motor.list_devices("COM4", '0',num2str(num_motors));
            disp('Device(s) found at Address: ')
            for i = 1:length(address)
                fprintf('Motor %d: %s', i, address{1,i})
            end
            
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % method to load DLL and connect to motor with known address
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function load_DLL()
            try
                assert(exist("C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO_DLL.dll", 'file'), 'No .dll file found for elliptec motors. Download from Thorlabs')
            catch ME
                uiwait(errordlg(ME.message, 'File Not found'),3)
            end
            % initalize the net assembly for rotation motor
            asm = NET.addAssembly("C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO_DLL.dll");

            % import all functions for motor control and Communication
            import Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.*
            import Thorlabs.Elliptec.ELLO_DLL.ELLDevices.*
            import Thorlabs.Elliptec.ELLO_DLL.ELLBaseDevice.*
            import Thorlabs.Elliptec.ELLO_DLL.ELLDevice.*
        end

        function message = Disconnect_static()
            try
                Thorlabs.Elliptec.ELLO_DLL.ELLDevicePort.Disconnect();
                message = 'Motor Disconnected';
            catch ME
                message = 'Unable to Disconnect Motor';
                errordlg(ME.message, 'ERROR','error')
            end
        end

    end

end
