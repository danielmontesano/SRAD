clear all
close all

load('G_C/DIENTE_ASCOPE_1.mat');
D=src1.Data;
D=double(D);

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal I');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
load('G_C/CANAL_I_2.mat'); YoffsetD= 306;Ni= 144; escala = 0.29;
% load('G_C\CANAL_I_SCAN_3.mat');YoffsetD= 1.0572e3;Ni=24;
% load('G_C\CANAL_I_SCANTRACK_4.mat');YoffsetD= 1.0494e3;Ni=18;
A=src1.Data;
A=double(A);


% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal Q');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
load('G_C/CANAL_Q_2.mat');
% load('G_C\CANAL_Q_SCAN_3.mat');
% load('G_C\CANAL_Q_SCANTRACK_4.mat');
B=src1.Data;
B=double(B);

fs=src1.SampleFrequency;
N=max(size(A));                % N?mero total de muestras del fichero
PRF=288;                       % Medida en el Laboratorio
Np=floor(fs/PRF);              % N?mero entero de celdas en tiempo r?pido, 
                               % Nivel inferior, los blancos se adelantar?n
R= 0:7.2/Np:7.2;                % Vector de distancias con span 7.2


M=round(max(size(A))/Np)-10;   % N?mero de celdas en tiempo lento que se procesan (quito 10)


offsetR=500;                   % Celda inicial para la formaci?n de la matriz, cambia el cero de distancia
                               % Par?metro de ajuste

  cont=0;                      % Contador para ajuste grueso del instante de la primera muestra
  cont1=0;                     % Contador para ajuste fino del instante de la primera muestra

  NPER=M;
  K=1;                         % Para ajustar con poco tiempo de ejecuci?n K=4   
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

 %MatrizRadar = randn(size(MatrizRadar))+j*randn(size(MatrizRadar));

%% Pantalla Tipo B

pared = 8.15;
blanco1= 2.63;

MatrizRadar = circshift(MatrizRadar,-round(YoffsetD-100),1);%Recortamos la matriz radar
span=7.2;
paso = span/size(MatrizRadar,1);
distancias = linspace(2, 9.2, size(MatrizRadar,1));
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
ylabel('Distancia(m)')


%% Filtrado y Diezmado
% Filtro
Ndiez=36;
 for i=1:size(MatrizRadar,2)
         MatrizRadar_diez(:,i) = filter((1/Ndiez)*ones(1,Ndiez),1,MatrizRadar(:,i),[],1);
 end
%Diezmado
matrizDiezmada = MatrizRadar_diez((Ndiez:Ndiez:end),:);
    
%Representacion 
figure(2)
imagesc(ejex,distancias,(abs(matrizDiezmada)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Filtrado y diezmado')
xlabel('Slot')
ylabel('Distancia(m)')

%C�lculo de clutter
ScanceladorIN=0.39; %Naturales
CcanceladorIN=0.2488;
NcanceladorIN=0.06748;
SC_in=20*log10(ScanceladorIN/CcanceladorIN);


%% Cancelador

%Cancelador simple
figure(3)
matrizCancelador1 = cancelador(1,matrizDiezmada);

imagesc(ejex,distancias,(abs(matrizCancelador1)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Cancelador Simple')
xlabel('Slot')
ylabel('Distancia(m)')

ScanceladorOUT_1=0.06284;
CcanceladorOUT_1=0.002181;
SC_cancelador1_out=20*log10(ScanceladorOUT_1/CcanceladorOUT_1);

%Cancelador doble
figure(4)
matrizCancelador2 = cancelador(2,matrizDiezmada);

imagesc(ejex,distancias,(abs(matrizCancelador2)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Cancelador Doble')
xlabel('Slot')
ylabel('Distancia(m)')

ScanceladorOUT_2=0.01059;
CcanceladorOUT_2=0.0007926;
SC_cancelador2_out=20*log10(ScanceladorOUT_2/CcanceladorOUT_2);

%Cancelador triple
figure(5)
matrizCancelador3 = cancelador(3,matrizDiezmada);

imagesc(ejex,distancias,(abs(matrizCancelador3)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Cancelador Triple')
xlabel('Slot')
ylabel('Distancia(m)')

ScanceladorOUT_3=0.005101;
CcanceladorOUT_3=0.001387;
SC_cancelador3_out=20*log10(ScanceladorOUT_3/CcanceladorOUT_3);

%Cancelador cero

figure(6)
matrizCancelador0 = cancelador(0,matrizDiezmada);

imagesc(ejex,distancias,(abs(matrizCancelador0)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Cancelador Cero')
xlabel('Slot')
ylabel('Distancia(m)')

%% M�dulo + Integrador

Ni_quieto= 144;
Ni_scan=24;
Ni_scantrack=18;

RC1=CcanceladorOUT_1;
RC2=CcanceladorOUT_2;
RC3=CcanceladorOUT_3;

Imti_cancelador1= SC_cancelador1_out-SC_in;
Imti_cancelador2= SC_cancelador2_out-SC_in;
Imti_cancelador3= SC_cancelador3_out-SC_in;
% Nos quedamos con el cancelador 1

MatrizIntegrada= integrador(1, 0,matrizCancelador1,Ni);

figure(7)
imagesc(ejex,distancias,(abs(MatrizIntegrada)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Integrador')
xlabel('Slot')
ylabel('Distancia (m)')
shading flat


ylabel('Distancia (m)')
shading flat


CA_CFAR(escala, MatrizIntegrada, distancias, ejex)


ylabel('Distancia(m)')
