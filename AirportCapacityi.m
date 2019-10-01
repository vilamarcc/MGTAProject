function [Xres,zval,x1,y1,x2,y2,x3,y3,x4,y4,xv,yv] = AirportCapacityi(slotsAC,alpha)
    %Cogemos los datos de nuestro aeropuerto y sacamos los puntos:
        %Todo dividido entre 4 porque en el documento está por hora y
        %nosotros queremos plotear cada cuarto de hora (15mins)
    Capdep = [0,54]/4;
    Caparr = [52,0]/4;
    AA = [30,52]/4;
    BB = [39,42]/4;
    CC = [42,37]/4;
    DD = [43,34]/4;
    
        %Computamos las rectas que obtenemos con esos puntos
    %Recta 1
    m1 = (AA(2) - BB(2))/(AA(1) - BB(1));
    b1 = AA(2) - m1*AA(1);
    x1 =[AA(1):0.01:BB(1)];
    y1 = m1*x1 + b1;
    %Rrecta 2 
    m2 = (BB(2) - CC(2))/(BB(1) - CC(1));
    b2 = BB(2) - m2*BB(1);
    x2 = [BB(1):0.01:CC(1)];
    y2 = m2*x2 + b2;
    %Recta 3
    m3 = (CC(2) - DD(2))/(CC(1) - DD(1));
    b3 = CC(2) - m3*CC(1);
    x3 = [CC(1):0.01:DD(1)];
    y3 = m3*x3 + b3;
    %Recta 4
    m4 = (DD(2) - Caparr(2))/(DD(1) - Caparr(1));
    b4 = DD(2) - m4*DD(1);
    x4 = [DD(1):0.01:Caparr(1)];
    y4 = m4*x4 + b4;
    %Recta vertical
    mv = 0;
    bv = AA(2) - mv*AA(1);
    xv = [Capdep(1):0.01:AA(1)]; 
    yv = mv*xv + bv;
    
    %Variables: Ai, Di
        % Ai = # of arrivals in slot i 
        % Di = # of departures in slot i 
    %Decision vector: %X = (A1,A2,A3,A4...,D1,D2,D3,D4...) 
    
    %Constraints de demanda:
        %Las variables son positivas 
            % -Ai <= 0 ; -Di <= 0
    j = 1; 
    A = zeros(2*length(slotsAC),2*length(slotsAC));
    while (j <= 2*length(slotsAC(:,1)))
        A(j,j) = -1;
        j = j + 1;
    end
    
        %Las variables on menores que los valores máximos 
            % Ai<=arr ; Di <= dep
    j = 1; 
    Ax = zeros(2*length(slotsAC),2*length(slotsAC));
    while (j <= 2*length(slotsAC(:,1)))
        Ax(j,j) = 1;
        j = j + 1;
   end
    A = [A;Ax];
    
        %Las variables son menores que las rectas 
            %Di -mAi <= b ; Di -m2Ai <=b2 ...
    %Recta 1
    j = 1;
    Ax = zeros(length(slotsAC),2*length(slotsAC));
    while (j <= length(slotsAC(:,1)))
        Ax(j,j) = -m1;
        Ax(j,j + length(slotsAC(:,1))) = 1;
        j = j + 1;
    end
    A = [A;Ax];
    %Recta 2
    j = 1;
    Ax = zeros(length(slotsAC),2*length(slotsAC));
    while (j <= length(slotsAC(:,1)))
        Ax(j,j) = -m2;
        Ax(j,j + length(slotsAC(:,1))) = 1;
        j = j + 1;
    end
    A = [A;Ax];
    %Recta 3
    j = 1;
    Ax = zeros(length(slotsAC),2*length(slotsAC));
    while (j <= length(slotsAC(:,1)))
        Ax(j,j) = -m3;
        Ax(j,j + length(slotsAC(:,1))) = 1;
        j = j + 1;
    end
    A = [A;Ax];
    %Recta 4
    j = 1;
    Ax = zeros(length(slotsAC),2*length(slotsAC));
    while (j <= length(slotsAC(:,1)))
        Ax(j,j) = -m4;
        Ax(j,j + length(slotsAC(:,1))) = 1;
        j = j + 1;
    end
    A = [A;Ax];
    
        %Condiciones de capacidad:
    %Llegadas: 
            %A1 <= 5 ; A1 + A2 <= 7 ; A1 + A2 + A3 <= 17 ...
    j = 1;
    Ax = zeros(length(slotsAC),2*length(slotsAC));
    while ( j <= length(slotsAC))
        i = 1;
        while (i <= length(slotsAC))
            if (j <= i)
                Ax(i,j) = 1;
            end
            i = i + 1;
        end
        j = j + 1;
    end
    A = [A;Ax];
    %Salidas: 
            %D1 <= 4 ; D1 + D2 <= 4 ; D1 + D2 + D3 <= 7 ... 
    j = length(slotsAC) + 1;
    Ax = zeros(length(slotsAC),2*length(slotsAC));
    while ( j <= 2*length(slotsAC))
        i = 1;
        while (i <= length(slotsAC))
            if (j <= i + length(slotsAC))
                Ax(i,j) = 1;
            end
            i = i + 1;
        end
        j = j + 1;
    end
    A = [A;Ax];
    
    %Creamos el vecto B de las desigualdades con las constraints ya
    %mencionadas (en orden):
    B = zeros(length(A),1);
    j = 1;
    c = 1;
    p = 1;
    colaA = 0;
    colaD = 0;
    while (j <= length(B))
        if (j > 2*length(slotsAC) && j <= 3*length(slotsAC))
            B(j) = Capdep(2);
        end
        if (j > 3*length(slotsAC) && j <= 4*length(slotsAC))
            B(j) = Caparr(1);
        end
        if (j > 4*length(slotsAC) && j <= 5*length(slotsAC))
            B(j) = b1;
        end
        if (j > 5*length(slotsAC) && j <= 6*length(slotsAC))
            B(j) = b2;
        end
        if (j > 6*length(slotsAC) && j <= 7*length(slotsAC))
            B(j) = b3;
        end
        if (j > 7*length(slotsAC) && j <= 8*length(slotsAC))
            B(j) = b4;
        end
        if (j > 8*length(slotsAC) && j <= 9*length(slotsAC))
            if (c <= length(slotsAC))
                colaA = colaA + slotsAC(c,3);
                B(j) = colaA;
                c = c + 1;
            end
        end
        if (j > 9*length(slotsAC) && j <= 10*length(slotsAC))
            if (p <= length(slotsAC))
                colaD = colaD + slotsAC(p,4);
                B(j) = colaD;
                p = p + 1;
            end
        end
        j = j + 1;
    end
    
    %Todas las variables han de ser integers y los límites los marcan las
    %dos primeras contraints:
    int = [1:2*length(slotsAC)];
    lb = zeros(2*length(slotsAC),1);
    ub = zeros(2*length(slotsAC),1);
    j = 1;
    while (j <= 2*length(slotsAC))
        if (j <= length(slotsAC))
            ub(j) = Caparr(1);
        end
        if (j > length(slotsAC))
            ub(j) = Capdep(2);
        end
        j = j + 1;
    end
        
    %Creamos la función objetivo:
        %      N
        % max sum(N-i +1)*(alpha*ui + (1-alpha)*vi)
        %     i=1
    C = zeros(1,2*length(slotsAC));    
    N = length(slotsAC);
    j = 1;
    while (j <= length(slotsAC))
        C(j) = -(N-j+1)*(alpha);
        C(j + N) = -(N-j+1)*(1-alpha);
        j = j + 1;
    end
   
    %Optimizamos
    [X,zval] = intlinprog(C,int,A,B,[],[],lb,ub);
    %Al estar maximizando, hemos de cambiar el signo
        %Matlab, por defecto, minimiza
    zval = -zval;
    
    %Separamos las variables en arrivals (Ai) y departures (Di), siguiendo
    %el orden en el que hemos definido el vector de decisión
    j = 1;
    Ai = zeros(length(X)/2,1);
    Di = zeros(length(X)/2,1);
    while (j <= length(X))
        if (j <= length(X)/2)
            Ai(j) = X(j);
        end
        if (j > length(X)/2)
            Di(j - length(X)/2) = X(j);
        end
        j = j + 1;
    end
    
    %Sacamos una variable nueva con los resultados:
        %Xres=[hora slot, minuto slot, Ai, Di]
    Xres = round([slotsAC(:,1),slotsAC(:,2),Ai,Di]);
end