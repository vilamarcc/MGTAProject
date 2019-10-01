function [CTAGDP,CTAminsGDP] = computeCTA_GDP(ETAmins,GroundDelay,AirDelay,nvolA)
    %Calculamos las CTA en minutos    
    CTAminsGDP=zeros(length(ETAmins),2);
    i=1;
    while(i<=length(ETAmins))
        CTAminsGDP(i,1)=nvolA(i,1);
        g=1; %Buscamos entre los controlled
        while(g<=length(GroundDelay))
            if(nvolA(i,1)==GroundDelay(g,1))
                CTAminsGDP(i,2)=ETAmins(i,1)+GroundDelay(g,2);
            end
            g=g+1;
        end
        a=1; %Buscamos entre los excluded
        while(a<=length(AirDelay))
            if(nvolA(i,1)==AirDelay(a,1))
                CTAminsGDP(i,2)=ETAmins(i,1)+AirDelay(a,2);
            end
            a=a+1;
        end
        if(CTAminsGDP(i,2)==0)
            CTAminsGDP(i,2)=ETAmins(i,1);
        end
        i=i+1;
    end
    
    %Pasamos la CTA a formato hhmm
    CTAGDP=zeros(length(ETAmins),2);
    i=1;
    while(i<=length(CTAGDP))
        CTAGDP(i,1)=CTAminsGDP(i,1);
        CTAGDP(i,2)=(fix(CTAminsGDP(i,2)/60) + 5)*100+fix(mod(CTAminsGDP(i,2),60)); %lo dejamos de la forma hhmm
        i=i+1;
    end
end

