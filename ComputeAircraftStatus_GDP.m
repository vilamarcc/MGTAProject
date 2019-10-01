function [NotAffected,Affected,ExcludedRadius,ExcludedFlying,ExcludedInternational,Controlled,Excluded] = ComputeAircraftStatus_GDP(ETAmins,ETDmins,distA,internA,Hfile,Hstart,HNoRegmins,radius,nvolA,nvolD,distD,internD)
        %NotAffected (ETA fuera del intervalo de regulación) & Affected
    NotAffected=[];
    Affected=[];
    %Arrivals
    v=1;
    while(v<=length(nvolA)) 
        if(ETAmins(v,1)<Hstart || ETAmins(v,1)>HNoRegmins)
            NotAffected=[NotAffected;nvolA(v,1)];
        else
            Affected=[Affected;nvolA(v,1)];
        end
        v=v+1;
    end
    %Departures
    v=1;
    while(v<=length(nvolD))
        if(ETDmins(v,1)<Hstart || ETDmins(v,1)>HNoRegmins)
            NotAffected=[NotAffected;nvolD(v,1)];
        else
            Affected=[Affected;nvolD(v,1)];
        end
        v=v+1;
    end
        
        %ExcludedRadius & ExcludedInternational 
    ExcludedRadius=[]; 
    ExcludedInternational=[];
    %Arrivals
    v=1;
    while(v<=length(nvolA))
        a=1;
        found=0;
        while(a<=length(Affected) && found==0)
            if(Affected(a,1)==nvolA(v,1))
                found=1;
            else
                a=a+1;
            end
        end
        if(found==1)
            if(distA(v,1)>radius)
                ExcludedRadius=[ExcludedRadius;nvolA(v,1)];
            end
            if(internA(v,1)==1)
                ExcludedInternational=[ExcludedInternational;nvolA(v,1)];
            end
        end
        v=v+1;
    end
    %Departures
    v=1;
    while(v<=length(nvolD))
        a=1;
        found=0;
        while(a<=length(Affected) && found==0)
            if(Affected(a,1)==nvolD(v,1))
                found=1;
            else
                a=a+1;
            end
        end
        if(found==1)
            if(distD(v,1)>radius)
                ExcludedRadius=[ExcludedRadius;nvolD(v,1)];
            end
            if(internD(v,1)==1)
                ExcludedInternational=[ExcludedInternational;nvolD(v,1)];
            end
        end
        v=v+1;
    end
    
        %ExcludedFlying
    ExcludedFlying=[];
    %Arrivals
    v=1;
    while(v<=length(nvolA))
        a=1;
        found=0;
        while(a<=length(Affected) && found==0)
            if(Affected(a,1)==nvolA(v,1))
                found=1;
            else
                a=a+1;
            end
        end
        if(found==1)
            if(ETAmins(v,1)<=Hfile)
                ExcludedFlying=[ExcludedFlying;nvolA(v,1)];
            end
        end
        v=v+1;
    end
    %Departures
    v=1;
    while(v<=length(nvolD))
        a=1;
        found=0;
        while(a<=length(Affected) && found==0)
            if(Affected(a,1)==nvolD(v,1))
                found=1;
            else
                a=a+1;
            end
        end
        if(found==1)
            if(ETDmins(v,1)<=Hfile)
                ExcludedFlying=[ExcludedFlying;nvolD(v,1)];
            end
        end
        v=v+1;
    end
    
        %Excluded
    Excluded=[];
    %ExcludedRadius
    er=1;
    while(er<=length(ExcludedRadius))
        e=1;
        found=0;
        while(e<=length(Excluded) && found==0)
            if(Excluded(e,1)==ExcludedRadius(er,1))
                found=1;
            else
                e=e+1;
            end
        end
        if(found==0)
            Excluded=[Excluded;ExcludedRadius(er,1)];
        end
        er=er+1;
    end
    %ExcludedInternational
    ei=1;
    while(ei<=length(ExcludedInternational)) 
        e=1;
        found=0;
        while(e<=length(Excluded) && found==0)
            if(Excluded(e,1)==ExcludedInternational(ei,1))
                found=1;
            else
                e=e+1;
            end
        end
        if(found==0)
            Excluded=[Excluded;ExcludedInternational(ei,1)];
        end
        ei=ei+1;
    end
    %ExcludedFlying
    ef=1;
    while(ef<=length(ExcludedFlying))
        e=1;
        found=0;
        while(e<=length(Excluded) && found==0)
            if(Excluded(e,1)==ExcludedFlying(ef,1))
                found=1;
            else
                e=e+1;
            end
        end
        if(found==0)
            Excluded=[Excluded;ExcludedFlying(ef,1)];
        end
        ef=ef+1;
    end
    
        %Controlled
    Controlled=[];
    %Arrivals
    v=1;
    while(v<=length(nvolA))
        e=1;
        founde=0;
        while(e<=length(Excluded) && founde==0)
            if(Excluded(e,1)==nvolA(v,1))
                founde=1;
            else
                e=e+1;
            end
        end
        a=1;
        founda=0;
        while(a<=length(Affected) && founda==0)
            if(Affected(a,1)==nvolA(v,1))
                founda=1;
            else
                a=a+1;
            end
        end
        if(founde==0 && founda==1)
            Controlled=[Controlled;nvolA(v,1)];
        end
        v=v+1;
    end
    %Departures
    v=1;
    while(v<=length(nvolD))
        e=1;
        found=0;
        while(e<=length(Excluded) && found==0)
            if(Excluded(e,1)==nvolD(v,1))
                found=1;
            else
                e=e+1;
            end
        end
        a=1;
        founda=0;
        while(a<=length(Affected) && founda==0)
            if(Affected(a,1)==nvolD(v,1))
                founda=1;
            else
                a=a+1;
            end
        end
        if(found==0 && founda==1)
            Controlled=[Controlled;nvolD(v,1)];
        end
        v=v+1;
    end
end

