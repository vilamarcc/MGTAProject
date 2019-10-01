function [colaAi,colaDi,colaAv,colaDv,colatotali,colatotalv] = QueuesAirportCapacity(slotsAC,Xresi, Xresv)
%Calculamos las colas en cada slot como la cola del slot anterior más la
%demanda del slot anterior (arrivals o departures) menos los vuelos
%(arrivals o departures) asignados en ese slot 

    %Instrumental Weather Conditions
        %Cola Arrivals
    colaAi= zeros(length(slotsAC),1);
    ca = 2;
    while (ca <= length (colaAi))
        colaAi (ca) = slotsAC(ca-1,3)-Xresi(ca-1,3) + colaAi(ca-1);
        ca = ca + 1;
    end
        %Cola Departures
    colaDi= zeros(length(slotsAC),1);
    ca = 2;
    while (ca <= length (colaDi))
        colaDi (ca) = slotsAC(ca-1,4)-Xresi(ca-1,4) + colaDi(ca-1);
        ca = ca + 1;
    end
        %Cola Total
    colatotali = colaAi+colaDi;
    %Visual Weather Conditions
        %Cola Arrivals
    colaAv= zeros(length(slotsAC),1);
    ca = 2;
    while (ca <= length (colaAv))
        colaAv (ca) = slotsAC(ca-1,3)-Xresv(ca-1,3) + colaAv(ca-1);
        ca = ca + 1;
    end
        %Cola Departures
    colaDv= zeros(length(slotsAC),1);
    ca = 2;
    while (ca <= length (colaDv))
        colaDv (ca) = slotsAC(ca-1,4)-Xresv(ca-1,4) + colaDv(ca-1);
        ca = ca + 1;
    end
        %Cola Total
    colatotalv = colaAv+colaDv;
end

