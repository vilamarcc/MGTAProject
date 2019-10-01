function [slots,slotsmins] = ComputeSlots(Hstart,Hend,HNoRegmins,PAAR,AAR,CapAer)
    %Pasamos la Hstart a horas en un vector
        %Hstart=[hora,minuto]
    HstartH = [fix(Hstart/60) + 5,fix(mod(Hstart,60))];
    
    %Creamos la matriz de slots
        %slots=[hora,minuto,vuelo asignado] 
    slots = [HstartH,0]; %Primera fila
        %Creamos slots entre Hstart y HNoReg
    Hcontador = Hstart;
    while (Hcontador <= HNoRegmins)
        if (Hcontador < Hend) 
            Hcontador = Hcontador + ceil(CapAer/PAAR);
        else
            Hcontador = Hcontador + ceil(CapAer/AAR);
        end
        slots = [slots;fix(Hcontador/60) + 5,fix(mod(Hcontador,60)),0];
    end
        %Creamos slots extras 
    f = 1;
    while (f <=50)
        Hcontador = Hcontador + ceil(CapAer/AAR);
        slots = [slots;fix((Hcontador)/60) + 5,fix(mod((Hcontador),60)),0];
        f = f + 1;
    end
    
    %Pasamos las horas de los slots a minutos en un vector
        %Minutos del 0 (5:00am) al 359 (10:50am)
    slotsmins=zeros(length(slots),1);
    i=1;
    while(i<=length(slotsmins))
        slotsmins(i,1)=60*slots(i,1)+slots(i,2)-300;
        i=i+1;
    end
end

