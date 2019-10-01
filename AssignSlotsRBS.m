function [slotsRBS,delaysRBS]=AssignSlotsRBS(slotsRBS,ETAmins,nvolA,Hstart,slotsmins,CapAer,AAR,HNoRegmins)
    %Asignamos slots: Buscamos el vuelo en nvolA para comprobar que su ETA
    %esté entre Hstart y HNoReg y luego comprobamos que el slot esté vacío
    %y que, por su ETA, pueda entrar
    v=1;
    while(v<=length(nvolA))
        if(ETAmins(v,1)>=Hstart && ETAmins(v,1)<=HNoRegmins)
            s=1;
            assigned=0;
            while(s<=length(slotsRBS) && assigned==0)
                if(slotsRBS(s,3)==0)
                    if(s~=length(slotsRBS) && ETAmins(v,1)<slotsmins(s+1,1))
                        slotsRBS(s,3)=nvolA(v,1);
                        assigned=1;
                    elseif(s==length(slotsRBS) && ETAmins(v,1)<slotsmins(s,1)+ceil(CapAer/AAR))
                        slotsRBS(s,3)=nvolA(v,1);
                        assigned=1;
                    elseif(ETAmins(v,1)<=slotsmins(s,1))
                        slotsRBS(s,3)=nvolA(v,1);
                        assigned=1;
                    else
                        s=s+1;
                    end
                else
                    s=s+1;
                end
            end
        end
        v=v+1;
    end         

    %Calculamos el número de vuelos regulados
    regfligthsRBS = 0;
    s = 1;
    while (s <= length(slotsRBS))
        if (slotsRBS(s,3) ~= 0)
            regfligthsRBS=regfligthsRBS+1;
        end
        s = s + 1;
    end

    %Calculamos el delay de cada vuelo
    delaysRBS=[];
    s=1;
    while(s<=length(slotsRBS))
        if(slotsRBS(s,3)~=0)
            v=1;
            while(v<=length(nvolA))
                if(nvolA(v,1)==slotsRBS(s,3))
                    if(slotsmins(s,1)-ETAmins(v,1)>=0)
                        delay=slotsmins(s,1)-ETAmins(v,1);
                    else
                        delay=0;
                    end
                    delaysRBS=[delaysRBS;slotsRBS(s,3),delay];
                end
                v=v+1;
            end
        end
        s=s+1;
    end
end