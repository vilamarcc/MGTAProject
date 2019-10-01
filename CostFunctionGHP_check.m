function [cft] = CostFunctionGHP_check(vuelosGHP,slotsminsGHP,rft,eps,Hend)
    cft=[];
    f=1;
    while(f<=length(vuelosGHP))
        t=1;
        while(t<=length(slotsminsGHP))
            if(slotsminsGHP(t,1)-vuelosGHP(f,2)>=0)
                cft=[cft;rft*((slotsminsGHP(t,1)-vuelosGHP(f,2))^(eps+1))];
            elseif(slotsminsGHP(t,1)-vuelosGHP(f,2)==-1 && vuelosGHP(f,2)<Hend)
                cft=[cft;0];
            else
                cft=[cft;-1]; %fiquem cost -1 quan no podem assignar el vol f al slot t
            end
            t=t+1;
        end
        f=f+1;
    end
end

