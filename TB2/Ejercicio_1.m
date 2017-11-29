
clear all
% close all

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar del canal I ');
% load (cat(2, directorio, DatosPlots)); % los datos de plots   
% 
% fc=input('Frecuencia de la portadora (GHz)=')
%% Quitar
% load('G_C/TB2_ruido_C.mat')
load('G_C/TB2_ruido_40_C.mat')
fc = 9;
%%
fc=fc*1e9;
%Se almacenan los datos en la Matriz A y se elimina la continua de los
%datos, valor medio
A=src1.Data;
A=double(A);
A=A-mean(A);
fs=src1.SampleFrequency; % frecuencia de muestreo
N=max(size(A)); % número de muestras

%%
figure
histfit(A,50,'normal');title('FDP del ruido. Salida CW')
xlabel('Valores (V)')
ylabel('Acumulacion de muestras');
desviacion = std(A);
varianza = var(A);
texto = 'La desviacion tipica es: %.5f y la varianza es %.9f\n';
fprintf(texto,desviacion,varianza)
potencia = varianza;
potencia_dbm = 10*log10(potencia);
texto2 = 'La potencia es: %.5f\n';
fprintf(texto2,potencia_dbm)
%%
t=(0:(N-1))/fs;
%eje de tiempos

figure
plot(t,A)
grid
xlabel('tiempo (sg)')
ylabel('V')
title('Datos Digitalizados')

