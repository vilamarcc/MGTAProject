function [slotsAC,slotsminsAC] = computeSlotsAC(ETAmins,ETDmins)
    %Hacemos un slot cada 15 minutos 
    %De 7:30 a 9:30 = de 150 a 250

    %Creamos las dos matrices de slots:
        %slotsAC=[hora, minuto, demanda arrivals, demanda departures]
        %slotsminsAC=[slot en minutos]
    slotsAC=zeros(8,4);
    slotsminsAC=zeros(8,1);
    
    %Computamos los slots en minutos (slotsminsAC)
    min=150;
    s=1;
    while(s<=length(slotsminsAC))
        slotsminsAC(s,1)=min;
        min=min+15;
        s=s+1;
    end
    
    %Pasamos los minutos a horas (slotsAC()
    s=1;
    while(s<=length(slotsAC))
        slotsAC(s,1)=fix(slotsminsAC(s,1)/60)+5;
        slotsAC(s,2)=mod(slotsminsAC(s,1),60);
        s=s+1;
    end
    
    %Demanda de arrivals en cada slot
    s=1;
    while(s<=length(slotsAC))
        v=1;
        while(v<=length(ETAmins))
            if(ETAmins(v,1)>=slotsminsAC(s,1) && ETAmins(v,1)<slotsminsAC(s,1)+15)
                slotsAC(s,3)=slotsAC(s,3)+1;
            end
            v=v+1;
        end
        s=s+1;
    end
    
    %Demanda de departures en cada slot
    s=1;
    while(s<=length(slotsAC))
        v=1;
        while(v<=length(ETDmins))
            if(ETDmins(v,1)>=slotsminsAC(s,1) && ETDmins(v,1)<slotsminsAC(s,1)+15)
                slotsAC(s,4)=slotsAC(s,4)+1;
            end
            v=v+1;
        end
        s=s+1;
    end
end