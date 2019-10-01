function [totalGD,maxGD,aveGD,totalAD,maxAD,aveAD,totaldelayGDP,avedelayGDP,delayedGDP]=ComputeDelayGDP(AirDelay,GroundDelay)
    maximumGD=max(GroundDelay);
    maxGD=maximumGD(2);
    maximumAD=max(AirDelay);
    maxAD=maximumAD(2);
    totalGD=0;
    delayedGD=0;
    i=1;
    while(i<=length(GroundDelay))
        totalGD=totalGD+GroundDelay(i,2);
        if(GroundDelay(i,2)~=0)
            delayedGD=delayedGD+1;
        end
        i=i+1;
    end
    totalAD=0;
    delayedAD=0;
    i=1;
    while(i<=length(AirDelay))
        totalAD=totalAD+AirDelay(i,2);
        if(AirDelay(i,2)~=0)
            delayedAD=delayedAD+1;
        end
        i=i+1;
    end
    aveGD=totalGD/delayedGD;
    aveAD=totalAD/delayedAD;
    totaldelayGDP=totalAD+totalGD;
    delayedGDP=delayedAD+delayedGD;
    avedelayGDP=totaldelayGDP/(delayedAD+delayedGD);
end
