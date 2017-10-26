warning ('off','all');
clear all
close all
[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
load (cat(2, directorio, DatosPlots)); % los datos de plots

canal1=Data.Channel1;
canal1=double(canal1);

canal2=Data.Channel2;
canal2=double(canal2);

time=Data.Time;
celdasAz=Data.SegmentCount;
celdasDis=Data.RecordLength;
bits=Data.Resolution;
escala=Data.Escala;
tau=Data.Tau;
rpm=Data.Rpm;
PRF=Data.PRF;
fs=Data.SampleFrequency;

fprintf('Tiempo: %s .\n', time);
fprintf('Frecuencia de muestreo: %s Hz .\n', fs);
fprintf('Celdas Azimut: %d .\n' , (celdasAz));
fprintf('Celdas Distancia: %d .\n' ,celdasDis);
fprintf('Resolución: %d .\n' ,bits);
fprintf('Escala: %d mn .\n' ,escala);
fprintf('Tau: %s s .\n' ,tau);
fprintf('Rpm: %d rpm .\n' ,rpm);
fprintf('PRF: %d Hz .\n' ,PRF);

N=length(canal1(:,1));

figure(1)
Rmax = (N/fs)*3e8/2;
distancia = linspace(0,Rmax,N);
tiempos = linspace(0,N/fs,N);
radar = canal1(:,1);
sync = canal2(:,1);

subplot (2,1,1)
h_1 = plot(distancia, radar);
title('Pantalla tipo A')
grid
xlabel('Distancia (m)')
ylabel('V')
subplot (2,1,2)
h_2 = plot(tiempos,sync);
grid
xlabel('Tiempo (s)')
ylabel('V')

h_1.XDataSource = 'distancia';
h_1.YDataSource = 'radar';

h_2.XDataSource = 'tiempos';
h_2.YDataSource = 'sync';

paso=1;
k=1;
for k=1:paso:N
radar = canal1(:,k);
sync = canal2(:,k);
refreshdata;
pause(0.001);
end


