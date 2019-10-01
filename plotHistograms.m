function plotHistograms(ETAmins,CTAmins,PAAR,Hstart,Hend,AAR,titulo)
    %Dividiremos los plots cada media hora por lo que tendremos 12 barras:
    times = 1:12;
    
    %Computamos los dos vectores a plotear:
        %Vuelos sin regular (NR: Non-Regulated)
    Aircraftsby30mins_NR = zeros(1,12);
    t = 1;
    time = 30;
    while (t<=length(times))
        e = 1;
        aircrafts = 0;
        while (e <= length(ETAmins))
            if (ETAmins(e) < time) && (ETAmins(e) >= time - 30)
                aircrafts = aircrafts + 1;
            end 
            e = e + 1;
        end
        Aircraftsby30mins_NR(t) = aircrafts;
        time = time + 30;
        t = t + 1;
    end     
        %Vuelos regulados (R: Regulated)
    Aircraftsby30mins_R = zeros(1,12);
    t = 1;
    time = 30;
    while (t<=length(times))
        aircrafts = 0;
        c = 1;
        while (c <= length(CTAmins))
            if (CTAmins(c,2) < time) && (CTAmins(c,2) >= time - 30)
                aircrafts = aircrafts + 1;
            end 
            c = c + 1;
        end
        Aircraftsby30mins_R(t) = aircrafts;
        time = time + 30;
        t = t + 1;
    end     

    %Creamos las dos rectas de capacidad:
        %Trozo capacidad reducida (8:00 - 8:59)
    startx = (Hstart/30)+0.5;
    endx = (Hend/30)+0.5;
    x = startx:0.5:endx;
    j = 1;
    y = zeros(1,length(x));
    while (j <=length(x))
        y(j) = PAAR/2;
        j = j + 1;
    end
        %Primer trozo capacidad nominal (9:00 - 10:59)
    x2 = 0:0.5:startx;
    y2 = zeros(1, length(x2));
    j = 1;
    while (j <= length(x2))
        y2(j) = AAR/2;
        j = j + 1;
    end
        %Segundo trozo capacidad nominal (5:00 - 7:59)
    x3 = endx:0.5:12.5;
    y3 = zeros(1, length(x3));
    j = 1;
    while (j <= length(x3))
        y3(j) = AAR/2;
        j = j + 1;
    end
    
    %Creamos el plot:
    figure('Name',titulo,'NumberTitle','off')
        %Sin regular
    subplot(2,1,1)
    bar(times,Aircraftsby30mins_NR)
    hold on
    plot(x,y,'g')
    hold on
    plot(x2,y2,'b')
    hold on
    plot(x3,y3,'b')
    title('Non-regulated')
    set(gca,'xticklabel',{'5:00','5:30','6:00','6:30','7:00','7:30','8:00','8:30','9:00','9:30','10:00','10:30'});
    	%Regulados
    subplot(2,1,2)
    bar(times,Aircraftsby30mins_R,'r')
    hold on
    plot(x,y,'g')
    hold on
    plot(x2,y2,'b')
    hold on
    plot(x3,y3,'b')
    title('Regulated')
    set(gca,'xticklabel',{'5:00','5:30','6:00','6:30','7:00','7:30','8:00','8:30','9:00','9:30','10:00','10:30'});
end