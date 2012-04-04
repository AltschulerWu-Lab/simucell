classdef Turbulent_Texture <SimuCell_Marker_Operation
  %Turbulent_Texture marker plugin used to add a turbulent texture effect
  %which "shuffles" the pixels to give the appearance of turbulence.
  %Is only useful if the existing levels are non-uniform.
  %
  %Turbulent_Texture Properties:
  %   max_displacement - Turbulent noise is essentially a rearrangment of
  %   pixels. This parameter specifies the max distance a pixel can be
  %   moved.
  %     Default value : 10
  %     Range value : 0 to 50
  %   length_scale - Scale of Noise [2 - long length scale, 5-short]]
  %     Default value : 3
  %     Range value : 2 to 6
  %   frequency_falloff - Scale of Noise [2 - long length scale, 5-short]]
  %     Default value : 0.5
  %     Range value : 0 to 1
  %   smooth_edges - Smooth the intensity at formerly FG pixels, now in BG?
  %     Default value : 'No'
  %     Available values : 'Yes','No'
  %
  %Usage:
  %%Create the impression of turbulence using the turbulent
  %%texture which semi-randomly moves pixels around locally, as might 
  %%happen in a turbulent fluid.
  %op=Turbulent_Texture();
  %
  %%This is the max distance in pixels that a pixel can be moved
  %set(op,'max_displacement',7);
  %
  %%This describes the length scale over which intensity varies. 2 is low
  %%wave-length (coarse variation) and 6 is very fine high frequency
  %%(fine variation)
  %set(op,'length_scale',5);
  %
  %%Each higher frequency component amplitude is smaller by this scaling
  %%factor
  %set(op,'frequency_falloff',0.8);
  %
  %subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    max_displacement
    length_scale
    frequency_falloff
    smooth_edges
    description=['Turbulent Texture: This "shuffles" the pixels to'...
      ' give the appearance of turbulence. Is only useful if the'...
      ' existing levels are non-uniform.'];
  end
  
  
  methods
    
    function obj=Turbulent_Texture()
      obj.max_displacement=Parameter('Max Distance a pixel can be moved',...
        10,SimuCell_Class_Type.number,...
        [1,50],['Turbulent noise is essentially a rearrangment of pixels.'...
        ' This parameter specifies the max distance a pixel can be moved']);
      obj.length_scale=Parameter('Length Scale',3,...
        SimuCell_Class_Type.number,...
        [2,6],'Scale of Noise [2 - long length scale, 5-short]]');
      obj.frequency_falloff=Parameter('Frequency Falloff',0.5,...
        SimuCell_Class_Type.number,...
        [0,1],'Scale of Noise [2 - long length scale, 5-short]]');
      obj.smooth_edges=Parameter('Smooth Edges','No',...
        SimuCell_Class_Type.list,...
        {'Yes','No'},...
        'Smooth the intensity at formerly FG pixels, now in BG?');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,...
        other_cells_mask,needed_shapes,needed_markers)
      tex=zeros(size(current_marker));
      [row,col]=find(current_shape_mask);
      xmin=max(min(row)-obj.max_displacement.value,1);
      ymin=max(min(col)-obj.max_displacement.value,1);
      xmax=min(max(row)+obj.max_displacement.value,size(current_marker,1));
      ymax=min(max(col)+obj.max_displacement.value,size(current_marker,2));
      selected_marker=current_marker(xmin:xmax,ymin:ymax);
      bx=min(row)-xmin;
      by=min(col)-ymin;
      noise=zeros(xmax-xmin+1,ymax-ymin+1);
      [X,Y]=meshgrid(1:xmax-xmin+1,1:ymax-ymin+1);
      dir_noise=cell(2,1);
      for dir=1:2
        for scale = obj.length_scale.value:6
          f = power(2,scale);
          weight = power(obj.frequency_falloff.value,scale);
          random_lattice = rand(f);
          random_lattice = ...
            [random_lattice(:,1) random_lattice random_lattice(:,end)];
          random_lattice = ...
            [random_lattice(1,:); random_lattice; random_lattice(end,:)];
          h = ones(3)/9;
          smoothed_random_lattice = conv2(random_lattice,h,'valid');
          y = linspace(1,size(smoothed_random_lattice,1),xmax-xmin+1);
          x = linspace(1,size(smoothed_random_lattice,2),ymax-ymin+1)';
          if f < 3
            method = 'bilinear';
          else
            method = 'bicubic';
          end
          temp_noise=interp2(smoothed_random_lattice,x,y,method);
          temp_noise=...
            (temp_noise-min(temp_noise(:)))/(max(temp_noise(:))-min(temp_noise(:)))-0.5;
          noise = noise + weight*abs(temp_noise);
        end
        dir_noise{dir}=...
          2*obj.max_displacement.value*((noise-min(noise(:)))/(max(noise(:))-min(noise(:)))-0.5);
      end
      X=X'+dir_noise{1};
      Y=Y'+dir_noise{2};
      X1=max(round(X(bx:(bx+max(row)-min(row)),by:(by+max(col)-min(col)))),1);
      Y1=max(round(Y(bx:(bx+max(row)-min(row)),by:(by+max(col)-min(col)))),1);
      I=sub2ind(size(X),X1(:),Y1(:));
      noise=zeros(max(row)-min(row)+1,max(col)-min(col)+1);
      noise(:)=selected_marker(I);
      switch(obj.smooth_edges.value)
        case 'Yes'
          selected_mask_big=current_shape_mask(xmin:xmax,ymin:ymax);
          selected_mask_small=current_shape_mask(min(row):max(row),min(col):max(col));
          selected_marker_small=current_marker(min(row):max(row),min(col):max(col));
          mask1=false(max(row)-min(row)+1,max(col)-min(col)+1);
          mask1(:)=selected_mask_big(I);
          h=fspecial('gaussian',obj.max_displacement.value,obj.max_displacement.value);
          temp=imfilter(selected_marker,h);
          mask2=selected_mask_small&(~mask1);
          noise(mask2)=(temp(mask2)+selected_marker_small(mask2))/2;
        case 'No'
      end
      tex(min(row):max(row),min(col):max(col))=noise;
      %             tex(object_mask)=tex(object_mask)./...
      %             mean(mean(tex(object_mask)));
      result=min(current_shape_mask.*sparse(tex),1);
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list=cell(0);
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list=cell(0);
    end
    
  end
  
  
end
