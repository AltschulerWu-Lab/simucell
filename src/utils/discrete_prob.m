function subp_num=discrete_prob(subp_probs)
    
    if(size(subp_probs,1)>1)
      subp_probs=subp_probs';
    end
    r=rand;
    pvec=[0 subp_probs];
    cp=cumsum(pvec);
    cp1=[cumsum(subp_probs) 1];
    
    subp_num=find((cp<r)&(cp1>r),1);

end

