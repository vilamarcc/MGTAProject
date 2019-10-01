function [vuelosGHP] = ComputeVuelosGHP(nvolA,ETAmins,Hstart,HNoRegmins,PAXA)
    %Cogemos los vuelos entre Hstart y HNoReg ( los datos que necesitamos
    vuelosGHP=[];
    v=1;
    while(v<=length(nvolA))
        if(ETAmins(v)>=Hstart && ETAmins(v)<=HNoRegmins)
            vuelosGHP = [vuelosGHP;nvolA(v),ETAmins(v),PAXA(v)];
        end
        v=v+1;
    end
end

