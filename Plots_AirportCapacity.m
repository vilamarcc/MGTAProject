function Plots_AirportCapacity(slotsAP,XresV,XresI,x1v,y1v,x2v,y2v,x3v,y3v,x4v,y4v,xvv,yvv,x1i,y1i,x2i,y2i,x3i,y3i,x4i,y4i,xvi,yvi,alpha,colaAi,colaDi,colatotali,colaAv,colaDv,colatotalv)
    
        %Airport Capacity: Visual Weather Conditions
    a = sprintf('Airport Capacity: Visual Weather Conditions with alpha = %g',alpha);
    figure('Name',a,'NumberTitle','off');
    %Sin regular
    subplot(2,1,1)
    scatter(slotsAP(:,3),slotsAP(:,4)) %Círculos de demanda
    hold on
    plot(x1v,y1v,'b')
    hold on
    plot(x2v,y2v,'b')
    hold on
    plot(x3v,y3v,'b')
    hold on 
    plot(x4v,y4v,'b')
    hold on
    plot(xvv,yvv,'b')
    ylabel('Departures/15min')
    xlabel('Arrivals/15min')
    title('Non-Regulated')
    legend({'Capacity demand','Maximum capacity'})
    axis([0 25 0 25]);
    %Regulados
    subplot(2,1,2)
    scatter(XresV(:,3),XresV(:,4)) %Círculos de demanda
    hold on
    plot(x1v,y1v,'b')
    hold on
    plot(x2v,y2v,'b')
    hold on
    plot(x3v,y3v,'b')
    hold on 
    plot(x4v,y4v,'b')
    hold on
    plot(xvv,yvv,'b')
    ylabel('Departures/15min')
    xlabel('Arrivals/15min')
    title('Regulated')
    legend({'Capacity demand','Maximum capacity'})
    axis([0 25 0 25]);
    
        %Airport Capacity: Instrumental Weather Conditions
    l = sprintf('Airport Capacity: Instrumental Weather Conditions with aplha = %g',alpha);
    figure('Name',l,'NumberTitle','off')
    %Sin regular
    subplot(2,1,1)
    scatter(slotsAP(:,3),slotsAP(:,4)) %Círculos de demanda
    hold on
    plot(x1i,y1i,'b')
    hold on
    plot(x2i,y2i,'b')
    hold on
    plot(x3i,y3i,'b')
    hold on 
    plot(x4i,y4i,'b')
    hold on
    plot(xvi,yvi,'b')
    ylabel('Departures/15min')
    xlabel('Arrivals/15min')
    title('Non-Regulated')
    legend({'Capacity demand','Maximum capacity'})
    axis([0 25 0 25]);
    %Regulados
    subplot(2,1,2)
    scatter(XresI(:,3),XresI(:,4)) %Círculos de demanda
    hold on
    plot(x1i,y1i,'b')
    hold on
    plot(x2i,y2i,'b')
    hold on
    plot(x3i,y3i,'b')
    hold on 
    plot(x4i,y4i,'b')
    hold on
    plot(xvi,yvi,'b')
    ylabel('Departures/15min')
    xlabel('Arrivals/15min')
    title('Regulated')
    legend({'Capacity demand','Maximum capacity'})
    axis([0 25 0 25]);
    
        %Plots de las colas
    figure('Name','Airport Capacity Queues','NumberTitle','off')
    minutos=[1:length(slotsAP)];
    %Visual Weather Conditions
    subplot (2,1,1)
    plot(minutos,colaAv)
    hold on
    plot(minutos,colaDv)
    hold on
    plot(minutos,colatotalv)
    ylabel('Aircrafts')
    xlabel('Time slots')
    t=sprintf('Visual Weather Conditions with alpha = %g',alpha);
    title(t)
    legend({'Arrivals Queue','Departures Queue','Total Queue'})
    %Instrumental Weather Conditions
    subplot (2,1,2)
    plot(minutos,colaAi)
    hold on
    plot(minutos,colaDi)
    hold on
    plot(minutos,colatotali)
    ylabel('Aircrafts')
    xlabel('Time slots')
    t=sprintf('Instrumental Weather Conditions with alpha = %g',alpha);
    title(t)
    legend({'Arrivals Queue','Departures Queue','Total Queue'})
end

