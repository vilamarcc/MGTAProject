function [ETA,distA,nvolA,internA,ETAmins,PAXA] = ExcelArrivals(filename)
excel=xlsread(filename,1,'D2:I162'); %Dades extretes del document
ETA=zeros(161,1); %Faig un vector per les hores d'arribada
distA=zeros(161,1); %Faig un vector per les dist�ncies EN MILLES N�UTIQUES
nvolA=zeros(161,1); %Faig un vector per el n�mero de vol
internA=zeros(161,1); %Faig un vector per saber si �s vol internacional
ETAmins=zeros(161,1); %Faig un vector amb les ETAs en minuts (0-359)
PAXA=zeros(161,1); %Faig un vector amb el n�mero de passatgers en connexi�
i=1;
while(i<=length(nvolA))
    ETA(i,1)=(100*excel(i,2))+excel(i,3); %Les escric de manera que quedi hhmm
    distA(i,1)=excel(i,4); 
    nvolA(i,1)=excel(i,1);
    internA(i,1)=excel(i,5); %1 internacional, 0 EEUU o Canad�
    PAXA(i,1)=excel(i,6);
    if(ETA(i,1)>=500 && ETA(i,1)<=559)
        ETAmins(i,1)=ETA(i,1)-500;
    end
    if(ETA(i,1)>=600 && ETA(i,1)<=659)
        ETAmins(i,1)=ETA(i,1)-540;
    end
    if(ETA(i,1)>=700 && ETA(i,1)<=759)
        ETAmins(i,1)=ETA(i,1)-580;
    end
    if(ETA(i,1)>=800 && ETA(i,1)<=859)
        ETAmins(i,1)=ETA(i,1)-620;
    end
    if(ETA(i,1)>=900 && ETA(i,1)<=959)
        ETAmins(i,1)=ETA(i,1)-660;
    end
    if(ETA(i,1)>=1000 && ETA(i,1)<=1059)
        ETAmins(i,1)=ETA(i,1)-700;
    end
    i=i+1;
end

