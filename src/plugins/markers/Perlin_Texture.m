classdef Perlin_Texture <SimuCell_Marker_Operation
  %Perlin_Texture marker plugin used to scales the intensity by a randomly
  %generated texture function.
  % The parametrization of the texture is a variation on the one used by 
  % Lehmussola et al in Proceedings of the IEEE, Vol. 96, No. 8. 
  % (16 July 2008), pp. 1348-1360, doi:10.1109/JPROC.2008.925490
  %
  %Perlin_Texture Properties:
  %   add_or_multiply - Should the noise be additive OR multiplicative
  %     Default value : 'Multiply'
  %     Available values : 'Add','Multiply'
  %   amplitude - Amplitude of Noise [0-low, 1-High]
  %     Default value : 0.5
  %     Range value : 0 to 1
  %   length_scale - Scale of Noise [2 - long length scale, 5-short]]
  %     Default value : 2
  %     Range value : 2 to 6
  %   frequency_falloff - Frequency Falloff [0 (Only lowest frequency) - 1 
  %   (All frequencies)]]
  %     Default value : 0.5
  %     Range value : 0 to 1
  %   noise_type - The type of variation in perlin.
  %     Default value : 'Standard 1/f'
  %     Available values : 'Standard 1/f','Turbulent'
  %
  %Usage:
  %%Perlin Texture (scale the intensity from the last step by a noisy 
  %%texture, to make it look more realistic)
  %op=Perlin_Texture();
  %
  %%The amplitude of the noise (0 is not noise, and you probably don't
  %%want to go much beyond 1, since intensities are in the [0-1] range)
  %set(op,'amplitude',0.3);
  %
  %%This describes the length scale over which intensity varies. 2 is low
  %%wave-length (coarse variation) and 6 is very fine high frequency
  %%(fine variation)
  %set(op,'length_scale',5);
  %
  %%Each higher frequency component amplitude is smaller by this scaling
  %%factor
  %set(op,'frequency_falloff',0.5);
  %
  %%The type of noise. Turbulent causes sharper transitions
  %set(op,'noise_type','Turbulent');
  %
  %subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
  %
  %
  % ------------------------------------------------------------------------------
  % Copyright ©2012, The University of Texas Southwestern Medical Center 
  % Authors:
  % Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
  % For latest updates, check: < http://www.SimuCell.org >.
  %
  % All rights reserved.
  % This program is free software: you can redistribute it and/or modify
  % it under the terms of the GNU General Public License as published by
  % the Free Software Foundation, version 3 of the License.
  %
  % This program is distributed in the hope that it will be useful,
  % but WITHOUT ANY WARRANTY; without even the implied warranty of
  % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  % GNU General Public License for more details:
  % < http://www.gnu.org/licenses/ >.
  %
  % ------------------------------------------------------------------------------
  %%

    
  
  properties
    add_or_multiply
    amplitude
    length_scale
    frequency_falloff
    noise_type
    description='Perlin Texture. Scales the intensity by a randomly generated texture function';
  end
  
  
  methods
    
    function obj=Perlin_Texture()
      obj.add_or_multiply=Parameter('Additive or Multiplicative','Multiply',SimuCell_Class_Type.list,...
        {'Add','Multiply'},'Should the noise be additive or multiplicative?');
      obj.amplitude=Parameter('Noise Amplitude',0.5,SimuCell_Class_Type.number,...
        [0,Inf],'Amplitude of Noise [0-low, 1-High]');
      obj.length_scale=Parameter('Length Scale',2,SimuCell_Class_Type.number,...
        [2,6],'Scale of Noise [2 - long length scale, 5-short]]');
      obj.frequency_falloff=Parameter('Frequency Falloff',0.5,SimuCell_Class_Type.number,...
        [0,1],'Frequency Falloff [0 (Only lowest frequency) - 1 (All frequencies)]]');
      obj.noise_type=Parameter('Noise Type','Standard 1/f',SimuCell_Class_Type.list,...
        {'Standard 1/f','Turbulent'},'Noise Type');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
      tex=zeros(size(current_marker));
      [row,col]=find(current_shape_mask);
      shape_mask=current_shape_mask(min(row):max(row),min(col):max(col));
      noise=zeros(max(row)-min(row)+1,max(col)-min(col)+1);
      for scale = obj.length_scale.value:6
        f = power(2,scale);
        weight = power(obj.frequency_falloff.value,scale);
        random_lattice = rand(f);
        random_lattice = [random_lattice(:,1) random_lattice random_lattice(:,end)];
        random_lattice = [random_lattice(1,:); random_lattice; random_lattice(end,:)];
        h = ones(3)/9;
        smoothed_random_lattice = conv2(random_lattice,h,'valid');
        y = linspace(1,size(smoothed_random_lattice,1),max(row)-min(row)+1);
        x = linspace(1,size(smoothed_random_lattice,2),max(col)-min(col)+1)';
        if f < 3
          method = 'bilinear';
        else
          method = 'bicubic';
        end
        temp_noise=interp2(smoothed_random_lattice,x,y,method);
        temp_noise=(temp_noise-min(temp_noise(:)))/(max(temp_noise(:))-min(temp_noise(:)));
        switch(obj.noise_type.value)
          case 'Standard 1/f'
            noise = noise + weight*temp_noise;
          case 'Turbulent'
            noise = noise + weight*abs(temp_noise);
        end
      end
      noise=(noise-min(noise(shape_mask)))/(max(noise(shape_mask))-min(noise(shape_mask)));
      noise=noise-mean(noise(shape_mask));
      noise= obj.amplitude.value*noise/std(noise(shape_mask));
      m=mean(current_marker(current_shape_mask));
      temp=current_marker(min(row):max(row),min(col):max(col));
      switch(obj.add_or_multiply.value)
        case 'Add'
          temp=temp+noise;
          temp=temp(shape_mask);
        case 'Multiply'
          temp=temp.*(noise+1);
          temp=temp(shape_mask);
      end
      [p,z]=hist(temp(:),100);
      p=p/sum(p);
      [alpha,~,exitflag]=fzero(@(a) obj.normalization_function(a,p,full(z),full(m)),sum(p.*full(z))-m);
      if(exitflag~=1)
        alpha=sum(p.*full(z))-m;
        %alpha= full(m)/sum(p.*full(z));
        if(isnan(m)||isinf(m))
          alpha=1;
        end
      end
      %tex(min(row):max(row),min(col):max(col))=noise;
      result=zeros(size(current_marker));
      switch(obj.add_or_multiply.value)
                case 'Add'
                    result(min(row):max(row),min(col):max(col))=...
                        max(min(current_marker(min(row):max(row),min(col):max(col))...
                        +noise-alpha,1),0);
                case 'Multiply'
                    result(min(row):max(row),min(col):max(col))=...
                        max(min(current_marker(min(row):max(row),min(col):max(col))...
                        .*(noise+1)-alpha,1),0);

      end
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list=cell(0);
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list=cell(0);
    end
    
  end
  
  
  methods (Static)
    function d=normalization_function(a,p,x,m)
      d=sum(p.*max(min(x-a,1),0))-m;
    end
  end
  
  
end
