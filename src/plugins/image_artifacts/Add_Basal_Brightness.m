classdef Add_Basal_Brightness <SimuCell_CellArtifact_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        basal_level
        description='Add a basal level of intensity to all pixels. Intensity saturates at 1';
    end
    
    methods
        function obj=Add_Basal_Brightness()
            obj.basal_level=Parameter('Basal Level',0.1,SimuCell_Class_Type.number,...
                [0,1],'Intensity added to to all pixels [0 -none, 1- full]');
           
        end
        
        
        
        function output_images=Apply(obj,input_images)
          number_of_channels=size(input_images);
          output_images=cell(number_of_channels,1);
          for channel=1:number_of_channels
            output_images{channel}=min(input_images{channel}+obj.basal_level.value,1);
          end    
        end
        
        
    end
end