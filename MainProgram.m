%Leemos los datos de los vuelos:
[ETA,distA,nvolA,internA,ETAmins,PAXA] = ExcelArrivals('Arrivals.xlsx');
[ETD,distD,nvolD,internD,ETDmins] = ExcelDepartures('Departures.xlsx');
    %ETA/D: Estimated Time of Arrival/Departure en formato hhmm
    %nvol: números de vuelo
    %dist: distancia del aeropuerto de origen/destino a nuestro aeropuerto
    %intern: si el vuelo es internacional o no
        %intern=1 --> internacional
        %intern=0 --> nacional
    %ETA/Dmins: Estimated Time of Arrival/Departure en minutos
      %[minutos del 0 (5:00am) al 359 (10:59am)]
    %PAXA: Pasajeros en conexión
%Datos del aeropuerto:
AAR=60; %Capacidad nominal
CapAer=60; %Capacidad del aeropuerto
%Suponiendo que de 8:00am a 9:00am la capacidad se reduce:
PAAR=30; %Capacidad reducida
Hstart=180; %8:00am
Hend=240; %9:00am

%Vemos la gráfica de demanda acumulada i calculamos la hora a la que deja
%de haber regulación (HNoReg) y, aproximadamente, el delay total:
[HNoReg,HNoRegmins,delay,minutes] = AggregateDemand(ETAmins,Hstart,Hend,PAAR,AAR);
%Computamos los slots (útiles para las tres regulaciones):
[slots,slotsmins] = ComputeSlots(Hstart,Hend,HNoRegmins,PAAR,AAR,CapAer);

        %Ejecutamos RBS:
[slotsRBS,delaysRBS]=AssignSlotsRBS(slots,ETAmins,nvolA,Hstart,slotsmins,CapAer,AAR,HNoRegmins);
[totaldelayRBS, averagedelayRBS,delayedRBS] = ComputeDelayRBS(delaysRBS);
[CTA_RBS,CTAmins_RBS] = computeCTA_RBSyGHP(delaysRBS,ETAmins,nvolA);
plotHistograms(ETAmins,CTAmins_RBS,PAAR,Hstart,Hend,AAR,'RBS');

        %Ejecutamos GDP:
%Establecemos los parámetros de Hfile y radius
Hfile=100; %6:40am
radius=1000; %en millas
[NotAffected,Affected,ExcludedRadius,ExcludedFlying,ExcludedInternational,Controlled,Excluded] = ComputeAircraftStatus_GDP(ETAmins,ETDmins,distA,internA,Hfile,Hstart,HNoRegmins,radius,nvolA,nvolD,distD,internD);
[slotsGDP,GroundDelay,AirDelay]=AssignSlotsGDP(slots,ETAmins,Controlled,Excluded,nvolA,Hstart,slotsmins,AAR,CapAer,HNoRegmins);
[CTAGDP,CTAminsGDP] = computeCTA_GDP(ETAmins,GroundDelay,AirDelay,nvolA);
plotHistograms(ETAmins,CTAminsGDP,PAAR,Hstart,Hend,AAR,'GDP');
[totalGD,maxGD,aveGD,totalAD,maxAD,aveAD,totaldelayGDP,avedelayGDP,delayedGDP]=ComputeDelayGDP(AirDelay,GroundDelay);
%Variamos el radius para ver cómo afecta:
  %(Usamos índice r en las variables para diferenciar)
delayVSradius=[];
fligthsVSradius=[];
r=200;
while(r<=radius)
    [NotAffectedr,Affectedr,ExcludedRadiusr,ExcludedFlyingr,ExcludedInternationalr,Controlledr,Excludedr] =ComputeAircraftStatus_GDP(ETAmins,ETDmins,distA,internA,Hfile,Hstart,HNoRegmins,r,nvolA,nvolD,distD,internD);
    fligthsVSradius = [fligthsVSradius; r, length(Controlledr), length(Excludedr)];
    [Ar,GDr,ADr]=AssignSlotsGDP(slots,ETAmins,Controlledr,Excludedr,nvolA,Hstart,slotsmins,AAR,CapAer,HNoRegmins);
    [totalGDr,maxGDr,aveGDr,totalADr,maxADr,aveADr,totaldelayGDPr,avedelayGDPr,delayedGDPr]=ComputeDelayGDP(ADr,GDr);
    delayVSradius=[delayVSradius;r,totalGDr,totalADr];
    r=r+1;
end
    %Primer plot: Cómo afecta a la clasificación de vuelos
figure('Name','Aircraft status VS radius','NumberTitle','off');
plot(fligthsVSradius(:,1),fligthsVSradius(:,2),'g')
hold on
plot(fligthsVSradius(:,1),fligthsVSradius(:,3),'r')
legend('Contolled','Excluded')
ylabel('Aircraft status')
xlabel('Radius')
title('Aircraft status VS radius')
    %Segundo plot: Cómo afecta al delay (separado por tipos)
figure('Name','Delay VS radius','NumberTitle','off');
plot(delayVSradius(:,1),delayVSradius(:,2),'g');
hold on
plot(delayVSradius(:,1),delayVSradius(:,3),'r');
legend({'Ground Delay','Air Delay'})
ylabel('Delay')
xlabel('Radius')
title('Delay VS radius')
%Variamos Hfile para ver cómo afecta:
  %(Usamos índice h en las variables para diferenciar)
delayVSHfile=[];
fligthsVSHfile = [];
h=0;
while(h<=Hstart-1)
    [NotAffectedh,Affectedh,ExcludedRadiush,ExcludedFlyingh,ExcludedInternationalh,Controlledh,Excludedh] = ComputeAircraftStatus_GDP(ETAmins,ETDmins,distA,internA,h,Hstart,HNoRegmins,radius,nvolA,nvolD,distD,internD);
    fligthsVSHfile = [fligthsVSHfile; h, length(Controlledh), length(Excludedh)];
    [Ah,GDh,ADh]=AssignSlotsGDP(slots,ETAmins,Controlledh,Excludedh,nvolA,Hstart,slotsmins,AAR,CapAer,HNoRegmins);
    [totalGDh,maxGDh,aveGDh,totalADh,maxADh,aveADh,totaldelayGDPh,avedelayGDPh,delayedGDPh]=ComputeDelayGDP(ADh,GDh);
    delayVSHfile=[delayVSHfile;h,totalGDh,totalADh];
    h=h+1;
end
    %Primer plot: Cómo afecta a la clasificación de vuelos
figure('Name','Aircraft status VS Hfile','NumberTitle','off');
plot(fligthsVSHfile(:,1),fligthsVSHfile(:,2),'g')
hold on
plot(fligthsVSHfile(:,1),fligthsVSHfile(:,3),'r')
ylabel('Aircraft status')
xlabel('Hfile')
title('Aircraft status VS Hfile')
legend('Contolled','Excluded')
    %Segundo plot: Cómo afecta al delay (separado por tipos)
figure('Name','Delay VS Hfile','NumberTitle','off');
plot(delayVSHfile(:,1),delayVSHfile(:,2),'g');
hold on
plot(delayVSHfile(:,1),delayVSHfile(:,3),'r');
ylabel('Delay')
xlabel('Hfile')
title('Delay VS Hfile')
legend({'Ground Delay','Air Delay'})

        %Ejecutamos GHP:
[vuelosGHP] = ComputeVuelosGHP(nvolA,ETAmins,Hstart,HNoRegmins,PAXA);
%Primero comprobamos: Para rf=1 i épsilon=0  -->  coste RBS = coste GHP
  %(Usamos índice check en las variables para diferenciar)
[cftcheck] = CostFunctionGHP_check(vuelosGHP,slotsmins,1,0,Hend);
[zmincheck,Xvcheck,slotsGHPcheck] = GHPprogram(vuelosGHP,slots,cftcheck);
[totaldelayGHPcheck,avedelayGHPcheck,delayedGHPcheck,delayGHPcheck] = computeDelayGHP(slotsGHPcheck,slotsmins,vuelosGHP);
fprintf('Using RBS regulation, we will have a cost of %g$\n',totaldelayRBS);
fprintf('Using GHP regulation, we will have a cost of %g$\n',totaldelayGHPcheck);
%Exceutem amb la funció de cost real --> rf=pasajeros en conexión i épsilon=0
[cft] = CostFunctionGHP(vuelosGHP,slotsmins,1,0,Hend);
[zmin,Xv,slotsGHP] = GHPprogram(vuelosGHP,slots,cft);
[totaldelayGHP,avedelayGHP,delayedGHP,delayGHP] = computeDelayGHP(slotsGHP,slotsmins,vuelosGHP);
[CTAGHP,CTAminsGHP] = computeCTA_RBSyGHP(delayGHP,ETAmins,nvolA);
plotHistograms(ETAmins,CTAminsGHP,PAAR,Hstart,Hend,AAR,'GHP');

        %Ejecutamos Airport Capacity
[slotsAC,slotsminsAC] = computeSlotsAC(ETAmins,ETDmins);
%Variamos alpha para ver cómo afecta a las colas:
    %alpha=0 
      %(Usamos índice a1 en las variables para diferenciar)
a1 = 0;
[Xresv1,zvalv1,x1v1,y1v1,x2v1,y2v1,x3v1,y3v1,x4v1,y4v1,xvv1,yvv1] = AirportCapacityv(slotsAC,a1);
[Xresi1,zvali1,x1i1,y1i1,x2i1,y2i1,x3i1,y3i1,x4i1,y4i1,xvi1,yvi1] = AirportCapacityi(slotsAC,a1);
[colaAi1,colaDi1,colaAv1,colaDv1,colatotali1,colatotalv1] = QueuesAirportCapacity(slotsAC,Xresi1, Xresv1);
Plots_AirportCapacity(slotsAC,Xresv1,Xresi1,x1v1,y1v1,x2v1,y2v1,x3v1,y3v1,x4v1,y4v1,xvv1,yvv1,x1i1,y1i1,x2i1,y2i1,x3i1,y3i1,x4i1,y4i1,xvi1,yvi1,a1,colaAi1,colaDi1,colatotali1,colaAv1,colaDv1,colatotalv1)
    %alpha=0.7
      %(Usamos índice a2 en las variables para diferenciar)
a2 = 0.7;
[Xresv2,zvalv2,x1v2,y1v2,x2v2,y2v2,x3v2,y3v2,x4v2,y4v2,xvv2,yvv2] = AirportCapacityv(slotsAC,a2);
[Xresi2,zvali2,x1i2,y1i2,x2i2,y2i2,x3i2,y3i2,x4i2,y4i2,xvi2,yvi2] = AirportCapacityi(slotsAC,a2);
[colaAi2,colaDi2,colaAv2,colaDv2,colatotali2,colatotalv2] = QueuesAirportCapacity(slotsAC,Xresi2, Xresv2);
Plots_AirportCapacity(slotsAC,Xresv2,Xresi2,x1v2,y1v2,x2v2,y2v2,x3v2,y3v2,x4v2,y4v2,xvv2,yvv2,x1i2,y1i2,x2i2,y2i2,x3i2,y3i2,x4i2,y4i2,xvi2,yvi2,a2,colaAi2,colaDi2,colatotali2,colaAv2,colaDv2,colatotalv2)
    %alpha=1
      %(Usamos índice a3 en las variables para diferenciar)
a3 = 1;
[Xresv3,zvalv3,x1v3,y1v3,x2v3,y2v3,x3v3,y3v3,x4v3,y4v3,xvv3,yvv3] = AirportCapacityv(slotsAC,a3);
[Xresi3,zvali3,x1i3,y1i3,x2i3,y2i3,x3i3,y3i3,x4i3,y4i3,xvi3,yvi3] = AirportCapacityi(slotsAC,a3);
[colaAi3,colaDi3,colaAv3,colaDv3,colatotali3,colatotalv3] = QueuesAirportCapacity(slotsAC,Xresi3, Xresv3);
Plots_AirportCapacity(slotsAC,Xresv3,Xresi3,x1v3,y1v3,x2v3,y2v3,x3v3,y3v3,x4v3,y4v3,xvv3,yvv3,x1i3,y1i3,x2i3,y2i3,x3i3,y3i3,x4i3,y4i3,xvi3,yvi3,a3,colaAi3,colaDi3,colatotali3,colaAv3,colaDv3,colatotalv3)

%Varriamos alpha para ver cómo afecta a las colas
      %(Usamos índice a4 en las variables para diferenciar)
aa = 0; %alpha
variacioncolasi = [];
variacioncolasv = [];
while (aa <= 1)
    [Xresv4,zvalv4] = AirportCapacityv(slotsAC,aa);
    [Xresi4,zvali4,x43,y43,x44,y44] = AirportCapacityi(slotsAC,aa);
    [colaAi4,colaDi4,colaAv4,colaDv4,colatotali4,colatotalv4] = QueuesAirportCapacity(slotsAC,Xresi4, Xresv4);
    j = 1;
    sumi = 0;
    while (j <= length(colatotali4))
        sumi = sumi + colatotali4(j);
        j = j + 1;
    end
    variacioncolasi = [variacioncolasi;aa,sumi];
    j = 1;
    sumv = 0;
    while (j <= length(colatotalv4))
        sumv = sumv + colatotalv4(j);
        j = j + 1;
    end
    variacioncolasv = [variacioncolasv;aa,sumv];
    aa = aa + 0.1;
end
%Plot cola total VS alpha
figure('Name','Total Queues alphas','NumberTitle','off')
    %Instrumental Weather Conditions
subplot (2,1,1)
plot(variacioncolasi(:,1),variacioncolasi(:,2));
ylabel('Total Queue')
xlabel('Alphas')
title('Instrumental Weather Conditions with different alpha')
    %Visual Weather Conditions
subplot (2,1,2)
plot(variacioncolasv(:,1),variacioncolasv(:,2));
ylabel('Total Queue')
xlabel('Alphas')
title('Visual Weather Conditions with different alpha')

%Variamos alpha para ver cómo afecta a la zval
  %(Usamos índice max en las variables para diferenciar)
a=0;
alphaVSzvalV=[];
alphaVSzvalI=[];
while(a<=1)
    [Xresvmax,zvalvmax] = AirportCapacityv(slotsAC,a);
    [Xresimax,zvalimax,x3amax,y3max,x4max,y4max] = AirportCapacityi(slotsAC,a);
    alphaVSzvalV=[alphaVSzvalV;a,zvalvmax];
    alphaVSzvalI=[alphaVSzvalI;a,zvalimax];
    a=a+0.1;
end
%Plot zval VS alpha
figure('Name','zval VS alpha','NumberTitle','off');
    %Visual Weather Conditions
subplot(2,1,1)
plot(alphaVSzvalV(:,1),alphaVSzvalV(:,2))
ylabel('zval')
xlabel('alpha')
title('Visual Weather Conditions with different alpha')
    %Instrumental Weather Conditions
subplot(2,1,2)
plot(alphaVSzvalI(:,1),alphaVSzvalI(:,2))
ylabel('zval')
xlabel('alpha')
title('Instrumental Weather Conditions with different alpha')

%Enseñamos los resultados:
    %RBS:
fprintf('\tRBS results:\n');
i=1;
while(i<=length(slotsRBS))
    if(slotsRBS(i,3)~=0)
        if(slotsRBS(i,2)/100<0.1)
            fprintf('Aircraft %g arrives at %g:0%g\n',slotsRBS(i,3),slotsRBS(i,1),slotsRBS(i,2));
        else
            fprintf('Aircraft %g arrives at %g:%g\n',slotsRBS(i,3),slotsRBS(i,1),slotsRBS(i,2));
        end
    end
    i=i+1;
end
    %GDP:
fprintf('\tGDP results:\n');
i=1;
while(i<=length(slotsGDP))
    if(slotsGDP(i,3)~=0)
        if(slotsGDP(i,2)/100<0.1)
            fprintf('Aircraft %g arrives at %g:0%g\n',slotsGDP(i,3),slotsGDP(i,1),slotsGDP(i,2));
        else
            fprintf('Aircraft %g arrives at %g:%g\n',slotsGDP(i,3),slotsGDP(i,1),slotsGDP(i,2));
        end
    end
    i=i+1;
end
    %GHP:
fprintf('\tGHP results:\n');
i=1;
while(i<=length(slotsGHP))
    if(slotsGHP(i,3)~=0)
        if(slotsGHP(i,2)/100<0.1)
            fprintf('Aircraft %g arrives at %g:0%g\n',slotsGHP(i,3),slotsGHP(i,1),slotsGHP(i,2));
        else
            fprintf('Aircraft %g arrives at %g:%g\n',slotsGHP(i,3),slotsGHP(i,1),slotsGHP(i,2));
        end
    end
    i=i+1;
end
%Resumen/Comparación RBS, GDP y GHP:
fprintf('Using RBS, the airport will have %g delayed aircraft and a total delay of %g minutes. It means, an average delay of %g minutes/aircraft\n',delayedRBS,totaldelayRBS,averagedelayRBS);
fprintf('Using GDP, the airport will have %g delayed aircraft and a total delay of %g minutes. It means, an average delay of %g minutes/aircraft\n',delayedGDP,totaldelayGDP,avedelayGDP);
fprintf('Using GHP, the airport will have %g delayed aircraft and a total delay of %g minutes. It means, an average delay of %g minutes/aircraft\n',delayedGHP,totaldelayGHP,avedelayGHP);