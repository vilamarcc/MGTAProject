function [ETD,distD,nvolD,internD,ETDmins] = ExcelDepartures(filename)
excel=xlsread(filename,1,'D2:H189'); %Dades extretes del document
ETD=zeros(188,1); %Faig un vector per les hores de sortida
distD=zeros(188,1); %Faig un vector per les distàncies EN MILLES NÀUTIQUES
nvolD=zeros(188,1); %Faig un vector per el número de vol
internD=zeros(188,1); %Faig un vector per saber si és vol internacional
ETDmins=zeros(188,1); %Faig un vector de les ETDs en minuts (0-359)

i=1;
while(i<=length(nvolD))
    ETD(i,1)=(100*excel(i,2))+excel(i,3); %Escric les hores de manera que quedi hhmm
    distD(i,1)=excel(i,4); 
    nvolD(i,1)=excel(i,1);
    internD(i,1)=excel(i,5); %1 internacional, 0 EEUU o Canadà
    if(ETD(i,1)>=500 && ETD(i,1)<=559)
        ETDmins(i,1)=ETD(i,1)-500;
    end
    if(ETD(i,1)>=600 && ETD(i,1)<=659)
        ETDmins(i,1)=ETD(i,1)-540;
    end
    if(ETD(i,1)>=700 && ETD(i,1)<=759)
        ETDmins(i,1)=ETD(i,1)-580;
    end
    if(ETD(i,1)>=800 && ETD(i,1)<=859)
        ETDmins(i,1)=ETD(i,1)-620;
    end
    if(ETD(i,1)>=900 && ETD(i,1)<=959)
        ETDmins(i,1)=ETD(i,1)-660;
    end
    if(ETD(i,1)>=1000 && ETD(i,1)<=1059)
        ETDmins(i,1)=ETD(i,1)-700;
    end
    i=i+1;
end

