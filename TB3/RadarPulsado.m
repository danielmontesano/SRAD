clear all
close all

load('G_C\DIENTE_ASCOPE_1.mat');
D=src1.Data;
D=double(D);

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal I');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
% load('G_C\CANAL_I_2.mat'); YoffsetD= 306;Ni= 144;
load('G_C\CANAL_I_SCAN_3.mat');YoffsetD= 1.0572e3;Ni=24;
% load('G_C\CANAL_I_SCANTRACK_4.mat');YoffsetD= 1.0494e3;Ni=18;
A=src1.Data;
A=double(A);


% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal Q');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
% load('G_C\CANAL_Q_2.mat');
load('G_C\CANAL_Q_SCAN_3.mat');
% load('G_C\CANAL_Q_SCANTRACK_4.mat');
B=src1.Data;
B=double(B);

fs=src1.SampleFrequency;
N=max(size(A));                % N?mero total de muestras del fichero
PRF=288;                       % Medida en el Laboratorio
Np=floor(fs/PRF);              % N?mero entero de celdas en tiempo r?pido, 
                               % Nivel inferior, los blancos se adelantar?n
R= 0:7.2/Np:7.2;                % Vector de distancias con span 7.2

deltaR = 0.15; % metros
deltaR_smuestr = 7.2/N;
sobremuestreo = round(deltaR/deltaR_smuestr);



M=round(max(size(A))/Np)-10;   % N?mero de celdas en tiempo lento que se procesan (quito 10)


offsetR=500;                   % Celda inicial para la formaci?n de la matriz, cambia el cero de distancia
                               % Par?metro de ajuste

  cont=0;                      % Contador para ajuste grueso del instante de la primera muestra
  cont1=0;                     % Contador para ajuste fino del instante de la primera muestra

  NPER=M;
  K=4;                         % Para ajustar con poco tiempo de ejecuci?n K=4   
%        figure(100)                        % Fichero completo K=1
% Quitar el offset
for k=1:NPER/K
    cont=cont+1;
    cont1=cont1+1;
 
    if cont<9  % Par?metro de ajuste grueso
        Kc=0;
     
    else
        cont=0;
        Kc=1;
  
    end
     if cont1<36  % Par?metro de ajuste fino
        Kc1=0;
     
    else
        cont1=0;
        Kc1=1;
  
    end
    offsetR=offsetR+Kc+Kc1;
    MatrizRadar(k,:)=A(offsetR+(k-1)*Np:1:offsetR+Np-1+(k-1)*Np)+1i*B(offsetR+(k-1)*Np:1:offsetR+Np-1+(k-1)*Np);
% subplot(211),plot(real(MatrizRadar(k,:)))
% title('Componente en Fase')
% xlabel('Muestras')
% ylabel('v')
% 
% axis([0 2000 -.5 .5])
%     subplot(212),plot(imag(MatrizRadar(k,:)))
% title('Componente en Cuadratura')
% xlabel('Muestras')
% ylabel('v')
% axis([0 2000 -.5 .5])
% pause(0.0001)

end

MatrizRadar=MatrizRadar';


%% Pantalla Tipo B

% figure(7)
%  colormap jet
% pcolor((abs(MatrizRadar)))
% colorbar
% xlabel('tiempo lento')
% ylabel('tiempo rapido')
% grid
% title('Matriz Radar a pelo')
% shading flat 
% 
% 
% disp('Seleccionar distancia blanco 1')
% [XoffsetD, YoffsetD] = ginput(1);
% % aux = find(R>YoffsetD);%Averiguamos el indice de ese ofset
% % indexD = aux(1);
% disp('Seleccionar distancia pared')
% [XoffsetD, YoffsetPared] = ginput(1);
pared = 8.15;
blanco1= 2.63;
% YoffsetD=YoffsetD; %correccion para que no quede pegado el blanco al origen

MatrizRadar = circshift(MatrizRadar,-round(YoffsetD-100),1);%Recortamos la matriz radar
span=7.2;
paso = span/size(MatrizRadar,1);
% paso = abs((pared-blanco1)/max([(-YoffsetPared+YoffsetD-size(MatrizRadar,1)) -YoffsetPared+YoffsetD]))
% inicio = blanco1-paso*round(100);
% final = pared + paso*(size(MatrizRadar,1)-YoffsetPared+YoffsetD+100);
distancias = linspace(2, 9.2, size(MatrizRadar,1));

% N = length(MatrizRadar(:,1));%Numero de muestras
% Rmax = (N/fs)*3e8/2;
ejex= linspace(1,1,Np);

figure(1)
imagesc(ejex,distancias,(abs(MatrizRadar)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Radar Pulsado: cancelador cero')
xlabel('Slot')

 %% Filtro adaptado
% 
% %Filtrado en dominio de la frecuencia
% pulso = zeros(1,size(MatrizRadar,1));
% n_bt = ceil(size(MatrizRadar,1)*1e9/fs);
% pulso(1:n_bt) = ones;
% 
% f = zeros(1,1e9); 
% f(:);
% f(1:1e9/(fs))= f(1:1e9/(fs))+1;
% 
% s = zeros(size(f));  
% s = s(:);                       % Signal in column vector
% s(201:205) = s(201:205) + 1; 
% 
% for i=1:size(MatrizRadar,2)
%  
% Hfa=conj(fft(MatrizRadar(:,i)));
% Yout(:,i)=ifft(fft(MatrizRadar(:,i)).*Hfa);
% Yshift(:,i)=Yout(:,i);
% end

% % Matriz tras filtro adaptado
% figure(1)
% pcolor(20*log10(abs(Yshift)))
% set(gca, 'YDir', 'normal');
% colormap('jet')
% c=colorbar;
% c.Label.String = 'Amplitud (V)';
% c.Label.FontSize = 11;
% title('Radar Pulsado: Filtro adaptado')
% xlabel('Slot')
% ylabel('Distancia (m)')
% shading flat

%% Diezmado

Ndiez=36;
 for i=1:size(MatrizRadar,2)
         MatrizRadar_diez(:,i) = filter((1/Nidiez)*ones(1,Nidiez),1,MatrizRadar(:,i),[],1);
    end
    matrizDiezmada = MatrizRadar_diez((Nidiez:Nidiez:end),:);
    
%Diezmado 
figure(2)
ejex= linspace(1,1,Np);
pcolor((abs(matrizDiezmada)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Radar Pulsado: Submuestreo')
xlabel('Slot')
shading flat

%% Cancelador

%Cancelador simple
figure(3)
matrizCancelador1 = cancelador(1,matrizDiezmada);

imagesc(ejex,R,(abs(matrizCancelador1)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Radar Pulsado: cancelador simple')
xlabel('Slot')

%Cancelador doble
figure(4)
matrizCancelador2 = cancelador(2,matrizDiezmada);

imagesc(ejex,R,(abs(matrizCancelador2)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Radar Pulsado: cancelador doble')
xlabel('Slot')

%Cancelador triple
figure(5)
matrizCancelador3 = cancelador(3,matrizDiezmada);

imagesc(ejex,R,(abs(matrizCancelador3)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Radar Pulsado: cancelador triple')
xlabel('Slot')

%Cancelador cero

figure(6)
matrizCancelador0 = cancelador(0,matrizDiezmada);

imagesc(ejex,R,(abs(matrizCancelador0)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Radar Pulsado: cancelador cero')
xlabel('Slot')


%% Módulo + Integrador

Ni_quieto= 144;
Ni_scan=24;
Ni_scantrack=18;

MatrizIntegrada= integrador(1, 0,matrizCancelador1,Ni);

% figure(9)
% colormap jet
% pcolor(((MatrizIntegrada)))
% colorbar
% xlabel('tiempo lento')
% ylabel('tiempo rapido')
% title('Matriz integrada')
% grid
% shading flat 

figure(7)
pcolor((MatrizIntegrada))
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Matriz integrada')
xlabel('Slot')
ylabel('Distancia (m)')
shading flat


