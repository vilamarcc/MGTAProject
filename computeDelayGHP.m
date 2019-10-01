function [totaldelayGHP,avedelayGHP,delayedGHP,delayGHP] = computeDelayGHP(slotsGHP,slotsminsGHP,vuelosGHP)
    %Creamos una matriz de delays:
        %delayGHP=[número de vuelo,delay]
    delayGHP=zeros(length(vuelosGHP),2);
    v=1;
    while(v<=length(vuelosGHP))
        delayGHP(v,1)=vuelosGHP(v,1);
        s=1;
        while(s<=length(slotsGHP))
            if(slotsGHP(s,3)==vuelosGHP(v,1) && slotsminsGHP(s,1)-vuelosGHP(v,2)>=0)
                delayGHP(v,2)=slotsminsGHP(s,1)-vuelosGHP(v,2);
            end
            s=s+1;
        end
        v=v+1;
    end
    
    %Sumamos el delay total y calculamos el número de vuelos con retraso
    d=1;
    totaldelayGHP=0;
    delayedGHP=0;
    while(d<=length(delayGHP))
        totaldelayGHP=totaldelayGHP+delayGHP(d,2);
        if(delayGHP(d,2)~=0)
            delayedGHP=delayedGHP+1;
        end
        d=d+1;
    end
    avedelayGHP=totaldelayGHP/delayedGHP;
end

