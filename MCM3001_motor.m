classdef MCM3001_motor < handle

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Author: Alex Gray, MS. Boston University
    %%% Software control for ThorLabs MCM3001 Motor Through direct serial
    %%% communication 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Example code to connect motor: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

motor = MCM3001_motor("COM5", channel)
motor_1.Connect(motor_list(1));
motor_1.Home();

%}
    properties
        
        COM_port; % COM port used for communication with motors
        connected; % make sure that device is configured
        device;
        channel;
        position;
        encoder_count;
    end 

    properties (Constant, Hidden)
        Baud_rate = 460800;
        available_channels = [0 1 2];
        encoder_conversion = 0.2116667; % convert 1 encoder count to um 
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Constructor Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function motor_handle = MCM3001_motor(COM_port, channel) % motor constructer
            motor_handle.COM_port = COM_port;
            motor_handle.channel = channel;
            motor_handle.connect_motor();
            motor_handle.position = motor_handle.query_position(motor_handle.channel);
        end


        function delete(motor_handle)
            if motor_handle.connected
                delete(motor_handle)
                disp('Motor Has been Successefuly Disconnected')
            else
                error('Motor is Not Connected ')
            end
        end

        function connect_motor(motor_handle)
            try
                motor_handle.device = serialport(motor_handle.COM_port, motor_handle.Baud_rate);
                motor_handle.connected = 1;
            catch ME
                error(ME.message)
            end
        end

        function pos = query_position(motor_handle, channel)
            assert(any(channel == motor_handle.available_channels), 'Input channel must be between 0 and 2')

            cmd = [0x0A 0x04 uint8(channel) 0x00 0x00 0x00]; % command structure to get position 
            try
                write(motor_handle.device, cmd, 'uint8')
                message = read(motor_handle.device, 12, 'uint8');
                encoder_pos = message(end-3:end);
                motor_handle.encoder_count = typecast(uint8(encoder_pos), 'int32');
                pos = double(motor_handle.encoder_count)*motor_handle.encoder_conversion;
                motor_handle.position = pos;
            catch ME
                error(ME.message)
            end
        end

        function set_position(motor_handle,channel, new_position)
            assert(any(channel == motor_handle.available_channels), 'Input channel must be between 0 and 2')
            
            encoder_pos = typecast(int32(new_position/motor_handle.encoder_conversion), 'uint8');
            cmd = horzcat([0x53 0x04 0x06 0x00 0x00 0x00 uint8(channel) uint8(channel)], encoder_pos);
           
            try
                write(motor_handle.device, cmd, 'uint8')
                
            catch ME
                error(ME.message)
            end

        end

        function move_relative(motor_handle, channel, distance)
            assert(any(channel == motor_handle.available_channels), 'Input channel must be between 0 and 2')
            current_position = motor_handle.query_position(channel);
            
            %distance given in microns
            new_pos = current_position - distance;
            motor_handle.set_position(channel, new_pos)
        end

        % set absolute position of the motor to a certain encoder position
        function set_encoder_zero(motor_handle, channel)
            assert(any(channel == motor_handle.available_channels), 'Input channel must be between 0 and 2')
            
            cmd = [0x09 0x04 0x06 0x00 0x00 0x00 uint8(channel) uint8(channel) 0x00 0x00 0x00 0x00];
            try
                write(motor_handle.device, cmd, 'uint8')
                motor_handle.position = motor_handle.query_position(channel);
            catch ME
                error(ME.message)
                return
            end
        end

        function motor_busy = motorStatus(motor_handle, channel)
            assert(any(channel == motor_handle.available_channels), 'Input channel must be between 0 and 2')
            
            cmd = [0x80 0x04 uint8(channel) 0x00 0x00 0x00];
            try
                write(motor_handle.device, cmd, 'uint8')
                text = read(motor_handle.device, 20,'uint8');
                motor_busy = text(17) & 0x30;
                motor_handle.position = motor_handle.query_position(channel);
            catch ME
                error(ME.message)
                return
            end
        end
    end 
end
