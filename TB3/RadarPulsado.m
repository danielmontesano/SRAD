close all

load('G_C\DIENTE_ASCOPE_1.mat');
D=src1.Data;
D=double(D);

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal I');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
load('G_C\CANAL_I_2.mat');
A=src1.Data;
A=double(A);


% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal Q');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
load('G_C\CANAL_Q_2.mat');
B=src1.Data;
B=double(B);

fs=src1.SampleFrequency
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

% Diezmado 22 (2 muestras en vez de 44)
outputMatrix = MatrizRadar(1:22:end, 1:22:end);


figure(3)
ejex= linspace(1,1,Np);
pcolor(20*log10(abs(outputMatrix))')
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Matriz Radar: Radar Pulsado')
xlabel('Slot')
ylabel('Distancia (m)')
shading flat

%Pantall Tipo B

figure(1)
 colormap jet
pcolor(20*log10(abs(MatrizRadar))')
colorbar
xlabel('tiempo lento')
ylabel('tiempo rapido')
grid
shading flat 

%Pantalla tipo B con eje de distancias
% no me cuadran las distancias con las tomadas en la practic
figure(2)
ejex= linspace(1,1,Np);
imagesc(ejex,R,20*log10(abs(MatrizRadar))')
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Matriz Radar: Radar Pulsado')
xlabel('Slot')
ylabel('Distancia (m)')