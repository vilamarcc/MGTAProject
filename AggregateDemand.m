function [HNoReg,HNoRegmins,delay,minutes] = AggregateDemand(ETAmins,Hstart,Hend,PAAR,AAR)
    
    %Creamos el vector de minutos - Desde 0 (5:00am) a 359 (10:50am)
    minutes = zeros(1,360);
    m = 2;
    while (m<=length(minutes)) 
        minutes(m) = minutes(m-1)+1;
        m = m + 1;
    end

    %Computamos el vector de demanda acumulada en cada minuto
    Aircrafts=zeros(1,360);
    m=1;
    t = 1;
    a = 0;
    while (m<=length(minutes))
        while (t <=length(ETAmins))
            if (minutes(m) == ETAmins(t,1))
                a = a + 1;
            end
            Aircrafts(m) = a;
            t = t + 1;
        end
        t = 1;
        m=m+1;
    end

    %Computamos las rectas de capacidad limitada para obtener HNoReg
        %Recta1: Entre Hstart y Hend y con pendiente igual a la capacidad reducida
    x1=Hstart:Hend;
    m1=PAAR/60;
    n1=Aircrafts(Hstart+1)-(m1*Hstart);
    y1=m1*x1+n1;
        %Recta2: Empieza en Hend, con pendiente igual a la capacidad nominal
        %y acaba donde cruza a la demanda acumulada
    m2=AAR/60;
    n2=Hend*(m1-m2)+n1;
    m=1;
    found=0;
    while(m<=length(minutes) && found==0)
        if(Aircrafts(m)==((m2*m)+n2))
            found=1;
            caphnr=Aircrafts(m);
            HNoRegmins=m;
        else
            m=m+1;
        end
    end
    x2=Hend:HNoRegmins;
    y2=(m2*x2)+n2;
    
    %Computamos el delay total
        %Área 1 (a1) - Integrar la curva de Hstart a HNoReg:
    t = Hstart;
    a1 = 0;
    while (t <= HNoRegmins)
        a1 = a1 + Aircrafts(t);
        t = t + 1;
    end
        %Triángulo (T1) y rectángulo (R1) que forma la Recta1:
    T1=(Hend-Hstart)*(Hend*m1+n1-Aircrafts(Hstart+1))*0.5;
    R1=(Hend-Hstart)*Aircrafts(Hstart+1);
        %Triángulo (T2) y rectángulo (R2) que forma la Recta2:
    T2=(caphnr-Hend*m1-n1)*(HNoRegmins-Hend)*0.5;
    R2=(HNoRegmins-Hend)*(Hend*m1+n1);
        %Al área 1 le restamos los triangulos y los rectángulos
        %De ahí obtenemos el área entre las rectas y la curva de demanda acumulada, es decir, el delay
    delay=a1-(T1+R1+T2+R2);
    
    %Finalmente pasamos HNoReg a horas y minutos en un vector
        %HNoReg=[hora,minuto]
    HNoReg = [fix(HNoRegmins/60) + 5,fix(mod(HNoRegmins,60))];
    
    %Hacemos los correspondientes plots
    figure('Name','Aggregate Demand','NumberTitle','off');
    plot(minutes,Aircrafts)
    hold on
    plot(x1,y1,'r')
    hold on
    plot(x2,y2,'g')
    ylabel('Demand (nº of aircrafts)')
    xlabel('Minutes')
    title('Aggregate Demand')
    legend({'Aggregate Demand','Capacity Reduced','Capacity Nominal'})
end

    

