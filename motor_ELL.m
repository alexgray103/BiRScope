classdef motor < handle
   properties
      Client tcpclient
   end
   methods
      function h = motor()
         motor.loadDLL()
         methods motor
         d = motor.ELLDevicePort.Connect("COM4")
         device = Thorlabs.Elliptec.ELLO_DLL.ELLDevices.ELLDevices()

      end

   
   end

   methods (Static)
      function loadDLL()
         NET.addAssembly("C:\Program Files\Thorlabs\Elliptec\Thorlabs.Elliptec.ELLO_DLL.dll")
      end
   end
end