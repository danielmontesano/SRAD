% Programa para la formaci?n de Matrices Radar para el Radar Pulsado Coherente
% MUIT 2017/18 TB3
% SSR
% Grupo de Microondas y Radar
% Curso 2017/18

clear all
close all

[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal I');
load (cat(2, directorio, DatosPlots)); % los datos de plots


A=src1.Data;
A=double(A);


[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos del canal Q');
load (cat(2, directorio, DatosPlots)); % los datos de plots

B=src1.Data;
B=double(B);

fs=src1.SampleFrequency
N=max(size(A));                % N?mero total de muestras del fichero
PRF=288;                       % Medida en el Laboratorio
Np=floor(fs/PRF);              % N?mero entero de celdas en tiempo r?pido, 
                               % Nivel inferior, los blancos se adelantar?n

M=round(max(size(A))/Np)-10;   % N?mero de celdas en tiempo lento que se procesan (quito 10)


offsetR=500;                   % Celda inicial para la formaci?n de la matriz, cambia el cero de distancia
                               % Par?metro de ajuste

  cont=0;                      % Contador para ajuste grueso del instante de la primera muestra
  cont1=0;                     % Contador para ajuste fino del instante de la primera muestra

  NPER=M;
  K=2;                         % Para ajustar con poco tiempo de ejecuci?n K=4   
       figure(100)                        % Fichero completo K=1
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

subplot(211),plot(real(MatrizRadar(k,:)))
title('Componente en Fase')
xlabel('Muestras')
ylabel('v')

axis([0 2000 -.5 .5])
    subplot(212),plot(imag(MatrizRadar(k,:)))
title('Componente en Cuadratura')
xlabel('Muestras')
ylabel('v')
axis([0 2000 -.5 .5])
pause(0.0001)

end

%Pantall Tipo B

figure(1)
 colormap jet
pcolor(20*log10(abs(MatrizRadar))')
colorbar
xlabel('tiempo lento')
ylabel('tiempo r?pido')
grid
shading flat 