function[out] = elliptical_shape(radius,eccentricity,variation)

if(radius~=round(radius))
    if(rand()<(radius-floor(radius)))
        radius=ceil(radius);
    else
        radius=floor(radius);
    end
end


step = 0.1;
t = (0:step:1)'*2*pi;


t1 = variation.*(2*rand(size(t))-1)+sin(t);
t2 = sqrt(1-eccentricity^2)*(variation.*(2*rand(size(t))-1)+cos(t));
t1(end) = t1(1);
t2(end) = t2(1);

theta=2*pi*rand();
rotmat=[cos(theta) -sin(theta); sin(theta) cos(theta)];
object = [t2';t1'];
object=rotmat*object;

pp_nuc = cscvn(object);
object = ppval(pp_nuc, linspace(0,max(pp_nuc.breaks),500));
	
object = radius*object;

object(1,:) = object(1,:) - min(object(1,:));
object(2,:) = object(2,:) - min(object(2,:));
object = round(object)+1;

I = zeros(max(round(object(1,:))),max(round(object(2,:))));
BW = roipoly(I,object(2,:),object(1,:));
out = BW;
