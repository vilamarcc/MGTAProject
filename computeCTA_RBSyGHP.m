function [CTA,CTAmins] = computeCTA_RBSyGHP(delay,ETAmins,nvolA)
    %Calculamos las CTA en minutos
        %CTA=ETA+delay
    CTAmins=zeros(length(ETAmins),2);
    t=1;
    while(t<=length(ETAmins))
        CTAmins(t,1)=nvolA(t,1);
        d=1;
        while(d<=length(delay))
            if(nvolA(t,1)==delay(d,1))
                CTAmins(t,2)=ETAmins(t,1)+delay(d,2);
            end
            d=d+1;
        end
        if(CTAmins(t,2)==0)
            CTAmins(t,2)=ETAmins(t,1);
        end
        t=t+1;
    end
    
    %Pasamos la CTA a formato hhmm
    CTA=zeros(length(ETAmins),2);
    c=1;
    while(c<=length(CTA))
        CTA(c,1)=CTAmins(c,1);
        CTA(c,2)=(fix(CTAmins(c,2)/60) + 5)*100+fix(mod(CTAmins(c,2),60));
        c=c+1;
    end
end

