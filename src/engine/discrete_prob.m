function subp_num=discrete_prob(subp_probs)
    
    r=rand;
    %number_of_subp=length(subp_probs);
    pvec=[0 subp_probs];
    cp=cumsum(pvec);
    cp1=[cumsum(subp_probs) 1];
    
    subp_num=find((cp<r)&(cp1>r),1);

end

