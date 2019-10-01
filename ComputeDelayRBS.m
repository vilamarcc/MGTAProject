function [totaldelayRBS,averagedelayRBS,vueloscondelayRBS] = ComputeDelayRBS(delaysRBS)
    %Sumamos el delay total y el número de aviones con retraso
    d=1;
    vueloscondelayRBS = 0;
    totaldelayRBS = 0;
    while (d <= length(delaysRBS))
        totaldelayRBS = totaldelayRBS + delaysRBS(d,2);
        if (delaysRBS(d,2) ~= 0)
            vueloscondelayRBS = vueloscondelayRBS + 1;
        end
        d = d + 1;
    end
    %Calculamos el delay medio
    averagedelayRBS = totaldelayRBS/vueloscondelayRBS;
end

