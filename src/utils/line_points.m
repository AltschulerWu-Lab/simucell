function output=line_points(x1,y1,x2,y2,sz)

r=floor(sqrt((x1-x2).^2+(y1-y2).^2));
dx=(x2-x1)/r;
dy=(y2-y1)/r;
output=zeros(r,2);
for i=1:r
    output(i,1)=round(x1+dx*i);
    output(i,2)=round(y1+dy*i);
end
output=sub2ind(sz,output(:,1),output(:,2));
end
