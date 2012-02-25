function d=norm_fn(a,p,x,m)
    d=sum(p.*max(min(x-a,1),0))-m;
end

