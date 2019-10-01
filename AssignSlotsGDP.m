function [slotsGDP,GroundDelay,AirDelay]=AssignSlotsGDP(slotsGDP,ETAmins,Controlled,Excluded,nvolA,Hstart,slotsmins,AAR,CapAer,HNoRegmins)
    %Quitamos los departures de excluded y de controlled
    ControlledA=[];
    c=1;
    while(c<=length(Controlled))
        v=1;
        found=0;
        while(v<=length(nvolA) && found==0)
            if(nvolA(v,1)==Controlled(c,1))
                found=1;
            else
                v=v+1;
            end
        end
        if(found==1)
            ControlledA=[ControlledA;Controlled(c,1)];
        end
        c=c+1;
    end
    ExcludedA=[];
    e=1;
    while(e<=length(Excluded))
        v=1;
        found=0;
        while(v<=length(nvolA) && found==0)
            if(nvolA(v,1)==Excluded(e,1))
                found=1;
            else
                v=v+1;
            end
        end
        if(found==1)
            ExcludedA=[ExcludedA;Excluded(e,1)];
        end
        e=e+1;
    end
    
    %Asignamos slots:
    e=1;
    while(e<=length(ExcludedA))
        v=1;
        while(v<=length(nvolA))
            if(nvolA(v,1)==ExcludedA(e,1))
                if(ETAmins(v,1)>=Hstart && ETAmins(v,1)<=HNoRegmins)
                    s=1;
                    assigned=0;
                    while(s<=length(slotsGDP) && assigned==0)
                        if(slotsGDP(s,3)==0)
                            if(s~=length(slotsGDP) && ETAmins(v,1)<slotsmins(s+1,1))
                                slotsGDP(s,3)=ExcludedA(e,1);
                                assigned=1;
                            elseif(s==length(slotsGDP) && ETAmins(v,1)<slotsmins(s,1)+ceil(CapAer/AAR))
                                slotsGDP(s,3)=ExcludedA(e,1);
                                assigned=1;
                            elseif(ETAmins(v,1)<=slotsmins(s,1))
                                slotsGDP(s,3)=ExcludedA(e,1);
                                assigned=1;
                            else
                                s=s+1;
                            end
                        else
                            s=s+1;
                        end
                    end
                end
            end
            v=v+1;
        end
        e=e+1;
    end
    c=1;
    while(c<=length(ControlledA))
        v=1;
        while(v<=length(nvolA))
            if(ControlledA(c,1)==nvolA(v,1))
                if((ETAmins(v,1)>=Hstart) && ETAmins(v,1)<=HNoRegmins)
                    s=1;
                    assigned=0;
                    while(s<=length(slotsGDP) && assigned==0)
                        if(slotsGDP(s,3)==0)
                            if(s~=length(slotsGDP) && ETAmins(v,1)<slotsmins(s+1,1))
                                slotsGDP(s,3)=ControlledA(c,1);
                                assigned=1;
                            elseif(s==length(slotsGDP) && ETAmins(v,1)<slotsmins(s,1)+ceil(CapAer/AAR))
                                slotsGDP(s,3)=ControlledA(c,1);
                                assigned=1;
                            else
                                s=s+1;
                            end
                        else
                            s=s+1;
                        end
                    end
                end
            end
            v=v+1;
        end
        c=c+1;
    end
    
    %Calcular delay
    GroundDelay=zeros(length(ControlledA),2);
    AirDelay=zeros(length(ExcludedA),2);
    
    e=1;
    while(e<=length(ExcludedA))
        AirDelay(e,1)=ExcludedA(e,1);
        n=1;
        while(n<=length(nvolA))
            if(nvolA(n,1)==AirDelay(e,1))
                X=ETAmins(n,1);
                n = 9000;
            else
                n=n+1;
            end
        end
        s=1;
        Y = 0;
        while(s<=length(slotsGDP))
            if(slotsGDP(s,3)==AirDelay(e,1))
                Y=slotsmins(s,1);
                s = 9000;
            else
                s=s+1;
            end
        end
        if (Y~=0 && Y-X>=0)
            AirDelay(e,2) = Y-X;
        end
        e=e+1;
    end
    c=1;
    while(c<=length(ControlledA))
        GroundDelay(c,1)=ControlledA(c,1);
        n=1;
        while(n<=length(nvolA))
            if(nvolA(n,1)==GroundDelay(c,1))
                X=ETAmins(n,1);
                n=9000;
            else
                n=n+1;
            end
        end
        s=1;
        Y = 0;
        while(s<=length(slotsGDP))
            if(slotsGDP(s,3)==GroundDelay(c,1))
                Y=slotsmins(s,1);
                s=9000;
            else
                s=s+1;
            end
        end
        if (Y~=0 && Y-X>=0)
            GroundDelay(c,2) = Y-X;
        end
        c=c+1;
    end
end

