function [zmin,Xv,slotsGHP] = GHPprogram(vuelosGHP,slotsGHP,cft)
    %Decision variables: xft
        %xft=1 si el vuelo f está asignado en el slot t
        %xft=0 si no
    %Decision vector: X=(x11 x12 x13 ... x1t x21 x22 x23 ... x2t ... xft)
        
    nx=length(vuelosGHP)*length(slotsGHP); %número total de variables
    
    %Todas las variables son integers y solo pueden ser 0 o 1:
    int=[1:nx];
    lb=zeros(nx,1); 
    ub=ones(nx,1);
        %Si el coste es -1 (cft=-1) es porque no se puede asignar el vuelo
        %f en el slot t, por lo que cambiamos la upper boundary:
    c=1;
    while(c<=length(cft))
        if(cft(c)==-1)
            ub(c,1)=0;
        end
        c=c+1;
    end
    
    %Constraints: Igualdades
        %Cada vuelo tiene exactamente un slot:
            %suma(x1t)=1 ; suma(x2t)=1 ; suma(x3t)=1 ...
    Aeq=zeros(length(vuelosGHP),nx);
    i=1;
    while(i<=length(vuelosGHP))
        j=1;
        while(j<=length(slotsGHP))
            s=length(slotsGHP)*(i-1)+j;
            Aeq(i,s)=1;
            j=j+1;
        end
        i=i+1;
    end
    beq=ones(1,length(vuelosGHP));
    %Constraints: Desigualdades
        %Cada slot puede tener como máximo un vuelo:
            %suma(xf1)<=1 ; suma(xf2)<=1 ; suma(xf3)<=1 ...
    A=zeros(length(slotsGHP),nx);
    i=1;
    while(i<=length(slotsGHP))
        j=1;
        while(j<=length(vuelosGHP))
            s=length(slotsGHP)*(j-1)+i;
            A(i,s)=1;
            j=j+1;
        end
        i=i+1;
    end
    b=ones(1,length(slotsGHP));
    
    %Optimización:
        %Función objetivo: suma(cft*xft)
    [Xv,zmin]=intlinprog(cft,int,A,b,Aeq,beq,lb,ub);
    
    %Colocamos el número de vuelo en la tercera columna del slot asignado
    x=1;
    while(x<=length(Xv))
        f=ceil(x/length(slotsGHP));
        t=x-((f-1)*length(slotsGHP));
        if(Xv(x)==1)
            slotsGHP(t,3)=vuelosGHP(f,1);
        end
        x=x+1;
    end
end

